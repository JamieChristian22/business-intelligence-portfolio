-- Executive KPIs
SELECT SUM(revenue) total_revenue, SUM(profit) total_profit, SUM(leads) total_leads,
SUM(dealswon) deals_won, SUM(dealswon)*1.0/NULLIF(SUM(leads),0) conversion_rate,
SUM(revenue)*1.0/NULLIF(SUM(dealswon),0) average_deal_size,
SUM(profit)*1.0/NULLIF(SUM(revenue),0) profit_margin FROM fact_sales;

-- Regional rank/share
WITH regional AS (
 SELECT r.region, SUM(s.revenue) revenue, SUM(s.profit) profit, SUM(s.leads) leads, SUM(s.dealswon) deals_won
 FROM fact_sales s JOIN dim_region r ON r.regionkey=s.regionkey GROUP BY r.region)
SELECT *, deals_won*1.0/NULLIF(leads,0) conversion_rate,
revenue*1.0/SUM(revenue) OVER() revenue_share,
DENSE_RANK() OVER(ORDER BY revenue DESC) revenue_rank FROM regional ORDER BY revenue DESC;

-- Channel efficiency
SELECT c.channel, SUM(s.revenue) revenue, SUM(s.profit) profit, SUM(s.leads) leads, SUM(s.dealswon) deals_won,
SUM(s.dealswon)*1.0/NULLIF(SUM(s.leads),0) conversion_rate,
SUM(s.revenue)*1.0/NULLIF(SUM(s.dealswon),0) avg_deal_size,
SUM(s.revenue)*1.0/NULLIF(SUM(s.leads),0) revenue_per_lead
FROM fact_sales s JOIN dim_channel c ON c.channelkey=s.channelkey GROUP BY c.channel ORDER BY revenue DESC;

-- YoY
WITH yearly AS (
 SELECT d.year, SUM(s.revenue) revenue FROM fact_sales s JOIN dim_date d ON d.datekey=s.datekey GROUP BY d.year)
SELECT year,revenue,LAG(revenue) OVER(ORDER BY year) prior_year_revenue,
(revenue-LAG(revenue) OVER(ORDER BY year))*1.0/NULLIF(LAG(revenue) OVER(ORDER BY year),0) yoy_growth
FROM yearly ORDER BY year;

-- Quarterly
SELECT d.year,d.quarter,SUM(s.revenue) revenue,SUM(s.profit) profit,
SUM(s.dealswon)*1.0/NULLIF(SUM(s.leads),0) conversion_rate
FROM fact_sales s JOIN dim_date d ON d.datekey=s.datekey GROUP BY d.year,d.quarter ORDER BY d.year,d.quarter;

-- Product rank
SELECT p.product,SUM(s.revenue) revenue,SUM(s.profit) profit,
SUM(s.dealswon)*1.0/NULLIF(SUM(s.leads),0) conversion_rate,
DENSE_RANK() OVER(ORDER BY SUM(s.revenue) DESC) revenue_rank
FROM fact_sales s JOIN dim_product p ON p.productkey=s.productkey GROUP BY p.product ORDER BY revenue DESC;
