-- Step 1: Calculate account tenure and total transactions for each customer
WITH customer_data AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        AVG(s.confirmed_amount) * 0.001 AS avg_profit_per_transaction -- 0.1% of transaction value
    FROM 
        users_customuser u
    LEFT JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE 
        u.is_active = 1 -- Only active users
    GROUP BY 
        u.id, u.first_name, u.last_name, u.date_joined
),

-- Step 2: Calculate estimated CLV
clv_data AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * avg_profit_per_transaction AS estimated_clv
    FROM 
        customer_data
)

-- Step 3: Order by estimated CLV
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) AS estimated_clv
FROM 
    clv_data
ORDER BY 
    estimated_clv DESC;