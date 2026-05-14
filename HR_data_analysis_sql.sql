SELECT * FROM cleaned_hr_data_csv;


-- 1. Total Number of Employees          ->  Counts total employees in the company.
SELECT COUNT(*) AS Total_Employees 
FROM cleaned_hr_data_csv;


-- 2. Attrition Rate                     ->  Calculates percentage of employees who left the company.
SELECT 
ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
    / COUNT(*), 2
) AS AttritionRate
FROM cleaned_hr_data_csv;


SELECT * FROM cleaned_hr_data_csv;

-- 3. Average Salary                       ->  Calculates average employee salary.
SELECT 
ROUND(AVG(Monthly_Income), 2) AS AvgSalary
FROM cleaned_hr_data_csv;


-- 4. Highest Paid Department                ->  Shows departments with highest average salary. 
SELECT 
Department,
ROUND(AVG(Monthly_Income), 2) AS AvgSalary
FROM cleaned_hr_data_csv
GROUP BY Department
ORDER BY AvgSalary DESC;


-- 5. Gender Diversity               ->  Shows total male and female employees. 
SELECT 
Gender,
COUNT(*) AS EmployeeCount
FROM cleaned_hr_data_csv
GROUP BY Gender;


-- 6. Department Turnover                ->  Shows which department has highest employee attrition. 
SELECT 
Department,
COUNT(*) AS Employees_Left
FROM cleaned_hr_data_csv
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY Employees_Left DESC;


-- 7. Job Satisfaction Analysis      ->  Shows average job satisfaction department-wise.
SELECT 
Department,
ROUND(AVG(Job_Satisfaction), 2) AS AvgSatisfaction
FROM cleaned_hr_data_csv
GROUP BY Department;


-- 8. Top Performing Employees       ->  Shows employees or job roles with high performance ratings.
SELECT 
Job_Role,
Department,
Performance_Rating
FROM cleaned_hr_data_csv
WHERE Performance_Rating >= 4
ORDER BY Performance_Rating DESC;


-- 9. Experience vs Salary          ->  Analyzes relationship between experience and salary.
SELECT 
Total_Working_Years,
ROUND(AVG(Monthly_Income), 2) AS AvgSalary
FROM cleaned_hr_data_csv
GROUP BY Total_Working_Years
ORDER BY Total_Working_Years;


-- 10. Overtime Impact on Attrition        ->  Shows whether overtime affects employee attrition.
SELECT 
Over_Time,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM cleaned_hr_data_csv
GROUP BY Over_Time;


-- 11. Salary Band Distribution       ->  Shows distribution of employees across salary bands.
SELECT 
Salary_Band,
COUNT(*) AS Employee_Count
FROM cleaned_hr_data_csv
GROUP BY Salary_Band
ORDER BY Employee_Count DESC;


-- 12. Experience Group Analysis        ->  Analyzes salary and employee count by experience group.
SELECT 
Experience_Group,
COUNT(*) AS Employee_Count,
ROUND(AVG(Monthly_Income),2) AS Avg_Salary
FROM cleaned_hr_data_csv
GROUP BY Experience_Group;


-- 13. Marital Status Analysis       ->  Shows employee distribution by marital status.
SELECT 
Marital_Status,
COUNT(*) AS EmployeeCount
FROM cleaned_hr_data_csv
GROUP BY Marital_Status;


-- 14. Work Life Balance Analysis     ->  Analyzes employee work-life balance ratings.
SELECT 
Work_Life_Balance,
COUNT(*) AS Employee_Count
FROM cleaned_hr_data_csv
GROUP BY Work_Life_Balance
ORDER BY Work_Life_Balance;


-- 15. Attrition by Gender   ->  Shows attrition count by gender.
SELECT 
Gender,
COUNT(*) AS Employees_Left
FROM cleaned_hr_data_csv
WHERE Attrition = 'Yes'
GROUP BY Gender;


-- 16. Attrition by Salary Band         ->  Shows which salary band has highest attrition.
SELECT 
Salary_Band,
COUNT(*) AS Employees_Left
FROM cleaned_hr_data_csv
WHERE Attrition = 'Yes'
GROUP BY Salary_Band;


-- 17. Average Experience by Department    ->  Shows average employee experience by department.
SELECT 
Department,
ROUND(AVG(Total_Working_Years),2) AS Avg_Experience
FROM cleaned_hr_data_csv
GROUP BY Department
ORDER BY Avg_Experience DESC;


-- 18. Employees with Longest Tenure    ->  Shows employees or roles with longest company tenure.
SELECT 
Job_Role,
Department,
Years_At_Company
FROM cleaned_hr_data_csv
ORDER BY Years_At_Company DESC
LIMIT 10;


-- 19. Current Role Experience Analysis    ->  Analyzes average years employees stay in current roles.
SELECT 
Job_Role,
ROUND(AVG(Years_In_Current_Role),2) AS Avg_Years_In_Role
FROM cleaned_hr_data_csv
GROUP BY Job_Role
ORDER BY Avg_Years_In_Role DESC;


-- 20. Promotion Analysis        ->  Shows average years since last promotion by department.
SELECT 
Department,
ROUND(AVG(Years_Since_Last_Promotion),2) AS Avg_Promotion_Gap
FROM cleaned_hr_data_csv
GROUP BY Department
ORDER BY Avg_Promotion_Gap DESC;


-- WINDOW FUNCTIONS
-- Department-wise Salary Ranking    ->  Ranks employees based on salary within each department.
SELECT 
Job_Role,
Department,
Monthly_Income,
RANK() OVER(
    PARTITION BY Department
    ORDER BY Monthly_Income DESC
) AS SalaryRank
FROM cleaned_hr_data_csv;


-- DENSE_RANK  use
SELECT 
Job_Role,
Department,
Monthly_Income,
DENSE_RANK() OVER(
    PARTITION BY Department
    ORDER BY Monthly_Income DESC
) AS DenseSalaryRank
FROM cleaned_hr_data_csv;


-- ROW_NUMBER use
SELECT 
Job_Role,
Department,
Monthly_Income,
ROW_NUMBER() OVER(
    PARTITION BY Department
    ORDER BY Monthly_Income DESC
) AS RowNum
FROM cleaned_hr_data_csv;


-- CTE use
-- Average Department Salary
WITH AvgDeptSalary AS (
    SELECT 
    Department,
    AVG(Monthly_Income) AS AvgSalary
    FROM cleaned_hr_data_csv
    GROUP BY Department
)


-- Shows departments where average salary is greater than 5000.
SELECT *
FROM AvgDeptSalary
WHERE AvgSalary > 5000;


-- Attrition Rate by Department
SELECT 
Department,
ROUND(
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)
    * 100.0 / COUNT(*),
2) AS AttritionRate
FROM cleaned_hr_data_csv
GROUP BY Department
ORDER BY AttritionRate DESC;


-- Top 5 Highest Paid Job Roles
SELECT 
Job_Role,
ROUND(AVG(Monthly_Income),2) AS AvgSalary
FROM cleaned_hr_data_csv
GROUP BY Job_Role
ORDER BY AvgSalary DESC
LIMIT 5;


-- Department-wise Performance Analysis
SELECT 
Department,
ROUND(AVG(Performance_Rating),2) AS Avg_Performance
FROM cleaned_hr_data_csv
GROUP BY Department
ORDER BY Avg_Performance DESC;


-- Employees Working Overtime with High Attrition
SELECT 
Over_Time,
Attrition,
COUNT(*) AS Employee_Count
FROM cleaned_hr_data_csv
GROUP BY Over_Time, Attrition;


-- Average Salary by Education Field
SELECT 
Education_Field,
ROUND(AVG(Monthly_Income),2) AS AvgSalary
FROM cleaned_hr_data_csv
GROUP BY Education_Field
ORDER BY AvgSalary DESC;


-- Employees Near Promotion
SELECT 
Job_Role,
Department,
Years_Since_Last_Promotion
FROM cleaned_hr_data_csv
WHERE Years_Since_Last_Promotion >= 5
ORDER BY Years_Since_Last_Promotion DESC; 



