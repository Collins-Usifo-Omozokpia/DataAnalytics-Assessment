WITH account_last_transaction AS (
    SELECT 
        s.id AS plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM 
        savings_savingsaccount s
    WHERE 
        s.new_balance > 0 -- Ensure the account is active
    GROUP BY 
        s.id, s.owner_id

    UNION ALL

    SELECT 
        p.id AS plan_id,
        p.owner_id,
        'Investment' AS type,
        MAX(p.last_charge_date) AS last_transaction_date
    FROM 
        plans_plan p
    WHERE 
        p.amount > 0 -- Ensure the account is active
    GROUP BY 
        p.id, p.owner_id
),


inactive_accounts AS (
    SELECT 
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
    FROM 
        account_last_transaction
)


SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM 
    inactive_accounts
WHERE 
    inactivity_days > 365
ORDER BY 
    inactivity_days DESC;