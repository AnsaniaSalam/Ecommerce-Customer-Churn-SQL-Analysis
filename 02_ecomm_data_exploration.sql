-- DATA CLEANING --

-- Handling Missing Values and Outliers:--

/* Impute mean for the following columns, and round off to the nearest integer if required: 
   WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear, DaySinceLastOrder.*/

USE ecomm;
SET SQL_SAFE_UPDATES = 0;

# Step 1: calculate the rounded mean of each column (NULLs are ignored by AVG)
SET @avg_wh   = (SELECT ROUND(AVG(WarehouseToHome))             FROM customer_churn);
SET @avg_hrs  = (SELECT ROUND(AVG(HourSpendOnApp))              FROM customer_churn);
SET @avg_hike = (SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) FROM customer_churn);
SET @avg_days = (SELECT ROUND(AVG(DaySinceLastOrder))           FROM customer_churn);

# Step 2: Impute / fill the NULLs
UPDATE customer_churn SET WarehouseToHome             = @avg_wh   WHERE WarehouseToHome IS NULL;
UPDATE customer_churn SET HourSpendOnApp              = @avg_hrs  WHERE HourSpendOnApp IS NULL;
UPDATE customer_churn SET OrderAmountHikeFromlastYear = @avg_hike WHERE OrderAmountHikeFromlastYear IS NULL;
UPDATE customer_churn SET DaySinceLastOrder           = @avg_days WHERE DaySinceLastOrder IS NULL;

# To check it worked, this should return 0 for every column:
SELECT SUM(WarehouseToHome IS NULL)             AS wh_nulls,
       SUM(HourSpendOnApp IS NULL)              AS hrs_nulls,
       SUM(OrderAmountHikeFromlastYear IS NULL) AS hike_nulls,
       SUM(DaySinceLastOrder IS NULL)           AS days_nulls
FROM customer_churn;

/* Impute mode for the following columns: Tenure, CouponUsed, OrderCount.*/

SET SQL_SAFE_UPDATES = 0;

# Step 1: find mode of each column
SET @mode_tenure = (SELECT Tenure FROM customer_churn
                    WHERE Tenure IS NOT NULL
                    GROUP BY Tenure ORDER BY COUNT(*) DESC LIMIT 1);

SET @mode_coupon = (SELECT CouponUsed FROM customer_churn
                    WHERE CouponUsed IS NOT NULL
                    GROUP BY CouponUsed ORDER BY COUNT(*) DESC LIMIT 1);

SET @mode_orders = (SELECT OrderCount FROM customer_churn
                    WHERE OrderCount IS NOT NULL
                    GROUP BY OrderCount ORDER BY COUNT(*) DESC LIMIT 1);

# Step 2: Imputing with the mode
UPDATE customer_churn SET Tenure     = @mode_tenure WHERE Tenure IS NULL;
UPDATE customer_churn SET CouponUsed = @mode_coupon WHERE CouponUsed IS NULL;
UPDATE customer_churn SET OrderCount = @mode_orders WHERE OrderCount IS NULL;

# To check, this should return 0 for each column
SELECT SUM(Tenure IS NULL)     AS tenure_nulls,
       SUM(CouponUsed IS NULL) AS coupon_nulls,
       SUM(OrderCount IS NULL) AS order_nulls
FROM customer_churn;

/* Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100.*/

# 1. To see which rows are outliers before deleting
SELECT CustomerID, WarehouseToHome
FROM customer_churn
WHERE WarehouseToHome > 100;

# 2. Delete / remove the outlier rows (WarehouseToHome > 100)
SET SQL_SAFE_UPDATES = 0;

DELETE FROM customer_churn
WHERE WarehouseToHome > 100;

# 3. To check and verify no outliers are left (should return no rows)
SELECT * FROM customer_churn WHERE WarehouseToHome > 100;


-- Dealing with Inconsistencies: -

/* Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and  
“Mobile” in the 'PreferedOrderCat' column with “Mobile Phone” to ensure uniformity.*/

SET SQL_SAFE_UPDATES = 0;

# Step 1. Preview the distinct values before changing anything
SELECT PreferredLoginDevice, COUNT(*) AS cnt FROM customer_churn GROUP BY PreferredLoginDevice;
SELECT PreferedOrderCat,     COUNT(*) AS cnt FROM customer_churn GROUP BY PreferedOrderCat;

# Step 2. Replace "Phone" with "Mobile Phone" in PreferredLoginDevice
UPDATE customer_churn 
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

# Step 3. Replace "Mobile" with "Mobile Phone" in PreferedOrderCat
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

# Step 4. Verify: "Phone" and "Mobile" should no longer appear
SELECT PreferredLoginDevice, COUNT(*) AS cnt FROM customer_churn GROUP BY PreferredLoginDevice;
SELECT PreferedOrderCat,     COUNT(*) AS cnt FROM customer_churn GROUP BY PreferedOrderCat;

/* Standardize payment mode values: Replace "COD" with "Cash on Delivery" and 
"CC" with "Credit Card" in the PreferredPaymentMode column. */

SET SQL_SAFE_UPDATES = 0;

# Step 1. Preview the distinct payment modes before changing anything
SELECT PreferredPaymentMode, COUNT(*) AS cnt
FROM customer_churn
GROUP BY PreferredPaymentMode;

# Step 2. Replace "COD" with "Cash on Delivery"
UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

# Step 3. Replace "CC" with "Credit Card"
UPDATE customer_churn 
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

# Step 4. Verify: "COD" and "CC" should no longer appear
SELECT PreferredPaymentMode, COUNT(*) AS cnt FROM customer_churn GROUP BY PreferredPaymentMode;


-- DATA TRANSFORMATION--

-- 1) Column Renaming: --
# Rename the column "PreferedOrderCat" to "PreferredOrderCat". 
ALTER TABLE customer_churn CHANGE COLUMN PreferedOrderCat PreferredOrderCat VARCHAR(20);

# Rename the column "HourSpendOnApp" to "HoursSpentOnApp".
ALTER TABLE customer_churn CHANGE COLUMN HourSpendOnApp HoursSpentOnApp INT;

-- 2) Creating New Columns: 

# Create a new column named ‘ComplaintReceived’ with values "Yes" if the corresponding value in the ‘Complain’ is 1, and "No" otherwise. 
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE customer_churn ADD COLUMN ComplaintReceived VARCHAR(3);
UPDATE customer_churn SET ComplaintReceived = IF(Complain = 1, 'Yes', 'No');

-- To verify: 0 should map to No and 1 to Yes
SELECT Complain, ComplaintReceived, COUNT(*) AS cnt FROM customer_churn GROUP BY Complain, ComplaintReceived;

# Create a new column named 'ChurnStatus'. Set its value to “Churned” if the corresponding value in the 'Churn' column is 1, else assign “Active”. 
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE customer_churn ADD COLUMN ChurnStatus VARCHAR(10);
UPDATE customer_churn SET ChurnStatus = IF(Churn = 1, 'Churned', 'Active');

-- To verify: 0 should map to Active and 1 to Churned
SELECT Churn, ChurnStatus, COUNT(*) AS cnt FROM customer_churn GROUP BY Churn, ChurnStatus;

-- 3) Column Dropping: 
/* Drop the columns "Churn" and "Complain" from the table. */
ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;

# Verify: Churn and Complain should no longer be in the table
DESCRIBE customer_churn;


-- DATA EXPLORATION AND ANALYSIS --

# 1) Retrieve the count of churned and active customers from the dataset.
SELECT ChurnStatus, COUNT(*) AS CustomerCount
FROM customer_churn GROUP BY ChurnStatus;

# 2) Display the average tenure and total cashback amount of customers who churned.
SELECT 
 AVG(Tenure) AS Avg_Tenure,
 SUM(CashbackAmount) AS Total_Cashback
FROM customer_churn WHERE ChurnStatus = 'Churned';

# 3) Determine the percentage of churned customers who complained.
SELECT 
 ROUND(COUNT(CASE WHEN ComplaintReceived = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2) AS Churned_Complaint_Percentage
FROM customer_churn WHERE ChurnStatus = 'Churned';

# 4) Identify the city tier with the highest number of churned customers whose preferred order category is Laptop & Accessory.
SELECT 
 CityTier,
 COUNT(*) AS Churned_Customer_Count
FROM customer_churn 
WHERE ChurnStatus = 'Churned' AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY Churned_Customer_Count DESC
LIMIT 1;

# 5) Identify the most preferred payment mode among active customers.
SELECT 
 PreferredPaymentMode,
 COUNT(*) AS Active_Customer_Count
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY Active_Customer_Count DESC
LIMIT 1;

# 6) Calculate the total order amount hike from last year for customers who are single and prefer mobile phones for ordering.
SELECT 
 SUM(OrderAmountHikeFromlastYear) AS Total_Order_Amount_Hike
FROM customer_churn
WHERE MaritalStatus = 'Single' AND PreferredOrderCat = 'Mobile Phone';

# 7) Find the average number of devices registered among customers who used UPI as their preferred payment mode.
SELECT 
 AVG(NumberOfDeviceRegistered) AS Avg_Devices_Registered
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

# 8) Determine the city tier with the highest number of customers.
SELECT 
 CityTier,
 COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY CityTier
ORDER BY Customer_Count DESC
LIMIT 1;

# 9) Identify the gender that utilized the highest number of coupons.
SELECT 
 Gender,
 SUM(CouponUsed) AS Total_Coupons_Used
FROM customer_churn
GROUP BY Gender
ORDER BY Total_Coupons_Used DESC
LIMIT 1;

# 10) List the number of customers and the maximum hours spent on the app in each preferred order category.
SELECT 
 PreferredOrderCat,
 COUNT(*) AS Customer_Count,
 MAX(HoursSpentOnApp) AS Max_Hours_Spent
FROM customer_churn
GROUP BY PreferredOrderCat;

# 11) Calculate the total order count for customers who prefer using credit cards and have the maximum satisfaction score.
SELECT 
 SUM(OrderCount) AS Total_Order_Count
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card' AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);

# 12) What is the average satisfaction score of customers who have complained?
SELECT 
 AVG(SatisfactionScore) AS Avg_Satisfaction_Score
FROM customer_churn
WHERE ComplaintReceived = 'Yes';

# 13) List the preferred order category among customers who used more than 5 coupons.
SELECT DISTINCT PreferredOrderCat
FROM customer_churn WHERE CouponUsed > 5;

# 14) List the top 3 preferred order categories with the highest average cashback amount.
SELECT 
 PreferredOrderCat,
 AVG(CashbackAmount) AS Avg_Cashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY Avg_Cashback DESC
LIMIT 3;

# 15) Find the preferred payment modes of customers whose average tenure is 10 months and have placed more than 500 orders.
SELECT 
 PreferredPaymentMode
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) = 10 AND SUM(OrderCount) > 500;

# 16) Categorize customers based on their distance from the warehouse to home such as 
# 'Very Close Distance' for distances <=5km,'Close Distance' for <=10km, 'Moderate Distance' for <=15km, and 'Far Distance' for >15km. 
# Then, display the churn status breakdown for each distance category.
SELECT 
 CASE 
  WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
  WHEN WarehouseToHome <= 10 THEN 'Close Distance'
  WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
  ELSE 'Far Distance'
 END AS Distance_Category,
 ChurnStatus,
 COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY Distance_Category, ChurnStatus
ORDER BY Distance_Category, ChurnStatus;

# 17) List the customer’s order details who are married, live in City Tier-1, 
# and their order counts are more than the average number of orders placed by all customers.
SELECT 
 CustomerID,
 OrderCount,
 PreferredOrderCat,
 OrderAmountHikeFromlastYear,
 CouponUsed,
 DaySinceLastOrder,
 CashbackAmount
FROM customer_churn
WHERE MaritalStatus = 'Married' AND CityTier = 1 
AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn);

# 18 a) Create a 'customer_returns' table in the 'ecomm' database and insert the following data:
USE ecomm;

CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT
);

INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
    (1001, 50022, '2023-01-01', 2130),
    (1002, 50316, '2023-01-23', 2000),
    (1003, 51099, '2023-02-14', 2290),
    (1004, 52321, '2023-03-08', 2510),
    (1005, 52928, '2023-03-20', 3000),
    (1006, 53749, '2023-04-17', 1740),
    (1007, 54206, '2023-04-21', 3250),
    (1008, 54838, '2023-04-30', 1990);

# 18 b) Display the return details along with the customer details of those who have churned and have made complaints.
SELECT 
 cr.ReturnID,
 cr.ReturnDate,
 cr.RefundAmount,
 cc.*
FROM customer_returns cr
JOIN customer_churn cc ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned' AND cc.ComplaintReceived = 'Yes';