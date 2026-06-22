select * from customer limit 20

select gender, SUM(purchase_amount) as revenue
from customer
group by gender

select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >= (select AVG(purchase_amount) from customer)

select item_purchased, ROUND(AVG(review_rating::numeric),2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer
where shipping_type in ('Standard', 'Express')
group by shipping_type

SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC;

SELECT item_purchased,
       ROUND(
           100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

WITH customer_type AS (
    SELECT customer_id,
           previous_purchases,
           CASE
               WHEN previous_purchases = 1 THEN 'New'
               WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM customer
)

SELECT customer_segment,
       COUNT(*) AS "Number of Customers"
FROM customer_type
GROUP BY customer_segment;

with item_counts as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
from customer
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

select age_group,
SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;