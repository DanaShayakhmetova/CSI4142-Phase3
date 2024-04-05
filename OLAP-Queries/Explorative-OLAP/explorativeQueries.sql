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
SELECT
   Customer_Key,
   Income,
   CASE
       WHEN (AGE_IN_2014 >= 20 AND AGE_IN_2014 < 30) THEN '20s'
       WHEN (AGE_IN_2014 >= 30 AND AGE_IN_2014 < 40) THEN '30s'
       WHEN (AGE_IN_2014 >= 40 AND AGE_IN_2014 < 50) THEN '40s'
       WHEN (AGE_IN_2014 >= 50 AND AGE_IN_2014 < 60) THEN '50s'
       WHEN (AGE_IN_2014 >= 60 AND AGE_IN_2014 < 70) THEN '60s'
       ELSE '70+'
   END AS Age_Group,
   Marital_Status,
   ROUND(AVG(Income) OVER W, 2) AS Avg_Income_By_Age_Group_Marital_Status
FROM
   Customer
WINDOW W AS (PARTITION BY
               CASE
                   WHEN (AGE_IN_2014 >= 20 AND AGE_IN_2014 < 30) THEN '20s'
                   WHEN (AGE_IN_2014 >= 30 AND AGE_IN_2014 < 40) THEN '30s'
                   WHEN (AGE_IN_2014 >= 40 AND AGE_IN_2014 < 50) THEN '40s'
                   WHEN (AGE_IN_2014 >= 50 AND AGE_IN_2014 < 60) THEN '50s'
                   WHEN (AGE_IN_2014 >= 60 AND AGE_IN_2014 < 70) THEN '60s'
                   ELSE '70+'
               END,
               Marital_Status);
