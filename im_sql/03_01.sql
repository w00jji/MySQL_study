# 각 직원별 총 주문 수와 전체 총 주문 수 조회 (총 주문 수가 5개 이상인 직원만, 평균 처리 시간이 2일 이상인 경우 '지연'으로 표시)
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

# 강사 풀이
select ifnull(dept_no,'전체') as 부서번호,
count(emp_no) as 직원수,
avg(year(curdate()-year(birthday))) as 평균나이
from employee
GROUP BY 
    dept_no
WITH ROLLUP;


# 예외문제(심화) : 각 제품별 및 전체 총 판매 수량, 평균 할인율, 
# 총 판매 금액 조회 (총 판매 수량이 100 이상인 제품만, 할인율이 0인 경우 '할인 없음'으로 표시)
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

# 내가 푼거
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

# 각 직원별 총 주문 수와 전체 총 주문 수 조회 (총 주문 수가 5개 이상인 직원만, 평균 처리 시간이 2일 이상인 경우 '지연'으로 표시)
select * from orders;

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

# 조인연산 : 두개 이상의 테이블을 연결하여 데이터를 검색하는 방법
# ANSL SQL 조인 방식 : CROSS,INNER,OUTER join 등이 있다.
# Non-ANSL SQL 조인 방식 : 테이블을 쉼표로 구ㅁ분하여 from 절에 작성함 , 조인 조건과 기타 조건을 구분하지 않고 모두 where절에 기술함

# 내부(inner) 조인 :
select * from orders;
select * from order_details;
# 공통 컬럼 customer_no

select o.order_no, o.customer_no, od.product_no , od.order_quantity
from orders o inner join order_details od on o.order_no=od.order_no;

# left inner join
select o.order_no, o.customer_no, od.product_no , od.order_quantity
from orders o left join order_details od on o.order_no=od.order_no;

# right inner join
select o.order_no, o.customer_no, od.product_no , od.order_quantity
from orders o right join order_details od on o.order_no=od.order_no;

-- # full join (버전 7버전 이하)
-- select o.order_no, o.customer_no, od.product_no , od.order_quantity
-- from orders o full outer join order_details od on o.order_no=od.order_no;



#inner join 문제 1번
# employee 테이블과 department 테이블을 조인하여 각 직원의 이름과 부서명을 조회하세요.
select * from employee;
select * from department;

select e.name , d.dept_name
from employee e join department d on e.dept_no = d.dept_no;

select name , dept_name
from employee  join department  on employee.dept_no = department.dept_no;

-- 문제 1-1
-- 각 직원의 이름과 부서명을 조회하고, 직원이 없는 부서도 포함하여 조회하세요.
select name , dept_name
from employee  right join department  on employee.dept_no = department.dept_no;

select name , dept_name
from employee  left join department  on employee.dept_no = department.dept_no;


# 문제 1-2 : orders 테이블과 customer 테이블을 조인하여 각 주문의 고객명을 조회하세요.
select * from orders;
select * from customer;

select person_in_charge_name,order_no
from orders join customer on orders.customer_no = customer.customer_no;

# 문제 1-3 : 주문이 없는 고객도 포함하여 각 주문의 고객명을 조회하세요.
select person_in_charge_name,order_no
from orders right join customer on orders.customer_no = customer.customer_no;

# 1-4. 각 주문 상세의 제품 이름을 조회하세요.
select * from order_details;
select order_no,product_name
from order_details  join products on order_details.product_no= order_details.product_no;
select * from products;
# 1-5. 재고가 0인 제품도 포함하여 각 주문 상세의 제품 이름을 조회하세요.
select * from order_details;
select order_no,product_name
from order_details right join products on order_details.product_no= order_details.product_no;


# 1-6. 각 주문의 고객명을 조회하세요.
select * from orders;
select * from 
customer;

# select customer_no , customer_comp_name from customer;
select * from orders;

select order_no , customer_comp_name
from orders left join customer on orders.customer_no = customer.customer_no;


# 1-7. 각 주문을 처리한 직원의 이름을 조회하세요.
select * from orders;
select * from employee;

select name , orders.Emp_no
from orders join  employee on orders.emp_no= employee.Emp_no;


# cross join : 데이터가 너무 많아져서 잘 안쓴다.
select p.product_name,d.dept_name
from products p cross join department d;

select o.order_no, ml.grade_name
from orders o cross join mileage_level ml;

# employee 테이블에서 각 직원과 그 직원의 상사 정보 조회
select e1.name as 직원명 , e2.name as 상사명
from employee e1 inner join employee e2 on e1.boss_number = e2.Emp_no;

select * from employee;


# 각 직원과 동일한 부서에 속한 다른 직원 정보 조회
select * from employee;
select * from department;

select e1.name as 직원명 , e2.name as '같은 부서 직원'
from employee e1 join employee e2 on e1.Dept_no = e2.dept_no
where e1.Emp_no <> e2.emp_no;


-- SQL에서 <> 연산자는 "같지 않다" 또는 "다르다"를 의미합니다. 즉, e1.Emp_no <> e2.Emp_no 
# 조건은 e1.Emp_no와 e2.Emp_no가 같지 않은 경우를 필터링하는 조건입니다.

-- 주어진 쿼리는 다음과 같은 내용을 수행합니다:

-- employee 테이블에서 동일한 부서(Dept_no)에 속하는 직원(e1과 e2)을 조인합니다.
-- e1.Emp_no <> e2.Emp_no 조건을 사용하여 같은 부서에 속하지만 다른 직원들을 선택합니다. 같은 부서의 동일한 직원이 나오는 것을 방지하는 것입니다.
-- 이 쿼리는 결과적으로 동일한 부서에 속한 서로 다른 직원들의 이름 쌍을 반환합니다. 
# 예를 들어, "직원 A"와 "직원 B"가 같은 부서에 있으면 결과에 "직원 A - 직원 B"와 "직원 B - 직원 A" 두 가지 조합이 포함될 수 있습니다.


# 2-1. 각 직원과 동일한 성별을 가진 다른 직원 정보를 조회하세요
select * from employee;

select e1.name , e2.name
from employee e1 join employee e2 on e1.gender = e2.gender
where e1.emp_no<>e2.emp_no;

# 2-2. employee 테이블에서 각 직원과 동일한 지역에 사는 다른 직원 정보를 조회하고 지역명도 함께 보이시오.


select e1.name as 직원명 , e2.name as 동일지역직원명,e1.area
from employee e1 join employee e2 on e1.area = e2.area
where e1.emp_no<>e2.emp_no;


select e.name , d.dept_name
from employee e, department d
where e.dept_no=d.dept_no;

# 문제 3-1. 특정 고객의 주문과 주문 상세를 조회하세요
select * from order_details;
select * from products;

select o.product_no, product_name
from order_details o,products p
where o.product_no=p.product_no;

# 강사가 푼거
select * from orders;

select o.order_no, od.product_no
from orders o , order_details od
where o.customer_no='CARRI' and o.order_no = od.order_no;
# 특정 고객 : o.customer_no='CARRI'

-- 문제 3-2(응용문제). 각 주문에 대해 해당 주문의 고객 정보와 주문에 포함된 모든 제품의 정보(제품명, 단가)를 조회하되,
--  주문에 포함된 제품의 총 금액(수량 * 단가)을 계산하여 결과에 포함하세요.

# 응용문제 사용 테이블 : orders o, customer c, order_details od, products p

select * from orders;
select * from customer;
select * from order_details od;
select * from products;

# order_no, customer_comp_name, product_name, unit_price, order_quantity, 총금액계산 부분

select o.order_no, c.customer_comp_name, p.product_name, p.unit_price, od.order_quantity,
 (od.order_quantity * p.unit_price) as 총금액
from orders o, customer c , order_details od, products p
where o.customer_no = c.customer_no and o.order_no = od.order_no and od.product_no=p.product_no;

# 응용문제 2. 각 직원의 상사 이름과 해당 직원이 처리한 주문의 총 금액을 조회하세요. 직원이 처리한 주문이 없는 경우도 포함하세요.
select e.name as 직원명,b.name as 상사명,coalesce(sum(od.order_quantity * p.unit_price),0) as 총금액
from employee e 
left join employee b on e.boss_number = b.emp_no
left join orders o on e.emp_no = o.emp_no
left join order_details od on o.order_no = od.order_no
left join products p on od.product_no = p.product_no
group by e.name, b.name;







