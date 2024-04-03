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


-- Combination 2: Drill down and Dice





-- Combination 3: Roll up and Slice





-- Combination 4: Roll up and Dice





