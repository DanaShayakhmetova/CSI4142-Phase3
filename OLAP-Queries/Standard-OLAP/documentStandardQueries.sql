-- Roll up by Year 
SELECT EXTRACT(year FROM Dt_Customer) AS Year, COUNT(*) AS Customer_Count
FROM Customer
GROUP BY EXTRACT(year FROM Dt_Customer)
ORDER BY Year;


-- Roll up by Month 
SELECT EXTRACT(month FROM Dt_Customer) AS Month,
      COUNT(*) AS Customer_Count
FROM Customer
GROUP BY EXTRACT(month FROM Dt_Customer)
ORDER BY Month;


-- Drill by Income Group 
SELECT CASE
        WHEN Income < 40000 THEN 'Low Income'
        WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
        ELSE 'High Income'
      END AS Income_Group,
      COUNT(*) AS Customer_Count
FROM Customer
GROUP BY Income_Group
ORDER BY Income_Group;


-- Slice by Marital Status 
SELECT Marital_Status,
      COUNT(*) AS Customer_Count
FROM Customer
WHERE Marital_Status = 'Single'
GROUP BY Marital_Status;


-- Dice by Age and Complain 
SELECT
   Age_Group,
   Complaint_Status,
   COUNT(*) AS Customer_Count
FROM (
   SELECT
       CASE
           WHEN age_in_2014 BETWEEN 0 AND 18 THEN 'Young'
           WHEN age_in_2014 BETWEEN 19 AND 50 THEN 'Adult'
           ELSE 'Old'
       END AS Age_Group,
       CASE
           WHEN s.Complaint_Key = 400001 THEN 'Complained'
           ELSE 'Did Not Complain'
       END AS Complaint_Status
   FROM
       Customer c
   LEFT JOIN
       SalesAnalysisFact s ON c.Customer_Key = s.Customer_Key
) AS subquery
GROUP BY
   Age_Group,
   Complaint_Status
ORDER BY
   Age_Group;


-- Dice by people who are married and spent over 100 dollars on gold 
SELECT
   c.*
FROM
   Customer c
JOIN
   SalesAnalysisFact s ON c.Customer_Key = s.Customer_Key
JOIN
   Products p ON s.Products_Key = p.Products_Key
WHERE
   c.Marital_Status = 'Married'
   AND p.MntGoldProds > 100;


