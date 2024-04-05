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
SELECT customer_key, year_birth, education, marital_status, household_size, dt_customer,
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



-- Dice by Elder Age Group and Complaint
SELECT
   "customer_key",
   "year_birth",
   "education",
   "marital_status",
   "income",
   "kidhome",
   "teenhome",
   "dt_customer",
   "living_situation",
   "is_parent",
   "household_size",
   "generation",
   Age_Group,
   Complaint_Status,
   COUNT(*) AS Customer_Count
FROM (
   SELECT
       c."customer_key",
       c."year_birth",
       c."education",
       c."marital_status",
       c."income",
       c."kidhome",
       c."teenhome",
       c."dt_customer",
       c."living_situation",
       c."is_parent",
       c."household_size",
       c."generation",
       CASE
           WHEN age_in_2014 BETWEEN 0 AND 18 THEN 'Young'
           WHEN age_in_2014 BETWEEN 19 AND 50 THEN 'Adult'
           ELSE 'Elder'
       END AS Age_Group,
       CASE
           WHEN s."complaint_key" = 400001 THEN 'Complained'
           ELSE 'Did Not Complain'
       END AS Complaint_Status
   FROM
       "customer" c
   LEFT JOIN
       "salesanalysisfact" s ON c."customer_key" = s."customer_key"
) AS subquery
WHERE Age_Group = 'Elder' AND Complaint_Status = 'Complained'
GROUP BY
  "customer_key",
   "year_birth",
   "education",
   "marital_status",
   "income",
   "kidhome",
   "teenhome",
   "dt_customer",
   "living_situation",
   "is_parent",
   "household_size",
   "generation",
   Age_Group,
   Complaint_Status
ORDER BY
   Age_Group;


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
