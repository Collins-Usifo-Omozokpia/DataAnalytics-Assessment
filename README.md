# DataAnalytics-Assessment

This repository contains SQL solutions to various data analytics scenarios for the Cowrywise assessment. Each question addresses a specific business need, and the solutions are designed to be efficient and insightful. Below is a detailed explanation of the approach taken for each question, along with challenges encountered and how they were resolved.

---

## Question 1: High-Value Customers with Multiple Products

- Initially, I attempted to join the `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables directly. However, this approach caused a timeout issue due to the large dataset.
- To resolve this, I partitioned the query into smaller steps using temporary tables:
  1. Identified users with funded savings accounts.
  2. Identified users with funded investment plans.
  3. Combined the results to find users with both products.
- This approach significantly improved performance and allowed us to calculate total deposits efficiently.

### First Challenge

- **Timeout Issue**: The direct join approach was too slow. Using temporary tables helped break the problem into manageable parts.

---

## Question 2: Transaction Frequency Analysis

- Calculated the total transactions and active months for each customer.
- Computed the average transactions per month by dividing total transactions by active months.
- Categorized customers based on their average transactions per month.
- Aggregated the results to count customers in each category and calculate the average transactions per month for each segment.

### Second Challenge

- Ensuring accurate calculation of active months required handling edge cases where customers had very few transactions. This was resolved by using `TIMESTAMPDIFF` to calculate the difference between the earliest and latest transaction dates.

---

## Question 3: Account Inactivity Alert

- Combined data from `savings_savingsaccount` and `plans_plan` tables to identify the last transaction date for each account.
- Calculated the number of days since the last transaction using `DATEDIFF`.
- Filtered accounts with inactivity greater than 365 days and sorted them by inactivity duration.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

- Calculated account tenure in months using `TIMESTAMPDIFF` between the signup date and the current date.
- Counted total transactions and calculated the average profit per transaction as 0.1% of the confirmed transaction amount.
- Estimated CLV using the provided formula and ordered the results by CLV in descending order.

### Third Challenge

- Handling cases where tenure was zero to avoid division by zero errors. This was resolved using `NULLIF` to safely handle such cases.

---
