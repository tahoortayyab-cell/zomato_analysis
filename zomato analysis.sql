CREATE DATABASE zomato_analysis;
USE zomato_analysis;

CREATE TABLE zomato (
    RestaurantID BIGINT,
    RestaurantName VARCHAR(255),
    CountryCode INT,
    City VARCHAR(100),
    Address VARCHAR(500),
    Locality VARCHAR(255),
    LocalityVerbose VARCHAR(255),
    Longitude DOUBLE,
    Latitude DOUBLE,
    Cuisines VARCHAR(255),
    AvgCostForTwo INT,
    Currency VARCHAR(50),
    HasTableBooking VARCHAR(10),
    HasOnlineDelivery VARCHAR(10),
    IsDeliveringNow VARCHAR(10),
    SwitchToOrderMenu VARCHAR(10),
    PriceRange INT,
    AggregateRating DECIMAL(3,1),
    RatingColor VARCHAR(50),
    RatingText VARCHAR(50),
    Votes INT
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/zomato.csv'
INTO TABLE zomato
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 1. Which cities have the highest number of restaurants?

SELECT City, COUNT(*) AS total_restaurants
FROM zomato
GROUP BY City
ORDER BY total_restaurants DESC;

-- 2. What is the average restaurant rating in each city?

SELECT City, AVG(AggregateRating) AS avg_rating
FROM zomato
GROUP BY City 
ORDER BY avg_rating DESC;

-- 3. Which restaurants offer the best value — high rating but low average cost for two — segmented by city?

SELECT RestaurantName, City, AvgCostForTwo, AggregateRating
FROM zomato
WHERE AggregateRating > 2.67 AND AvgCostForTwo < 1199 AND AvgCostForTwo > 0
ORDER BY AggregateRating DESC, AvgCostForTwo ASC;

-- 4. What is the average cost for two people by city?

SELECT City, AVG(AvgCostForTwo) AS avg_cost_for_two
FROM zomato 
GROUP BY City 
ORDER BY avg_cost_for_two DESC;

-- 5. What percentage of restaurants offer online delivery?

SELECT COUNT(*) AS total_restaurants,
ROUND
	(COUNT
		(CASE WHEN HasOnlineDelivery = 'Yes' THEN 1 ELSE NULL END) / COUNT(*) * 100.0, 2)
			AS pct_online_delivery
FROM zomato;

-- 6. What percentage of restaurants offer table booking?

SELECT COUNT(*) AS total_restaurants,
ROUND
	(COUNT
		(CASE WHEN HasTableBooking = 'Yes' THEN 1 ELSE NULL END) / COUNT(*) * 100.0, 2) 
			AS pct_table_booking
FROM zomato;

-- 7. What percentage of restaurants are currently delivering now?

SELECT COUNT(*) AS total_restaurants,
ROUND
	(COUNT
		(CASE WHEN IsDeliveringNow = 'Yes' THEN 1 ELSE NULL END) / COUNT(*) * 100.0, 2) 
			AS pct_delivering_now
FROM zomato;

-- 8. How are restaurants distributed across different price ranges?

SELECT PriceRange, COUNT(*) AS total_restaurants
FROM zomato 
GROUP BY PriceRange 
ORDER BY total_restaurants DESC;

-- 9. What is the average rating for each rating category (Excellent, Very Good, Good, Average, Poor)?

SELECT RatingText, AVG(AggregateRating) AS avg_rating
FROM zomato 
GROUP BY RatingText 
ORDER BY avg_rating DESC;

-- 10. What is the average rating for each price range?

SELECT PriceRange, AVG(AggregateRating) AS avg_rating
FROM zomato 
GROUP BY PriceRange 
ORDER BY avg_rating DESC;

-- 11. Which cities have the highest average restaurant ratings (minimum 50 restaurants)?

SELECT City, AVG(AggregateRating) AS avg_rating
FROM zomato 
GROUP BY City 
HAVING COUNT(*) >= 50 
ORDER BY avg_rating DESC;

-- 12. Which localities contain the highest number of restaurants?

SELECT Locality, COUNT(*) AS total_restaurants
FROM zomato 
GROUP BY Locality 
ORDER BY total_restaurants DESC;

-- 13. Compare average ratings of restaurants with and without online delivery.

SELECT HasOnlineDelivery, AVG(AggregateRating) AS avg_rating
FROM zomato 
GROUP BY HasOnlineDelivery 
ORDER BY avg_rating DESC;

-- 14. Compare average ratings of restaurants with and without table booking.

SELECT HasTableBooking, AVG(AggregateRating) AS avg_rating
FROM zomato 
GROUP BY HasTableBooking 
ORDER BY avg_rating DESC;

-- 15. Which cuisine types receive the highest average ratings?

WITH RECURSIVE CTE AS (
    SELECT TRIM(SUBSTRING_INDEX(Cuisines, ',', 1)) AS cuisine,
    SUBSTRING(Cuisines, LENGTH(SUBSTRING_INDEX(Cuisines, ',', 1)) + 2) AS remaining
    FROM zomato
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS cuisine,
    SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2) AS remaining
    FROM CTE WHERE remaining != ''
)
SELECT cuisine, COUNT(*) AS total
FROM CTE GROUP BY cuisine ORDER BY total DESC;

-- 16. Which cuisine types generate the highest customer engagement (average votes)?

WITH RECURSIVE CTE AS (
    SELECT 
        TRIM(SUBSTRING_INDEX(Cuisines, ',', 1)) AS cuisine,
        SUBSTRING(Cuisines, LENGTH(SUBSTRING_INDEX(Cuisines, ',', 1)) + 2) AS remaining,
        Votes
    FROM zomato
    UNION ALL
    SELECT 
        TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS cuisine,
        SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2) AS remaining,
        Votes
    FROM CTE WHERE remaining != ''
)
SELECT cuisine, AVG(Votes) AS avg_votes
FROM CTE GROUP BY cuisine ORDER BY avg_votes DESC;

-- 17. For each city, identify the most popular cuisine.

WITH RECURSIVE CTE AS (
    SELECT 
        TRIM(SUBSTRING_INDEX(Cuisines, ',', 1)) AS cuisine,
        SUBSTRING(Cuisines, LENGTH(SUBSTRING_INDEX(Cuisines, ',', 1)) + 2) AS remaining,
        City
    FROM zomato
    UNION ALL
    SELECT 
        TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS cuisine,
        SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2) AS remaining,
        City
    FROM CTE WHERE remaining != ''
)
SELECT City, cuisine, total
FROM (
    SELECT City, cuisine, COUNT(*) AS total,
    RANK() OVER (PARTITION BY City ORDER BY COUNT(*) DESC) AS rnk
    FROM CTE
    GROUP BY City, cuisine
) ranked
WHERE rnk = 1
ORDER BY City;

-- 18. Which country has the highest percentage of restaurants offering table booking?

SELECT 
    CountryCode,
    COUNT(*) AS total_restaurants,
    ROUND(
        COUNT(CASE 
            WHEN HasTableBooking = 'Yes' THEN 1 
            ELSE NULL
        END) / COUNT(*) * 100,
        2
    ) AS tablebookingspercentage
FROM zomato
GROUP BY CountryCode
ORDER BY tablebookingspercentage DESC;

-- 19. What are the top 10 highest-rated restaurants globally with more than 100 votes?

SELECT RestaurantName, AggregateRating, Votes
from zomato 
WHERE Votes > 100 
ORDER BY AggregateRating DESC 
LIMIT 10;

-- 20. Which restaurants received the highest number of votes?

SELECT RestaurantName, Votes
from zomato 
ORDER BY Votes DESC
LIMIT 10;

-- 21. Rank the top 3 restaurants in each city based on ratings and votes.

WITH ranked AS( 
  Select RestaurantName, City, AggregateRating, Votes,	
	DENSE_RANK () OVER(partition by City
		ORDER BY AggregateRating DESC,  Votes DESC) as rnk
from zomato )
Select * from ranked 
where rnk <=3;

-- 22. Which cuisine and price range combinations achieve the highest average ratings?

WITH RECURSIVE CTE AS( 
   SELECT TRIM(SUBSTRING_INDEX(Cuisines, ',', 1)) AS cuisine,
        SUBSTRING(Cuisines, LENGTH(SUBSTRING_INDEX(Cuisines, ',', 1)) + 2) AS remaining,
        PriceRange,  AggregateRating
from zomato
UNION ALL 
  SELECT TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS cuisine,
        SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2) AS remaining,
        PriceRange, AggregateRating 
from CTE 
    WHERE remaining != ''
)
SELECT cuisine, PriceRange, AVG(AggregateRating) AS avg_rating
FROM CTE 
GROUP BY cuisine, PriceRange
ORDER BY avg_rating DESC,  PriceRange DESC;

-- 23. Identify restaurants with above-average votes but below-average ratings (potential reputation risks).

SELECT RestaurantName, City, Votes, AggregateRating
FROM zomato
WHERE Votes > (SELECT AVG(Votes) FROM zomato)
AND AggregateRating < (SELECT AVG(AggregateRating) FROM zomato)
ORDER BY Votes DESC;

-- 24. Does online delivery increase customer engagement (votes) and ratings?

Select HasOnlineDelivery,
ROUND( AVG(AggregateRating) , 2) AS AVG_RATING, 
ROUND( AVG(Votes) , 2) AS AVG_VOTES
from zomato 
GROUP BY HasOnlineDelivery
ORDER BY AVG_RATING DESC;

-- 25. Do restaurants with table booking achieve higher ratings and belong to higher price ranges?

Select HasTableBooking, ROUND(AVG(AggregateRating) ,2 ) as AVG_Rating,
ROUND(AVG(PriceRange) , 2) AS AVG_PriceRange
from zomato
GROUP BY HasTableBooking
ORDER BY AVG_Rating DESC;

-- 26. Do expensive restaurants actually receive better ratings than budget restaurants?

Select PriceRange, 
ROUND(AVG(AggregateRating) , 2) AS AVG_RATING
from zomato
GROUP BY  PriceRange
ORDER BY AVG_RATING DESC;
 
 -- 27. Which cities have a high number of restaurants but below-average ratings (market quality concerns)?
 
SELECT City, ROUND(AVG(AggregateRating), 2) AS avg_rating, COUNT(*) AS total_restaurants
FROM zomato
WHERE AggregateRating < (SELECT AVG(AggregateRating) FROM zomato)
GROUP BY City
ORDER BY total_restaurants DESC;
 
 --  28. Which cuisines have high ratings but relatively few restaurants (market gap opportunities)?
 
 WITH RECURSIVE CTE AS (
    SELECT 
        TRIM(SUBSTRING_INDEX(Cuisines, ',', 1)) AS cuisine,
        SUBSTRING(Cuisines, LENGTH(SUBSTRING_INDEX(Cuisines, ',', 1)) + 2) AS remaining,
        AggregateRating, RestaurantID
    FROM zomato
    UNION ALL
    SELECT 
        TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS cuisine,
        SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2) AS remaining,
        AggregateRating, RestaurantID
    FROM CTE WHERE remaining != ''
)
SELECT cuisine, AVG(AggregateRating) AS AVG_RATING, COUNT(DISTINCT RestaurantID) AS total_restaurant
FROM CTE 
GROUP BY cuisine 
ORDER BY AVG_RATING DESC,
total_restaurant ASC;


-- 29. Identify "Hidden Gems" — restaurants with ratings above 4.5 but votes below the city average.

SELECT RestaurantName, City, Votes
FROM zomato z1
WHERE AggregateRating > 4.5
AND Votes < (SELECT AVG(Votes) FROM zomato z2 WHERE z2.City = z1.City);

-- 30. Identify restaurants with votes in the top 20% but ratings in the
--  bottom 20% (high visibility, low satisfaction).

WITH ranked AS (
    SELECT 
        RestaurantName,
        Votes,
        AggregateRating,
        ROUND(PERCENT_RANK() OVER(ORDER BY Votes DESC) , 2)  AS vote_rank,
       ROUND( PERCENT_RANK() OVER(ORDER BY AggregateRating ASC) , 2) AS rating_rank
    FROM zomato
)
SELECT *
FROM ranked
WHERE vote_rank <= 0.20
AND rating_rank <= 0.50;
