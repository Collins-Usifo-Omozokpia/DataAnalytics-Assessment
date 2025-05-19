-- Get users with funded savings accounts and create a temporary table
CREATE TEMPORARY TABLE funded_savings_users AS
SELECT 
    s.owner_id AS user_id,
    COUNT(DISTINCT s.id) AS savings_count,
    SUM(s.new_balance) AS total_savings
FROM 
    savings_savingsaccount s
WHERE 
    s.new_balance > 0
GROUP BY 
    s.owner_id;
    
    
-- Get users with funded investment plans and create a temporary table
CREATE TEMPORARY TABLE funded_investment_users AS
SELECT 
    p.owner_id AS user_id,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(p.amount) AS total_investments
FROM 
    plans_plan p
WHERE 
    p.amount > 0
GROUP BY 
    p.owner_id;
    
    
-- Combine results for users with both savings and investment plans
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    fs.savings_count,
    fi.investment_count,
    (fs.total_savings + fi.total_investments) AS total_deposits
FROM 
    users_customuser u
JOIN 
    funded_savings_users fs ON u.id = fs.user_id
JOIN 
    funded_investment_users fi ON u.id = fi.user_id
ORDER BY 
    total_deposits DESC;