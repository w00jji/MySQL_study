select * from customer;
select * from department;
select * from employee;
select * from mileage_level;
select * from order_details;
select * from orders;
select * from products;

# 기본 키들
# dept_no CHAR(2) PRIMARY KEY             : 테이블 명 customer
#Emp_no CHAR(3) PRIMARY KEY               : 테이블 명 department
#customer_no CHAR(5) PRIMARY KEY          : 테이블 명 employee
#,product_no INT PRIMARY KEY,             : 테이블 명 mileage_level
# order_no CHAR(5) PRIMARY KEY,           : 테이블 명 order_details
# order_no CHAR(5),                       :  기본키 없음 orders
# grade_name CHAR(1) PRIMARY KEY,         :테이블 명 employee

select Dept_no,count(*) as 직원수
from employee
group by Dept_no
having count(*) >=5;

# 각 주문 번호별 평균 가격과 가격이 50000 이상인 order_details 조회
select order_no,avg(unit_price) as '평균 급여'
from order_details
group by order_no
having avg(unit_price) >= 2000;


select * from orders;

# 고객별 주문 수 와 주문수가 10개 이상인 고객 조회
select customer_no,count(order_no) as 주문수
from orders
group by customer_no
having count(order_no) >=10;

# 테이블명 ororder_details
# 제품별 총 판매 수량과 총 판매 수량이 100이상인 제품 조회

select * from order_details;

select product_no,sum(order_quantity) as 판매수량
from order_details
group by product_no
having sum(order_quantity)  >=100;

# 각 도시별 고객 수와 고객 수가 10명 이상인 도시 조회
select * from customer;

select  city ,count(city)
from customer
group by city
having count(city)>=10;

select count(customer_no)
from customer
group by city;

# 각 고객의 마일리지 합계와 마일리지가 10000이상인 고객 조회
select  city ,sum(mileage)
from customer
group by city
having sum(mileage)>=10000;


select * from customer;

# 각 부서별 및 전체 직원 수 조회
# - WITH ROLLUP
-- 그룹별 소계와 전체 총계를 한번에 확인하고 싶을때 사용합
select dept_no,count(*) as 직원수
from employee
group by dept_no with rollup;

select dept_no,count(*) as 직원수
from employee
group by dept_no;

# 각 도시별 및 전체 고객수 조회
select city,count(*) as 직원수
from customer
group by city with rollup;


# 각 제품별 및 전체 총 판매 수량과 총 판매 금액 조회
select * from order_details;

select product_no,round(sum(order_quantity*unit_price * (1-discount_rate)),1)as '총 판매 금액',
sum(order_quantity) as '판매 수량'
from order_details
group by product_no with rollup;

select product_no
from order_details
order by product_no asc;
# 문제 1. 각 직원별 및 전체 주문 처리 수와 평균 주문 처리 시간 조회
select * from orders;

select emp_no,count(emp_no),avg(shipment_date)
from orders
group by emp_no with rollup;

#문제 2: 각 부서별 및 전체 직원 수와 평균 입사 날짜 조회(employee 테이블)
select * from employee;

select Dept_no,count(Dept_no), avg(date_of_emp)
from employee
group by Dept_no;
#문제 2-1: 각 부서별 및 전체 직원 수와 평균 재직 날짜 조회(employee 테이블)
SELECT 
    Dept_no,
    COUNT(*) AS employee_count,
    AVG (DATEDIFF(CURDATE(), date_of_emp)) AS avg_days_employed
FROM 
    employee
GROUP BY 
    Dept_no
WITH ROLLUP;


#문제 3: 각 부서별 및 전체 직원 수와 평균 나이 조회 (employee 테이블)
SELECT 
    Dept_no,
    COUNT(*) AS employee_count,
    AVG(TIMESTAMPDIFF(YEAR, birthday, CURDATE())) AS average_age
FROM 
    employee
GROUP BY 
    Dept_no
WITH ROLLUP;

# 예외문제(심화) : 각 제품별 및 전체 총 판매 수량, 평균 할인율, 
# 총 판매 금액 조회 (총 판매 수량이 100 이상인 제품만, 할인율이 0인 경우 '할인 없음'으로 표시)
select * from order_details;
SELECT 
    product_no,
    SUM(order_quantity) AS total_sales_quantity,
    AVG(CASE 
            WHEN discount_rate = 0 THEN NULL 
            ELSE discount_rate
        END) AS avg_discount_rate,
    CASE 
        WHEN AVG(CASE 
                    WHEN discount_rate = 0 THEN NULL 
                    ELSE discount_rate 
                 END) IS NULL THEN '할인 없음'
        ELSE CONCAT(ROUND(AVG(discount_rate) * 100, 2), '%')
    END AS avg_discount_rate_display,
    SUM(unit_price * order_quantity * (1 - discount_rate)) AS total_sales_amount
FROM 
    order_details
GROUP BY 
    product_no

WITH ROLLUP
having total_sales_quantity >=100;

# 강사 풀이
sELECT IFNULL(product_no, '전체') AS 제품번호,
       SUM(order_quantity) AS 총판매수량,
       CASE
         WHEN AVG(discount_rate) = 0 THEN '할인 없음'
         ELSE AVG(discount_rate)
       END AS 평균할인율,
       SUM(order_quantity * unit_price * (1 - discount_rate)) AS 총판매금액
FROM order_details
WHERE order_quantity > 0
GROUP BY product_no WITH ROLLUP
HAVING SUM(order_quantity) >= 100 OR product_no IS NULL;

# 각 직원별 총 주문 수와 전체 총 주문 수 조회 (총 주문 수가 5개 이상인 직원만, 평균 처리 시간이 2일 이상인 경우 '지연'으로 표시)
select * from orders;
SELECT
    emp_no,
    COUNT(emp_no) AS total_orders,
    CASE
        WHEN AVG(DATEDIFF(shipment_date, order_date)) >= 2 THEN '지연'
        ELSE '정상'
    END AS status
FROM
    orders
GROUP BY
    emp_no
HAVING
    COUNT(emp_no) >= 5
UNION ALL
SELECT
    '전체' AS emp_no,
    COUNT(emp_no) AS total_orders,
    CASE
        WHEN AVG(DATEDIFF(shipment_date, order_date)) >= 2 THEN '지연'
        ELSE '정상'
    END AS status
FROM
    orders;

# 강사 풀이
SELECT IFNULL(emp_no, '전체') AS 직원번호,
       COUNT(order_no) AS 총주문수,
       CASE
         WHEN AVG(DATEDIFF(shipment_date, order_date)) >= 2 THEN '지연'
         ELSE AVG(DATEDIFF(shipment_date, order_date))
       END AS 평균처리시간
FROM orders
WHERE shipment_date IS NOT NULL AND order_date IS NOT NULL
GROUP BY emp_no WITH ROLLUP
HAVING COUNT(order_no) >= 5 OR emp_no IS NULL;
