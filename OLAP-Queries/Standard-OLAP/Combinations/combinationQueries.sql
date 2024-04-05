-- Combination 1:  Roll Up by Income Group and Slice by Married Marital Status 
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


-- Combination 2: Roll up by Registration Year  and Slice by Master Education 
SELECT *,
       EXTRACT(year FROM Dt_Customer) AS Year
FROM Customer
WHERE Education = 'Masters'
ORDER BY Year;


-- Combination 3: Roll Up by Income Group and Slice with Graduate Education 

SELECT c.*,
       CASE
         WHEN Income < 40000 THEN 'Low Income'
         WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
         ELSE 'High Income'
       END AS Income_Group
FROM Customer c
WHERE c.Education IN ('PhD', 'Master')
ORDER BY c.Customer_Key;


-- Combination 4: Roll up by Age decade and Dice with Household Size and 30s
WITH Age_Group_CTE AS (
    SELECT 
      Customer_Key,
        CASE
            WHEN (AGE_IN_2014 >= 20 AND AGE_IN_2014 < 30) THEN '20s'
            WHEN (AGE_IN_2014 >= 30 AND AGE_IN_2014 < 40) THEN '30s'
            WHEN (AGE_IN_2014 >= 40 AND AGE_IN_2014 < 50) THEN '40s'
            WHEN (AGE_IN_2014 >= 50 AND AGE_IN_2014 < 60) THEN '50s'
            WHEN (AGE_IN_2014 >= 60 AND AGE_IN_2014 < 70) THEN '60s'
            ELSE '70+'
        END AS Age_Group,
        education,
        Marital_Status,
        kidhome,
        teenhome,
        Household_Size,
        Income,
        dt_customer
    FROM 
        Customer
)
SELECT 
    c.Customer_Key,
    ag.Age_Group,
    ag.Household_Size,
    c.education,
    c.Marital_Status,
    c.kidhome,
    c.teenhome,
    c.Household_Size,
    c.Income,
    c.dt_customer
FROM 
    Customer c
JOIN 
    Age_Group_CTE ag ON c.Customer_Key = ag.Customer_Key
WHERE 
    ag.Age_Group = '30s' AND ag.household_size = 3;






