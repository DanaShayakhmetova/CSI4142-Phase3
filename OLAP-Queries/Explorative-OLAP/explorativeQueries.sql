-- Iceberg 
SELECT sf.Customer_Key,
       SUM(p.MntWines + p.MntFruits + p.MntMeatProducts + p.MntFishProducts + p.MntSweetProducts + p.MntGoldProducts) AS Total_Spending
FROM SalesAnalysisFact sf
JOIN Products p ON sf.Products_Key = p.Products_Key
GROUP BY sf.Customer_Key
ORDER BY Total_Spending DESC
LIMIT 10;

-- Window Query
WITH CustomerWineSpending AS (
    SELECT c.Generation,
           c.Customer_Key,
           SUM(p.MntWines) AS Total_Wine_Spending,
           ROW_NUMBER() OVER (PARTITION BY c.Generation ORDER BY SUM(p.MntWines) DESC) AS Wine_Spending_Rank
    FROM SalesAnalysisFact sa
    JOIN Customer c ON sa.Customer_Key = c.Customer_Key
    JOIN Products p ON sa.Products_Key = p.Products_Key
    GROUP BY c.Customer_Key
)
SELECT Generation,
       Customer_Key,
       Total_Wine_Spending,
       Wine_Spending_Rank
FROM CustomerWineSpending;

-- Window Clause Query 
WITH CustomerSeasonalJoining AS (
    SELECT
        Customer_Key,
        Education,
        Dt_Customer,
        CASE 
            WHEN EXTRACT(MONTH FROM Dt_Customer) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM Dt_Customer) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM Dt_Customer) IN (9, 10, 11) THEN 'Fall'
            WHEN EXTRACT(MONTH FROM Dt_Customer) IN (12, 1, 2) THEN 'Winter'
        END AS Season
    FROM
        Customer
)
SELECT
    Education,
    Season,
    COUNT(Customer_Key) AS Customer_Count_Per_Education_Level,
    SUM(COUNT(Customer_Key)) OVER W AS Total_Customers_Per_Season
FROM
    CustomerSeasonalJoining
GROUP BY
    Season, Education
WINDOW W AS (PARTITION BY Season);
