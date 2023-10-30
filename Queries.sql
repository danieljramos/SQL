-- 01 How would you use a subquery to find the total number of orders placed by customers who have made a purchase more than once?

Select 
sum(salary) from 
(select emp_no, count(salary) as counter, sum(salary) as salary from salaries group by emp_no) as count where counter > 2

/

with count as (select emp_no, count(salary) as counter from salaries group by emp_no)

select
sum(salary) from salaries left join count on salaries.emp_no = count.emp_no
where
counter > 2

Write a query to identify products that have been ordered more times than the average number of orders per product.

select product  from (select product, count(orders) as count_order from product) as total_orders where count_order > (select avg(count_order) from total_orders)

with orders as (select product , count(orders) as order_count from products)
select product from orders where order_count > avg(sum(orders)) or WHERE order_count > (SELECT AVG(order_count) FROM orders)

with orders as (select product , count(orders) as order_count from products)
select product from orders where order_count > avg(sum(orders)) or WHERE order_count > (SELECT AVG(order_count) FROM orders)

How would you find employees who joined the company after the most recent hire date within their department using a subquery?
select last_name from employees  where hire_date >= (select max(hire_date) from employees)

Write a query to retrieve customers who have placed orders worth more than the average order amount.

select emp_no from salaries group by emp_no having sum(salary)> (select avg(salary) from salaries)

Write a query to display product details along with the percentage difference between the product's price and the average price of all products.'

select a.emp_no, avg(a.avg_salary)/sum(a.t), sum(a.avg_salary)/sum(a.t)
from
(select emp_no,(select avg(salary) from salaries) as avg_salary , sum(salary) as t from salaries group by emp_no, avg_salary ) a group by emp_no

with avg_salary as (select emp_no, avg(salary) as avg_salary from salaries group by emp_no)
select salaries.emp_no, avg(avg_salary)/sum(salary)  from salaries left join avg_salary on   salaries.emp_no = avg_salary.emp_no group by salaries.emp_no

Write a query to find employees whose manager has a higher salary than the average salary of all managers.

Select emp_no as employee from salaries where 

How would you use a window function to rank emp by their total salary within each salary employee?

select emp_no, rank() over(order by total_salary desc) from (select  emp_no, sum(salary) as total_salary from salaries group by emp_no) as total

get top 5
select emp_no from (select emp_no, rank() over(order by salary desc) as ranking from salaries) as ranking where ranking < 5

with total_salary as (select emp_no, sum(salary) as total_salary from salaries group by emp_no),  


ranking as ( select emp_no, rank() over(order by total_salary desc) as ranking1 from total_salary)

select emp_no, ranking1 from ranking where ranking1 < 5


