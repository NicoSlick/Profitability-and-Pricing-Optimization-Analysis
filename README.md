# Supply-Chain-Profitability-Analysis
 SQL-based analysis to identify inefficiencies in supply chain profitability, focusing on product-level performance, discount impact, and sales contributions.

This project uses SQL to analyze and optimize supply chain performance by focusing on product profitability, pricing strategies, and discount impact. Using a public supply chain dataset that includes financial figures, the analysis identifies key areas of improvement—such as low-margin products and the impact of discounts on profitability. The goal is to provide actionable insights that help streamline their pricing models, reduce pricing inefficiencies, and improve overall profitability in supply chain operations. 

WITH product_performance AS (
    SELECT 
        product_name,
        SUM(order_item_quantity) AS total_quantity, -- Total units sold
        SUM(order_item_total_amount) AS total_revenue, -- Total revenue
        SUM(order_item_discount) AS total_discount, -- Total discounts given
        AVG(order_item_profit_ratio) AS avg_profit_margin, -- Average profit margin
        (SUM(order_item_total_amount) * 1.0 / (SELECT SUM(order_item_total_amount) FROM logistics.logistics)) * 100 AS sales_contribution, -- Sales contribution to total
        CASE 
            WHEN AVG(order_item_profit_ratio) < 0.04999 THEN 'Low Profit'
            WHEN AVG(order_item_profit_ratio) BETWEEN 0.05 AND 0.1999 THEN 'Average Profit'
            ELSE 'High Profit'
        END AS profit_class, -- Profit margin flag
        (SUM(order_item_discount) / NULLIF(SUM(order_item_total_amount), 0)) * 100 AS discount_impact -- Discount impact on revenue
    FROM logistics.logistics
    GROUP BY product_name
)
SELECT 
    product_name,
ROUND(total_quantity, 4) AS total_quantity,
ROUND(total_revenue, 4) AS total_revenue,
ROUND(total_discount, 4) AS total_discount,
ROUND(avg_profit_margin, 4) AS avg_profit_margin,
profit_class,
ROUND(sales_contribution, 4) AS sales_contribution,
ROUND(discount_impact, 4) AS discount_impact
FROM product_performance
ORDER BY sales_contribution DESC
