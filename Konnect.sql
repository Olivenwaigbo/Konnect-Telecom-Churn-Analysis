SELECT * FROM default_schema.churn;

-- a. Check for duplicates
SELECT Customer_ID, COUNT( Customer_ID ) as count
FROM  default_schema.churn
GROUP BY Customer_ID
HAVING count(Customer_ID) > 1;

-- 1. Find total number of customers
SELECT
COUNT(DISTINCT Customer_ID) AS customer_count
FROM default_schema.churn;

-- 2. How much revenue did maven lose to churned customers?
SELECT Customer_Status, 
COUNT(Customer_ID) AS customer_count
FROM default_schema.churn
GROUP BY Customer_Status;

-- 3. How much revenue has M Telecom lost to churn?
 SELECT 
  Customer_Status, 
  CEILING(SUM(Total_Revenue)) AS Revenue, 
  ROUND((SUM(Total_Revenue) * 100.0) / SUM(SUM(Total_Revenue)) OVER(), 1) AS Revenue_Percentage
FROM 
  default_schema.churn
GROUP BY Customer_status;


-- 4. Average Tenure in Months and Average Monthly Charges of customers--
SELECT CEILING(AVG(Tenure_in_Months)) AS Average_Tenure_in_Months,  CEILING(AVG(Monthly_Charge)) AS Average_Monthly_Charges
FROM default_schema.churn;

-- 5. Typical tenure for churners
SELECT
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '6 months'
        WHEN Tenure_in_Months <= 12 THEN '1 Year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '> 2 Years'
    END AS Tenure,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(),1) AS Churn_Percentage
FROM
default_schema.churn
WHERE
Customer_Status = 'Churned'
GROUP BY
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '6 months'
        WHEN Tenure_in_Months <= 12 THEN '1 Year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '> 2 Years'
    END
ORDER BY
Churn_Percentage DESC;


-- 6. Which cities have the highest churn rates?
SELECT City,
    COUNT(Customer_ID) AS Churned,
    CEILING(COUNT(CASE WHEN Customer_Status = 'Churned' THEN Customer_ID ELSE NULL END) * 100.0 / COUNT(Customer_ID)) AS Churn_Rate
FROM
    default_schema.churn
GROUP BY
    City
HAVING
    COUNT(Customer_ID)  > 30
AND
    COUNT(CASE WHEN Customer_Status = 'Churned' THEN Customer_ID ELSE NULL END) > 0
ORDER BY
    Churn_Rate DESC 
    LIMIT 4; 
    
-- 7. Why did churners leave and how much did it cost?
SELECT 
  Churn_Category,  
  ROUND(SUM(Total_Revenue),0)AS Churned_Rev,
  CEILING((COUNT(Customer_ID) * 100.0) / SUM(COUNT(Customer_ID)) OVER()) AS Churn_Percentage
FROM 
  default_schema.churn
WHERE 
    Customer_Status = 'Churned'
GROUP BY 
  Churn_Category
ORDER BY 
  Churn_Percentage DESC;
  
-- 8. Specific Reason why the customers left?
SELECT Churn_Reason, Churn_Category,  
  ROUND(COUNT(Customer_ID) * 100 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
   default_schema.churn
WHERE 
    Customer_Status = 'Churned'
GROUP BY 
  Churn_Reason,
  Churn_Category
ORDER BY 
  Churn_Percentage DESC
LIMIT 5; 

-- 9. What offers did churners have?
SELECT
    Offer,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
Offer
ORDER BY 
Churn_Percentage DESC;


-- 10.What Internet Type did churners have?
SELECT
    Internet_Type,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    default_schema.churn
WHERE 
    Customer_Status = 'Churned'
GROUP BY
Internet_Type
ORDER BY 
Churned DESC;

-- 11. What Internet Type did 'Competitor' churners have?
SELECT
    Internet_Type,
    Churn_Category,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    default_schema.churn
WHERE 
    Customer_Status = 'Churned'
    AND Churn_Category = 'Competitor'
GROUP BY
Internet_Type,
Churn_Category
ORDER BY Churn_Percentage DESC;

-- 12.Did churners have premium tech support?
SELECT 
    Premium_Tech_Support,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(),1) AS Churn_Percentage
FROM
default_schema.churn
WHERE 
    Customer_Status = 'Churned'
GROUP BY Premium_Tech_Support
ORDER BY Churned DESC;

-- 13. What contract were churners on?
SELECT 
    Contract,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Contract
ORDER BY 
    Churned DESC;
    
-- 14. HOW old were churners?
SELECT  
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END AS Age,
    ROUND(COUNT(Customer_ID) * 100 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END
ORDER BY
Churn_Percentage DESC;


-- 15. What gender were churners?
SELECT
    Gender,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Gender
ORDER BY
Churn_Percentage DESC;

-- 16 Were churners married
SELECT
    Married,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Married
ORDER BY
Churn_Percentage DESC;

-- 17 Did churners have dependents
SELECT
    CASE
        WHEN Number_of_Dependents > 0 THEN 'Has Dependents'
        ELSE 'No Dependents'
    END AS Dependents,
    ROUND(COUNT(Customer_ID) *100 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage

FROM
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY 
CASE
        WHEN Number_of_Dependents > 0 THEN 'Has Dependents'
        ELSE 'No Dependents'
    END
ORDER BY Churn_Percentage DESC;

-- 18 . Do churners have phone lines
SELECT
    Phone_Service,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churned
FROM
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY 
    Phone_Service;
    
-- 18.i  Do churners have internet service
SELECT 
    Internet_Service,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churned
FROM
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY 
    Internet_Service;

-- 19. Did they give referrals
SELECT
    CASE
        WHEN Number_of_Referrals > 0 THEN 'Yes'
        ELSE 'No'
    END AS Referrals,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churned
FROM
    default_schema.churn
WHERE
    Customer_Status = 'Churned'
GROUP BY 
    CASE
        WHEN Number_of_Referrals > 0 THEN 'Yes'
        ELSE 'No'
    END;

-- 21. Are high value customers at risk?

SELECT 
    CASE 
        WHEN (num_conditions >= 3) THEN 'High Risk'
        WHEN num_conditions = 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level,
    COUNT(Customer_ID) AS num_customers,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(),1) AS cust_percentage
FROM 
    (
    SELECT 
        Customer_ID,
        SUM(CASE WHEN Offer = 'Offer E' OR Offer = 'None' THEN 1 ELSE 0 END)+
        SUM(CASE WHEN Contract = 'Month-to-Month' THEN 1 ELSE 0 END) +
        SUM(CASE WHEN Premium_Tech_Support = 'No' THEN 1 ELSE 0 END) +
        SUM(CASE WHEN Internet_Type = 'Fiber Optic' THEN 1 ELSE 0 END) +
        SUM(CASE WHEN Number_of_Referrals >= 1 THEN 1 ELSE 0 END )AS num_conditions
    FROM 
        default_schema.churn
    WHERE 
        Monthly_Charge > 64 
        AND Customer_Status = 'Stayed'
        AND Number_of_Referrals >= 1
        AND Tenure_in_Months > 6
    GROUP BY 
        Customer_ID
    HAVING 
        SUM(CASE WHEN Offer = 'Offer E' OR Offer = 'None' THEN 1 ELSE 0 END) +
        SUM(CASE WHEN Contract = 'Month-to-Month' THEN 1 ELSE 0 END) +
        SUM(CASE WHEN Premium_Tech_Support = 'No' THEN 1 ELSE 0 END) +
        SUM(CASE WHEN Internet_Type = 'Fiber Optic' THEN 1 ELSE 0 END)+
        SUM(CASE WHEN Number_of_Referrals >= 1 THEN 1 ELSE 0 END)>= 1
    ) AS subquery
GROUP BY 
    CASE 
        WHEN (num_conditions >= 3) THEN 'High Risk'
        WHEN num_conditions = 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END; 