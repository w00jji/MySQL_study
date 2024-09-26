# 날짜, 시간함수
-- # NOW( ),SYSDATE( ) : 시스템의 현재 날짜와 시간을 반환함
-- CURDATE( ) : 시스템의 현재 날짜를 반환함
-- CURTIME( ) : 시스템의 현재 시간을 반환함

select now() as now_time; 
select sysdate(),
curdate(),
curtime();

# 연도,분기,월,일,시,분,초, 반환 함

-- DATE_FORMAT() 함수에 변환할 날짜와 '-, .' 등의 구분자를 넣어 사용합니다.
-- 날짜 포맷을 하기 위해서는 아래에 나와있는 포맷 문자를 넣은 뒤 구분자나 띄어쓰기 등을 사용하여 표현하면 됩니다.

select date_format(NOW(),'%Y-%m-%d');
select date_format(NOW(),'%Y년%m월%d일 %H시%i분%S초') as date_time;

SELECT YEAR(now()),
		   QUARTER(now() ),
		   MONTH( now()), 
		   DAY(now() ), 
		   HOUR(now() ), 
		   MINUTE(now() ), 
		   SECOND(now() );
           
-- QUARTER() 함수는 주어진 날짜 값(1에서 4 사이의 숫자)에 대한 분기를 반환합니다.

-- 1월-3월은 1을 반환합니다.
-- 4-6월은 2를 반환합니다.
-- 7-9월은 3을 반환합니다.
-- 10월-12월은 4를 반환합니다.

select * from actor;

SELECT YEAR(last_update),actor_id from actor;


-- DATEDIFF() : 기간을 일자 기준으로 반환함

-- TIMESTAMPDIFF( ) : 기간을 지정한 단위 기준으로 보여줌
-- SELECT DATEDIFF(끝 일자, 시작 일자),
-- 		   TIMESTAMPDIFF(단위, 시작 일자, 끝 일자);
SELECT DATEDIFF('2018-03-28 23:59:59', '2017-03-01 00:00:00');
SELECT DATEDIFF('2017-04-01 ', '2017-03-01'); # 날짜 차이를 일(Day)로 나타내줌


SELECT DATEDIFF(now(), last_update),
		   TIMESTAMPDIFF(Year, last_update, now())
           ,last_update,now()
           from actor;

# 문 1: last_update와 현재 날짜 사이의 일 수가 30일 이상인 레코드만 조회하여 days_since_update로 반환하시오.

select datediff(now(),last_update) as dtdf
from actor
where datediff(now(),last_update) >=30;


# 문2:현재 시간과 last_update 사이의 달 수가 6개월 이상인 레코드만 조회하여 
# investment_duration_months로 반환하시오.

SELECT 
		   TIMESTAMPDIFF(Month, last_update, now())
           ,last_update,now() as investment_duration_months
           from actor
           where TIMESTAMPDIFF(Month, last_update, now()) >=180;
           
           
# 문 3 : last_update와 현재 날짜 사이의 분 수를 계산하여 minutes_since_last_update으로 반환하시오.
SELECT 
		   TIMESTAMPDIFF( MINUTE, last_update, now())
           ,last_update,now() as minutes_since_last_update
           from actor;

# - 기간 반영하는 함수

-- ADDDATE( ) : 지정한 날짜를 기준으로 그 기간만큼 더한 날짜를 반환하는 함수

-- SUBDATE( ) : 기간만큼 뺀 날짜를 반환함
-- SELECT ADDDATE(날짜,기간) 또는 ADDDATE(날짜,INTERVAL 기간 단위),
-- 			 SUBDATE(날짜, 기간) 또는 SUBDATE(날짜,INERVAL 기간 단위);

select adddate(now(),30), adddate(now(),interval -50 day),
subdate(now(),30), adddate(now(),interval 50 day);

# 문1 : last_update에 30일을 더한 날짜가 현재 날짜보다 이전인 레코드만 조회하여 new_update_date로 반환하시오
select adddate(last_update,30) as new_update_date
from actor
where adddate(last_update,30)<now();

# 문2 : last_update에 45일을 더한 날짜와 last_update에서 1년을 뺀 날짜를 
#각각 new_update_date와 earlier_update_date로 반환하고, 
#두 날짜를 'YYYY-MM-DD' 형식으로 
#formatted_new_update_date와 formatted_earlier_update_date로 출력하시오.

SELECT 
    last_update,
    DATE_ADD(last_update, INTERVAL 45 DAY) AS new_update_date,
    DATE_SUB(last_update, INTERVAL 1 YEAR) AS earlier_update_date,
    DATE_FORMAT(DATE_ADD(last_update, INTERVAL 45 DAY), '%Y-%m-%d') AS formatted_new_update_date,
    DATE_FORMAT(DATE_SUB(last_update, INTERVAL 1 YEAR), '%Y-%m-%d') AS formatted_earlier_update_date
FROM 
    actor;


-- - 타 날짜 반환 함수

-- LAST_DAT( ) : 해당 월의 마지막 일자를 반환함

-- DAYOFYEAR( ) : 현재 연도에서 며칠이 지났는지를 반환함

-- MONTHNAME( )은 월을 영문으로, WEEKDAY( )는 요일을 정수로 보여줌 

SELECT last_day(last_update),
			 DAYOFYEAR(last_update),
			 MONTHNAME(last_update),
			 WEEKDAY(last_update)
             from actor;
             


select * from payment;
# 문제 1 : last_update가 속한 주의 요일을 weekday_update로 반환하시오.

select weekday(payment_date),payment_date as weekday_update from payment;

# 문제 2. last_update의 달의 마지막 날이 해당 연도의 365일 중 300일 이후인 레코드만 조회하여
# last_day_update와 day_of_year_update로 반환하시오.

SELECT 
    payment_date,
    LAST_DAY(payment_date) AS last_day_update,
    DAYOFYEAR(LAST_DAY(payment_date)) AS day_of_year_update
FROM 
    payment
WHERE 
    DAYOFYEAR(LAST_DAY(payment_date)) > 50;

# 문제 3 : last_update가 속한 요일이 월요일(0)이면서 해당 달의 이름이 'January'인 레코드만 조회하여 
# weekday_last_update과 month_name_last_update로 반환하시오.
SELECT 
    payment_date,
    DAYOFWEEK(payment_date) - 1 AS weekday_last_update,  -- 요일을 0(월요일)에서 6(일요일)로 맞추기 위해 -1
    MONTHNAME(payment_date) AS month_name_last_update
FROM 
    payment
WHERE 
    DAYOFWEEK(payment_date) = 2  -- 월요일 (1 = 일요일, 2 = 월요일, ..., 7 = 토요일)
    AND MONTHNAME(payment_date) = 'January';
    
    
# 문제 4 : last_update의 달의 이름이 'March'이면서 해당 연도의 100일 이전인 레코드만 조회하여 
# month_name_equity_evaluation과 day_of_year_equity_evaluation로 반환하시오.
SELECT 
    last_update,
    MONTHNAME(last_update) AS month_name_equity_evaluation,
    DAYOFYEAR(last_update) AS day_of_year_equity_evaluation
FROM 
    actor
WHERE 
    MONTHNAME(last_update) = 'March'
    AND DAYOFYEAR(last_update) < 100;

#문제 1
SELECT LAST_DAY(last_update) AS last_day_update, DAYOFYEAR(last_update) AS day_of_year_update, MONTHNAME(last_update) AS month_name_update
FROM actor;
#문제 2
#last_update의 달의 마지막 날이 해당 연도의 365일 중 300일 이후인 레코드만 조회하여 last_day_update와 day_of_year_update로 반환하시오.
SELECT LAST_DAY(last_update) AS last_day_update, DAYOFYEAR(LAST_DAY(last_update)) AS day_of_year_update
FROM actor
WHERE DAYOFYEAR(LAST_DAY(last_update)) > 300;
#문제 3
#last_update가 속한 요일이 월요일(0)이면서 해당 달의 이름이 'January'인 레코드만 조회하여 weekday_evaluation과 month_name_evaluation로 반환하시오.
SELECT WEEKDAY(last_update) AS weekday_last_update, MONTHNAME(last_update) AS month_name_last_update
FROM actor
WHERE WEEKDAY(last_update) = 0 AND MONTHNAME(last_update) = 'January';
#문제 4
#last_update의 달의 이름이 'March'이면서 해당 연도의 100일 이전인 레코드만 조회하여 month_name_equity_evaluation과 day_of_year_equity_evaluation로 반환하시오.
SELECT MONTHNAME(payment_date) AS month_name_equity_evaluation, DAYOFYEAR(payment_date) AS day_of_year_equity_evaluation
FROM payment
WHERE MONTHNAME(payment_date) = 'August' AND DAYOFYEAR(payment_date) < 5000;
