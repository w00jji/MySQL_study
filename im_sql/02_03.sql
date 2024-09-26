-- - 형 변환 함수 : 데이터를 검색, 삽입할 때 컬럼에 맞는 형식으로 지정하지 않으면 오류가 나는 경우에 사용하는 함수

-- CAST( ), CONVERT( )

-- 원하는 형태로 데이터타입을 변경하여 처리하거나 확인할 수 있음

SELECT CAST(age AS char)
		 from finance_data;
         
# unsigned, singned
SELECT CAST(age AS unsigned)
		 from finance_data 
         where cast(age AS unsigned) >=30;
         

select age, if(age>=30,'30대이상','30대 미만') from finance_data;



# age가 40 이상인 경우 'Very High', 30 이상 40 미만인 경우 'High', 
#그렇지 않으면 'Low'를 반환하여 funds_level로 출력하시오.

# MySQL에서 주어진 조건을 만족하는 funds_level을 반환하려면 CASE 문을 사용하는 것이 더 적절합니다.
SELECT 
    age,
    CASE 
        WHEN age >= 40 THEN 'Very High'
        WHEN age >= 30 AND age < 40 THEN 'High'
        ELSE 'Low'
    END AS funds_level
FROM 
    finance_data;


SELECT 
    age,
    IF(age >= 40, 'Very High', 
        IF(age >= 30, 'High', 'Low')) AS funds_level
FROM 
    finance_data;

# payment_date가 2005년 이후인 경우 'Recent', 그렇지 않으면 'Old'를 반환하여 update_status로 출력하시오.
SELECT 
    payment_date,
    CASE 
        WHEN YEAR(payment_date) > 2005 THEN 'Recent'
        ELSE 'Old'
    END AS update_status
FROM 
   payment;

SELECT 
    payment_date,
    IF(YEAR(payment_date) > 2005, 'Recent', 'Old') AS update_status
FROM 
    payment;

-- IFNULL( ) : 수식1이 NULL이 아니면 수식1의 값을 반환하고, NULL이면 수식2의 값을 반환함

-- NULLIF( ) : 두 수식 값을 비교하여 값이 같으면 NULL을 반환하고, 값이 다르면 수식1의 값을 반환함

select ifnull(age,0) as age_isnull
from finance_data;

select ifnull(age,'nan') as age_isnull
from finance_data;

select nullif(age,34) as age_isnull
from finance_data;

# age가 30인 경우 NULL을 반환하고, 각 레코드의 age 값을 2배로 하여 age_value로 출력하시오.
SELECT 
    age,
    CASE 
        WHEN age = 30 THEN NULL
        ELSE age * 2
    END AS age_value
FROM 
    finance_data;

# last_update가 '2023-01-01'인 경우 NULL을 반환하여 update_date로 출력하시오.
select nullif(last_update,'2005-01-01') from actor;


-- CASE 문 : 함수는 아니지만 조건 비교가 여러 개일 때 유용하게 사용할 수 있음

-- 모든 조건을 만족하지 않으면 ELSE 다음에 값을 넣어줌

-- CASE 문은 반드시 END로 마무리

SELECT CASE WHEN 조건식 THEN'성과초과달성'
			WHEN 조건식 THEN '성과달성'
			ELSE '미달성'
			 END;
             
select age, case when age <18 then'미성년자'
				 when age between 19 and 30 then '성인'
                 ELSE '시니어'
                 end as age_group
from finance_data;


# age를 그룹화하여 별칭을 age_group으로 하고 
# 각 age_group별로 총 gold를 계산하여 totalfund로 반환하시오.
select sum(gold) as totalfund
from finance_data
group by age;

SELECT 
    CASE 
        WHEN age >= 0 AND age < 10 THEN '0-9'
        WHEN age >= 10 AND age < 20 THEN '10-19'
        WHEN age >= 20 AND age < 30 THEN '20-29'
        WHEN age >= 30 AND age < 40 THEN '30-39'
        ELSE '40+'
    END AS age_group,
    SUM(gold) AS totalfund
FROM 
    finance_data
GROUP BY 
    age_group
ORDER BY 
    age_group desc;  -- 선택적으로 age_group을 정렬할 수 있음
