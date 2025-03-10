SELECT * FROM Sales_Table;
SHOW columns from sales_table from starbucks_koramangala_sales

# cleaning transaction date and adding day of week
UPDATE sales_table
SET transaction_date = STR_TO_DATE(transaction_date, '%W, %d %M %Y')
WHERE transaction_date IS NOT NULL;

ALTER TABLE sales_table
ADD COLUMN day_of_week varchar(10)
UPDATE sales_table
SET day_of_week = DAYNAME(transaction_date);

ALTER TABLE sales_table
MODIFY COLUMN transaction_DATE DATE

ALTER TABLE sales_table
MODIFY COLUMN DAY_OF_WEEK DATE

# cleaning transaction time: updating column name and cleaning time format

#raname the column title
ALTER TABLE sales_table
CHANGE COLUMN `new_transaction_time` `transaction_time` VARCHAR(20);

UPDATE sales_table
SET transaction_time = STR_TO_DATE(REPLACE(transaction_time, '_', ' '), '%h:%i:%s %p')
WHERE transaction_time IS NOT NULL;

ALTER TABLE sales_table
MODIFY COLUMN transaction_time TIME

#setting numeric value for percentage calculation in platform_fee table
ALTER TABLE platform_fee
ADD COLUMN percent_decimal VARCHAR(5)

UPDATE platform_fee
SET percent_decimal = CASE 
    WHEN `Average Commision` IS NULL OR `Average Commision` = '' THEN NULL
    ELSE REPLACE(`Average Commision`, '%', '') * 0.01
END;


#cleaning unit price column
UPDATE sales_table
SET `unit_price (price_paid)` = REPLACE(`unit_price (price_paid)`, '_', '')
WHERE `unit_price (price_paid)` LIKE '_%';

UPDATE sales_table
SET `unit_price (price_paid)` = REPLACE(`unit_price (price_paid)`, ',', '')


ALTER TABLE sales_table
CHANGE COLUMN `unit_price (price_paid)` `unit_price` float;



