/*
REPORTS: 
1. Rank branches w.r.t. highest net profit in 2024 (prevoius file) 
2. highest product category revenue - all branches 
3. most popular product category (units sold) - all branches
4. most popular product (units sold) - all branches 
5. most popular product and category w.r.t. branch
6. monthly sales waterfall (next file) 
*/

ALTER table product_details
CHANGE COLUMN `product_id` `product_id` INT
CHANGE COLUMN `product_category` `product_category` VARCHAR(100)
CHANGE COLUMN `Product Details` `product_details` VARCHAR(100)
CHANGE COLUMN `Product Type` `product_type` VARCHAR(100)

SHOW COLUMNS FROM product_details
SELECT * FROM SALES_TABLE

-- ------------------------


# MOST POPULAR PRODUCTS:

SELECT 
	RANK() OVER(ORDER BY SUM(S.transaction_qty) DESC) as ranking
	, P.product_details
	, SUM(S.transaction_qty) as units_sold
    
FROM sales_table S
JOIN product_details P on P.product_id = S.product_id
# WHERE S.store_id = 3 -- STORE ID VARIABLE
GROUP BY P.product_details

ORDER BY ranking
LIMIT 5




# MOST POPULAR PRODUCT CATEGORIES:


SELECT
	RANK() OVER (ORDER BY SUM(S.transaction_qty) DESC) AS ranking
	, P.product_category
	, SUM(S.transaction_qty) as units_sold
    
FROM sales_table S
JOIN product_details P on P.product_id = S.product_id
# WHERE S.store_id = 3 -- STORE ID VARIABLE
GROUP BY P.product_category
ORDER BY ranking
LIMIT 5



# HIGHEST REVENUE CHURNED BY CATEGORY:


SELECT
	RANK() OVER (ORDER BY SUM(S.unit_price * S.transaction_qty) * 0.3 DESC) AS ranking
	, P.product_category
	, SUM((S.unit_price * S.transaction_qty)) AS revenue_generated
    , ROUND((SUM((S.unit_price * S.transaction_qty)) * 0.3),0) AS net_profit_generated 

FROM sales_table S
JOIN product_details P on P.product_id = S.product_id
#WHERE S.store_id = 3 -- STORE ID VARIABLE
GROUP BY P.product_category
ORDER BY ranking
LIMIT 5


# MOST POPULAR CATEGORY W.R.T. BRANCH (SINGLE TABLE):

WITH units_branch_category AS (
SELECT
	 S.store_id
	, SD.store_location_name AS store
	, P.product_category
	, SUM(S.transaction_qty) as units_sold
    
FROM sales_table S
JOIN product_details P on P.product_id = S.product_id
JOIN store_details SD on SD.store_id = S.store_id

 GROUP BY P.product_category, S.store_id, store
 )
, ranked_units AS (
SELECT 
	*, RANK() OVER(PARTITION BY store_id ORDER BY units_sold DESC) as ranking
FROM units_branch_category
)
SELECT * from ranked_units
WHERE ranking <=5 AND store_id = '8'
ORDER BY store_id, ranking

