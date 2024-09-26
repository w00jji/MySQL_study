-- select * from finance_data-- 
#celing 함수 : 올림
select ceiling(age) as ceil_age
from finance_data;

select ceiling(123.4567);

#floor 함수 : 버림
select floor(age) as floor_age
from finance_data;

select floor(123.4567);

# round 함수 : 지정한 위치에서 반올림
select round(age,2) as round_age
from finance_data;

select round(123.4567,2);

#truncate 함수 : 지정한 위치에서 버림 작업을 수행하는 함수
select truncate(age,1) as truncate_age
from finance_data;

select truncate(123.456,2);


select ceiling(123.4567), # 올림
 floor(123.4567), # 내림
 round(123.4567,2), # 지정한 위치에서 반올림
 truncate(123.456,2); # 지정한 위치에서 버림

#abs,sign,power,rand

SELECT 
	ABS(-1),
	SIGN(1), # 양수의 경우1, 음수의 경우 -1을 반환하는 함수
	POWER(2,2), # n제곱승 값을 반환하는 함수
	SQRT(2), #제곱근 값을 반환하는 함수
	RAND(), # 0과 1사이 임의의 실수 값을 반환하는 함수
	RAND(0);

# mod(), % , 피연산자 mod 피연산자
select mod(3,3),
	  4 % 3,
      5 mod 2;

select mod(age,2) as mod_age
from finance_data;

select mod(age,2) as mod_age
from finance_data
where mod(age,2)=1;

select mod(age,2) + mod(gold,2),age,gold as mod_age
from finance_data;

select mod(age,6) , age 
from finance_data;


# 문제 1 :age의 2.5제곱을 계산하고 소수점 둘째 자리까지 반올림하여 rounded_power_age로 출력하시오.
select round(power(age,2.5),2) as rounded_power_age
from finance_data;

# Mutual_Funds의 제곱근이 3 이상인 레코드만 조회하여 sqrt_mutual_funds로 출력하시오.

select Mutual_Funds from finance_data;

select sqrt(Mutual_Funds) as sqrt_mutual_funds
from finance_data
where sqrt(Mutual_Funds) >=2;

select sqrt(Mutual_Funds) as sqrt_mutual_funds;


# Debentures의 네제곱을 계산한 후, 그 값의 제곱근을 구하여 sqrt_power_debentures로 출력하시오.
select sqrt(power(Debentures,4)) as sqrt_power_debentures
from finance_data;

# 레코드를 임의의 순서로 정렬하여 random_order로 출력하시오.
SELECT RAND() AS random_order
FROM finance_data
ORDER BY random_order;

select *
from finance_data
order by RAND(); # 이렇게 하면 finance_data 테이블이 그냥 랜덤으로 정렬 , asc ,desc가 랜덤으로 나오는거임









