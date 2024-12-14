-- First I would like to assess if our fact table contains any duplicates.
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY opportunity_id, sales_agent, product, 'account', deal_stage, engage_date) AS row_num
FROM sales_pipeline;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY opportunity_id, sales_agent, product, 'account', deal_stage, engage_date) AS row_num
FROM sales_pipeline
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- There are no duplicates found. 


-- 1.) How is each sales team performing compared to the rest?

-- First, let's JOIN the sales_teams table with the sales_pipeline table. 

SELECT *
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
LIMIT 100;


-- Lets look at Wins (Sales) for each agent, manager, and region


SELECT 
    sales_teams.sales_agent,
    SUM(close_value) as 'Total Sales',
	COUNT(opportunity_id) as 'Won Deals'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
WHERE
	deal_stage IN ('Won')
GROUP BY
	sales_teams.sales_agent
ORDER BY
	2 DESC;
    
-- Darcel Schlecht has made the most sales.

SELECT 
    sales_teams.manager,
    SUM(close_value) as 'Total Sales',
	COUNT(opportunity_id) as 'Won Deals'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
WHERE
	deal_stage IN ('Won')
GROUP BY 
	sales_teams.manager
ORDER BY
	2 DESC;
    
-- Melvin Marxin and Summer Sewald manage the agents that made the most sales.
    
SELECT 
    sales_teams.regional_office,
    SUM(close_value) as 'Total Sales',
	COUNT(opportunity_id) as 'Won Deals'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
WHERE
	deal_stage IN ('Won')
GROUP BY 
	sales_teams.regional_office
ORDER BY
	2 DESC;
    
-- Although the central regional office completed the most sales, the West regional office made the most sales. 

-----------------------------------------------------------------------------------------------------------------

-- Perhaps high sales are the result of continuing through adversity.
-- Let's assess the Win/Loss ratio for each agent, manager, region. 

SELECT
	sales_teams.sales_agent,
	COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS Wins,
    COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END) AS Losses,
    CASE 
    WHEN COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END) = 0 THEN NULL
    ELSE ROUND(CAST(COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS FLOAT) /
         COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END), 2) END AS win_loss_ratio
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
GROUP BY 
	sales_teams.sales_agent
ORDER BY
	win_loss_ratio DESC;

-- Hayden Neloms has the highest win/loss ratio. 
-- Although Darcel S. made the most sales, he is middle of the pack in win/loss ratio. 

SELECT
	sales_teams.manager,
	COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS Wins,
    COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END) AS Losses,
    CASE 
    WHEN COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END) = 0 THEN NULL
    ELSE ROUND(CAST(COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS FLOAT) /
         COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END), 2) END AS win_loss_ratio
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
GROUP BY 
	sales_teams.manager
ORDER BY
	win_loss_ratio DESC;
    
    
SELECT
	sales_teams.regional_office,
	COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS Wins,
    COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END) AS Losses,
    CASE 
    WHEN COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END) = 0 THEN NULL
    ELSE ROUND(CAST(COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS FLOAT) /
         COUNT(CASE WHEN deal_stage = 'Lost' THEN 1 END), 2) END AS win_loss_ratio
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
GROUP BY 
	sales_teams.regional_office
ORDER BY
	win_loss_ratio DESC;


-- For each agent, manager, regional office, what is the average upsale of a product from its retail price?

SELECT 
    sales_teams.sales_agent,
	SUM(close_value - sales_price) AS upsale,
    COUNT(CASE WHEN deal_stage = "Won" THEN opportunity_id END) AS Closes,
    SUM(close_value - sales_price)/COUNT(CASE WHEN deal_stage = "Won" THEN opportunity_id END) AS
    'upsale per close'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
    LEFT JOIN products ON sales_pipeline.product = products.product
WHERE
	deal_stage IN ('Won')
GROUP BY 
	sales_teams.sales_agent
ORDER BY
	4 DESC;
    
-- Niesha Huffines sells product on average, $45 more than the retail price.
    
SELECT 
    sales_teams.manager,
	SUM(close_value - sales_price) AS upsale,
	COUNT(CASE WHEN deal_stage = "Won" THEN opportunity_id END) AS Closes,
    SUM(close_value - sales_price)/COUNT(CASE WHEN deal_stage = "Won" THEN opportunity_id END) AS
    'upsale per close'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
    LEFT JOIN products ON sales_pipeline.product = products.product
WHERE
	deal_stage IN ('Won')
GROUP BY 
	sales_teams.manager
ORDER BY
	4 DESC;


SELECT 
    sales_teams.regional_office,
	SUM(close_value - sales_price) AS upsale,
    COUNT(CASE WHEN deal_stage = "Won" THEN opportunity_id END) AS Closes,
    SUM(close_value - sales_price)/COUNT(CASE WHEN deal_stage = "Won" THEN opportunity_id END) AS
    'upsale per close'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
    LEFT JOIN products ON sales_pipeline.product = products.product
WHERE
	deal_stage IN ('Won')
GROUP BY 
	sales_teams.regional_office
ORDER BY
	4 DESC;
    
-- Central and West regional offices undersell product more so than East.
-- Although, these two regions outsell East in total sales. 

-- Finally, let's look at sales per quarter

SELECT
    sales_pipeline.sales_agent,
    SUM(CASE 
            WHEN MONTH(close_date) IN (1, 2, 3) THEN close_value 
            ELSE 0 
        END) AS Q1_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (4, 5, 6) THEN close_value 
            ELSE 0 
        END) AS Q2_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (7, 8, 9) THEN close_value
            ELSE 0 
        END) AS Q3_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (10, 11, 12) THEN close_value 
            ELSE 0 
        END) AS Q4_Revenue,
	SUM(close_value) as 'Total Sales'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
    LEFT JOIN products ON sales_pipeline.product = products.product
GROUP BY 
	sales_pipeline.sales_agent
ORDER BY
	5 DESC;
	

SELECT
    sales_teams.manager,
    SUM(CASE 
            WHEN MONTH(close_date) IN (1, 2, 3) THEN close_value 
            ELSE 0 
        END) AS Q1_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (4, 5, 6) THEN close_value 
            ELSE 0 
        END) AS Q2_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (7, 8, 9) THEN close_value
            ELSE 0 
        END) AS Q3_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (10, 11, 12) THEN close_value 
            ELSE 0 
        END) AS Q4_Revenue,
	SUM(close_value) as 'Total Sales'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
    LEFT JOIN products ON sales_pipeline.product = products.product
GROUP BY 
	sales_teams.manager
ORDER BY
	5 DESC;


SELECT
    sales_teams.regional_office,
    SUM(CASE 
            WHEN MONTH(close_date) IN (1, 2, 3) THEN close_value 
            ELSE 0 
        END) AS Q1_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (4, 5, 6) THEN close_value 
            ELSE 0 
        END) AS Q2_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (7, 8, 9) THEN close_value
            ELSE 0 
        END) AS Q3_Revenue,
    SUM(CASE 
            WHEN MONTH(close_date) IN (10, 11, 12) THEN close_value 
            ELSE 0 
        END) AS Q4_Revenue,
	SUM(close_value) as 'Total Sales'
FROM sales_pipeline
	LEFT JOIN sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
    LEFT JOIN products ON sales_pipeline.product = products.product
GROUP BY 
	sales_teams.regional_office
ORDER BY
	5 DESC;

