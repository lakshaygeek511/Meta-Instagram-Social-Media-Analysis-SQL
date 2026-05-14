-- SOCIAL MEDIA ANALYSIS META IG CLONE

-- OBJECTIVE QUESTIONS

-- Task-1. Are there any tables with duplicate or missing null values? If so, how would you handle them?

-- Identifying Duplicate Values
use ig_clone;
SELECT username, COUNT(*) as count
FROM users
GROUP BY username
HAVING count > 1;

-- Handling Duplicate Values

WITH DuplicateRecords AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num FROM users)
DELETE FROM users
WHERE id IN (SELECT id FROM DuplicateRecords WHERE row_num > 1);

-- Identifying Null Values

SELECT *
FROM users
WHERE id IS NULL OR username IS NULL or created_at is NULL ;

-- Task-2.What is the distribution of user activity levels (e.g., number of posts, likes, comments) across the user base?

select u.id,
		u.username,
        count(distinct p.id) as post_count,
        count(distinct c.id) as comment_count,
        count(distinct l.photo_id) as like_count
from users u
left join photos p on u.id = p.user_id
left join comments c on u.id = c.user_id
left join likes l on u.id = l.user_id
group by u.id,u.username;

-- Task-3.Calculate the average number of tags per post (photo_tags and photos tables)

with post_tag_count as (select photo_id,count(distinct tag_id) as tag_count from photo_tags group by photo_id)

select avg(tag_count) as avg_tags_by_post from post_tag_count;

-- Task-4. Identify the top users with the highest engagement rates (likes, comments) on their posts and rank them.

With Total_likes as (
select u.username , count(l.user_id) as total_likes 
from users as u 
left join likes as l 
on u.id = l.user_id 
group by u.username ),

Total_comments as (
select u.username , count(c.user_id) as total_comments 
from users as u 
left join comments as c 
on u.id = c.user_id 
group by u.username )

select l.username , l.total_likes , c.total_comments ,(l.total_likes + c.total_comments) as engagement_rate,
Dense_rank() over (order by (l.total_likes + c.total_comments) desc) as engagement_rate_rank 
from Total_likes as l 
join Total_comments as c 
on l.username = c.username  
limit 20;

-- Task-5. Which users have the highest number of followers and followings?
with count_follower as (select follower_id,
		count(follower_id) as followers_count
    from follows  
group by follower_id),

count_following as(select followee_id,
		count(followee_id) as following_count
    from follows  
group by followee_id)

select u.id,
		u.username,
        coalesce(a.followers_count,0) as follower_count,
        coalesce(b.following_count,0) as following_count
from users u 
left join count_follower a on u.id = a.follower_id
left join count_following b on u.id = b.followee_id;


-- Task 6. Calculate the average engagement rate (likes, comments) per post for each user.
 
with count_like as (select distinct photo_id,
							count(user_id) as like_Count
					from likes
					group by photo_id),
 
count_comment as (select photo_id,
		count(user_id) as comment_count
from comments
group by photo_id),

engagement as (select p.id as photo_id,
		p.user_id,
        coalesce(l.like_count,0) as like_count ,
        coalesce(c.comment_count,0) as comment_count,
        coalesce(l.like_count+c.comment_count , 0) as total_engagement
from photos p 
left join count_like l on p.id = l.photo_id
left join count_comment c on p.id = c.photo_id)

select distinct e.user_id,
		u.username,
        avg(e.total_engagement) as avg_engagement_rate
from users u 
join engagement e on u.id = e.user_id
group by e.user_id
order by avg(e.total_engagement)  desc;

-- Task.7 Get the list of users who have never liked any post (users and likes tables)

select 
	id, username 
from users 
where id not in (select user_id from likes);

-- Task.8 How can you leverage user-generated content (posts, hashtags, photo tags) 
-- to create more personalized and engaging ad campaigns?

-- MOST USED TAGS:
SELECT t.tag_name, 
    COUNT(pt.photo_id) AS tag_usage_count
FROM tags t
JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY t.tag_name
ORDER BY tag_usage_count DESC;


-- 9. Are there any correlations between user activity levels and specific content types (e.g., photos, videos, reels)? How can this information guide content creation and curation strategies?
SELECT 
    u.id AS user_id,
    u.username,
    COUNT(DISTINCT p.id) AS total_photos_posted,
    COUNT(DISTINCT l.photo_id) AS total_likes_given,
    COUNT(DISTINCT c.id) AS total_comments_made,
    (
        SELECT COUNT(*) 
        FROM likes l2
        JOIN photos p2 ON l2.photo_id = p2.id
        WHERE p2.user_id = u.id
    ) AS total_likes_received,
    (
        SELECT COUNT(*) 
        FROM comments c2
        JOIN photos p2 ON c2.photo_id = p2.id
        WHERE p2.user_id = u.id
    ) AS total_comments_received
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
LEFT JOIN likes l ON u.id = l.user_id
LEFT JOIN comments c ON u.id = c.user_id
GROUP BY u.id, u.username
HAVING COUNT(DISTINCT p.id) > 0
ORDER BY total_photos_posted DESC;


-- Task.10 Calculate the total number of likes, comments, and photo tags for each user.
with count_of_like as (select user_id,
		count(*) as like_count
from likes
group by user_id),

count_of_comment as (select user_id,
		count(*) as comment_count
from comments
group by user_id),

count_of_tags as (select tag_id,
							count(*) as tag_count
			from photo_tags
            group by tag_id)
            
select u.id,
		coalesce(l.like_count,0) as like_count,
		coalesce(c.comment_count,0) as comment_count,
        coalesce(t.tag_count,0) as tag_count
from users u 
left join count_of_like l on u.id = l.user_id
left join count_of_comment c on u.id = c.user_id
left join count_of_tags t on u.id = t.tag_id;

-- Task.11 Rank users based on their total engagement (likes, comments, shares) over a month.

with Post_likes AS (select distinct user_id, count(*) AS like_count
	from likes group by  user_id),
     
Post_comments AS (select distinct user_id, count(*) AS comment_count
	from comments GROUP BY user_id),
	
	Total_likes_n_comments AS (
	  SELECT distinct u.id AS User_id, u.username,
                coalesce(pl.like_count, 0) AS like_count,
	            coalesce(pc.comment_count, 0) AS comment_count,
				coalesce(pl.like_count, 0) + coalesce(pc.comment_count, 0) AS total_engagement
      FROM users as u
	  LEFT JOIN Post_likes as pl ON u.id=pl.user_id
	  LEFT JOIN Post_comments as pc ON u.id=pc.user_id)
      
      select User_id , username as Username , like_count , comment_count , total_engagement ,
			dense_rank() over (order by total_engagement desc) as User_rank 
      from Total_likes_n_comments ;

-- Task.12 Retrieve the hashtags that have been used in posts with the highest average number of likes. Use a CTE to calculate the average likes for each hashtag first.

With Likes_Count as (   
SELECT photo_id,count(user_id) AS LikesCount
FROM likes
GROUP BY photo_id)

select t.tag_name , round(avg(c.LikesCount),0) as Avg_likes
from tags as t 
join photo_tags as pt 
on t.id = pt.tag_id
join Likes_Count as c
on pt.photo_id = c.photo_id
group by t.tag_name
order by Avg_likes desc;

-- Task 13. Retrieve the users who have started following someone after being followed by that person.

SELECT DISTINCT
       f1.follower_id AS user_id,         
       f1.followee_id AS followed_back_to, 
       f2.created_at  AS followed_me_at, 
       f1.created_at  AS i_followed_back_at
FROM   follows AS f1              
JOIN   follows AS f2             
       ON  f1.follower_id = f2.followee_id 
       AND f1.followee_id = f2.follower_id
WHERE  f1.created_at  >  f2.created_at;   

-- Subjective questions
-- Task 1.Based on user engagement and activity levels, which users would you consider the most loyal or valuable? How would you reward or incentivize these users?

with likes_count as (select distinct user_id,
		count(*) as num_of_likes from likes
group by user_id),
comments_count as (
select distinct user_id,
		count(*) as num_of_comments
from comments
group by user_id
),
photo_count as (
select distinct user_id,
		count(*) as num_of_photos
from photos 
group by user_id
),
phototags_count as (
select p.user_id,
		count(pt.tag_id) as num_of_phototags
from photos p 
join photo_tags as pt on p.id = pt.photo_id
group by p.user_id
) ,
Count_of_followers as (
select follower_id , count(follower_id) as follower_count ,
count(followee_id) as followee_count
from follows 
group by follower_id)

select u.id as UserID,
		u.username,
        coalesce(l.num_of_likes ,0)  as num_of_likes,
        coalesce(c.num_of_comments, 0) as num_of_comments,
        coalesce(pp.num_of_photos,0) as num_of_photos,
        coalesce(p.num_of_phototags,0) as num_of_phototags,
        coalesce(f.follower_count,0) as follower_count,
        coalesce(f.followee_count,0) as followee_count,
        coalesce((l.num_of_likes+c.num_of_comments+pp.num_of_photos),0)  as engagement_rate,
        rank() over(order by (l.num_of_likes+c.num_of_comments+pp.num_of_photos) desc ) as engagement_rate_rank
from users u 
LEFT JOIN 
    likes_count as l ON u.id=l.user_id
LEFT JOIN 
    comments_count as c ON u.id=c.user_id
LEFT JOIN
	photo_count as pp on u.id = pp.user_id
LEFT join 
    phototags_count as  p ON u.id=p.user_id
LEFT JOIN 
	Count_of_followers as f ON u.id = f.follower_id
order by engagement_rate_rank asc;

-- Task2. For inactive users, what strategies would you recommend to re-engage them and encourage them to start posting or engaging again?

with likes_count as (select distinct user_id,
		count(*) as num_of_likes from likes
group by user_id),
comments_count as (
select distinct user_id,
		count(*) as num_of_comments
from comments
group by user_id
),
photo_count as (
select distinct user_id,
		count(*) as num_of_photos
from photos 
group by user_id
),
phototags_count as (
select p.user_id,
		count(pt.tag_id) as num_of_phototags
from photos p 
join photo_tags as pt on p.id = pt.photo_id
group by p.user_id
) ,
Count_of_followers as (
select follower_id , count(follower_id) as follower_count ,
count(followee_id) as followee_count
from follows 
group by follower_id)

select u.id as UserID,
		u.username,
        coalesce(l.num_of_likes ,0)  as num_of_likes,
        coalesce(c.num_of_comments, 0) as num_of_comments,
        coalesce(pp.num_of_photos,0) as num_of_photos,
        coalesce(p.num_of_phototags,0) as num_of_phototags,
        coalesce(f.follower_count,0) as follower_count,
        coalesce(f.followee_count,0) as followee_count,
        coalesce((l.num_of_likes+c.num_of_comments+pp.num_of_photos),0)  as engagement_rate,
        rank() over(order by (l.num_of_likes+c.num_of_comments+pp.num_of_photos) asc ) as engagement_rate_rank
from users u 
LEFT JOIN 
    likes_count as l ON u.id=l.user_id
LEFT JOIN 
    comments_count as c ON u.id=c.user_id
LEFT JOIN
	photo_count as pp on u.id = pp.user_id
LEFT join 
    phototags_count as  p ON u.id=p.user_id
LEFT JOIN 
	Count_of_followers as f ON u.id = f.follower_id
order by engagement_rate_rank asc;

-- Task 3. Which hashtags or content topics have the highest engagement rates? How can this information guide content strategy and ad campaigns?

with Likes as (
SELECT photo_id, COUNT(*) AS total_likes 
FROM likes GROUP BY photo_id),

Comments as (  
  SELECT photo_id, COUNT(*) AS total_comments 
  FROM comments GROUP BY photo_id)
  
SELECT t.tag_name,
    COUNT(pt.photo_id) AS total_posts,
    SUM(l.total_likes) AS total_likes,
    SUM(c.total_comments) AS total_comments,
    ROUND((COALESCE(SUM(l.total_likes), 0) + COALESCE(SUM(c.total_comments), 0)) / COUNT(pt.photo_id),0) AS average_engagement
FROM tags t
JOIN photo_tags pt 
ON t.id = pt.tag_id
LEFT JOIN Likes as l 
on pt.photo_id = l.photo_id
LEFT JOIN Comments as c
on pt.photo_id = c.photo_id
group by t.tag_name
order by average_engagement desc;

-- Task-4. Are there any patterns or trends in user engagement based on
-- demographics (age, location, gender) or posting times?
--  How can these insights inform targeted marketing campaigns?

With Likes as 
(SELECT photo_id, COUNT(*) AS Total_likes 
FROM likes GROUP BY photo_id) , 

Comments as 
(SELECT photo_id, COUNT(*) AS Total_comments 
FROM comments GROUP BY photo_id) 

 SELECT
    DATE_FORMAT(p.created_dat, '%H') AS Hour_of_day,
    COUNT(p.id) AS Total_posts,
    COALESCE(SUM(L.Total_likes), 0) AS Total_likes,
    COALESCE(SUM(c.Total_comments), 0) AS Total_comments,
    ROUND((COALESCE(SUM(l.Total_likes), 0) + COALESCE(SUM(c.Total_comments), 0)) / COUNT(p.id),0) 
    AS Average_engagement
FROM photos AS p
LEFT JOIN Likes as l
ON p.id = l.photo_id
LEFT JOIN Comments as c 
ON p.id = c.photo_id
GROUP BY Hour_of_day ;

-- Task 5 Based on follower counts and engagement rates, 
-- which users would be ideal candidates for influencer marketing campaigns? 
-- How would you approach and collaborate with these influencers?

WITH Followers AS (
    SELECT f.follower_id AS user_id,
          COUNT(f.follower_id) AS follower_count
    FROM follows f
    GROUP BY f.follower_id),
total_likes_n_comments AS (
    SELECT p.user_id,
        COUNT(DISTINCT l.user_id) AS total_likes,
        COUNT(DISTINCT c.id) AS total_comments
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY p.user_id),
Final AS (
    SELECT u.id, u.username as Username,
	coalesce(sum(f.follower_count),0) as Follower_count,
	coalesce(sum(t.total_likes),0) AS Total_likes,
	coalesce(sum(t.total_comments),0) AS Total_comments,
	Round(coalesce(sum(t.total_likes), 0) + coalesce(sum(t.total_comments),0) / coalesce(count(f.follower_count),1),0) 
	AS Engagement_rate
    FROM users u
    LEFT JOIN Followers f ON u.id = f.user_id
    LEFT JOIN total_likes_n_comments t ON u.id = t.user_id
    group by u.id ,u.username )
    
SELECT
    id AS User_id, Username, Follower_count, 
    Total_likes, Total_comments, Engagement_rate
FROM Final 
ORDER BY engagement_rate DESC, follower_count DESC;

-- Task 6.	Based on user behaviour and engagement data, 
-- how would you segment the user base for targeted marketing campaigns or personalized recommendations?

With Likes as 
 (SELECT user_id, COUNT(*) AS likes_count 
 FROM likes 
 GROUP BY user_id),
 
Comments as 
 (SELECT user_id, COUNT(*) AS comments_count 
 FROM comments 
 GROUP BY user_id) 
 
 SELECT 
    u.id AS user_id,
    u.username,
    COALESCE(SUM(likes_count), 0) AS Total_likes,
    COALESCE(SUM(comments_count), 0) AS Total_comments,
    COALESCE(COUNT(DISTINCT p.id), 0) AS Total_photos,
    CASE 
        WHEN COALESCE(COUNT(DISTINCT p.id), 0) = 0 THEN 0 
        ELSE (COALESCE(SUM(likes_count), 0) + COALESCE(SUM(comments_count), 0)) / COALESCE(COUNT(DISTINCT p.id), 1) 
    END AS Engagement_rate,
    CASE 
        WHEN COALESCE(COUNT(DISTINCT p.id), 0) = 0 THEN 'Inactive Users'
        WHEN (COALESCE(SUM(likes_count), 0) + COALESCE(SUM(comments_count), 0)) / COALESCE(COUNT(DISTINCT p.id), 1) > 150 THEN 'Ative Users'
        WHEN (COALESCE(SUM(likes_count), 0) + COALESCE(SUM(comments_count), 0)) / COALESCE(COUNT(DISTINCT p.id), 1) BETWEEN 100 AND 150 
        THEN 'Moderately Active Users'
        ELSE 'Inactive Users'
    END AS Engagement_level
FROM users as u
LEFT JOIN photos p ON u.id = p.user_id
LEFT JOIN Likes as l 
ON u.id = l.user_id
LEFT JOIN Comments as c
ON u.id = c.user_id
GROUP BY u.id, u.username
ORDER BY engagement_rate DESC;

-- For Presentation 

-- Data overview 

-- Tabels 
show tables;

-- Count of users
select count(username) as count_of_username from users;

-- Count of posts 
select count(distinct id) as count_of_post from photos;

-- Count of likes 
select count(user_id) as count_of_likes from likes;

-- Count of comments
select count(id) as count_of_comments from comments ;

-- User activity (comments)

with CTE as (
select user_id ,count(id) as Total_Photos
from photos
group by user_id
order by Total_Photos desc),

CTE2 as (
select id , username from users) 

select Total_Photos ,count(username) as Count_of_users 
from CTE as a
left join CTE2 as b 
on a.user_id = b.id 
group by Total_Photos
order by Total_Photos desc;

-- User activity (likes)

with CTE as (
select user_id ,count(user_id) as Total_Likes
from likes
group by user_id
order by Total_Likes desc),

CTE2 as (
select id , username from users) 

select Total_Likes ,count(username) as Count_of_users 
from CTE as a
left join CTE2 as b 
on a.user_id = b.id 
group by Total_Likes
order by Total_Likes desc;

-- User activity (comments)

with CTE as (
select user_id ,count(id) as Total_comments
from comments
group by user_id
order by Total_comments desc),

CTE2 as (
select id , username from users) 

select Total_comments ,count(username) as Count_of_users 
from CTE as a
left join CTE2 as b 
on a.user_id = b.id 
group by Total_comments
order by Total_comments desc;

