USE adashi_assessment;

SELECT * FROM plans_plan;
SELECT * FROM savings_savingsaccount;
SELECT * FROM users_customuser;
SELECT * FROM withdrawals_withdrawal;



use adashi_assessment;

SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_savingsaccount s 
    ON s.owner_id = u.id AND s.confirmed_amount > 0
LEFT JOIN plans_plan p 
    ON p.owner_id = u.id
WHERE p.is_a_fund = 1
GROUP BY u.id, u.first_name, u.last_name
HAVING COUNT(DISTINCT s.id) >= 1 AND COUNT(DISTINCT p.id) >= 1
ORDER BY total_deposits DESC;

SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_savingsaccount s 
    ON s.owner_id = u.id AND s.confirmed_amount > 0
LEFT JOIN plans_plan p 
    ON p.owner_id = u.id
WHERE p.is_a_fund = 1
GROUP BY u.id, u.first_name, u.last_name
HAVING COUNT(DISTINCT s.id) >= 1 AND COUNT(DISTINCT p.id) >= 1
ORDER BY total_deposits DESC;

DESCRIBE plans_plan;
SELECT 1;

SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    s.savings_count,
    i.investment_count,
    ROUND(s.total_deposit / 100, 2) AS total_deposits
FROM users_customuser u
JOIN (
    SELECT owner_id, COUNT(*) AS savings_count, SUM(confirmed_amount) AS total_deposit
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
) s ON u.id = s.owner_id
JOIN (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
) i ON u.id = i.owner_id
ORDER BY total_deposits DESC
LIMIT 3;

WITH transaction_counts AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.created_at), MAX(s.created_at)) + 1 AS tenure_months
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
monthly_avg AS (
    SELECT
        tc.owner_id,
        u.first_name,
        u.last_name,
        tc.total_transactions,
        tc.tenure_months,
        ROUND(tc.total_transactions / tc.tenure_months, 2) AS avg_tx_per_month
    FROM transaction_counts tc
    JOIN users_customuser u ON u.id = tc.owner_id
),
categorized AS (
    SELECT
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
    FROM monthly_avg
    GROUP BY frequency_category
)
SELECT * FROM categorized;
DESCRIBE savings_savingsaccount;

WITH transaction_counts AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.Type), MAX(s.Type)) + 1 AS tenure_months
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
monthly_avg AS (
    SELECT
        tc.owner_id,
        u.first_name,
        u.last_name,
        tc.total_transactions,
        tc.tenure_months,
        ROUND(tc.total_transactions / tc.tenure_months, 2) AS avg_tx_per_month
    FROM transaction_counts tc
    JOIN users_customuser u ON u.id = tc.owner_id
),
categorized AS (
    SELECT
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
    FROM monthly_avg
    GROUP BY frequency_category
)
SELECT * FROM categorized;
SHOW COLUMNS FROM savings_savingsaccount;
SHOW COLUMNS FROM withdrawals_withdrawal;
WITH transactions AS (
    SELECT
        w.owner_id,
        w.TransactionDates AS transaction_date
    FROM withdrawals_withdrawal w
    WHERE w.TransactionDates IS NOT NULL
),
transaction_summary AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1 AS tenure_months
    FROM transactions
    GROUP BY owner_id
),
monthly_avg AS (
    SELECT
        ts.owner_id,
        u.first_name,
        u.last_name,
        ts.total_transactions,
        ts.tenure_months,
        ROUND(ts.total_transactions / ts.tenure_months, 2) AS avg_tx_per_month
    FROM transaction_summary ts
    JOIN users_customuser u ON u.id = ts.owner_id
),
categorized AS (
    SELECT
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
    FROM monthly_avg
    GROUP BY frequency_category
)
SELECT * FROM categorized;

WITH transactions AS (
    SELECT
        w.owner_id,
        w.transaction_date
    FROM withdrawals_withdrawal w
    WHERE w.transaction_date IS NOT NULL
),
transaction_summary AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1 AS tenure_months
    FROM transactions
    GROUP BY owner_id
),
monthly_avg AS (
    SELECT
        ts.owner_id,
        u.first_name,
        u.last_name,
        ts.total_transactions,
        ts.tenure_months,
        ROUND(ts.total_transactions / ts.tenure_months, 2) AS avg_tx_per_month
    FROM transaction_summary ts
    JOIN users_customuser u ON u.id = ts.owner_id
),
categorized AS (
    SELECT
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
    FROM monthly_avg
    GROUP BY frequency_category
)
SELECT * FROM categorized;

WITH last_withdrawal AS (
    SELECT
        w.owner_id,
        MAX(w.transaction_date) AS last_withdrawal_date
    FROM withdrawals_withdrawal w
    GROUP BY w.owner_id
),
last_savings_transaction AS (
    
    SELECT
        s.owner_id,
        MAX(s.maturity_end_date) AS last_savings_date
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
last_transaction AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        GREATEST(
            COALESCE(ls.last_savings_date, '1900-01-01'),
            COALESCE(lw.last_withdrawal_date, '1900-01-01')
        ) AS last_transaction_date
    FROM plans_plan p
    LEFT JOIN last_savings_transaction ls ON ls.owner_id = p.owner_id
    LEFT JOIN last_withdrawal lw ON lw.owner_id = p.owner_id
),
inactive_accounts AS (
    SELECT
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactivity_days
    FROM last_transaction
    WHERE DATEDIFF(CURRENT_DATE, last_transaction_date) > 365
)
SELECT * FROM inactive_accounts
ORDER BY inactivity_days DESC;



WITH deposits AS (
    SELECT
        s.owner_id,
        COUNT(*) AS deposit_count,
        SUM(s.confirmed_amount) AS total_deposit_value
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
withdrawals AS (
    SELECT
        w.owner_id,
        COUNT(*) AS withdrawal_count,
        SUM(w.amount_withdrawn) AS total_withdrawn_value
    FROM withdrawals_withdrawal w
    GROUP BY w.owner_id
),
transaction_summary AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.signup_date, CURDATE()) AS tenure_months,
        COALESCE(d.deposit_count, 0) + COALESCE(w.withdrawal_count, 0) AS total_transactions,
        COALESCE(d.total_deposit_value, 0) + COALESCE(w.total_withdrawn_value, 0) AS total_transaction_value
    FROM users_customuser u
    LEFT JOIN deposits d ON u.id = d.owner_id
    LEFT JOIN withdrawals w ON u.id = w.owner_id
),
clv_calc AS (
    SELECT
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND(
            (CASE 
                WHEN tenure_months > 0 AND total_transactions > 0 
                THEN (total_transactions / tenure_months) * 12 * (0.001 * (total_transaction_value / total_transactions)) 
                ELSE 0 
            END) / 100, 2) AS estimated_clv  
    FROM transaction_summary
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;

DESCRIBE users_customuser;


WITH deposits AS (
    SELECT
        s.owner_id,
        COUNT(*) AS deposit_count,
        SUM(s.confirmed_amount) AS total_deposit_value
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
withdrawals AS (
    SELECT
        w.owner_id,
        COUNT(*) AS withdrawal_count,
        SUM(w.amount_withdrawn) AS total_withdrawn_value
    FROM withdrawals_withdrawal w
    GROUP BY w.owner_id
),
transaction_summary AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COALESCE(d.deposit_count, 0) + COALESCE(w.withdrawal_count, 0) AS total_transactions,
        COALESCE(d.total_deposit_value, 0) + COALESCE(w.total_withdrawn_value, 0) AS total_transaction_value
    FROM users_customuser u
    LEFT JOIN deposits d ON u.id = d.owner_id
    LEFT JOIN withdrawals w ON u.id = w.owner_id
),
clv_calc AS (
    SELECT
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND(
            (CASE 
                WHEN tenure_months > 0 AND total_transactions > 0 
                THEN (total_transactions / tenure_months) * 12 * (0.001 * (total_transaction_value / total_transactions)) 
                ELSE 0 
            END) / 100, 2) AS estimated_clv  
    FROM transaction_summary
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;











