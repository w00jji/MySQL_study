#데이터베이스 생성(company_db)
-- create database company_db;
#데이터베이스 선택
-- use company_db;
#테이블 생성(test)
-- create table test (
-- id int PRIMARY KEY auto_increment,
-- first_name VARCHAR(50),
-- last_name VARCHAR(50),
-- email VARCHAR(100) UNIQUE,
-- date_of_birth DATE,
-- date_of_joining DATE,
-- department VARCHAR(50),
-- salary DECIMAL(10, 2)
-- )
#문제 2. test 테이블에 직원의 직급을 저장할 rank 컬럼을 추가하세요. 이 컬럼은 최대 20자의 가변 길이 문자열을 저장할 수 있어야 합니다.
-- alter table test
-- add column `rank` varchar(20);
#문제 3. test 테이블의 salary 컬럼의 데이터 타입을 변경하여 최대 15자리 숫자를 소수점 이하 두 자리까지 저장할 수 있도록 수정하세요.
-- alter table test
-- modify column salary decimal(15, 2);
#문제 4. test 테이블의 date_of_joining 컬럼의 이름을 hire_date로 변경하고, 데이터 타입을 TIMESTAMP로 변경하세요.
-- alter table test
-- change column date_of_joining hire_date timestamp;
#문제 5. test 테이블에서 rank 컬럼을 삭제하세요.
-- alter table test
-- drop column `rank`;
#문제 6. test 테이블의 이름을 staff로 변경하세요.
-- alter table test
-- rename to staff;


#테이블 삭제
-- drop table staff;
#데이터베이스 삭제
-- drop database company_db;

create view create_emp as
select * from employee;

# 각 제품의 재고가 10개 이하인 제품의 제품명과 재고 수량을 조회하세요.

create view inven10 as
select product_name, sum(inventory)
from products
group by product_name
having sum(inventory) <=10;

# 문제 1. (view)각 부서별로 직원 수를 조회하시오. 단, 부서 번호와 부서 이름, 그리고 직원 수를 포함하시오.

select * from employee; 
select * from department;

select *
from employee e join department d on e.dept_no=d.dept_no ;


create view d_em_cnt as
SELECT 
    d.dept_no AS "부서 번호", 
    d.dept_name AS "부서 이름", 
    COUNT(e.emp_no) AS "직원 수"
FROM 
    employee e
JOIN 
    department d 
ON 
    e.dept_no = d.dept_no
GROUP BY 
    d.dept_no, 
    d.dept_name
ORDER BY 
    d.dept_no;


-- 문제 2. 특정 고객이 주문한 제품들의 총 금액을 조회하는 VIEW를 생성하시오. 단, 고객 번호와 고객 이름, 그리고 총 금액을 포함하시오.
select * from customer;
select * from orders;
select * from order_details;


-- select c.customer_no,c.customer_comp_name, od.sum(unit_price * order_quantity * (1-discount_rate)) as 총금액
-- from customer c left join
-- orders o on c.customer_no=o.customer_no left join
-- order_details od  on o.order_no=od.order_no
-- where customer_no='NETVI';



create view ACDDR_cus as
SELECT 
    c.customer_no AS "고객 번호", 
    c.person_in_charge_name AS "고객 이름", 
    SUM(od.unit_price * od.order_quantity * (1 - od.discount_rate)) AS "총 금액"
FROM 
    customer c
LEFT JOIN 
    orders o ON c.customer_no = o.customer_no
LEFT JOIN 
    order_details od ON o.order_no = od.order_no
where c.customer_no = 'ACDDR'
GROUP BY 
    c.customer_no;
   



-- 문제 3. 각 직원의 상사 이름과 직원 이름을 함께 조회하는 VIEW를 생성하시오. 단, 상사가 없는 직원도 포함하시오.

select * from employee;

create view 각_직원_상사 as
select e.name as 직원이름 , b.name as 상사
from employee e join employee b on e.Emp_no=b.boss_number;



-- 문제 4. 모든 주문에 대해 주문 번호와 주문한 제품의 개수, 총 주문 금액을 조회하는 VIEW를 생성하시오.

select * from orders;
select * from order_details;

create view 주문번호_개수_금액 as
select order_no, sum(order_quantity) as 제품개수 , round(sum(unit_price * order_quantity * (1-discount_rate)),2) as 총주문금액
from order_details
group by order_No;


-- 문제 5. 특정 직원이 담당한 주문 내역을 조회하는 VIEW를 생성하시오. 단, 직원 번호와 이름, 주문 번호, 주문 날짜, 고객 이름을 포함하시오.
select * from employee;
select * from orders;

-- select o.emp_no,e.name , o.order_no , o.order_date , o.request_date,o.shipment_date
-- from employee e join orders o on e.Emp_no=o.emp_no
-- group by o.emp_no;


create view 특정직원_담당_내역 as 
SELECT 
    o.emp_no AS "직원 번호", 
    e.name AS "직원 이름", 
    o.order_no AS "주문 번호", 
    o.order_date AS "주문 날짜", 
    c.customer_comp_name AS "고객 이름"
FROM 
    employee e
JOIN 
    orders o ON e.emp_no = o.emp_no
JOIN 
    customer c ON o.customer_no = c.customer_no
where o.emp_no = 'E04';

# 뷰 조회

SELECT * FROM information_schema.views
WHERE table_name = 'create_emp';

show create view acddr_cus;