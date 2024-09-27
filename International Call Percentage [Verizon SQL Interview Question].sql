-- A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

-- What percentage of phone calls are international? Round the result to 1 decimal.

-- Assumption:

-- The caller_id in phone_info table refers to both the caller and receiver.
-- phone_calls Table:
-- Column Name	Type
-- caller_id	integer
-- receiver_id	integer
-- call_time	timestamp
-- phone_calls Example Input:
-- caller_id	receiver_id	call_time
-- 1	2	2022-07-04 10:13:49
-- 1	5	2022-08-21 23:54:56
-- 5	1	2022-05-13 17:24:06
-- 5	6	2022-03-18 12:11:49
-- phone_info Table:
-- Column Name	Type
-- caller_id	integer
-- country_id	integer
-- network	integer
-- phone_number	string
-- phone_info Example Input:
-- caller_id	country_id	network	phone_number
-- 1	US	Verizon	+1-212-897-1964
-- 2	US	Verizon	+1-703-346-9529
-- 3	US	Verizon	+1-650-828-4774
-- 4	US	Verizon	+1-415-224-6663
-- 5	IN	Vodafone	+91 7503-907302
-- 6	IN	Vodafone	+91 2287-664895
-- Example Output:
-- international_calls_pct
-- 50.0
-- Explanation
-- There is a total of 4 calls with 2 of them being international calls (from caller_id 1 => receiver_id 5, and caller_id 5 => receiver_id 1). Thus, 2/4 = 50.0%

-- The dataset you are querying against may have different input & output - this is just an example!



WITH CALLER AS 
(
  SELECT p1.caller_id,p2.country_id
  FROM phone_calls p1
  JOIN phone_info p2
  USING (caller_id)
),
CTE AS 
(
  SELECT c.caller_id,c.country_id,
  p.receiver_id FROM CALLER c
  JOIN phone_calls p USING (caller_id)
),
CTE_2 AS 
(
  SELECT CTE.caller_id,CTE.country_id as c_country_id,
  CTE.receiver_id ,C.country_id as r_country_id
  FROM CTE
  JOIN phone_info C 
  on CTE.receiver_id = C.caller_id 
),
 CTE_3 AS
(
  SELECT DISTINCT
  *
  FROM CTE_2
) 

SELECT 
ROUND
(
  (COUNT
  (
        CASE 
        WHEN C_COUNTRY_ID <> R_COUNTRY_ID
        THEN 1 
        ELSE NULL 
        END
  )
/COUNT(*)::FLOAT*100)::NUMERIC,1
) AS international_calls_pct
FROM CTE_3;

