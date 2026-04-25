CREATE DATABASE hr_project;
SELECT * FROM `wa_fn-usec_-hr-employee-attrition` LIMIT 5;

SELECT COUNT(*) FROM `wa_fn-usec_-hr-employee-attrition`;
RENAME TABLE `wa_fn-usec_-hr-employee-attrition`
TO employee_attrition;

-- Purpose: Count total employees by attrition status (Yes/No)
SELECT 
    e.Attrition AS attrition_status,
    COUNT(*) AS total_employees
FROM employee_attrition AS e
GROUP BY e.Attrition;

-- Purpose: Calculate overall attrition rate in the company
SELECT 
    ROUND(
        (SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS attrition_rate_percent
FROM employee_attrition AS e;

-- Purpose: Identify departments with highest employee attrition risk
SELECT 
    e.Department AS department,
    ROUND(
        SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percent
FROM employee_attrition AS e
GROUP BY e.Department
ORDER BY attrition_rate_percent DESC;

-- Purpose: Find which job roles have highest attrition rates
SELECT 
    e.JobRole AS job_role,
    ROUND(
        SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percent
FROM employee_attrition AS e
GROUP BY e.JobRole
ORDER BY attrition_rate_percent DESC;

-- Purpose: Check if overtime is linked to employee attrition
SELECT 
    e.OverTime AS overtime_flag,
    e.Attrition AS attrition_status,
    COUNT(*) AS total_employees
FROM employee_attrition AS e
GROUP BY e.OverTime, e.Attrition;

-- Purpose: Compare salary differences between employees who left vs stayed
SELECT 
    e.Attrition AS attrition_status,
    ROUND(AVG(e.MonthlyIncome), 2) AS average_monthly_income
FROM employee_attrition AS e
GROUP BY e.Attrition;

-- Purpose: Analyze how job satisfaction affects employee attrition
SELECT 
    e.JobSatisfaction AS job_satisfaction_level,
    e.Attrition AS attrition_status,
    COUNT(*) AS total_employees
FROM employee_attrition AS e
GROUP BY e.JobSatisfaction, e.Attrition
ORDER BY e.JobSatisfaction;

-- Purpose: Understand impact of work-life balance on attrition
SELECT 
    e.WorkLifeBalance AS work_life_balance_level,
    e.Attrition AS attrition_status,
    COUNT(*) AS total_employees
FROM employee_attrition AS e
GROUP BY e.WorkLifeBalance, e.Attrition
ORDER BY e.WorkLifeBalance;

-- Purpose: Identify stable employees with low attrition risk
SELECT 
    e.EmployeeNumber,
    e.JobRole,
    e.MonthlyIncome,
    e.OverTime,
    e.JobSatisfaction
FROM employee_attrition AS e
WHERE 
    e.OverTime = 'No'
    AND e.JobSatisfaction >= 3
    AND e.MonthlyIncome > 6000;

-- Purpose: Compare key factors between employees who left vs stayed
-- This helps identify main drivers of attrition

SELECT 
    e.Attrition AS attrition_status,
    
    -- Average monthly income for each group
    ROUND(AVG(e.MonthlyIncome), 2) AS avg_monthly_income,

    -- Proportion of employees working overtime (Yes = 1, No = 0)
    ROUND(AVG(CASE WHEN e.OverTime = 'Yes' THEN 1 ELSE 0 END), 2) AS overtime_rate,

    -- Average job satisfaction score
    ROUND(AVG(e.JobSatisfaction), 2) AS avg_job_satisfaction,

    -- Average work-life balance score
    ROUND(AVG(e.WorkLifeBalance), 2) AS avg_work_life_balance

FROM employee_attrition AS e
GROUP BY e.Attrition;
