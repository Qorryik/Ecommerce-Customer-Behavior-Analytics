CREATE TABLE clean_cust_churn
LIKE cust_churn;  

INSERT clean_cust_churn
SELECT *
FROM cust_churn;

SELECT *
FROM clean_cust_churn; 

-- Remove records where Age is smaller than 10 and greater than 100 
DELETE 
FROM clean_cust_churn
WHERE Age < 10 OR Age > 100;

-- Remove records where Total_Purchases is smaller than 0
DELETE 
FROM clean_cust_churn
WHERE Total_Purchases < 0;

-- Remove records where Total_Purchases = 0 but other purchase-related fields still contain non-zero values
DELETE 
FROM clean_cust_churn
WHERE Total_Purchases = 0;

SELECT COUNT(*)
FROM clean_cust_churn;

-- Remove records where Rate Colums is greater than 100 
DELETE 
FROM clean_cust_churn
WHERE Discount_Usage_Rate > 100;

DELETE 
FROM clean_cust_churn
WHERE Cart_Abandonment_Rate > 100;

-- Change numeric-related columns data type from TEXT to numeric
ALTER TABLE clean_cust_churn
MODIFY COLUMN Session_Duration_Avg DOUBLE,
MODIFY COLUMN Pages_Per_Session DOUBLE,
MODIFY COLUMN Email_Open_Rate DOUBLE,
MODIFY COLUMN Product_Reviews_Written DOUBLE,
MODIFY COLUMN Social_Media_Engagement_Score DOUBLE,
MODIFY COLUMN Mobile_App_Usage DOUBLE,
MODIFY COLUMN Payment_Method_Diversity DOUBLE,
MODIFY COLUMN Credit_Balance DOUBLE;

-- Change age column data type and fill NULL values with 'Prefer not to say'
ALTER TABLE clean_cust_churn
MODIFY COLUMN Age VARCHAR(50);

UPDATE clean_cust_churn
SET Age = 'Prefer Not to Say'
WHERE Age IS NULL;

SELECT COUNT(*)
FROM clean_cust_churn
WHERE Age = 'Prefer Not to Say';

-- Fill NULL values with 0
UPDATE clean_cust_churn
SET 
	Wishlist_Items = COALESCE(Wishlist_Items, 0),
    Discount_Usage_Rate = COALESCE(Discount_Usage_Rate, 0),
    Returns_Rate = COALESCE(Returns_Rate, 0),
    Email_Open_Rate = COALESCE(Email_Open_Rate, 0),
	Customer_Service_Calls = COALESCE(Customer_Service_Calls, 0),
    Product_Reviews_Written = COALESCE(Product_Reviews_Written, 0),
    Social_Media_Engagement_Score = COALESCE(Social_Media_Engagement_Score, 0),
    Mobile_App_Usage = COALESCE(Mobile_App_Usage, 0),
    Credit_Balance = COALESCE(Credit_Balance, 0);
    
-- Fill NULL values with median
-- Session_Duration_Avg column
UPDATE clean_cust_churn
SET Session_Duration_Avg = (
	WITH ordered_data AS(
		SELECT Session_Duration_Avg,
			   ROW_NUMBER() OVER(ORDER BY Session_Duration_Avg) AS rn,
               COUNT(*) OVER() AS total_rows
		FROM clean_cust_churn
        WHERE Session_Duration_Avg IS NOT NULL
    )
    SELECT AVG(Session_Duration_Avg)
    FROM ordered_data
    WHERE rn IN(
		FLOOR((total_rows + 1) / 2),
        FLOOR((total_rows + 2) / 2)
    )
)
WHERE Session_Duration_Avg IS NULL;

-- Pages_Per_Session column
UPDATE clean_cust_churn
SET Pages_Per_Session = (
	WITH ordered_data AS(
		SELECT Pages_Per_Session,
			   ROW_NUMBER() OVER(ORDER BY Pages_Per_Session) AS rn,
			   COUNT(*) OVER() AS total_rows
        FROM clean_cust_churn
        WHERE Pages_Per_Session IS NOT NULL
    )
    SELECT AVG(Pages_Per_Session)
    FROM ordered_data
    WHERE rn IN(
		FLOOR((total_rows + 1) / 2),
        FLOOR((total_rows + 2) / 2)
    )
)
WHERE Pages_Per_Session IS NULL;

-- Days_Since_Last_Purchase column
UPDATE clean_cust_churn
SET Days_Since_Last_Purchase = (
	WITH ordered_data AS (
		SELECT Days_Since_Last_Purchase,
			   ROW_NUMBER() OVER(ORDER BY Days_Since_Last_Purchase) AS rn,
               COUNT(*) OVER() AS total_rows
		FROM clean_cust_churn
        WHERE Days_Since_Last_Purchase IS NOT NULL
    )
    SELECT AVG(Days_Since_Last_Purchase)
    FROM ordered_data
    WHERE rn IN(
		FLOOR((total_rows + 1) / 2),
        FLOOR((total_rows + 2) / 2)
    )
)
WHERE Days_Since_Last_Purchase IS NULL;

-- Payment_Method_Diversity column
UPDATE clean_cust_churn
SET Payment_Method_Diversity = (
	WITH ordered_data AS(
		SELECT Payment_Method_Diversity,
			   ROW_NUMBER() OVER(ORDER BY Payment_Method_Diversity) AS rn,
               COUNT(*) OVER() AS total_rows
		FROM clean_cust_churn
        WHERE Payment_Method_Diversity IS NOT NULL
    )
    SELECT AVG(Payment_Method_Diversity)
    FROM ordered_data
    WHERE rn IN(
		FLOOR((total_rows + 1) / 2),
        FLOOR((total_rows + 2) / 2)
    )
)
WHERE Payment_Method_Diversity IS NULL;



