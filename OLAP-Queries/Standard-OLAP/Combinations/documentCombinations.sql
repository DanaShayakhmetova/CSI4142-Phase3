-- SQL code that was mentioned in our Phase 3 Document 

-- Combination 1 
SELECT 
    CASE
        WHEN Income < 40000 THEN 'Low Income'
        WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
        WHEN Income > 80000 THEN 'High Income'
        ELSE 'Unknown'  
    END AS Income_Group,
    COUNT(*) AS Customer_Count
FROM 
    Customer
WHERE 
    Marital_Status = 'Married'
GROUP BY 
    ROLLUP(Income_Group)
ORDER BY 
    Income_Group;

-- Combination 2
SELECT EXTRACT(year FROM Dt_Customer) AS Year,
      COUNT(*) AS Customer_Count
FROM Customer
WHERE Education = 'Master'
GROUP BY EXTRACT(year FROM Dt_Customer)
ORDER BY Year;

-- Combination 3 
SELECT CASE
        WHEN Income < 40000 THEN 'Low Income'
        WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
        ELSE 'High Income'
      END AS Income_Group,
      Education,
      COUNT(*) AS Customer_Count
FROM Customer
WHERE Education IN ('PhD', 'Master')
GROUP BY Income_Group, Education
ORDER BY Income_Group, Education;


-- Combination 4
SELECT CASE
        WHEN (AGE_IN_2014 >= 20 AND AGE_IN_2014 < 30) THEN '20s'
        WHEN (AGE_IN_2014 >= 30 AND AGE_IN_2014 < 40) THEN '30s'
        WHEN (AGE_IN_2014 >= 40 AND AGE_IN_2014 < 50) THEN '40s'
        WHEN (AGE_IN_2014 >= 50 AND AGE_IN_2014 < 60) THEN '50s'
        WHEN (AGE_IN_2014 >= 60 AND AGE_IN_2014 < 70) THEN '60s'
        ELSE '70+'
      END AS Age_Group,
      Household_Size,
      COUNT(*) AS Customer_Count
FROM Customer
GROUP BY Age_Group, Household_Size
ORDER BY Age_Group, Household_Size;
