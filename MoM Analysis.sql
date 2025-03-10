
#monthly sales waterfall
# predictive analysis of categories (top selling months) / done!
# location influence prediction


/*
WITH total_revenue AS (
SELECT 
    store_id,
    MONTHNAME(transaction_date) AS month,
    MONTH(transaction_date) AS month_number,
    SUM(transaction_qty * unit_price) AS total_sales
FROM 
    sales_table 
GROUP BY 
    store_id, month, month_number
ORDER BY 
    store_id, month_number

)

SELECT *
	, ROUND(((total_sales - LAG(total_sales) OVER(ORDER BY store_id, month_number)) *100 / total_sales),2) as waterfall_per_month
FROM total_revenue
*/
-- -------------------------------------------------------

#predictive analysis:
-- 1. TIME SERIES 2. MACHINE LEARNING 3. DEEP LEARNING

# TOP SELLING MONTHS W.R.T. CATEGORY
WITH category_month_ranking AS (
SELECT 
	RANK() OVER(partition by PD.product_category ORDER BY SUM(ST.transaction_qty) DESC) as ranking
	, PD.product_category
    , MONTHNAME(ST.transaction_date) as monthname
    , MONTH(ST.transaction_date) as monthnumber
    , SUM(ST.transaction_qty) as units_sold
    
FROM sales_table ST
LEFT JOIN product_details PD on ST.product_id = PD.product_id
WHERE PD.product_category = 'coffee' OR PD.product_category = 'tea'
	AND ST.store_id = '3' -- STORE CHOICE
GROUP BY PD.product_category , monthnumber , monthname
ORDER BY PD.product_category , MONTH(ST.transaction_Date)
)

SELECT *
FROM category_month_ranking
WHERE ranking <=3
ORDER BY product_category , ranking


# seasons for each category









