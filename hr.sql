-- King 이라는 직원을 출력
select *
from employees
where last_name like '%King%';

--월급순 내림차순으로 직원정보를 출력
select employee_id as "사번"
, first_name as "성"
, last_name as "이름"
, salary as "월급"
from employees
order by salary desc;

-- 전화번호에 010이 포함된 직원
select *
from employees
where phone_number like '%010%';

-- 50번 부서의 직원을 출력해라
select first_name || ' ' || last_name as "이름" -- || : 문자열 연결 연산자
, phone_number as "전화번호"
, manager_id
from employees
where department_id = 50
order by "이름" desc;

-- 부서가 없는 직원을 출력
select employee_id as "사번",
first_name || ' ' || last_name as "이름", 
salary as "급여",
email as "이메일",
phone_number as "전화번호",
department_id
from employees
where department_id is null; -- is null







