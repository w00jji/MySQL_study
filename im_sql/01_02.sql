select * from finance_data;

-- select instr('testsize','size') as gen_in_f

select instr(gender,'F') as gen_in_F
from finance_data;

select elt(field(gender,'Male','Female'),'M','F') as gender_elt
from finance_data;

select * from finance_data;

-- select instr('testsize','size') as gen_in_f

select instr(gender,'F') as gen_in_F
from finance_data;

select elt(field(gender,'Male','Female'),'M','F') as gender_elt
from finance_data;

select elt(2,'sql','python','C');

select age from finance_data where age between 20 and 21;
select elt(field(age,20,21),'20대','20대') as age_elt
from finance_data;

select repeat(gender,3) as re_gen
from finance_data;

select replace(Investment_Avenues,'Yes','Y') as rep_ia
from finance_data;

select replace(replace(Investment_Avenues,'Yes','Y'),'No','N') as rep_ia
from finance_data;


select reverse('ABCDEFG') as rev;

select reverse(gender) as gender_rev
from finance_data;

# 1번 문제
-- Expect의 값을 2번 반복하여 repeated_expect로 출력하고, 
-- 각 반복된 값 사이에 '-'를 추가하여 출력하시오.
--  예를 들어, '20%-30%'는 '20%-30%-20%-30%'로 출력하시오.
 
 select * from finance_data;
 
 select concat(Expect,'-',Expect)as repeadted_expect from finance_data ;
 #------------------------------------------------------------------------
 
 # 2번 문제
 --  gender와 age를 결합하여 gender_age로 만든 후, 
--  gender_age 문자열을 2번 반복하고, 각 반복된 값 사이에 공백을 추가한
--  최종 문자열의 모든 공백을 '_'로 대체하여 modified_gender_age로 출력하시오
 
# 1번째 방법
 select concat(gender,age) as gender_age from finance_data;
 
SELECT
    REPLACE(CONCAT(gender, age, ' ', gender,  age), ' ', '_') AS modified_gender_age
FROM
    finance_data;

# ----------------------------------------
# 2번째 방법   
SELECT 
    REPLACE(CONCAT(gender_age, ' ', gender_age), ' ', '_') AS modified_gender_age
FROM (
    SELECT CONCAT(gender, ' ', age) AS gender_age 
    FROM finance_data
) AS subquery; # 재사용하기 위해서 subquery를 적어 준다.
    
# AS subquery를 삭제하면 실행되지 않는 이유는 SQL에서 서브쿼리에 별칭을 지정하지 않으면 메인 쿼리에서 해당 서브쿼리의 결과를 참조할 수 없기 때문입니다. 
# 서브쿼리를 사용하는 경우, 별칭을 통해 메인 쿼리가 서브쿼리의 결과를 식별하고 참조할 수 있게 됩니다.
