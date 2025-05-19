-- Calculate the total transactions and months for each customer
WITH customer_transactions AS (
    SELECT 
        s.owner_id AS user_id,
        COUNT(s.id) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1 AS active_months
    FROM 
        savings_savingsaccount s
    GROUP BY 
        s.owner_id
),

-- Calculate the average transactions per month for each customer
average_transactions AS (
    SELECT 
        user_id,
        total_transactions,
        active_months,
        (total_transactions / active_months) AS avg_transactions_per_month
    FROM 
        customer_transactions
),

-- Categorize customers based on transaction frequency
categorized_customers AS (
    SELECT 
        user_id,
        avg_transactions_per_month,
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        average_transactions
)

-- Aggregate results by frequency category
SELECT 
    frequency_category,
    COUNT(user_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM 
    categorized_customers
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');