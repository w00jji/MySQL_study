# 변수 설정
SET @abc=100;
set @exam=10;
set @var_name='이소미';
set @from :=100;

select * from employee where name=@var_name;


#사용자변수 사용 문제
#특정 직원의 이름을 입력받아 해당 직원과 상사 명을 출력하는 sql


select name ,boss_number from employee;
-- 사용자 변수를 설정합니다.
SET @employee_name = '이소미';

-- 특정 직원과 상사의 이름을 조회하는 쿼리
SELECT 
    e.name AS 직원이름, 
    b.name AS 상사이름
FROM 
    employee e
LEFT JOIN 
    employee b ON e.boss_number = b.emp_no
WHERE 
    e.name = @employee_name;
    
-- 로컬 변수(Local Variable)는 프로그래밍에서 특정 범위(scope) 내에서만 접근할 수 있는 변수입니다.
--  데이터베이스의 경우, 저장 프로시저나 함수 내에서 사용되며 해당 객체 내에서만 유효합니다. 
-- 이는 전역 변수(Global Variable)와는 달리 범위가 제한되어 있어서 프로시저나 함수 실행 중에만 사용할 수 있습니다.


DELIMITER //
CREATE PROCEDURE CountEmployeesInDept()
BEGIN
    -- 로컬 변수 선언, DECLARE: 변수정의
    
    DECLARE deptNo CHAR(2) CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
    DECLARE employeeCount INT;
    -- 변수 초기화
    SET deptNo = '01';
    SET employeeCount = 0;
   
    -- 특정 부서의 직원 수 계산
    SELECT COUNT(*)
    INTO employeeCount
     # 이 쿼리는 employee 테이블에서 부서 번호가 '01'인 직원들의 수를 세고,
    # 그 결과를 employeeCount 변수에 저장합니다
    
    FROM employee
    WHERE dept_no = deptNo COLLATE utf8mb4_general_ci;
    -- 결과 출력
    SELECT CONCAT('Department ', deptNo, ' has ', employeeCount, ' employees.') AS Result;
END //
DELIMITER ;


# 문제 1: 특정 고객의 총 주문 금액 계산
-- 특정 고객의 모든 주문에 대한 총 금액을 계산하는 저장 프로시저를 작성할 것
-- 프로시저는 고객 번호를 입력 매개변수로 받고, 해당 고객의 총 주문 금액을 반환
DROP PROCEDURE IF EXISTS CalculateTotalOrderAmountForCustomer;


DELIMITER //

CREATE PROCEDURE CalculateTotalOrderAmountForCustomer(
    IN p_customer_no VARCHAR(10) -- 입력 매개변수: 고객 번호
)
BEGIN
    DECLARE total_amount DECIMAL(10, 2); -- 총 주문 금액을 저장할 변수

    -- 총 주문 금액 계산 쿼리
    SELECT SUM(unit_price * order_quantity * (1 - discount_rate))
    INTO total_amount
    FROM orders o
    JOIN order_details od ON o.order_no = od.order_no
    WHERE o.customer_no = p_customer_no COLLATE utf8mb4_general_ci;

    -- 결과 출력
    SELECT total_amount AS TotalOrderAmount; -- 총 주문 금액 출력
END //

DELIMITER ;


CALL CalculateTotalOrderAmountForCustomer('NETVI');

select * from orders;


# 문제 2: 특정 부서의 직원 평균 연봉 계산
-- 특정 부서의 직원들의 평균 연봉을 계산하는 저장 프로시저를 작성
-- 프로시저는 부서 번호를 입력 매개변수로 받고, 해당 부서의 직원 평균 연봉을 반환
-- 기존에 같은 이름의 프로시저가 존재할 경우 삭제합니다.
DROP PROCEDURE IF EXISTS CalculateAverageSalaryForDepartment;

-- DELIMITER를 //로 변경하여 다음 줄부터 프로시저의 시작과 끝을 명시합니다.

-- DELIMITER \\
-- create procedure calc_avg_sal_bydept(in var_deptno char(5))
-- begin
-- # 변수 설정
-- declare avg_salary decimal(10,2);
-- # 실행 sql문
-- select avg(salary) into avg_salary from employee
-- where dept_no COLLATE = utf8m4_general_ci = var_deptno COLLATE utf8m4_general_ci;
-- # 출려 sql문
-- select var_detno as 부서번호,avg_salary as 평균연봉;
-- end
-- DELIMITER;







DELIMITER //
-- 새로운 프로시저를 생성합니다.
CREATE PROCEDURE CalculateAverageSalaryForDepartment(
    IN p_department_id CHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci -- 입력 매개변수: 부서 번호
)
BEGIN
    DECLARE avg_salary DECIMAL(10, 2); -- 평균 연봉을 저장할 변수 선언

    -- 평균 연봉 계산 쿼리
    SELECT AVG(salary)
    INTO avg_salary  -- 계산된 평균 연봉을 avg_salary 변수에 저장합니다.
    FROM employee
    WHERE dept_no = p_department_id; -- 입력된 부서 번호와 일치하는 직원의 연봉만을 계산합니다.

    -- 계산된 평균 연봉을 반환합니다.
    SELECT avg_salary AS AverageSalary;
END //

-- DELIMITER를 기본값인 ;로 변경하여 다음 SQL 명령문이 정상적으로 실행될 수 있도록 합니다.
DELIMITER ;


select * from department;

CALL CalculateAverageSalaryForDepartment('A1');


# 문제 3: 특정 제품의 총 판매량 계산
-- 특정 제품의 총 판매량을 계산하는 저장 프로시저를 작성
-- 프로시저는 제품 번호를 입력 매개변수로 받고, 해당 제품의 총 판매량을 반환

-- 기존에 같은 이름의 프로시저가 존재할 경우 삭제합니다.
DROP PROCEDURE IF EXISTS CalculateTotalSalesForProduct;

-- DELIMITER를 //로 변경하여 다음 줄부터 프로시저의 시작과 끝을 명시합니다.
DELIMITER //

-- 새로운 프로시저를 생성합니다.
CREATE PROCEDURE CalculateTotalSalesForProduct(
    IN p_product_id INT -- 입력 매개변수: 제품 번호
)
BEGIN
    DECLARE total_sales INT; -- 총 판매량을 저장할 변수 선언

    -- 총 판매량 계산 쿼리
    SELECT SUM(od.order_quantity*od.unit_price*(1-discount_rate))
    INTO total_sales  -- 계산된 총 판매량을 total_sales 변수에 저장합니다.
    FROM orders o
    JOIN order_details od ON o.order_no = od.order_no
    WHERE od.product_no = p_product_id; -- 입력된 제품 번호와 일치하는 제품의 주문량을 합산합니다.

    -- 계산된 총 판매량을 반환합니다.
    SELECT total_sales AS TotalSales,p_product_id;
END //

-- DELIMITER를 기본값인 ;로 변경하여 다음 SQL 명령문이 정상적으로 실행될 수 있도록 합니다.
DELIMITER ;

-- 제품 번호가 101인 제품의 총 판매량을 계산합니다.
CALL CalculateTotalSalesForProduct(10);
CALL CalculateTotalSalesForProduct(17);

select * from order_details;

#문제3.
DELIMITER \\
create procedure calc_total_sales(in var_prodno int)
begin
#변수 설정
declare total_sales int;
#실행 sql문
select sum(order_quantity) into total_sales
from order_details
where product_no = var_prodno;
#출력 sql문
select var_prodno as 제품번호, total_sales as 총판매량;
end\\
DELIMITER ;
#프로시저 호출
call calc_total_sales(10);





