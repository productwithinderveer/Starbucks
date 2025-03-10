# NEW TOTAL SALES ANALYSIS
-- LABOUR COST / done!
-- PLATFORM COST / done!

# calculation for each month:
-- cogs # gross
-- platform fee
-- store operational cost
-- labour cost
-- taxes  # net



WITH yearly_labour_cost_per_branch AS (
SELECT 
	SUM(Labour_cost_per_month) * 12 as yearly_labour_cost
FROM labour_cost
)

#sales column:
, sales_per_transaction AS (
SELECT
	store_id, transaction_id,
	unit_price*transaction_qty AS sales_transaction
FROM
   sales_table
)

#gross profit column:
, gross_profit_per_transaction AS (  
SELECT 	
	SPT.store_id, SPT.transaction_id,
    ROUND((SPT.sales_transaction * (1-SD.COGS_ratio)),0) as gross_profit
FROM sales_per_transaction SPT
JOIN store_details SD on SPT.store_id = SD.store_id
)

# platform effective gross column:
, platform_effective_gross_per_transaction AS
(
SELECT S.* , P.`Platform Fee` , P.`percent_decimal`
	, CASE
		WHEN S.Platform = 'Zomato' OR S.Platform = 'Swiggy' THEN ROUND((GP.gross_profit - P.`platform fee`) * (1-P.percent_decimal),0)
		ELSE ROUND(GP.gross_profit, 0)
		END AS platform_effective_gross
        
FROM sales_table S
LEFT JOIN platform_fee P on S.Platform = P.Platform
JOIN gross_profit_per_transaction GP on GP.transaction_id = S.transaction_id
)
, total_sales_gross AS (
SELECT

	SD.store_location_name AS store
    , ROUND(SUM(sales_transaction),0) as total_sales -- total sales
    ,  ROUND(SUM(PEG.platform_effective_gross),0) as gross_profit -- total gross profit
	
FROM sales_per_transaction SPT
LEFT JOIN store_details SD ON SPT.store_id = SD.store_id
JOIN platform_effective_gross_per_transaction PEG on PEG.transaction_id = SPT.transaction_id
GROUP BY store

) 
    
SELECT
	
	RANK() OVER (ORDER BY (TSG.gross_profit - YLC.yearly_labour_cost - (SD.operational_cost)) DESC) AS ranking
	, TSG.*
	, ROUND(((TSG.gross_profit - YLC.yearly_labour_cost - (SD.operational_cost))) * 0.95,0) AS 2024_net_profit -- net profit with 5% tax

FROM total_sales_gross TSG
JOIN yearly_labour_cost_per_branch YLC
JOIN store_details SD ON SD.store_location_name=TSG.store
ORDER BY ranking ASC


# fuction for Adding Platform Costs:
/*
select * from sales_table
SELECT * FROM platform_fee

SELECT *
	, CASE
		WHEN S.Platform = 'Zomato' OR S.Platform = 'Swiggy' THEN (S.unit_price * S.transaction_qty - P.`platform fee`) * (1-P.percent_decimal)
		ELSE S.unit_price   
		END AS unit_price_minus_platform_fee
        
FROM sales_table S
LEFT JOIN platform_fee P on S.Platform = P.Platform
*/
		
