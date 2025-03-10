
SELECT * FROM labour_cost
SHOW COLUMNS FROM labour_cost

ALTER TABLE labour_cost
MODIFY COLUMN Time_bracket VARCHAR(20)


ALTER TABLE labour_cost
MODIFY COLUMN start_time TIME,
MODIFY COLUMN end_time TIME;

SELECT DISTINCT Labour_Cost_Per_Month
FROM labour_cost;

-- Ensure start_time and end_time are of TIME type
ALTER TABLE labour_cost
MODIFY COLUMN start_time TIME,
MODIFY COLUMN end_time TIME;

-- Update start_time and end_time based on Labour_Cost_Per_Month values
UPDATE labour_cost
SET 
    start_time = CASE
        WHEN Labour_Cost_Per_Month = '6 AM - 12 PM' THEN '06:00:00'
        WHEN Labour_Cost_Per_Month = '12 PM - 6 PM' THEN '12:00:00'
        WHEN Labour_Cost_Per_Month = '6 PM - 12 AM' THEN '18:00:00'
        WHEN Labour_Cost_Per_Month = '12 AM - 3 AM' THEN '00:00:00'
        ELSE NULL
    END,
    end_time = CASE
        WHEN Labour_Cost_Per_Month = '6 AM - 12 PM' THEN '12:00:00'
        WHEN Labour_Cost_Per_Month = '12 PM - 6 PM' THEN '18:00:00'
        WHEN Labour_Cost_Per_Month = '6 PM - 12 AM' THEN '00:00:00'
        WHEN Labour_Cost_Per_Month = '12 AM - 3 AM' THEN '03:00:00'
        ELSE NULL
    END
WHERE Labour_Cost_Per_Month IS NOT NULL;  -- Optional: only update rows with valid values

-- -----------------------------------------------

UPDATE labour_cost
SET start_time = STR_TO_DATE(REPLACE(start_time, '_', ' '), '%h:%i:%s %p')
WHERE start_time IS NOT NULL;


UPDATE labour_cost
SET end_time = STR_TO_DATE(REPLACE(end_time, '_', ' '), '%h:%i:%s %p')
WHERE end_time IS NOT NULL;

UPDATE labour_cost
SET end_time = '23:59:59'
WHERE Time_bracket = '6 PM - 12 AM'

-- ---------------------------------------------------

SELECT * FROM sales_table

ALTER TABLE sales_table
ADD COLUMN Time_bracket VARCHAR(20)


UPDATE sales_table S
JOIN labour_cost L ON S.transaction_time >= L.start_time AND S.transaction_time < L.end_time
SET S.time_bracket = L.time_bracket

SELECT * from sales_table
WHERE Time_bracket IS NULL

