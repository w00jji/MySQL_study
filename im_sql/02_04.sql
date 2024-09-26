# 각 나이 그룹별 gold의 합계를 계산하고 그룹화하여 total_funds로 반환하시오.
select sum(gold) as total_funds,age
from finance_data
group by age;

# 각 성별과 나이 그룹별 총 gold을 계산하고 200 이상인 그룹만 반환
SELECT 
    gender,
    CASE 
        WHEN age >= 0 AND age < 10 THEN '0-9'
        WHEN age >= 10 AND age < 20 THEN '10-19'
        WHEN age >= 20 AND age < 30 THEN '20-29'
        WHEN age >= 30 AND age < 40 THEN '30-39'
        ELSE '40+'
    END AS age_group,
    SUM(gold) AS total_gold
FROM 
    finance_data
GROUP BY 
    gender, age_group
HAVING 
    SUM(gold) >= 200;

# 각 성별별 gold의 평균을 계산하고 10 이상인 그룹만 반환하여 avg_golds로 출력하시오
select avg(gold) as gold_avg
from finance_data
group by gender
having avg(gold) >=5;

# 각 성별과 나이 그룹별 총 gold을 계산하고 10 이상인 그룹만 반환
select sum(gold) ,CASE 
        WHEN age >= 0 AND age < 10 THEN '0-9'
        WHEN age >= 10 AND age < 20 THEN '10-19'
        WHEN age >= 20 AND age < 30 THEN '20-29'
        WHEN age >= 30 AND age < 40 THEN '30-39'
        ELSE '40+'
    END AS age_group
from sakila.finance_data
group by age_group , gender
having sum(gold) >=10;
# 각 성별별 gold의 평균을 계산하고 6 이상인 그룹만 반환하여 avg_golds로 출력하시오.
select avg(gold) as avg_golds
from sakila.finance_data
group by gender
having avg(gold)>=6;