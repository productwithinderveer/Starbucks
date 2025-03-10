-- select * from sales_table
-- select * from store_details




#total sales w.r.t. branch

# (SUM(ST.unit_price * ST.transaction_qty) - SD.operational_cost_per_month) AS rough_profit

WITH total_sales_table AS (
SELECT
	store_id,
	SUM(unit_price * transaction_qty) AS total_sales
FROM
    sales_table ST

 #WHERE MONTH(ST.transaction_date) = 10   -- May Month Specification
GROUP BY
	store_id
)

SELECT
	RANK() OVER (ORDER BY ((TS.total_sales - SD.operational_cost) * SD.COGS_ratio) DESC) AS ranking
	, SD.store_location_name
    , TS.total_sales as 2024_total_sales
    , round(TS.total_sales - SD.COGS_ratio,0) as 2024_gross_profit
	, ROUND(((TS.total_sales - SD.operational_cost) * SD.COGS_ratio),0) AS 2024_net_profit


FROM total_sales_table TS
LEFT JOIN store_details SD ON TS.store_id = SD.store_id
ORDER BY
    ranking ASC


