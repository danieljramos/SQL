-- 01 How would you use a subquery to find the total number of orders placed by customers who have made a purchase more than once?

SELECT sum(salary)
FROM
  (SELECT emp_no,
          count(salary) AS counter,
          sum(salary) AS salary
   FROM salaries
   GROUP BY emp_no) AS COUNT
WHERE counter > 2

-- using with clause -- 

WITH COUNT AS
  (SELECT emp_no,
          count(salary) AS counter
   FROM salaries
   GROUP BY emp_no)
SELECT sum(salary)
FROM salaries
LEFT JOIN COUNT ON salaries.emp_no = count.emp_no
WHERE counter > 2

-- 02 Write a query to identify products that have been ordered more times than the average number of orders per product.

SELECT product
FROM
  (SELECT product,
          count(orders) AS count_order
   FROM product) AS total_orders
WHERE count_order >
    (SELECT avg(count_order)
     FROM total_orders)

-- Using with clause --  
  
  WITH orders AS
  (SELECT product,
          count(orders) AS order_count
   FROM products)
SELECT product
FROM orders
WHERE order_count > avg(sum(orders))
  OR WHERE order_count >
    (SELECT AVG(order_count)
     FROM orders)


-- 03 How would you find employees who joined the company after the most recent hire date within their department using a subquery?

  SELECT last_name
FROM employees
WHERE hire_date >=
    (SELECT max(hire_date)
     FROM employees)

-- 04 Write a query to retrieve customers who have placed orders worth more than the average order amount.

SELECT emp_no
FROM salaries
GROUP BY emp_no
HAVING sum(salary)>
  (SELECT avg(salary)
   FROM salaries)

-- 05 Write a query to display product details along with the percentage difference between the product's price and the average price of all products.'

SELECT a.emp_no,
       avg(a.avg_salary)/sum(a.t),
       sum(a.avg_salary)/sum(a.t)
FROM
  (SELECT emp_no,

     (SELECT avg(salary)
      FROM salaries) AS avg_salary,
          sum(salary) AS t
   FROM salaries
   GROUP BY emp_no,
            avg_salary) a
GROUP BY emp_no

-- Using with clause --
  
WITH avg_salary AS
  (SELECT emp_no,
          avg(salary) AS avg_salary
   FROM salaries
   GROUP BY emp_no)
SELECT salaries.emp_no,
       avg(avg_salary)/sum(salary)
FROM salaries
LEFT JOIN avg_salary ON salaries.emp_no = avg_salary.emp_no
GROUP BY salaries.emp_no

-- 06 How would you use a window function to rank emp by their total salary within each salary employee?

SELECT emp_no,
       rank() over(
                   ORDER BY total_salary DESC)
FROM
  (SELECT emp_no,
          sum(salary) AS total_salary
   FROM salaries
   GROUP BY emp_no) AS total

-- 07 get top 5
  
SELECT emp_no
FROM
  (SELECT emp_no,
          rank() over(
                      ORDER BY salary DESC) AS ranking
   FROM salaries) AS ranking
WHERE ranking < 5

-- Using with clause --
  
WITH total_salary AS
  (SELECT emp_no,
          sum(salary) AS total_salary
   FROM salaries
   GROUP BY emp_no),
     ranking AS
  (SELECT emp_no,
          rank() over(
                      ORDER BY total_salary DESC) AS ranking1
   FROM total_salary)
SELECT emp_no,
       ranking1
FROM ranking
WHERE ranking1 < 5



