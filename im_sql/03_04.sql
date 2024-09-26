# 1, 'John', 'Doe', 'Sales', 50000

select * FROM employee;

insert into employee (Emp_no,eng_name,salary) values (1,'John Doe Sales',50000);

select Emp_no,eng_name,salary from employee where Emp_no=1;

-- 제품 테이블에 제품 이름은 'Laptop', 포장 방식은 'Box', 단가는 1200, 재고는 50

# 문제 2 employee 테이블에 
# 직원 번호는 '마지막 번호'
#새로운 직원 'Jane Smith'를 추가하고, 
#, 
-- 영어 이름은 'Smith', 
-- 직위는 'Manager', 
-- 성별은 'F', 
-- 생일은 '1985-07-19', 
-- 입사일은 '2020-05-10', 
-- 주소는 '123 Maple St', 
-- 도시는 'New York', 
-- 지역은 'NY', 
-- 전화번호는 '555-1234', 
-- 상사 번호는 'E5', 
-- 부서 번호는 'A2'로 설정하세요.
select * FROM employee;

insert into employee value ('E11','Jane Smith','Smith','Manager','F','1985-07-19','2020-05-10','123 Maple St','New York',
'NY','555-1234','E5','A2',0);

delete from employee where Emp_no = 'E11';
delete from employee where Emp_no = '1';
# 문제3. customer 테이블에 
-- 새로운 고객을 추가하고, 
-- 고객 번호는 '아무거나', 
-- 회사 이름은 'Tech Solutions', 
-- 담당자 이름은 'Tom Brown', 
-- 담당자 직위는 'CEO', 
-- 주소는 '456 Oak Ave', 
-- 도시는 'San Francisco', 
-- 지역은 'CA', 
-- 전화번호는 '555-5678', 
-- 마일리지는 500으로 설정하세요.


# 문제 4. orders 테이블에 새로운 주문을 추가하고, 주문 번호는 '마지막 번호', 고객 번호는 'C0001', 직원 번호는 '임의', 주문 날짜는 '2023-07-01', 요청 날짜는 '2023-07-05', 배송 날짜는 '2023-07-04'로 설정하세요.


# 문제 1. employee 테이블에서 직원 번호가 'E02'인 직원의 주소를 '456 Elm St'로 업데이트하세요.
update employee
set address='456 Elm St'
where Emp_no = 'E02';

select Emp_no,address from employee;

# 문제 2. products 테이블에서 제품 번호가 21인 제품의 재고를 70으로 업데이트하세요.
select product_no,inventory from products;
update products
set inventory=70
where product_no=21;


# 문제 3. customer 테이블에서 고객 번호가 'ANRFR'인 고객의 마일리지를 1500으로 업데이트하세요
select * from customer;

update customer
set mileage = 1500
where customer_no = 'ANRFR';

select * from customer where customer_no='ANRFR';

-- 문제 2. 특정 기간 동안 주문한 모든 고객의 마일리지를 해당 기간의 최대 주문 금액으로 업데이트하세요.
-- 2020-04-01 ~ 2020-04-10
-- Step 1: Calculate the maximum order amount for each customer within the given date range
WITH max_order_amount AS (
    SELECT o.customer_no, MAX(od.total_amount) AS max_amount
    FROM orders o
    JOIN (
        SELECT order_no, customer_no, SUM(unit_price * order_quantity * (1 - discount_rate)) AS total_amount
        FROM order_details
        GROUP BY order_no, customer_no
    ) od ON o.order_no = od.order_no
    WHERE o.order_date BETWEEN '2020-04-01' AND '2020-04-10'
    GROUP BY o.customer_no
)

-- Step 2: Update the mileage of each customer to the maximum order amount found in Step 1
UPDATE customer c
SET c.mileage = (
    SELECT moa.max_amount
    FROM max_order_amount moa
    WHERE moa.customer_no = c.customer_no
)
WHERE EXISTS (
    SELECT 1
    FROM max_order_amount moa
    WHERE moa.customer_no = c.customer_no
);

# 문제 3 특정 마일리지 이하의 모든 고객을 삭제하세요.
-- delete from customer where maileage <=1000;
# 문제4. 특정 도시의 모든 고객을 삭제하세요. (도시: 'San Francisco')
select * from employee;
select * from customer;
-- delete from customer where city='함경북도';



