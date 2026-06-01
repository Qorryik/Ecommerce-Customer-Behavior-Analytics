SELECT *
FROM cust_churn;

SHOW COLUMNS FROM cust_churn;

WITH duplicate_cte AS (
    SELECT *,
    
    ROW_NUMBER() OVER(
        PARTITION BY 
            Age,
            Gender,
            Country,
            City,
            Membership_Years,
            Login_Frequency,
            Session_Duration_Avg,
            Pages_Per_Session,
            Cart_Abandonment_Rate,
            Wishlist_Items,
            Total_Purchases,
            Average_Order_Value,
            Days_Since_Last_Purchase,
            Discount_Usage_Rate,
            Returns_Rate,
            Email_Open_Rate,
            Customer_Service_Calls,
            Product_Reviews_Written,
            Social_Media_Engagement_Score,
            Mobile_App_Usage,
            Payment_Method_Diversity,
            Lifetime_Value,
            Credit_Balance,
            Churned,
            Signup_Quarter
        
        ORDER BY Age
    ) AS row_num
    
    FROM cust_churn
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT COUNT(*)
FROM cust_churn
WHERE age > 100;

SELECT COUNT(*)
FROM cust_churn
WHERE Total_Purchases < 0;

SELECT Total_Purchases,
	   COUNT(*) AS total_data
FROM cust_churn
WHERE Total_Purchases < 0
GROUP BY Total_Purchases
ORDER BY total_data DESC;

SELECT Login_Frequency, Session_Duration_Avg, Total_Purchases, Average_Order_Value
FROM cust_churn
WHERE Login_Frequency = 0;

SELECT COUNT(*)
FROM cust_churn
WHERE Login_Frequency = 0 AND 
	  (Session_Duration_Avg = 0 OR Session_Duration_Avg IS NULL) AND
      (Pages_Per_Session = 0 OR Pages_Per_Session IS NULL);
	
SELECT DISTINCT Pages_Per_Session
FROM cust_churn
ORDER BY 1;

SELECT *
FROM cust_churn
WHERE Total_Purchases = 0;

SELECT Total_Purchases, Discount_Usage_Rate, Returns_Rate
FROM cust_churn
WHERE Discount_Usage_Rate > Total_Purchases OR 
	  Returns_Rate > Total_Purchases
ORDER BY Total_Purchases;

SELECT COUNT(*)
FROM cust_churn
WHERE Mobile_App_Usage > 100;

SELECT DISTINCT Days_Since_Last_Purchase
FROM cust_churn
ORDER BY 1;

SELECT *
FROM cust_churn
WHERE Pages_Per_Session IS NULL;

SELECT Total_Purchases, Returns_Rate
FROM cust_churn
WHERE Total_Purchases < 0
ORDER BY 1, 2;

SELECT COUNT(*)
FROM cust_churn
WHERE Login_Frequency = 0;

SELECT Session_Duration_Avg, Pages_Per_Session
FROM cust_churn
WHERE Session_Duration_Avg IS NOT NULL AND
	  Pages_Per_Session IS NOT NULL
ORDER BY 1, 2;

SELECT Average_Order_Value, Discount_Usage_Rate
FROM cust_churn
WHERE Discount_Usage_Rate IS NOT NULL
ORDER BY 2 DESC;

SELECT Age,
	   COUNT(*) AS total
FROM cust_churn
WHERE Age < 10 OR Age > 100
GROUP BY Age;

