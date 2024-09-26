ALTER TABLE tradingcomp.employee
ADD COLUMN salary DECIMAL(10, 2);

SET SQL_SAFE_UPDATES = 0; # safe 모드가 켜저서 UPDATE , delete 명령을 막아둔걸 일시적으로 허용하는 코드


UPDATE tradingcomp.employee
SET salary = CASE Emp_no
    WHEN 'E01' THEN 42000.00
    WHEN 'E02' THEN 73000.00
    WHEN 'E03' THEN 43000.00
    WHEN 'E04' THEN 40000.00
    WHEN 'E05' THEN 52000.00
    WHEN 'E06' THEN 48000.00
    WHEN 'E07' THEN 38000.00
    WHEN 'E08' THEN 65000.00
    WHEN 'E09' THEN 62000.00
    WHEN 'E10' THEN 32000.00
    ELSE NULL
END;
select salary from tradingcomp.employee;
select * from employee;

select emp_no, name,salary from employee
where salary = (select max(salary) from employee);

# 특정 부서에서 가장 최근에 입사한 직원의 정보 조회
select emp_no,name,dept_no,date_of_emp
from employee
where date_of_emp=(select max(date_of_emp) from employee where Dept_no='A1');

# 문제 1: 가장 많은 주문을 한 고객의 정보를 조회

SELECT *
FROM customer c
JOIN (
    SELECT customer_no, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_no
    ORDER BY order_count DESC
    LIMIT 1
) o ON c.customer_no = o.customer_no;


# 문제 2: 특정 부서에서 가장 높은 연봉을 받는 직원의 정보를 조회, 특정 부서는 'A1'으로함
select * from department;
select * from employee;

select *
from employee
where  salary=(select max(salary) from employee WHERE Dept_no = 'A1');

select emp_no,name,salary,dept_no from employee
where salary = (
 select max(salary) from employee where Dept_no='A1'
);
# 문제 3: 특정 제품을 가장 많이 주문한 고객의 정보를 조회
select * from customer;
select * from order_details;
select * from orders;

SELECT *
FROM customer c
JOIN (
    SELECT o.customer_no, SUM(od.order_quantity) AS total_quantity
    FROM order_details od
    JOIN orders o ON od.order_no = o.order_no
    WHERE od.product_no = '1' -- 특정 제품 번호로 교체
    GROUP BY o.customer_no
    ORDER BY total_quantity DESC
    LIMIT 1
) t ON c.customer_no = t.customer_no;


select customer_no,customer_comp_name from customer
where customer_no=(
 select customer_no
 from orders o
 join order_details od on o.order_no = od.order_no
 where od.product_no = '1'
 group by customer_no
 order by sum(od.order_quantity) DESC
 limit 1
);


# 문제 4: 특정 부서에서 가장 많은 주문을 처리한 직원의 정보를 조회
select * from employee;
select * from orders;

SELECT *,
       COUNT(o.order_no) AS order_count
FROM employee e
JOIN orders o ON e.emp_no = o.emp_no
WHERE e.Dept_no = 'A1'
ORDER BY order_count DESC
LIMIT 1;

select *
from employee e join orders o on e.Emp_no=o.Emp_no
where e.Dept_no='A1';

select emp_no , name, dept_no,date_of_emp
from employee
where emp_no = (select emp_no from orders where emp_no in (select emp_no from employee where Dept_no='A1')
group by Emp_no
order by count(*) DESC
limit 1);



# Emp_no name eng_name position gender birthday date_of_emp address city area telephone boss_number Dept_no salary

#order_no customer_no emp_no order_date request_date shipment_date

# 가장 최근 입사한 직원보다 먼저 입사한 직원 정보 조회
select * from employee;
select emp_no,name,date_of_emp
from employee
where date_of_emp <(
 select max(date_of_emp) from employee
);

# 가장 많이 주문한 제품 상위 3개를 주문한 고객들의 정보를 조회
select * from order_details;
select * from customer;

select *
from customer,order_details
where order_quantity;

select *
from customer,order_details
where order_quantity in (
select count(order_quantity) from order_details group by product_no
order by count(order_quantity) Desc);

select * from order_details;
select product_no,count(order_quantity) from order_details group by product_no order by count(order_quantity) Desc;

SELECT product_no
    FROM order_details
    GROUP BY product_no
    ORDER BY COUNT(order_quantity) DESC
    LIMIT 3;

-- Step 1: 가장 많이 주문된 상위 3개 제품 찾기
WITH top_products AS (
    SELECT product_no
    FROM order_details
    GROUP BY product_no
    ORDER BY COUNT(order_quantity) DESC
    LIMIT 3
)

-- Step 2: 상위 3개 제품을 주문한 고객들의 정보 조회
SELECT c.* ,od.order_quantity
FROM customer c
JOIN orders o ON c.customer_no = o.customer_no
JOIN order_details od ON o.order_no = od.order_no
WHERE od.product_no IN (59,31,24);

select * from customer;
select customer_no, customer_comp_name 
from customer
where customer_no in (
select customer_no 
from orders o 
join order_details od on o.order_no = od.order_no
where od.product_no in ( 
select product_no from (
	select product_no
    from order_details 
    group by product_no
    order by sum(order_quantity) 
    DESC limit 3 ) as top_products
));

select product_no from 
(select product_no 
from order_details 
group by product_no 
order by sum(order_quantity) DESC limit 3 ) as top_products;






