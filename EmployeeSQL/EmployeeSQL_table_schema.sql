/**********************************************************************************************************************************************/
/***  DATA ENGINEERING: table schema  *********************************************************************************************************/
/**********************************************************************************************************************************************/
/**********************************************/
/***  departments  ****************************/
/**********************************************/
-- Drop table, if it exists
DROP TABLE IF EXISTS departments;

-- Create table to import data into
CREATE TABLE departments (
    id SERIAL NOT NULL,
    dept_no VARCHAR(4) UNIQUE NOT NULL,
    dept_name VARCHAR(20) NOT NULL,
	PRIMARY KEY(id,dept_no)
);

-- Import data from departments.csv using postgreSQL's table Import/Export data feature
-- View columns and datatypes in table to make sure everything was imported correctly
SELECT * FROM departments;

/**********************************************/
/***  employees  ******************************/
/**********************************************/
-- Drop table, if it exists
DROP TABLE IF EXISTS employees;

-- Create table to import data into
CREATE TABLE employees (
    id SERIAL NOT NULL,
    emp_no INTEGER UNIQUE NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    gender VARCHAR(4) NOT NULL,
    hire_date DATE NOT NULL,
	PRIMARY KEY(id,emp_no)
);

-- Import data from employees.csv using postgreSQL's table Import/Export data feature
-- View columns and datatypes in table to make sure everything was imported correctly
SELECT * FROM employees;

/**********************************************/
/***  dept_emp  *******************************/
/**********************************************/
-- Drop table, if it exists
DROP TABLE IF EXISTS dept_emp;

-- Create table to import data into
CREATE TABLE dept_emp (
    id SERIAL NOT NULL,
    emp_no INTEGER NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

-- Import data from dept_emp.csv using postgreSQL's table Import/Export data feature
-- View columns and datatypes in table to make sure everything was imported correctly
SELECT * FROM dept_emp;

/**********************************************/
/***  dept_manager  ***************************/
/**********************************************/
-- Drop table, if it exists
DROP TABLE IF EXISTS dept_manager;

-- Create table to import data into
CREATE TABLE dept_manager (
    id SERIAL NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    emp_no INTEGER NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY(id),
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

-- Import data from dept_manager.csv using postgreSQL's table Import/Export data feature
-- View columns and datatypes in table to make sure everything was imported correctly
SELECT * FROM dept_manager;

/**********************************************/
/***  salaries  *******************************/
/**********************************************/
-- Drop table, if it exists
DROP TABLE IF EXISTS salaries;

-- Create table to import data into
CREATE TABLE salaries (
    id SERIAL NOT NULL,
    emp_no INTEGER NOT NULL,
    salary INTEGER NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

-- Import data from salaries.csv using postgreSQL's table Import/Export data feature
-- View columns and datatypes in table to make sure everything was imported correctly
SELECT * FROM salaries;

/**********************************************/
/***  titles  *********************************/
/**********************************************/
-- Drop table, if it exists
DROP TABLE IF EXISTS titles;

-- Create table to import data into
CREATE TABLE titles (
    id SERIAL NOT NULL,
    emp_no INTEGER NOT NULL,
    title VARCHAR(30) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

-- Import data from titles.csv using postgreSQL's table Import/Export data feature
-- View columns and datatypes in table to make sure everything was imported correctly
SELECT * FROM titles;