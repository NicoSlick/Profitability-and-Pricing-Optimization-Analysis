WITH product_performance AS (
    SELECT 
        product_name,
        SUM(order_item_quantity) AS total_quantity, -- Number of units sold
        SUM(order_item_total_amount) AS total_revenue, -- Total revenue
        SUM(order_item_discount) AS total_discount, -- Total discounts given
        AVG(order_item_profit_ratio) AS avg_profit_margin, -- Average profit margin
        (SUM(order_item_total_amount) / (SELECT SUM(order_item_total_amount) FROM logistics.logistics)) * 100 AS sales_contribution, -- Sales contribution to total revenue as a percentage
        CASE 
            WHEN AVG(order_item_profit_ratio) < 0.04999 THEN 'Low Profit'
            WHEN AVG(order_item_profit_ratio) BETWEEN 0.05 AND 0.1999 THEN 'Average Profit'
            ELSE 'High Profit'
        END AS profit_class, -- Classifaction of product based on profit margin bracket 
        (SUM(order_item_discount) / NULLIF(SUM(order_item_total_amount), 0)) * 100 AS discount_impact -- Discount impact on revenue as a percentage
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
ORDER BY sales_contribution DESC -- Display, rounding, and ordering of rows
