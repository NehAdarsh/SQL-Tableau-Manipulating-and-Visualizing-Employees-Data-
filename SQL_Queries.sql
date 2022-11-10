USE employees_mod;

#Breakdown between male and female employees
select e.gender, count(e.emp_no) as num_of_employees, year(d.from_date) as calender_year
FROM t_employees as e
join t_dept_emp as d
on d.emp_no = e.emp_no
group by calender_year, e.gender
having calender_year >= 1990;


#Breakdown between male and female employees
SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;


#Breakdown of average salary of male and female employees untill year 2002
SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;


#Average employee salary since 1990
DROP PROCEDURE IF EXISTS filter_salary;

DELIMITER $$
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
SELECT 
    e.gender, d.dept_name, AVG(s.salary) as avg_salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
    WHERE s.salary BETWEEN p_min_salary AND p_max_salary
GROUP BY d.dept_no, e.gender;
END$$

DELIMITER ;

CALL filter_salary(50000, 90000);




-- select avg(s.salary),dept_name
-- from t_salaries as s
-- join t_dept_emp as de
-- on s.emp_no = t.emp_no
-- join t_departments as t2
-- on t.dept_no = t2.dept_no
-- where year(t.from_date) = 1999
-- group by 2;




-- select d.dept_name, e.gender,count(*) as num_of_employees
-- FROM t_employees as e
-- join t_dept_emp as de
-- on de.emp_no = e.emp_no
-- join t_departments d
-- on d.dept_no = de.dept_no
-- group by 1, 2
-- order by 1;
