-- Roll up Operation on Years:
SELECT c.customer_key, c.year_birth, c.education, c.marital_status, c.income, c.household_size, Yearly.Year
FROM Customer c
JOIN (
   SELECT EXTRACT(year FROM Dt_Customer) AS Year, COUNT(*) AS Customer_Count
   FROM Customer
   GROUP BY EXTRACT(year FROM Dt_Customer)
) Yearly ON EXTRACT(year FROM c.Dt_Customer) = Yearly.Year
ORDER BY Year;


-- Roll up Operation on Months:
SELECT customer_key, year_birth, education, marital_status, income, household_size,
     EXTRACT(month FROM Dt_Customer) AS Month,
     COUNT(*) OVER (PARTITION BY EXTRACT(month FROM Dt_Customer)) AS Customer_Count
FROM Customer
ORDER BY Month;


-- Drill Down into Income Groups
SELECT *,
      (SELECT CASE
                WHEN Income < 40000 THEN 'Low Income'
                WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
                ELSE 'High Income'
              END
       FROM Customer AS sub
       WHERE sub.Customer_Key = c.Customer_Key) AS Income_Group
FROM Customer AS c;



-- Slice by Specific Marital Status
SELECT *
FROM Customer
WHERE Marital_Status = 'Single';



-- Dice by Age Group and Whether each customer complained or not
SELECT
    c.*,
    subquery.Age_Group,
    subquery.Complaint_Status,
    subquery.Customer_Count
FROM (
    SELECT
        c.Customer_Key,
        CASE
            WHEN c.age_in_2014 BETWEEN 0 AND 18 THEN 'Young'
            WHEN c.age_in_2014 BETWEEN 19 AND 50 THEN 'Adult'
            ELSE 'Old'
        END AS Age_Group,
        CASE
            WHEN s.Complaint_Key = 400001 THEN 'Complained'
            ELSE 'Did Not Complain'
        END AS Complaint_Status,
        COUNT(*) AS Customer_Count
    FROM
        Customer c
    LEFT JOIN
        SalesAnalysisFact s ON c.Customer_Key = s.Customer_Key
    GROUP BY
        c.Customer_Key,
        Age_Group,
        Complaint_Status
) AS subquery
JOIN
    Customer c ON subquery.Customer_Key = c.Customer_Key;



-- Dice by People who are married and spend more than 100 dollars on gold  
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
