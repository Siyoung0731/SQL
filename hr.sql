-- King 이라는 직원을 출력
select *
from employees
where last_name like '%King%';

--월급순 내림차순으로 직원정보를 출력
select employee_id, first_name, last_name, salary
from employees
order by salary desc;

-- 전화번호에 100이 포함된 직원
select *
from employees
where phone_number like '%100%';

-- 50번 부서의 직원을 출력해라
select *
from employees
where department_id = 50
order by desc;
-- 부서가 없는 직원을 출력
select *
from employees
where department_id is null;







