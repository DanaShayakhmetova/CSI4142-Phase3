-- Combination 1:  Drill down and Slice
SELECT 
    CASE
        WHEN Income < 40000 THEN 'Low Income'
        WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS Income_Group,
    *
FROM 
    Customer
WHERE 
    Marital_Status = 'Married'
ORDER BY 
    Income_Group;


-- Combination 2: Roll up and Slice
SELECT *,
       EXTRACT(year FROM Dt_Customer) AS Year
FROM Customer
WHERE Education = 'Masters'
ORDER BY Year;


-- Combination 3: Drill down and Dice 
SELECT c.*,
       CASE
         WHEN Income < 40000 THEN 'Low Income'
         WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
         ELSE 'High Income'
       END AS Income_Group
FROM Customer c
WHERE c.Education IN ('PhD', 'Master')
ORDER BY c.Customer_Key;


-- Combination 4: Roll up and Dice
SELECT *,
       CASE
         WHEN (AGE_IN_2014 >= 20 AND AGE_IN_2014 < 30) THEN '20s'
         WHEN (AGE_IN_2014 >= 30 AND AGE_IN_2014 < 40) THEN '30s'
         WHEN (AGE_IN_2014 >= 40 AND AGE_IN_2014 < 50) THEN '40s'
         WHEN (AGE_IN_2014 >= 50 AND AGE_IN_2014 < 60) THEN '50s'
         WHEN (AGE_IN_2014 >= 60 AND AGE_IN_2014 < 70) THEN '60s'
         ELSE '70+'
       END AS Age_Group
FROM Customer;





