/**********************************************************************************************************************************************/
/***  DATA ANALYSIS: queries  *****************************************************************************************************************/
/**********************************************************************************************************************************************/
/**********************************************************************************************/
-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
--	300,024 records
/**********************************************************************************************/
SELECT
	E.emp_no AS "EmployeeNumber",
	E.last_name AS "LastName",
	E.first_name AS "FirstName",
	E.gender AS "Gender",
	S.salary AS "Salary"
FROM employees E
	JOIN salaries S
		ON E.emp_no = S.emp_no
;
/**********************************************************************************************/
-- 2. List employees who were hired in 1986.
--	36,150 records
/**********************************************************************************************/
SELECT 
	emp_no AS "EmployeeNumber",
	last_name AS "LastName",
	first_name AS "FirstName",
	hire_date AS "HireDate"
FROM employees
WHERE 1=1
-- 	AND hire_date BETWEEN '1986-01-01' AND '1986-12-31'
	AND EXTRACT(YEAR FROM hire_date) IN(1986)
;
/**********************************************************************************************/
-- 3. List the manager of each department with the following information: department number, department name,
-- the manager's employee number, last name, first name, and start and end employment dates.
-- 		NOTE: There are instances where there is more than one manager listed for each department (historical values); this query shows all records;
-- 			if we only need to see current/most recent, I've included logic to narrow that down; also the ASK was for end employment date, this is not a column
-- 			in the data, so assuming the dept_manager.to_date (aliased as ManagerToDate) would be the "end" date; included dept_manager.from_date (aliased as
-- 			ManagerFromDate) to see if employee was hired as a manager (equivalent to employees.hire_date), or promoted from another position within the company to manager
--	24 records
/**********************************************************************************************/
SELECT
	D.dept_no AS "DepartmentNumber",
	D.dept_name AS "DepartmentName",
	DM.emp_no AS "ManagerEmployeeNumber",
	E.last_name AS "ManagerLastName",
	E.first_name AS "ManagerFirstName",
	E.hire_date AS "ManagerHireDate",
	DM.from_date AS "ManagerFromDate",
	DM.to_date AS "ManagerToDate",
-- /***  In the event we need to see the current/most recent manager, these columns may be used  ***/
	CASE WHEN ROW_NUMBER() OVER(PARTITION BY D.dept_no ORDER BY DM.to_date DESC) IN(1) THEN 1 ELSE 0 END AS "MostRecentManagerFlag"
-- 	ROW_NUMBER() OVER(PARTITION BY D.dept_no ORDER BY DM.to_date DESC) AS "DepartmentManagerRowNumber"
FROM departments D
	JOIN dept_manager DM
		ON D.dept_no = DM.dept_no
	JOIN employees E
		ON DM.emp_no = E.emp_no
ORDER BY D.dept_no, DM.to_date DESC
;
/**********************************************************************************************/
-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
-- 		NOTE: There are instances where an employee appears in multiple departments, moving from one to another; this query shows all records;
-- 			certain employees may appear multiple times, but in different departments; if we only need to see current/most recent, I've included logic to narrow that down
--	331,603 records
/**********************************************************************************************/
SELECT
	E.emp_no AS "EmployeeNumber",
	E.last_name AS "LastName",
	E.first_name AS "FirstName",
	D.dept_name AS "DepartmentName",
-- /***  In the event we need to see the current/most recent department for each employee, these columns may be used  ***/
-- 	DE.from_date,
-- 	DE.to_date,
	CASE WHEN ROW_NUMBER() OVER(PARTITION BY E.emp_no ORDER BY DE.to_date DESC) IN(1) THEN 1 ELSE 0 END AS "MostRecentDepartmentFlag"
-- 	ROW_NUMBER() OVER(PARTITION BY E.emp_no ORDER BY DE.to_date DESC) AS "DepartmentRowNumber"
FROM employees E
	JOIN dept_emp DE
		ON E.emp_no = DE.emp_no
	JOIN departments D
		ON DE.dept_no = D.dept_no
-- WHERE 1=1
-- /***  In the event we ONLY need to see the current/most recent department for each employee, these columns may be used  ***/
-- ***ERROR***; PostgreSQL doesn't allow for window functions to be used in WHERE clause
-- 	AND ROW_NUMBER() OVER(PARTITION BY E.emp_no ORDER BY DE.to_date DESC) IN(1)
ORDER BY E.emp_no, DE.to_date DESC
;
/**********************************************************************************************/
-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
--	20 records
/**********************************************************************************************/
SELECT
	last_name AS "LastName",
	first_name AS "FirstName"
FROM employees
WHERE 1=1
	AND first_name IN('Hercules')
	AND last_name LIKE 'B%'
ORDER BY last_name, first_name
;
/**********************************************************************************************/
-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
--	52,245 records
/**********************************************************************************************/
SELECT
	E.emp_no AS "EmployeeNumber",
	E.last_name AS "LastName",
	E.first_name AS "FirstName",
	D.dept_name AS "DepartmentName"
FROM employees E
	JOIN dept_emp DE
		ON E.emp_no = DE.emp_no
	JOIN departments D
		ON DE.dept_no = D.dept_no
WHERE 1=1
	AND LOWER(D.dept_name) IN('sales')
;
/**********************************************************************************************/
-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
--	137,952 records
/**********************************************************************************************/
SELECT
	E.emp_no AS "EmployeeNumber",
	E.last_name AS "LastName",
	E.first_name AS "FirstName",
	D.dept_name AS "DepartmentName"
FROM employees E
	JOIN dept_emp DE
		ON E.emp_no = DE.emp_no
	JOIN departments D
		ON DE.dept_no = D.dept_no
WHERE 1=1
-- 	AND (LOWER(D.dept_name) IN('sales')
-- 		OR LOWER(D.dept_name) IN('development'))		--	137,952 records
	AND LOWER(D.dept_name) IN('sales','development')
;
/**********************************************************************************************/
-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
--	1,638 records
/**********************************************************************************************/
SELECT
	last_name AS "LastName",
	COUNT(DISTINCT emp_no) AS "FrequencyCount"
FROM employees
GROUP BY last_name
ORDER BY COUNT(DISTINCT emp_no) DESC
;
/**********************************************************************************************************************************************/
/**********************************************************************************************************************************************/
/**********************************************************************************************************************************************/


/**********************************************************************************************************************************************/
/***  EPILOGUE: April Foolsday  ***************************************************************************************************************/
-- Evidence in hand, you march into your boss's office and present the visualization. With a sly grin, your boss thanks you for your work.
-- On your way out of the office, you hear the words, "Search your ID number." You look down at your badge to see that your employee ID number is 499942.
/**********************************************************************************************************************************************/
SELECT
	E.emp_no AS "EmployeeNumber",
	E.last_name AS "LastName",
	E.first_name AS "FirstName",
	T.title AS "EmployeeTitle",
	D.dept_name AS "DepartmentName",
	S.salary AS "EmployeeSalary"
FROM employees E
	JOIN dept_emp DE
		ON E.emp_no = DE.emp_no
	JOIN departments D
		ON DE.dept_no = D.dept_no
	JOIN salaries S
		ON E.emp_no = S.emp_no
	JOIN titles T
		ON E.emp_no = T.emp_no
WHERE 1=1
	AND E.emp_no IN(499942)
/**********************************************************************************************************************************************/
/**********************************************************************************************************************************************/
/**********************************************************************************************************************************************/