# CRM-Sales-Opportunities
README

MavenTECH 2017 Performance Data (Power BI, Python, SQL)

1.)	Overview:
This project showcases an interactive CRM dashboard created in Power BI. It analyzes sales performance, account insights, project trends, and team efficiency. 
MySQL and Python components are included to demonstrate more comprehensive data analysis and visualization. 

2.)	Data Sources and Structure
Data Tables:

crm_accounts
-	Columns: account, sector, year_established, revenue, employees, office_location, subsidiary_of

crm_products
-	Columns: product, series, sales_price

crm_sales_teams
-	Columns: sales_agent, manager, regional_office

crm_sales_pipeline
-	Columns: opportunity_id, sales_agent, product, account, deal_stage, engage date, close_date, close_value
  
Relationships:
-	crm_accounts: account (Primary Key) // crm_sales_pipeline: account (Foreign Key)
-	crm_products: product (Primary Key) // crm_sales_pipeline: product (Foreign Key)
-	crm_sales_teams: sales_agent (Primary Key) // crm_sales_pipeline: sales_agent (Foreign Key)

3.)	Dashboard Pages and Features

Page 1: Home Page
-	KPIs: Total Sales, Average Deal Size, Total Closes, Agent Close Rate
-	Figures: Time Series of Sales, Deals Closed per Product, Top 10 Accounts, Sales by Work Sector
-	Filters: Q1, Q2, Q3, Q4, 2017
Page 2: Team Performance
-	Figures: Total Sales per Agent, Correlation of Number of Agent Sales and Closes, Sales by Team, Agent Sales History
-	Filters: Q1, Q2, Q3, Q4, 2017
Page 3: Account Insights
-	Figures: Revenue by Sector, Account Breakdown
-	Filters: Q1, Q2, Q3, Q4, 2017
Page 4: Product Performance
-	KPIs: Total Sales
-	Figures: Total Sales by Product, Total Sales by Product Series, Time Series of Sales, Product Breakdown 
-	Filters: Q1, Q2, Q3, Q4, 2017

4.)	Key Measures:

1.)	Average Deal Size = AVERAGE(‘crm sales_pipeline’[close_value])

2.)	Deals This Year = CALCULATE(COUNT(‘crm sales_pipeline’[opportunity_id]), YEAR(‘crm sales_pipeline’[close_date] = YEAR(TODAY())))

3.)	Sales per Agent = DIVIDE(SUM(‘crm sales_pipeline’[close_value]), COUNT(‘crm sales_teams’[sales_agent]))

4.)	Total Closes = CALCULATE(COUNT(‘crm sales_pipeline’[opportunity_id]), ‘crm sales_pipeline’[deal_stage] = ‘Won”)

5.)	Total Employees = SUM(‘crm accounts’[employees])

6.)	Total Revenue = SUMX(‘crm accounts’, ‘crm accounts’[revenue])

7.)	Total Sales Value = CALCULATE(SUM(‘crm sales_pipeline’[close_value]), ‘crm sales_pipeline’[deal_stage] = “Won”)

8.)	Win Rate = DIVIDE(COUNTROWS(FILTERS(‘crm sales_pipeline’, ‘crm sales_pipeline’[deal_stage] = “Won”)), COUNTROWS(‘crm sales_pipeline’))

SQL script and Jupyter Notebook are both provided in the repository

5.)	Conclusion and Insights

Sales Team Performance:
The win/loss ratio across deals suggests that volume drives success. While Melvin Marxen’s team leads in sales, much of this success is attributed to Darcel Schlecht's outstanding performance. Conversely, Destin Brinkmann's team consistently underperforms, with all agents in the bottom third. Notably, Rocco Neubert and Celia Rouche manage well-balanced teams. Additionally, Niesha Huffines' ability to sell products at an average of $45 above retail offers an opportunity for cross-team collaboration to share effective upselling strategies.

Account Contributions:

Retail, technology, and medical sectors collectively contribute to nearly half of total sales, highlighting them as key focus areas. Additionally, accounts in the software sector have shown significant growth, with sales comparable to the medical sector between Q2 and Q3, making it another promising target for future efforts.

Product Trends:

MavenTECH's ability to sell GTX Pro at comparable volumes to GTX Basic—despite being 9 times more expensive—highlights its appeal. GTX Plus Pro, priced $700 higher than GTX Pro, is the second-best seller, reinforcing the demand for high-value products. Conversely, GTX Basic's limited contribution to quarterly performance suggests a pricing adjustment or removal might be needed. Similarly, MG Special, while the second-best seller in volume, contributes the least sales value, signaling an opportunity to test a price increase or promotional adjustments in the next quarter.
 
Final Thoughts: 

Sales success is primarily volume-driven, with standout performers like Darcel Schlecht and well-balanced teams under Rocco Neubert and Celia Rouche setting the standard. Key focus areas for accounts remain retail, technology, and medical, with software emerging as a high-growth sector. The strong demand for premium products like GTX Pro and GTX Plus Pro underscores an opportunity to optimize product offerings and pricing strategies for maximum impact.

