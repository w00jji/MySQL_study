# 사용자 정의 함수

delimiter \\
create function fn_prod_amount(quantity int,price int)
returns int
deterministic
begin
declare amount int;
set amount = quantity * price;
return amount;
end \\
delimiter ;

# 문제 1: 특정 고객의 총 주문 금액을 계산하는 함수 작성
# 특정 고객의 총 주문 금액을 계산하는 사용자 정의 함수를 작성하고 이를 사용하여 결과를 출력
select * from customer;
select * from order_details;
select * from orders;
DROP FUNCTION IF EXISTS fn_cus_price;
-- 구분자를 변경하여 함수 본문을 작성할 수 있도록 설정
DELIMITER \\

-- fn_cus_price 함수 생성
CREATE FUNCTION fn_cus_price(customer_no CHAR(5))
RETURNS DECIMAL(10, 2)
DETERMINISTIC 
BEGIN
    DECLARE total_price DECIMAL(10, 2); # 변수 설정
    
    -- 총 주문 금액 계산
    SELECT SUM(od.unit_price * od.order_quantity)
    INTO total_price
    FROM order_details od
    JOIN orders o ON od.order_no = o.order_no join customer c on c.customer_no=o.customer_no
    WHERE o.customer_no = customer_no COLLATE utf8mb4_general_ci;
    
    RETURN total_price;
END \\

-- 구분자를 원래대로 복원
DELIMITER ;

select fn_cus_price('ACDDR');

-- 문제 2: 특정 제품의 총 판매량을 계산하는 함수 작성
-- 특정 제품의 총 판매량을 계산하는 사용자 정의 함수를 작성하고 이를 사용하여 결과 출력

select * from products;
select * from order_details;

DROP FUNCTION IF EXISTS fn_특정제품_총판매량;

delimiter \\
create function fn_특정제품_총판매량(product_no int)
returns DECIMAL(15,2)
deterministic # 오류나서 코드 넣음
begin
	declare total_price DECIMAL(15,2);
    
    select SUM(unit_price * order_quantity*(1-discount_rate))
    into total_price
    from order_details;
    
    return total_price;
end \\
delimiter ;

select fn_특정제품_총판매량(11);

-- 문제 3: 특정 직원의 부서명을 반환하는 함수 작성
-- 특정 직원의 부서명을 반환하는 사용자 정의 함수를 작성하고 이를 사용하여 결과를 출력


select * from employee;
select * from department;


-- 기존 함수를 삭제
DROP FUNCTION IF EXISTS fn_특정직원_부서명;

-- 구분자를 변경하여 함수 본문을 작성할 수 있도록 설정
DELIMITER \\

-- fn_특정직원_부서명 함수 생성
CREATE FUNCTION fn_특정직원_부서명(Emp_no CHAR(3))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50); -- 변수 설정
    
    -- 직원의 이름과 부서명 검색 및 결합
    SELECT CONCAT(e.name, ' - ', d.dept_name)
    INTO result
    FROM employee e
    JOIN department d ON e.dept_no = d.dept_no
    WHERE e.emp_no = Emp_no COLLATE utf8mb4_general_ci;
    
    RETURN result;
END \\

-- 구분자를 원래대로 복원
DELIMITER ;

select fn_특정직원_부서명('E01');


# 문제 4: 특정 고객의 특정 제품에 대한 총 주문 수량을 계산하는 함수 작성
# 특정 고객의 특정 제품에 대한 총 주문 수량을 계산하는 사용자 정의 함수를 작성하고 이를 사용하여 결과를 출력

select * from customer;
select * from orders;
select * from order_details;

-- 기존 함수를 삭제
DROP FUNCTION IF EXISTS fn_특정고객_특정제품_총주문수량;

-- 구분자를 변경하여 함수 본문을 작성할 수 있도록 설정
DELIMITER \\

-- fn_특정고객_특정제품_총주문수량 함수 생성
CREATE FUNCTION fn_특정고객_특정제품_총주문수량(customer_no CHAR(5), product_no INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_quantity INT; -- 변수 설정
    
    -- 총 주문 수량 계산
    SELECT SUM(od.order_quantity)
    INTO total_quantity
    FROM order_details od
    JOIN orders o ON od.order_no = o.order_no
    WHERE o.customer_no = customer_no COLLATE utf8mb4_general_ci
      AND od.product_no = product_no COLLATE utf8mb4_general_ci;
    
    RETURN total_quantity;
END \\

-- 구분자를 원래대로 복원
DELIMITER ;

select fn_특정고객_특정제품_총주문수량('NETVI', 11);

SELECT SUM(od.order_quantity) AS total_order_quantity, o.customer_no
FROM order_details od
JOIN orders o ON od.order_no = o.order_no
JOIN customer c ON o.customer_no = c.customer_no
WHERE od.product_no = 11
GROUP BY o.customer_no;

    