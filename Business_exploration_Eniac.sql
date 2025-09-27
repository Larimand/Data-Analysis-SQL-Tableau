USE magist123;
SELECT * FROM products;
SELECT * FROM product_category_name_translation;
SELECT * FROM sellers;
SELECT * FROM customers;
SELECT * FROM geo;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM order_payments;
SELECT * FROM order_reviews;
-- How many orders are there in the dataset?
SELECT * FROM order_reviews;
SELECT COUNT(order_id) FROM orders;
-- Are orders actually delivered?
SELECT order_status, COUNT(order_status)
FROM orders
GROUP BY order_status;
-- Is Magist having user growth?
SELECT
	YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM orders
WHERE order_purchase_timestamp LIKE ("20%")
GROUP BY year_, month_ 
ORDER BY year_, month_;
-- How many products are there on the products table? 
SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;
-- Which are the categories with the most products?
SELECT
	p.product_category_name,
    product_category_name_english,
    COUNT(DISTINCT p.product_id) AS n_products
FROM products p
LEFT JOIN product_category_name_translation tr
	ON tr.product_category_name = p.product_category_name
GROUP BY product_category_name
ORDER BY n_products DESC;
-- Which categories most sold?
SELECT
	p.product_category_name,
	tr.product_category_name_english,
    COUNT(DISTINCT oi.product_id) AS n_products_sold
FROM products p
INNER JOIN product_category_name_translation tr
	ON tr.product_category_name = p.product_category_name
INNER JOIN order_items oi
	ON p.product_id = oi.product_id
GROUP BY
	p.product_category_name,
    tr.product_category_name_english
ORDER BY
	n_products_sold DESC;
-- How many of those products were present in actual transactions? 
SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;
-- What’s the price for the most expensive and cheapest products?
SELECT
	MAX(price) AS most_expensive,
	MIN(price) AS cheapest
FROM order_items;
-- What are the highest and lowest payment values?
SELECT
	MAX(payment_value) AS highest_payment,
	MIN(payment_value) AS lowest_payment
FROM
	order_payments;
-- Maximum someone has paid for an order
SELECT
    SUM(payment_value) AS highest_order
FROM order_payments
GROUP BY order_id
ORDER BY highest_order DESC
LIMIT 1;
-- What is the average product price?
SELECT 
	AVG(price) AS average_price
FROM
	order_items;
-- What is the average product price per category?
SELECT
	p.product_category_name,
    product_category_name_english,
    COUNT(DISTINCT p.product_id) AS n_products,
    AVG(oi.price) AS average_price
FROM products p
LEFT JOIN product_category_name_translation tr
	ON tr.product_category_name = p.product_category_name
INNER JOIN order_items oi
	on oi.product_id = p.product_id
GROUP BY product_category_name
ORDER BY n_products DESC;
-- What categories of tech products does Magist have?
SELECT DISTINCT
    pc.product_category_name_english
FROM product_category_name_translation pc
WHERE pc.product_category_name_english LIKE '%phon%'
   OR pc.product_category_name_english LIKE '%stat%'
   OR pc.product_category_name_english LIKE '%comp%'
   OR pc.product_category_name_english LIKE '%pc%'
   OR pc.product_category_name_english LIKE '%conso%'
   OR pc.product_category_name_english LIKE '%elec%'
   OR pc.product_category_name_english LIKE '%tablet%'
   OR pc.product_category_name_english LIKE '%securit%';
-- What is the average price of products at Magist?
SELECT 
	AVG(price) AS average_price
FROM
	order_items;
-- What is the average price of tech products at Magist?
SELECT AVG(oi.price) AS average_price
FROM products p
LEFT JOIN product_category_name_translation tr
	ON tr.product_category_name = p.product_category_name
INNER JOIN order_items oi
	on oi.product_id = p.product_id
WHERE tr.product_category_name_english IN (
  'computers','computers_accessories','electronics',
  'telephony','fixed_telephony','consoles_games','pc_gamer',
  'tablets_printing_image','security_and_services',
  'signaling_and_security','stationery');
/* How many products of the tech categories have been sold (within the time window of the database snapshot)?
What percentage does that represent from the overall number of products sold? */
SELECT
	COUNT(oi.product_id) AS n_products
FROM order_items oi
INNER JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation tr
  ON p.product_category_name = tr.product_category_name
WHERE tr.product_category_name_english IN (
  'computers','computers_accessories','electronics',
  'telephony','fixed_telephony','consoles_games','pc_gamer',
  'tablets_printing_image','security_and_services',
  'signaling_and_security','stationery');
-- Overall number of sold products
SELECT COUNT(*) AS total_items_sold
FROM order_items oi;
-- What is the percentage of Tech products sold?
SELECT 
    COUNT(*) AS tech_products_sold,
    (SELECT COUNT(*) FROM order_items) AS total_products_sold,
    ROUND(
        (COUNT(*) / (SELECT COUNT(*) FROM order_items)) * 100, 
        2
    ) AS percentage_tech_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation tr 
    ON p.product_category_name = tr.product_category_name
WHERE tr.product_category_name_english IN (
  'computers','computers_accessories','electronics',
  'telephony','fixed_telephony','consoles_games','pc_gamer',
  'tablets_printing_image','security_and_services',
  'signaling_and_security','stationery');
-- Are expensive tech products popular?
SELECT 
    CASE 
        WHEN oi.price < 100 THEN 'Cheap'
        WHEN oi.price BETWEEN 100 AND 1000 THEN 'Mid-range'
        WHEN oi.price > 1000 THEN 'Expensive'
    END AS price_range,
    COUNT(DISTINCT product_id)
FROM order_items oi
JOIN products p
USING (product_id)
JOIN product_category_name_translation tr 
	ON p.product_category_name = tr.product_category_name
WHERE tr.product_category_name_english IN (
  'computers','computers_accessories','electronics',
  'telephony','fixed_telephony','consoles_games','pc_gamer',
  'tablets_printing_image','security_and_services',
  'signaling_and_security','stationery')
GROUP BY price_range;
-- What was the first and the last order date within the dataset?
SELECT
	MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;
-- How many months of data are included in the magist database?
SELECT TIMESTAMPDIFF(MONTH,
					MIN(order_purchase_timestamp),
                    MAX(order_purchase_timestamp)) AS N_of_months
FROM orders;
-- How many sellers are there?
SELECT COUNT(DISTINCT(seller_id)) FROM sellers;
-- How many Tech sellers are there?
SELECT
	COUNT(DISTINCT oi.seller_id) AS tech_sellers
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation tr
  ON p.product_category_name = tr.product_category_name
WHERE tr.product_category_name_english IN (
  'computers','computers_accessories','electronics','audio',
  'telephony','fixed_telephony','consoles_games','pc_gamer',
  'tablets_printing_image','security_and_services',
  'signaling_and_security','stationery'
);
-- What percentage of overall sellers are Tech sellers?
SELECT 
    tech_sellers,
    total_sellers,
    ROUND((tech_sellers / total_sellers) * 100, 2) AS percentage_tech_sellers
FROM
    (SELECT COUNT(DISTINCT oi.seller_id) AS tech_sellers
     FROM order_items oi
     JOIN products p ON oi.product_id = p.product_id
     LEFT JOIN product_category_name_translation tr ON p.product_category_name = tr.product_category_name
     WHERE tr.product_category_name_english IN (
         'computers','computers_accessories','electronics','audio',
         'telephony','fixed_telephony','consoles_games','pc_gamer',
         'tablets_printing_image','security_and_services',
         'signaling_and_security','stationery'
     )
    ) AS tech,
    (SELECT COUNT(DISTINCT seller_id) AS total_sellers FROM sellers) AS total;
-- What is the total amount earned by all sellers?
SELECT
	ROUND(SUM(price), 2) AS amount_by_all_sellers
FROM order_items
JOIN orders o
USING (order_id)
WHERE order_status NOT IN ("cancelled", "unavailable");
-- What is the total amount earned by all Tech sellers?
SELECT
	ROUND(SUM(price), 2) AS amount_by_tech_sellers
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation tr
  ON p.product_category_name = tr.product_category_name
WHERE tr.product_category_name_english IN (
  'computers','computers_accessories','electronics','audio',
  'telephony','fixed_telephony','consoles_games','pc_gamer',
  'tablets_printing_image','security_and_services',
  'signaling_and_security','stationery');
-- Can you work out the average monthly income of all sellers?
SELECT 
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
  SUM(oi.price) AS monthly_income
FROM order_items oi
JOIN orders o
	ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;
-- Can you work out the average monthly income of Tech sellers?
SELECT 
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
  SUM(oi.price) AS monthly_income_tech
FROM order_items oi
JOIN orders o
	ON oi.order_id = o.order_id
JOIN products p
	ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation tr
       ON p.product_category_name = tr.product_category_name
WHERE o.order_status = 'delivered'
  AND tr.product_category_name_english IN (
    'computers','computers_accessories','electronics','audio',
    'telephony','fixed_telephony','consoles_games','pc_gamer',
    'tablets_printing_image','security_and_services',
    'signaling_and_security','stationery')
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;
-- What’s the average time between the order being placed and the product being delivered?
SELECT 
    AVG(TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
-- How many orders are delivered on time vs orders delivered with a delay?
SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On Time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Unknown'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
-- Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT
    CASE 
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 100 THEN "> 100 day Delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 7 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 100 THEN "1 week to 100 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 3 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 7 THEN "4-7 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 1  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 3 THEN "1-3 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 1 THEN "less than 1 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 0 THEN 'On time' 
    END AS "delay_range", 
    AVG(product_weight_g) AS weight_avg,
    MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight,
    COUNT(DISTINCT a.order_id) AS orders_count
FROM orders a
LEFT JOIN order_items b
    USING (order_id)
LEFT JOIN products c
    USING (product_id)
WHERE order_estimated_delivery_date IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
AND order_status = 'delivered'
GROUP BY delay_range;