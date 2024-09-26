-- 고객 테이블에서 고객 번호와 회사 이름을 선택합니다.
SELECT customer_no, customer_comp_name
FROM customer
WHERE customer_no IN (
    -- 특정 조건을 만족하는 고객 번호를 선택합니다.
    # 각 고객의 총 주문 수량을 확인(having)
    
    SELECT customer_no
    FROM orders o
    JOIN order_details od ON o.order_no = od.order_no
    WHERE od.product_no = '1'  -- 제품 번호가 '1'인 주문 내역만 고려합니다.
    GROUP BY customer_no
    HAVING SUM(od.order_quantity) > (
        -- 제품 번호가 '1'인 제품을 주문한 고객들의 평균 주문 수량을 계산합니다.
        SELECT AVG(total_quantity)
        FROM (
            -- 각 고객별로 제품 번호 '1'에 대한 총 주문 수량을 계산합니다.
            SELECT customer_no, SUM(order_quantity) AS total_quantity
            FROM orders o
            JOIN order_details od ON o.order_no = od.order_no
            WHERE od.product_no = '1'
            GROUP BY customer_no
        ) AS avg_quantities  -- 서브쿼리의 결과를 avg_quantities로 명명합니다.
    )
);

SELECT d.dept_name, stats.avg_salary
FROM department d
JOIN (
    SELECT dept_no, AVG(salary) AS avg_salary
    FROM employee
    GROUP BY dept_no
) stats
ON d.dept_no = stats.dept_no
WHERE stats.avg_salary >= 50000;

# 각 직원의 정보와 그 직원이 속한 부서 조회
SELECT e.emp_no, e.name, e.salary,
       (SELECT d.dept_name
        FROM department d
        WHERE d.dept_no = e.dept_no) AS dept_name
FROM employee e;


# 부서명과 평균연뵹 조회(단, 평균 연봉이 50000이상인 부서만)

with dept_avg_sal as(
		select dept_no,avg(salary) as avg_sal
        from employee
        group by dept_no
)select d.dept_name,a.avg_sal
from department d join dept_avg_sal a on d.dept_no = a.dept_no
where a.avg_sal >=50000;

# 각 직원에 대한 상사 정보 조회
with employee_hierarchy as(
select e.emp_no, e.name as employee_name,e.boss_number,b.name as boss_name
from employee e
left join employee b on e.boss_number = b.Emp_no
)
select emp_no,employee_name,boss_name
from employee_hierarchy;


# 문제 1. 부서별로 직원 수가 5명 이상인 부서의 부서명과 직원 수를 조회하세요.

with dept_employee_count as (
	select dept_no,count(emp_no) as employee_count
    from employee
    group by dept_no
)
select d.dept_name , dc.employee_count
from department d join dept_employee_count dc
on d.dept_no = dc.dept_no
where dc.employee_count>=7;


# 문제 2. 모든 주문의 총 금액을 계산하는 쿼리를 작성하세요.
select * from order_details;


select order_no,round(sum(unit_price*order_quantity*(1-discount_rate)),2) as '주문별 총 금액'
from order_details
group by order_no with rollup;


with  order_total as(select order_no,round(sum(unit_price*order_quantity*(1-discount_rate)),2) as a
from order_details
group by order_no )
select sum(a) as all_total
from order_total;


-- 문제 3. 각 제품의 재고가 10개 이하인 제품의 제품명과 재고 수량을 조회하세요.

select * from products;

select product_name, sum(inventory)
from products
group by product_name
having sum(inventory) <=10;


-- 문제 4. 모든 직원의 연봉과 그 연봉의 평균 연봉을 함께 조회하는 쿼리를 작성하세요.

select * from employee;

with avg_salary_employee as(select avg(salary) as avg_salary
from employee)

select salary , name , avg_salary
from employee , avg_salary_employee;

# GPT 답
-- 첫 번째 CTE: 평균 연봉 계산
WITH avg_salary_employee AS (
    SELECT AVG(salary) AS avg_salary
    FROM employee
),

-- 두 번째 CTE: 직원의 연봉과 이름을 포함
employee_salary AS (
    SELECT emp_no, name, salary
    FROM employee
)

-- 메인 쿼리: 각 직원의 연봉, 이름과 평균 연봉을 조회
SELECT es.name, es.salary, ase.avg_salary
FROM employee_salary es, avg_salary_employee ase;

# 응용문제 1. 각 고객의 주문 수와 총 주문 금액을 조회하세요. 단, 총 주문 금액이 1000 이상인 고객만 조회하세요.

select * from order_details;


with  order_sum_price as(
select order_no, round(sum(unit_price*order_quantity*(1-discount_rate))) as sum_price
, sum(order_quantity) as quantity_count
from order_details
group by order_no
having round(sum(unit_price*order_quantity*(1-discount_rate)))>=1000
)

select * from customer;
select * from order_details;
select * from orders;


-- 각 주문의 총 금액과 주문 수량 계산
WITH order_sum_price AS (
    SELECT order_no, 
           SUM(unit_price * order_quantity * (1 - discount_rate)) AS sum_price,
           SUM(order_quantity) AS quantity_count
    FROM order_details
    GROUP BY order_no
),

-- 각 주문에 해당하는 고객 번호 가져오기
order_group_no AS (
    SELECT o.order_no, o.customer_no, osp.sum_price, osp.quantity_count
    FROM orders o
    JOIN order_sum_price osp ON o.order_no = osp.order_no
),

-- 고객별 주문 수와 총 주문 금액 집계
customer_order_summary AS (
    SELECT ogn.customer_no,
           COUNT(ogn.order_no) AS order_count,
           SUM(ogn.sum_price) AS total_order_price
    FROM order_group_no ogn
    GROUP BY ogn.customer_no
)

-- 총 주문 금액이 1000 이상인 고객 조회
SELECT c.customer_no, cos.order_count, cos.total_order_price
FROM customer_order_summary cos
JOIN customer c ON cos.customer_no = c.customer_no
WHERE cos.total_order_price >= 1000;


# 상관 서브쿼리 문제 1 : 각 부서에서 가장 높은 연봉을 받는 직원의 이름과 연봉을 조회하세요
select * from employee;

with De_max_sal as(select Dept_no, max(salary) as max_salary
from employee
group by Dept_no)


-- 각 부서에서 최대 연봉을 받는 직원 조회
SELECT e.name, e.salary
FROM employee e
JOIN De_max_sal dms ON e.Dept_no = dms.Dept_no AND e.salary = dms.max_salary;

# 상관 서브쿼리
SELECT e.name, e.salary
FROM employee e
WHERE e.salary = (
    SELECT MAX(sub.salary)
    FROM employee sub
    WHERE sub.Dept_no = e.Dept_no
);

# 일반 서브 쿼리
SELECT e.name, e.salary
FROM employee e
WHERE e.salary IN (
    SELECT MAX(sub.salary)
    FROM employee sub
    GROUP BY sub.Dept_no
);

# 다중 컬럼 서브 쿼리

# 주문 번호, 주문 날짜
select o.order_no,o.order_date
from orders o join order_details od on o.order_no=od.order_no
where (od.product_no,od.order_quantity) in (
select product_no, inventory
from products
where inventory <=10
);

# 제품 번호, 재고 수량
-- select product_no, inventory
-- from products
-- where inventory <=10;


# 1차 예제로 활용 - 추후 변동 가능
-- #일반 서브쿼리(전체 직원 중 최고 연봉)
-- SELECT emp_no, name, salary
-- FROM employee
-- WHERE salary = (SELECT MAX(salary) FROM employee);
-- #상관서브쿼리
-- SELECT e.name, e.salary
-- FROM employee e
-- WHERE e.salary = (
--     SELECT MAX(salary)
--     FROM employee
--     WHERE dept_no = e.dept_no
-- );


#응용문제 1. 각 고객의 주문 수와 총 주문 금액을 조회하세요. 단, 총 주문 금액이 1000 이상인 고객만 조회하세요.
with cust_order as (
select c.customer_no, c.customer_comp_name,
count(o.order_no) as order_cnt,
SUM(od.unit_price * od.order_quantity * (1 - od.discount_rate)) AS total_amount
from customer c
join orders o on c.customer_no = o.customer_no
join order_details od on o.order_no = od.order_no
group by c.customer_no, c.customer_comp_name
)
select customer_no, customer_comp_name, order_cnt, total_amount
from cust_order
where total_amount >= 1000;








