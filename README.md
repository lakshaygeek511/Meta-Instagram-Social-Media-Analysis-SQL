<div align="center">

<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL"/>
<img src="https://img.shields.io/badge/PowerPoint-B7472A?style=for-the-badge&logo=microsoft-powerpoint&logoColor=white" alt="PowerPoint"/>
<img src="https://img.shields.io/badge/Data%20Analysis-0078D4?style=for-the-badge&logo=databricks&logoColor=white" alt="Data Analysis"/>
<img src="https://img.shields.io/badge/SQL%20Analytics-FF6F00?style=for-the-badge&logo=postgresql&logoColor=white" alt="SQL Analytics"/>
<img src="https://img.shields.io/badge/Meta-0668E1?style=for-the-badge&logo=meta&logoColor=white" alt="Meta"/>
<img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" alt="Instagram"/>

# 📸 Social Media Analysis — Meta · Instagram Clone

### A comprehensive SQL-driven analysis of a Instagram clone dataset to uncover actionable marketing insights on user engagement, retention, content strategy & campaign targeting.

---

</div>

## 🎯 Problem Statement

> As data analysts embedded with the **Marketing Team**, the goal is to transform raw engagement data from an Instagram-like relational database into concrete, data-backed strategies.

The Marketing team needs data-driven strategies to:
- 📈 **Increase** user engagement across the platform
- 🔁 **Improve** user retention and reduce churn
- 🚀 **Drive** new user acquisition via organic & paid channels
- 🎯 **Optimise** ad campaigns using hashtag, timing & content insights
- 🏆 **Identify & reward** the most loyal and valuable users

Without insights from existing data, campaigns remain generic and underperform. This analysis **bridges that gap**.

---

## 📌 Project Overview

This project performs an end-to-end SQL analysis on a **7-table relational Instagram clone dataset**, answering both objective data questions (metrics, distributions, rankings) and subjective business questions (strategy, campaigns, retention).

| Metric | Value |
|---|---|
| 🗄️ Total Tables Analysed | **7** |
| ❓ Objective Questions | **10** |
| 💡 Subjective Questions | **4** |
| 🏷️ Top Hashtags Identified | **10** |
| 🕖 Peak Engagement Hour | **7 PM** |
| ⭐ Avg. Engagement Score | **63 / hour** |
| 📊 Total Posts Analysed | **257 (peak window)** |

---

## 📂 Dataset Description

The dataset is a relational clone of Instagram's core data model, consisting of **7 interconnected tables**:

<img width="2084" height="1172" alt="image" src="https://github.com/user-attachments/assets/5f56bf9e-fac0-45a3-8c2f-4170cf39c3d3" />

---
## 🧹 Data Cleaning & Quality Check

| Check Performed | Method | Result |
|---|---|---|
| Duplicate detection | `GROUP BY` + `HAVING COUNT(*) > 1` | ✅ No duplicates found |
| NULL value check | `WHERE column IS NULL` | ✅ No nulls found |
| Duplicate deletion (if any) | `ROW_NUMBER()` window function + `DELETE` | ✅ Ready to use |
| Data integrity | Cross-table JOIN validation | ✅ All foreign keys consistent |

> ✅ **Dataset was found to be completely clean** — no duplicates or missing values across all 7 tables, allowing analysis to proceed directly without any data imputation.

---

## 🔍 Methodology

| Step | Action | Technique |
|---|---|---|
| **01 — Data Cleaning** | Check duplicates & NULLs across all tables | `ROW_NUMBER()`, `WHERE IS NULL`, `HAVING` |
| **02 — Exploratory SQL** | Compute per-user activity distributions | `LEFT JOIN`, `GROUP BY`, `COUNT(DISTINCT)` |
| **03 — Engagement Scoring** | Rank users by likes + comments + posts | `RANK()`, `DENSE_RANK()`, CTEs |
| **04 — Hashtag Analysis** | Find top hashtags by avg likes per post | CTEs on `photo_tags` & `tags`, `AVG()` |
| **05 — Temporal Analysis** | Identify peak posting & engagement hours | `EXTRACT(HOUR)`, grouped aggregation |
| **06 — Insights & Strategy** | Translate SQL outputs to recommendations | Business analysis & marketing strategy |

---

## 📊 Objective Questions & Key Findings

### Q1 — Data Quality: Duplicate & NULL Values
> **Result:** No duplicates or nulls found across any table. Dataset is production-ready.

---

### Q2 — User Activity Distribution (Posts, Likes, Comments)
> **Approach:** `LEFT JOIN` across `users → photos`, `likes`, `comments`. `COUNT(DISTINCT)` per metric.

**Key Insight:**
- Top **10%** of users generate ~**60%** of all posts & engagement — a classic Pareto distribution.
- **40%** of users show little-to-no activity — a significant re-engagement opportunity.

---

### Q3 — Average Tags Per Post
> **Approach:** CTE on `photo_tags` → `COUNT(DISTINCT tag_id)` per photo → `AVG()` of tag counts.

**Key Insight:** Calculated the average number of hashtags per post across the entire platform, serving as a baseline for content tagging strategy.

---

### Q4 — Top Users by Engagement Rate
> **Approach:** Two CTEs for total likes & total comments per user → combined via `INNER JOIN` → ranked with `DENSE_RANK()`.

| Metric | Value |
|---|---|
| Avg Platform Engagement | **63** |
| Top User Score | **1,720** |
| Top Users Multiplier | **4–6×** platform average |

**Key Insight:** Top 20 users show engagement rates **4–6× the platform average**, making them ideal brand ambassador or early-access candidates.

---

### Q5 — Highest Followers & Followings
> **Approach:** Two CTEs (`count_follower`, `count_following`) → `LEFT JOIN` with `users` → `COALESCE()` for zero-fill.

**Key Insight:** Identifies high-reach accounts ideal for organic growth campaigns and influencer seeding.

---

### Q6 — Average Engagement Rate Per Post Per User
> **Approach:** Three-CTE pipeline (`Post_Likes` → `Post_Comments` → `Engagement`) → `AVG(total_engagement)` per user.

**Key Insight:** Surfaces users with the strongest per-post performance, uncovering quality creators vs. high-volume low-quality posters.

---

### Q7 — Users Who Never Liked Any Post
> **Approach:** `LEFT JOIN` users with likes → `WHERE likes.photo_id IS NULL`.

**Key Insight:** These passive users are prime candidates for targeted re-engagement nudges and gamification prompts.

---

### Q8 — Most Used Hashtags (Ad Campaign Targeting)
> **Approach:** `JOIN tags → photo_tags` → `GROUP BY tag_name` → `ORDER BY COUNT DESC`.

**Key Insight:** Most-used tags signal the strongest organic interest areas for ad creative alignment.

---

### Q9 — Monthly Engagement Ranking
> **Approach:** `Post_likes` + `Post_comments` CTEs → `DENSE_RANK()` on `total_engagement DESC`.

> **Note:** Likes & comments data is available for **June 2025 only** in this dataset.

---

### Q10 — Top Hashtags by Average Likes
> **Approach:** `Likes_Count` CTE → `JOIN tags → photo_tags → Likes_Count` → `AVG(LikesCount)` per tag → `ORDER BY Avg_likes DESC`.

**Key Insight:**

| Rank | Hashtag | Theme |
|---|---|---|
| 1 | #Beauty | Lifestyle |
| 2 | #Delicious | Food |
| 3 | #Foodie | Food |
| 4 | #Dreamy | Aesthetic |
| 5 | #Food | Food |
| 6 | #Photography | Creative |
| 7 | #Smile | Lifestyle |
| 8 | #Stunning | Aesthetic |
| 9 | #Sunset | Nature/Travel |
| 10 | #Beach | Nature/Travel |

> 🍕 **Beauty, Food & Photography dominate** — ad creative and influencer briefs aligned to these themes will maximise organic reach.

---

### Q11 — Users Who Followed Back After Being Followed
> **Approach:** Self-join on `follows` table (swap `follower_id ↔ followee_id`) → filter `f1.created_at > f2.created_at`.

**Key Insight:** Reveals reciprocal follow behaviour patterns — a key signal of community formation and healthy social graph growth.

---

## 💡 Subjective Questions & Strategy Recommendations

### SQ1 — Who Are the Most Loyal & Valuable Users?
> **Engagement Score = Total Likes + Total Comments + Total Posts**

Ranked using `RANK() DESC` across a multi-CTE pipeline aggregating all activity signals per user.

**Reward & Incentive Strategies:**

| Strategy | Description |
|---|---|
| 🏅 Custom Badges | "Top Creator", "Power User", "Community Leader" — public recognition |
| 🛠️ Early Feature Access | Analytics dashboards, content scheduling, engagement insights |
| 🎉 Exclusive Events | Virtual & in-person networking events for top performers |
| 🎁 Discounts & Credits | Platform credits and partner discounts to reward loyalty |

---

### SQ2 — How Do We Re-engage Inactive Users?
> Same scoring as SQ1 but `RANK() ASC` to surface lowest-engagement users. `COALESCE()` fills NULLs with 0.

**Re-engagement Strategies:**

| Strategy | Description |
|---|---|
| 📧 Personalised Emails | Show missed popular content & tailored recommendations |
| 🔔 In-App Nudges | Milestone alerts (e.g., "You're 10 away from 100 followers!") |
| 🎮 Gamification | Weekly posting streaks, "Most Liked Photo" contests with rewards |
| 📝 Content Templates | Ready-to-post prompts & re-onboarding guides for returning users |
| 💬 Feedback Loops | Update Explore page to highlight content matching past interests |

---

### SQ3 — Which Hashtags Drive the Highest Engagement?
> Two CTEs (`Likes`, `Comments`) → join `tags → photo_tags → CTEs` → `AVG(likes + comments) / posts` per tag → `TOP 10 DESC`.

**Content Strategy & Ad Campaign Implications:**

| Strategy | Action |
|---|---|
| 📅 Content Planning | Creators incorporate top hashtags to boost visibility |
| 🎯 Ad Targeting | Align ad themes to Food, Beauty, Travel & Photography |
| 📆 Trend Alignment | Launch seasonal campaigns with #sunset, #beach, #stunning |
| 🤝 Influencer Collabs | Partner with creators who regularly use top-10 hashtags |
| 🔗 Hashtag Pairing | Combine branded + popular tags (e.g., #delicious + #foodie) for discoverability |

---

### SQ4 — Peak Engagement Hours for Targeted Marketing
> Two CTEs for likes & comments per photo → joined with `EXTRACT(HOUR FROM created_at)` → `AVG((likes + comments) / posts)` per hour.

| Metric | Value |
|---|---|
| 🕖 Peak Engagement Hour | **7 PM** |
| ⭐ Max Avg Engagement Score | **63** |
| 📊 Posts in Peak Window | **257** |
| 👍 Likes in Peak Window | **8,782** |
| 💬 Comments in Peak Window | **7,488** |

**Key Insight:** Scheduling ads, promoted posts, and push notifications at **7 PM** will maximise reach and interaction rates. Pair this with top hashtags for compounding impact.

---

## 🚀 Platform Improvement Roadmap

| Feature | Category | Description |
|---|---|---|
| 📊 Live Engagement Dashboard | Analytics | Real-time hourly spikes, trending hashtags & top posts — react to viral moments in minutes |
| 🤖 Auto Re-engagement Triggers | Automation | ML-based inactivity detection (14-day silence) auto-fires personalised push/email sequences |
| 🏷️ Smart Hashtag Insights | Discovery | Recommend high-performing hashtags to creators at post time to boost organic reach |

---

## 📁 Project Structure

```
📦 Social-Media-Analysis-Meta-IG-Clone/
│
├── 📄 Social_Media_Analysis___Meta_IG_Clone__.docx
│     ├── Objective Questions (Q1–Q10) with SQL Approaches & Results
│     └── Subjective Questions (SQ1–SQ4) with Insights & Recommendations
│
├── 🗄️ Social_Media_Analysis_Meta_IG_Clone.sql
│     ├── Data Cleaning Queries
│     ├── Objective SQL Queries (Tasks 1–11)
│     └── Subjective SQL Queries (Tasks 1–4)
│
├── 📽️ Meta_IG_Social_Media_Analysis.pptx
│     └── Executive Summary Presentation (12 Slides)
│
└── 📝 README.md
```

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **MySQL** | Primary database engine — all queries, CTEs, window functions |
| **SQL CTEs** | Multi-step aggregation pipelines for engagement scoring |
| **Window Functions** | `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()` for ranking & deduplication |
| **Microsoft PowerPoint** | 12-slide executive summary of all findings & strategies |
| **Microsoft Word** | Detailed written analysis document with query explanations |

### 🔑 Key SQL Techniques Used

```sql
-- Window Functions
RANK() OVER (ORDER BY engagement DESC)
DENSE_RANK() OVER (ORDER BY total_likes + total_comments DESC)
ROW_NUMBER() OVER (PARTITION BY id ORDER BY id)

-- CTEs (Common Table Expressions)
WITH cte_name AS (SELECT ...)

-- Temporal Extraction
EXTRACT(HOUR FROM created_at)

-- NULL Handling
COALESCE(value, 0)

-- Aggregation
COUNT(DISTINCT), AVG(), SUM(), GROUP BY, HAVING
```

---

## 🚀 How to Use

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/Social-Media-Analysis-Meta-IG-Clone.git
   cd Social-Media-Analysis-Meta-IG-Clone
   ```

2. **Set up the database**
   ```sql
   CREATE DATABASE ig_clone;
   USE ig_clone;
   -- Import the schema and seed data, then run:
   SOURCE Social_Media_Analysis_Meta_IG_Clone.sql;
   ```

3. **Run the SQL analysis**
   - Open `Social_Media_Analysis_Meta_IG_Clone.sql` in MySQL Workbench or any SQL client
   - Execute queries section by section (Objective → Subjective)
   - Results map directly to the findings in the `.docx` analysis document

4. **Review the Analysis Document**
   ```
   Social_Media_Analysis___Meta_IG_Clone__.docx
   ```
   - Objective Questions (Q1–Q10): SQL logic, approach, and query results
   - Subjective Questions (SQ1–SQ4): Business insights and marketing strategies

5. **View the Presentation**
   ```
   Meta_IG_Social_Media_Analysis.pptx
   ```
   - 12-slide executive summary for stakeholder presentation

---

<div align="center">

---

### 📊 Quick Stats

![Tables](https://img.shields.io/badge/Tables%20Analysed-7-blue?style=flat-square)
![Objective Qs](https://img.shields.io/badge/Objective%20Questions-10-green?style=flat-square)
![Subjective Qs](https://img.shields.io/badge/Subjective%20Questions-4-brightgreen?style=flat-square)
![Top Hashtags](https://img.shields.io/badge/Top%20Hashtags-10-orange?style=flat-square)
![Peak Hour](https://img.shields.io/badge/Peak%20Engagement-7%20PM-red?style=flat-square)
![Avg Engagement](https://img.shields.io/badge/Avg%20Engagement%20Score-63-purple?style=flat-square)

---

*Analysis by **Lakshay Garg** · Meta Instagram Clone · Data Analytics & Marketing Strategy*

</div>
