-- The Bloomberg terminal is the go-to resource for financial professionals, offering convenient access to a wide array of financial datasets. As a Data Analyst at Bloomberg, you have access to historical data on stock performance.

-- Currently, you're analyzing the highest and lowest open prices for each FAANG stock by month over the years.

-- For each FAANG stock, display the ticker symbol, the month and year ('Mon-YYYY') with the corresponding highest and lowest open prices (refer to the Example Output format). Ensure that the results are sorted by ticker symbol.

-- stock_prices Schema:
-- Column Name	Type	Description
-- date	datetime	The specified date (mm/dd/yyyy) of the stock data.
-- ticker	varchar	The stock ticker symbol (e.g., AAPL) for the corresponding company.
-- open	decimal	The opening price of the stock at the start of the trading day.
-- high	decimal	The highest price reached by the stock during the trading day.
-- low	decimal	The lowest price reached by the stock during the trading day.
-- close	decimal	The closing price of the stock at the end of the trading day.
-- stock_prices Example Input:
-- Note that the table below displays randomly selected AAPL data.

-- date	ticker	open	high	low	close
-- 01/31/2023 00:00:00	AAPL	142.28	142.70	144.34	144.29
-- 02/28/2023 00:00:00	AAPL	146.83	147.05	149.08	147.41
-- 03/31/2023 00:00:00	AAPL	161.91	162.44	165.00	164.90
-- 04/30/2023 00:00:00	AAPL	167.88	168.49	169.85	169.68
-- 05/31/2023 00:00:00	AAPL	176.76	177.33	179.35	177.25
-- Example Output:
-- ticker	highest_mth	highest_open	lowest_mth	lowest_open
-- AAPL	May-2023	176.76	Jan-2023	142.28
-- Apple Inc. (AAPL) achieved its highest opening price of $176.76 in May 2023 and its lowest opening price of $142.28 in January 2023.

-- The dataset you are querying against may have different input & output - this is just an example!


WITH CTE AS 
(
  SELECT 
  TICKER,
  MAX(OPEN) AS HIGH
  FROM stock_prices
  GROUP BY TICKER
  ORDER BY TICKER
),

CTE_2 AS 
(
  SELECT
  TICKER,
  MIN(OPEN) AS LOW
  FROM STOCK_PRICES
  GROUP BY TICKER
  ORDER BY TICKER
),

CTE_3 AS
(
  SELECT 
  CTE_2.TICKER,
  CTE_2.LOW,
  TO_CHAR(E.DATE,'Mon-YYYY') as DATE
  FROM CTE_2
  JOIN STOCK_PRICES E 
  USING (TICKER)
  WHERE E.DATE IN
  (
    SELECT DATE
    FROM STOCK_PRICES
    WHERE OPEN = CTE_2.LOW
  )
)

SELECT
CTE.TICKER,
TO_CHAR(E.DATE,'Mon-YYYY') AS HIGHEST_MTH,
CTE.HIGH AS HIGHEST_OPEN,
CTE_3.DATE AS LOWEST_MTH,
CTE_3.LOW AS LOWEST_OPEN
FROM CTE 
JOIN STOCK_PRICES E
ON E.TICKER = CTE.TICKER
JOIN CTE_3
ON E.TICKER = CTE_3.TICKER
WHERE E.DATE IN 
(
  SELECT DATE
  FROM STOCK_PRICES
  WHERE OPEN = CTE.HIGH
)
ORDER BY TICKER;
