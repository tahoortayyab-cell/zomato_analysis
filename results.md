# 📊 Zomato Restaurant Analysis — Query Results

---

## Q1. Which cities have the highest number of restaurants?

| City | Total Restaurants |
|---|---|
| New Delhi | 5473 |
| Gurgaon | 1118 |
| Noida | 1080 |
| Faridabad | 251 |

---

## Q2. What is the average restaurant rating in each city?

Top cities by avg rating (cities with fewer restaurants rank higher due to less competition).

---

## Q3. Best value restaurants (high rating > 2.67, low cost < 1199)

Multiple budget-friendly restaurants achieve top ratings across Indian cities.

---

## Q4. Average cost for two people by city

| City | AVG Cost For Two |
|---|---|
| Jakarta | 308,437.50 (IDR) |
| Tangerang | 250,000.00 (IDR) |
| Bogor | 160,000.00 (IDR) |

> Note: Values in local currency — not directly comparable across countries.

---

## Q5. Percentage of restaurants offering online delivery

| Total Restaurants | Online Delivery % |
|---|---|
| 9551 | 25.66% |

---

## Q6. Percentage of restaurants offering table booking

| Total Restaurants | Table Booking % |
|---|---|
| 9551 | 12.12% |

---

## Q7. Percentage of restaurants currently delivering now

| Total Restaurants | Delivering Now % |
|---|---|
| 9551 | 0.36% |

---

## Q8. Restaurant distribution across price ranges

| Price Range | Total Restaurants |
|---|---|
| 1 (Budget) | 4444 |
| 2 | 3113 |
| 3 | 1408 |
| 4 (Luxury) | 586 |

---

## Q9. Average rating for each rating category

| Rating Text | AVG Rating |
|---|---|
| Excellent | 4.66 |
| Very Good | 4.17 |
| Good | 3.68 |
| Average | 3.05 |
| Poor | 2.30 |
| Not rated | 0.00 |

---

## Q10. Average rating for each price range

| Price Range | AVG Rating |
|---|---|
| 4 (Luxury) | 3.82 |
| 3 | 3.68 |
| 2 | 2.94 |
| 1 (Budget) | 2.00 |

---

## Q11. Cities with highest avg ratings (min 50 restaurants)

| City | AVG Rating |
|---|---|
| Gurgaon | 2.65 |
| New Delhi | 2.44 |
| Noida | 2.04 |
| Faridabad | 1.87 |

---

## Q12. Localities with highest number of restaurants

| Locality | Total Restaurants |
|---|---|
| Connaught Place | 122 |
| Rajouri Garden | 99 |
| Shahdara | 87 |
| Defence Colony | 86 |
| Malviya Nagar | 85 |

---

## Q13. Average ratings: online delivery vs no delivery

| Has Online Delivery | AVG Rating |
|---|---|
| Yes | 3.25 |
| No | 2.47 |

---

## Q14. Average ratings: table booking vs no table booking

| Has Table Booking | AVG Rating |
|---|---|
| Yes | 3.44 |
| No | 2.56 |

---

## Q15. Most common cuisines across all restaurants

| Cuisine | Total |
|---|---|
| North Indian | 3960 |
| Chinese | 2735 |
| Fast Food | 1986 |
| Mughlai | 995 |
| Italian | 764 |

---

## Q16. Cuisines with highest customer engagement (avg votes)

| Cuisine | AVG Votes |
|---|---|
| Sunda | 1838.00 |
| Iranian | 1791.33 |
| Bi_rek | 1305.00 |
| Peranakan | 1159.00 |
| Pub Food | 1042.00 |

---

## Q17. Most popular cuisine per city (sample)

| City | Cuisine | Total |
|---|---|---|
| Abu Dhabi | Indian | 7 |
| Agra | North Indian | 15 |
| Ahmedabad | Continental | 12 |
| Albany | American / Steak | 4 (tie) |

---

## Q18. Country with highest % of table booking restaurants

| Country Code | Total Restaurants | Table Booking % |
|---|---|---|
| 162 (Philippines) | 22 | 63.64% |
| 214 | 60 | 30.00% |
| 215 | 80 | 15.00% |

---

## Q19. Top 10 highest-rated restaurants (more than 100 votes)

| Restaurant | Rating | Votes |
|---|---|---|
| Shorts Burger and Shine | 4.9 | 820 |
| Tantra Asian Bistro | 4.9 | 474 |
| Atlanta Highway Seafood Market | 4.9 | 681 |
| Oakwood Cafe | 4.9 | 249 |
| The Cafe | 4.9 | — |

---

## Q20. Restaurants with highest number of votes

| Restaurant | Votes |
|---|---|
| Toit | 10934 |
| Truffles | 9667 |
| Hauz Khas Social | 7931 |
| Peter Cat | 7574 |
| AB's - Absolute Barbecues | 6907 |

---

## Q21. Top 3 restaurants per city (sample)

| Restaurant | City | Rating | Votes | Rank |
|---|---|---|---|---|
| Punjab Grill | Abu Dhabi | 4.9 | 216 | 1 |
| Tamba | Abu Dhabi | 4.7 | 201 | 2 |
| The Cheesecake Factory | Abu Dhabi | 4.6 | 586 | 3 |
| Sheroes Hangout | Agra | 4.9 | 77 | 1 |

---

## Q22. Best cuisine + price range combinations

| Cuisine | Price Range | AVG Rating |
|---|---|---|
| Sunda | 3 | 4.90 |
| Taiwanese | 2 | 4.90 |
| Deli | 1 | 4.90 |
| Curry | 4 | 4.70 |
| Scottish | 3 | 4.70 |

---

## Q23. Reputation risk restaurants (high votes, low rating)

Restaurants with above-average votes (>138) AND below-average rating (<2.67).

---

## Q24. Online delivery impact on engagement and ratings

| Has Online Delivery | AVG Rating | AVG Votes |
|---|---|---|
| Yes | 3.25 | 211.31 |
| No | 2.47 | 138.13 |

---

## Q25. Table booking impact on ratings and price range

| Has Table Booking | AVG Rating | AVG Price Range |
|---|---|---|
| Yes | 3.44 | 3.03 |
| No | 2.56 | 1.64 |

---

## Q26. Price range vs average rating

| Price Range | AVG Rating |
|---|---|
| 4 (Luxury) | 3.82 |
| 3 | 3.68 |
| 2 | 2.94 |
| 1 (Budget) | 2.00 |

---

## Q27. Cities with high restaurant count but below-average ratings

High-density cities like New Delhi show below-average ratings — market saturation effect.

---

## Q28. Market gap cuisines (high rating, few restaurants)

| Cuisine | AVG Rating | Total Restaurants |
|---|---|---|
| Sunda | 4.90 | 3 |
| Bi_rek | 4.70 | 1 |
| Taiwanese | 4.65 | 2 |
| Ramen | 4.50 | 2 |
| Dim Sum | 4.47 | 3 |

---

## Q29. Hidden Gems (rating > 4.5, votes below city average)

| Restaurant | City | Rating | Votes |
|---|---|---|---|
| Le Petit Souffle | Makati City | — | 314 |
| Sambo Kojin | Mandaluyong City | — | 229 |
| Locavore | Pasig City | — | 532 |

---

## Q30. High visibility, low satisfaction restaurants

| Restaurant | Votes | Rating | Vote Rank | Rating Rank |
|---|---|---|---|---|
| Pind Balluchi | 322 | 1.8 | 0.12 | 0.22 |
| Club Ice Cube | 230 | 2.0 | 0.16 | 0.23 |
| Yo! China | 191 | 2.0 | 0.19 | 0.23 |

> Note: Rating threshold relaxed to bottom 50% — strict bottom 20% yielded no results in this dataset, and only the top 3 results of all queries are display here.
