-- Displays the number of SAME DAY orders that have late delivery
SELECT COUNT(1)
FROM superstore_order
WHERE ship_date > order_date AND ship_mode = 'Same Day';

-- The relationship between the amount of discount given and profitability (the average profit of the company from each discount rate criterion)
SELECT
	discount,
	CASE
		WHEN discount < 0.2 THEN 'LOW'
		WHEN discount >= 0.2 AND discount < 0.4 THEN 'MODERATE'
		WHEN discount >= 0.4 THEN 'HIGH'
	END AS discount_level,
	ROUND(AVG(profit), 3) AS avg_profit
FROM superstore_order
GROUP BY 1
ORDER BY 1;

-- Analyzing the performance of the Category and Subcategory of the products owned by the company
SELECT
	s2.category,
	s2.sub_category,
	ROUND(AVG(s1.discount),2) AS avg_disc,
	ROUND(AVG(s1.profit),2) AS avg_profit
FROM superstore_order s1
JOIN superstore_customer s2
	ON s1.customer_id = s2.customer_id
GROUP BY 1, 2
ORDER BY 1, 2;

-- Displays the performance of each Customer Segment in the three States (California, Texas, Georgia) for 2016 only
SELECT 
	segment,
	ROUND(SUM(total_sales),2) AS totalsales,
	ROUND(AVG(avg_profit),2) AS avgprofit
FROM(
	SELECT
		s2.state,
		s2.segment,
		SUM(sales) AS total_sales,
		ROUND(AVG(profit),1) AS avg_profit
	FROM superstore_order s1
	JOIN superstore_customer s2
		ON s1.customer_id = s2.customer_id
	WHERE s2.state IN ('California', 'Texas', 'Georgia')
		AND (s1.order_date BETWEEN '2016-01-01' AND '2016-12-31')
	GROUP BY 1, 2
	ORDER BY 2
) s1
GROUP BY 1;

-- Displays the number of customers who have an average discount above 0.4% (including 0.4%) for each region
SELECT
	s2.region,
	s1.customer_id,
	ROUND(AVG(s1.discount),1) AS avg_disc
FROM superstore_order s1
JOIN superstore_customer s2
	ON s1.customer_id = s2.customer_id
GROUP BY 1, 2
HAVING ROUND(AVG(s1.discount),1) >= 0.4
ORDER BY 1, 2;



