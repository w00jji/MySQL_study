
-- select * From actor;

-- # select first_name,actor_id From actor where first_name='ED' order by actor_id asc;

-- # select first_name From actor where last_update='2006-02-15 04:34:33' and first_name = 'ELVIS';

-- select * from customer;

-- select first_name,last_name,last_update,create_date
-- from customer
-- where store_id =2
-- union
-- select first_name,last_name,last_update,create_date
-- from customer
-- where active=0
-- order by first_name;


-- select * from city where city_id is null;

-- select * from finance_data;

-- select age,gender,Fixed_Deposits from finance_data where Fixed_Deposits between 5 and 10 order by Fixed_Deposits asc;

-- select char_length('hi'),length('hi'),char_length('안녕'),length('안녕');

-- select concat(gender,'-',age) as gender_age # 컬럼을 합칠 때 사용
-- from finance_data;

-- select LEFT(gender,1) as first_letter
-- from finance_data;

-- select right(Investment_Avenues,2) as two_last_char_Inv
-- from finance_data;

-- select substr(gender,2,2) as sub_letter # substr(gender,2,2) : (컬럼명, 시작위치 인덱스, 시작위치 인덱스부터 출력할 인덱스 길이)
-- from finance_data;

-- select substring_index(source,' ',1) as first_part_source # source 컬럼 안에 데이터의 ' ' 공백을 기준으로 인덱스를 지정
-- from finance_data;   

-- select source from finance_data;

-- select substring_index(`What are your savings objectives?`,' ',1) as wa
-- from finance_data;


-- select lpad(gender,10,'*') as pad_gen # 보통 문자열의 길이를 맞춰주고 싶을 때 사용
-- from finance_data;

# Duration 길이를 20으로하고 오른쪽에다가 -를 삽입alter

-- select * from finance_data;
-- select Rpad(Duration,'20','-') as R_D
-- from finance_data;

-- select ltrim(Source) 
-- from finance_data;

-- select trim(leading' ' from Investment_Avenues) as IA_Leading_trim
-- from finance_data;

select * from finance_data;
#filed 함수
-- select field(gender,'Male','Female') as field_gender
-- from finance_data;

select field(Invest_Monitor,'Monthly','Daily')
from finance_data;







