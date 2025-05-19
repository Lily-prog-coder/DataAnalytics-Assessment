#  DataAnalytics-Assessment

This repository contains solutions to a SQL proficiency assessment designed to test analytical and technical skills in solving business data problems using SQL.



## Question 1: High-Value Customers with Multiple Products

###  Objective
Identify customers who have both a **funded savings account** and a **funded investment plan** to support cross-selling efforts.

### Approach
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan`
- Filtered:
  - Savings accounts with `confirmed_amount > 0`
  - Investment plans with `is_a_fund = 1`
- Grouped by customer and calculated total deposits
- Sorted by `total_deposits` in descending order

### Output
- `owner_id`, `name`, `savings_count`, `investment_count`, `total_deposits`

---

## Question 2: Transaction Frequency Analysis

### Objective
Classify customers based on how often they transact each month.

###  Approach
- Counted savings transactions per customer
- Aggregated by customer and month
- Calculated average monthly transactions
- Applied frequency segmentation:
  - High Frequency (≥10/month)
  - Medium Frequency (3–9/month)
  - Low Frequency (≤2/month)

### Output
- `frequency_category`, `customer_count`, `avg_transactions_per_month`

---

## Question 3: Account Inactivity Alert

###  Objective
Find **active accounts** (savings or investments) with **no inflow** in the past 365 days.

###  Approach
- Joined savings and investment plans
- Used the most recent transaction date for each account
- Calculated `inactivity_days = DATEDIFF(CURRENT_DATE, last_transaction_date)`
- Filtered where `inactivity_days > 365`

### Output
- `plan_id`, `owner_id`, `type`, `last_transaction_date`, `inactivity_days`

---

## Question 4: Customer Lifetime Value (CLV) Estimation

### Objective
Estimate CLV based on account tenure and transaction value.

### Approach
- Calculated `tenure_months` from `date_joined`
- Summed deposits and withdrawals as total transaction value (converted from kobo to naira)
- Used simplified CLV formula:
  \[
  \text{CLV} = \left(\frac{\text{total_transactions}}{\text{tenure_months}}\right) \times 12 \times 0.001
  \]
- Sorted by estimated CLV in descending order

###  Output
- `customer_id`, `name`, `tenure_months`, `total_transactions`, `estimated_clv`

---

## Challenges Faced

- Encountered "Unknown column" errors due to unfamiliar table schemas; resolved by exploring the database structure and checking column names directly.
- Managed large result sets and server timeouts by applying `LIMIT` clauses.
- Adjusted for transaction units (kobo to naira) and ensured consistent calculations.
- Used inner and left joins carefully to avoid unintentionally dropping relevant data.

---

##  Repository Structure
DataAnalytics-Assessment/
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md

