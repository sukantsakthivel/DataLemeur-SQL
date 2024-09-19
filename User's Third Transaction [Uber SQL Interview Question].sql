-- Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

-- transactions Table:
-- Column Name	Type
-- user_id	integer
-- spend	decimal
-- transaction_date	timestamp
-- transactions Example Input:
-- user_id	spend	transaction_date
-- 111	100.50	01/08/2022 12:00:00
-- 111	55.00	01/10/2022 12:00:00
-- 121	36.00	01/18/2022 12:00:00
-- 145	24.99	01/26/2022 12:00:00
-- 111	89.60	02/05/2022 12:00:00
-- Example Output:
-- user_id	spend	transaction_date
-- 111	89.60	02/05/2022 12:00:00
-- The dataset you are querying against may have different input & output - this is just an example!

-- p.s. for more Uber SQL interview tips & problems, check out the Uber SQL Interview Guide


WITH CT AS 
(
  SELECT USER_ID,
  COUNT(USER_ID) AS CT_ID
  FROM TRANSACTIONS
  GROUP BY USER_ID
),

CTE AS 
(
  SELECT USER_ID FROM CT
  WHERE CT_ID >2
  ORDER BY USER_ID
),

CTE_2 AS
(
  SELECT * FROM TRANSACTIONS T 
  JOIN CTE USING (USER_ID) 
  ORDER BY T.USER_ID,T.TRANSACTION_DATE
),

CTE_3 AS 
(
  SELECT ROW_NUMBER() OVER(ORDER BY USER_ID) AS IDS,*
  FROM CTE_2
)

SELECT USER_ID,SPEND,TRANSACTION_DATE FROM CTE_3 WHERE IDS%3=0; 


