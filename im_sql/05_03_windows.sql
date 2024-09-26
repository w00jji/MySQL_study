#윈도우함수 sum()
select
e.emp_no, e.name, e.dept_no, e.salary,
sum(e.salary) over (partition by e.dept_no) as total_dept_sal,
sum(e.salary) over (partition by e.dept_no order by e.emp_no) as emp_sal
from employee e;

# 설명
-- 이 쿼리는 employee 테이블의 각 직원에 대해 부서별 전체 급여 합계와 부서별 직원의 누적 급여를 계산합니다.
-- sum(e.salary) over (partition by e.dept_no)은 각 부서별로 전체 직원들의 급여 합계를 계산하는 윈도우 함수입니다.
-- sum(e.salary) over (partition by e.dept_no order by e.emp_no)은 각 부서 내에서 직원들의 emp_no 순서에 따라 누적 급여를 계산하는 윈도우 함수입니다.


#dense_rank() 함수 사용법
select e.emp_no, e.name, e.salary,
dense_rank() over (order by e.salary desc) as dense_ranks
from employee e;

-- 1. dense_rank() 함수
-- dense_rank() 함수는 윈도우 함수로, 순위를 밀집된(dense) 형태로 매깁니다. 즉, 순위가 같은 경우에도 중복 없이 순차적으로 순위를 부여합니다.
-- dense_rank() 함수에는 파티션(PARTITION)을 지정하지 않았기 때문에 전체 결과 집합에 대해 순위가 매겨집니다.
-- 2. over (order by e.salary desc)
-- over 절은 윈도우 함수가 적용될 범위를 지정합니다.
-- order by e.salary desc: salary 열을 기준으로 내림차순으로 정렬합니다.
-- desc는 내림차순을 나타내며, e.salary 열 값이 높은 순서대로 정렬합니다.
-- 3. dense_ranks 열
-- dense_rank() over (order by e.salary desc) as dense_ranks: dense_rank() 함수를 사용하여 salary 열을 기준으로 각 직원의 밀집 순위를 계산합니다.
-- dense_ranks 열은 employee 테이블에서 각 직원의 밀집된 순위를 보여줍니다.

-- 문제 1: 각 부서별로 급여 상위 3명 찾기
select * from employee;
SELECT emp_no, name, dept_no, salary ,dept_rank
FROM (
    SELECT 
        emp_no,
        name,
        dept_no,
        salary,
        ROW_NUMBER() OVER (PARTITION BY dept_no ORDER BY salary DESC) AS dept_rank
    FROM employee

) ranked_employee
WHERE dept_rank <= 3;




-- 문제 0: 각 직원의 입사일에 따른 순위 매기기
SELECT * FROM employee;
SELECT emp_no, name, date_of_emp,
       RANK() OVER (ORDER BY date_of_emp) AS hire_date_rank
FROM employee;
