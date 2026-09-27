# 🍽️ Zomato Restaurant Analysis — SQL Project

## Project Overview

This project performs in-depth exploratory data analysis on the Zomato restaurant dataset using MySQL. The dataset contains restaurant-level information from multiple countries including India, Philippines, USA, UAE, and more — covering ratings, cuisines, delivery options, pricing, and customer engagement.

The goal was to go beyond surface-level queries and answer real business questions: Which cuisines are underserved? Where are the market gaps? Which restaurants have high traffic but poor quality? What drives customer engagement?

- **Database:** zomato_analysis
- **Table:** zomato
- **Tool Used:** MySQL Workbench
- **Total Queries:** 30
- **Dataset Size:** 9,551 rows
- **Dataset Source:** [Kaggle — Zomato Restaurants Data](https://www.kaggle.com/datasets/shrutimehta/zomato-restaurants-data)

---

## Dataset Description

The `zomato` table contains restaurant-level data with the following key columns:

| Column | Description |
|---|---|
| RestaurantID | Unique restaurant identifier |
| RestaurantName | Name of the restaurant |
| CountryCode | Numeric country code |
| City | City where the restaurant is located |
| Locality | Local area or neighborhood |
| Cuisines | Cuisine types offered — comma-separated (e.g. "North Indian, Chinese") |
| AvgCostForTwo | Average cost for two people in local currency |
| Currency | Local currency of the country |
| HasTableBooking | Whether table booking is available (Yes/No) |
| HasOnlineDelivery | Whether online delivery is available (Yes/No) |
| IsDeliveringNow | Real-time delivery status at data collection time (Yes/No) |
| PriceRange | Price range category — 1 (Budget) to 4 (Luxury) |
| AggregateRating | Overall restaurant rating on a scale of 0 to 5 |
| RatingText | Rating label — Excellent, Very Good, Good, Average, Poor, Not Rated |
| Votes | Total number of customer votes/reviews |

> **Important Notes:**
> - `AvgCostForTwo` is in local currency per country — cross-country comparisons are misleading without currency normalization (e.g. Jakarta's 308,437 is Indonesian Rupiah, not USD).
> - `IsDeliveringNow` is a real-time snapshot taken at data collection time — it does not represent a meaningful business trend and was analyzed only for completeness.

---

## Technical Challenges & How They Were Solved

### Challenge 1 — CSV Import Encoding Issue
The dataset contained international city names with special characters (Turkish, European accents) saved in Latin-1 encoding. MySQL Workbench's Table Data Import Wizard silently dropped 99.7% of the data — only 27 out of 9,551 rows were imported with no error shown.

**Solution:** Used `LOAD DATA INFILE` with explicit `CHARACTER SET latin1` to correctly handle the encoding and load all 9,551 rows.

```sql
LOAD DATA INFILE 'path/to/zomato.csv'
INTO TABLE zomato
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
```

**Key lesson:** GUI import tools silently fail on messy international data. Command-level control is always more reliable.

---

### Challenge 2 — Comma-Separated Cuisine Column
The `Cuisines` column stores multiple cuisines in a single cell (e.g. `"North Indian, Chinese, Fast Food"`). Standard `GROUP BY Cuisines` would treat each combination as a separate group — meaning "North Indian, Chinese" and "North Indian" would be counted separately instead of both counting toward "North Indian."

**Solution:** Used **Recursive CTEs with `SUBSTRING_INDEX()`** to split the comma-separated string into individual rows before grouping:

```sql
WITH RECURSIVE CTE AS (
    SELECT TRIM(SUBSTRING_INDEX(Cuisines, ',', 1)) AS cuisine,
           SUBSTRING(Cuisines, LENGTH(SUBSTRING_INDEX(Cuisines, ',', 1)) + 2) AS remaining
    FROM zomato
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
           SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)
    FROM CTE WHERE remaining != ''
)
SELECT cuisine, COUNT(*) AS total FROM CTE GROUP BY cuisine ORDER BY total DESC;
```

This technique was applied in Q15, Q16, Q17, Q22, and Q28.

---

## SQL Concepts Used

| Concept | Applied In |
|---|---|
| GROUP BY + Aggregations (COUNT, AVG, SUM, ROUND) | Q1–Q14, Q18, Q24–Q27 |
| CASE WHEN for conditional counting | Q5, Q6, Q7, Q18 |
| Subqueries (scalar + correlated) | Q3, Q23, Q27, Q29 |
| Recursive CTEs + SUBSTRING_INDEX | Q15, Q16, Q17, Q22, Q28 |
| Window Functions — RANK(), DENSE_RANK() | Q17, Q21 |
| Window Functions — PERCENT_RANK() | Q30 |
| HAVING clause | Q11 |
| Multiple JOINs / Self-referencing subqueries | Q29 |

---

## Business Questions Answered

| # | Question | Key Technique |
|---|---|---|
| 1 | Which cities have the most restaurants? | GROUP BY + COUNT |
| 2 | Average restaurant rating by city? | AVG + ORDER BY |
| 3 | Best value restaurants (high rating, low cost)? | WHERE + Subquery |
| 4 | Average cost for two by city? | AVG + GROUP BY |
| 5 | % restaurants with online delivery? | CASE WHEN + COUNT |
| 6 | % restaurants with table booking? | CASE WHEN + COUNT |
| 7 | % restaurants currently delivering? | CASE WHEN + COUNT |
| 8 | Distribution across price ranges? | GROUP BY + COUNT |
| 9 | Avg rating per rating category? | AVG + GROUP BY |
| 10 | Avg rating per price range? | AVG + GROUP BY |
| 11 | Cities with highest avg ratings (min 50 restaurants)? | HAVING + AVG |
| 12 | Localities with most restaurants? | GROUP BY + COUNT |
| 13 | Online delivery vs no delivery — ratings? | GROUP BY + AVG |
| 14 | Table booking vs no booking — ratings? | GROUP BY + AVG |
| 15 | Most common cuisines globally? | Recursive CTE |
| 16 | Cuisines with highest avg votes? | Recursive CTE + AVG |
| 17 | Most popular cuisine per city? | Recursive CTE + RANK() |
| 18 | Country with highest table booking %? | CASE WHEN + GROUP BY |
| 19 | Top 10 highest-rated restaurants (100+ votes)? | WHERE + ORDER BY + LIMIT |
| 20 | Most voted restaurants? | ORDER BY + LIMIT |
| 21 | Top 3 restaurants per city? | DENSE_RANK() + CTE |
| 22 | Best cuisine + price range combos? | Recursive CTE + AVG |
| 23 | High votes but low rating — reputation risks? | Correlated Subquery |
| 24 | Does online delivery boost engagement? | AVG + GROUP BY |
| 25 | Does table booking mean higher ratings? | AVG + GROUP BY |
| 26 | Do expensive restaurants get better ratings? | AVG + GROUP BY |
| 27 | Cities with many restaurants but low ratings? | Subquery + GROUP BY |
| 28 | High-rated cuisines with few restaurants (market gaps)? | Recursive CTE + COUNT DISTINCT |
| 29 | Hidden gems — high rating, low local visibility? | Correlated Subquery |
| 30 | High visibility but low satisfaction restaurants? | PERCENT_RANK() |

---

## Key Findings & Insights

### 🏙️ City & Market Analysis
- **New Delhi** has 5,473 restaurants — 57% of the entire dataset — yet has below-average ratings. Extreme market saturation drives quality scores down.
- Only 4 cities have 50+ restaurants (all in India's NCR region). Gurgaon leads in average rating (2.65) among these.
- **Connaught Place** is Delhi's most competitive locality with 122 restaurants.

### ⭐ Ratings & Quality
- Price range and rating are positively correlated — luxury restaurants (PriceRange 4) average 3.82 vs budget (PriceRange 1) at 2.00.
- However, budget restaurants CAN achieve top ratings (4.9) — price is not the only quality indicator.
- Restaurants with **online delivery** average 3.25 rating vs 2.47 without — a 0.78 point difference.
- Restaurants with **table booking** average 3.44 rating vs 2.56 without — a 0.88 point difference.

### 🍜 Cuisine Analysis
- **North Indian** is the most common cuisine with 3,960 restaurant mentions — nearly 3x more than Fast Food (1,986).
- **Sunda cuisine** generates the highest average votes (1,838) despite only 3 restaurants — niche cuisines drive higher engagement than common ones.
- **North Indian** restaurants average only 150 votes despite being the most common — high competition reduces individual visibility.

### 📈 Market Opportunities
- **Sunda, Taiwanese, Ramen, and Dim Sum** — high ratings (4.5+) but very few restaurants. Strong market gap opportunities for new entrants.
- **Hidden Gems** (Q29): Multiple restaurants in Manila/Philippines area have 4.5+ ratings but votes below their city average — undermarketed, high-quality restaurants.

### ⚠️ Reputation Risks
- **Pind Balluchi** — top 12% for votes (322) but only 1.8 aggregate rating. Classic high-traffic, low-satisfaction case.
- Q23 identifies restaurants with above-average votes (>138) AND below-average rating (<2.67) — these are brands relying on historical popularity while quality has declined.

### 🌍 International Insights
- **Philippines (CountryCode 162)** leads in table booking adoption at 63.64%.
- **Toit (Bangalore, India)** is the most-voted restaurant globally with 10,934 votes.
- **Jakarta** appears most expensive by AvgCostForTwo (308,437) — but this is Indonesian Rupiah, not comparable to other currencies.

---

## Project Files

| File | Description |
|---|---|
| `zomato_analysis.sql` | All 30 SQL queries |
| `results.md` | Query outputs and result tables |
| `README.md` | This file — project overview and insights |

---

**Author:** Tahoor Tayyab
**GitHub:** [github.com/tahoortayyab-cell](https://github.com/tahoortayyab-cell)
**LinkedIn:** [linkedin.com/in/tahoor-tayyab](https://linkedin.com/in/tahoor-tayyab)

**SQL Project — Zomato Restaurant Analysis**
Tool: MySQL Workbench | Dataset: Kaggle Zomato (9,551 rows)
