select * from tab;
----------------------------------------------------------------------
SUBQUERY : SQL 문안에 SQL문을 넣어서 실행한 방법
         : 반드시 () 안에 있어야 한다
         : () 안에는 ORDER BY 사용불가
         : WHERE 조건에 맞도록 작성
----------------------------------------------------------------------
-- IT 부서의 직원정보를 출력하시오
--1) IT 부서의 부서번호를 찾는다 = 60
select department_id
from departments
where department_name = 'IT';
--2) 60번 부서의 직원정보를 출력 
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
department_id as "부서번호"
from employees
where department_id = 60;

-- 1) + 2) SUBQUERY
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
department_id as "부서번호"
from employees
where department_id = (
    select department_id 
    from departments
    where department_name = 'IT'
);
-- JOIN 
select e.department_id as "부서번호",
e.first_name || ' ' || last_name as "이름",
d.department_name as "부서명"
from employees e
join departments d
on e.department_id = d.department_id
where d.department_name LIKE 'IT';




-- 평균월급보다 많은 월급을 받는 사람의 명단
--1) 평균월급 -- 6461.831775700934579439252336448598130841
select avg(salary)
from employees;

--2) 월급이 6461.831775700934579439252336448598130841 보다 많은 직원
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
salary as "평균월급보다 많은 월급" 
from employees
where salary > (select avg(salary) from employees);

-- IT 부서의 평균월급보다 많은 월급을 받는 사람의 명단
select  employee_id, first_name || ' ' || last_name, salary
from employees
where  salary > (select avg(salary) from employees where department_id = (select department_id from departments where department_name = 'IT'));

-- 50번 부서의 최고 월급자의 이름을 출력
select *
from employees
where salary = (select max(salary) from employees where department_id = (select department_id from departments where department_id = 50)) and department_id = 50;

-- SALES 부서의 평균월급보다 많은 월급을 받는 사람의 명단
select *
from employees
where salary > (select avg(salary) from employees where department_id = (select department_id from departments where department_name = 'Sales')) and department_id = 80;


-- 다중행 서브쿼리
select *
from employees e
where (e.job_id, e.salary) in (select job_id, min(salary) as "그룹별 급여" from employees group by job_id)
order by e.salary desc;
-- 상관 서브 쿼리
-- job_history에 있는 부서번호와 departments에 있는 부서번호가 같은 부서를 찾아서, 사원명과 부서명을 가져오려고 서브 쿼리는 select 절에서 사용
select a.department_id, a.department_name
from departments a 
where exists (select 1 from job_history b where a.department_id = b.department_id);

-- SHIPPING 부서의 명단
select employee_id, first_name, last_name
from employees
where department_id = (select department_id from departments where UPPER(department_name) = 'SHIPPING');

-- 카티션프로덕트 : 109 * 27 = 2943 -> CROSS JOIN
-- 직원이름, 부서명
-- JOIN
select e.first_name || ' ' || last_name as "직원이름",
d.department_name as "부서명"
from departments d
join employees e
on d.department_id = e.department_id;

--OUTER JOIN
select e.first_name || ' ' || last_name as "직원이름",
d.department_name as "부서명"
from departments d
full outer join employees e
on d.department_id = e.department_id;

-- LEFT JOIN
select e.first_name || ' ' || e.last_name as "직원이름",
d.department_name as "부서명"
from employees e
left outer join departments d
on e.department_id = d.department_id;
-- RIGHT JOIN
select e.first_name || ' ' || e.last_name as "직원이름",
d.department_name as "부서명"
from employees e
right outer join departments d
on e.department_id = d.department_id;

-- 3) 모든 직원을 출력해라
-- 부서번호가 null

select e.first_name || ' ' || e.last_name as "직원이름",
d.department_name as "부서명"
from employees e
left outer join departments d
on d.manager_id = e.manager_id;

select e.first_name || ' ' || e.last_name as "직원이름",
d.department_name as "부서명"
from employees e
full outer join departments d
on d.manager_id = e.manager_id
where d.manager_id is not null;

-- full outer join - OLD문법에 존재하지 않는 명령
-------------------------------------------------
--표준 SQL 문법
--1. CROSS JOIN
select j.job_id, j.job_title
from employees e
join jobs j
on e.job_id = j.job_id;

--2. INNER JOIN

--3. OUTER JOIN
---1 LEFT OUTER JOIN
select e.first_name, e.last_name, d.department_name
from employees e
left join departments d
on e.department_id = d.department_id;
---2 RIGHT OUTER JOIN
select e.first_name, e.last_name, d.department_name
from employees e
right join departments d
on e.department_id = d.department_id;
---3 FULL OUTER JOIN
select e.first_name || ' ' || e.last_name as "이름", d.department_name as "부서명"
from employees e
full join departments d
on e.department_id = d.department_id
where e.department_id = (select department_id from job_history where job_id = 'IT_PROG') and e.department_id = 60;

-- 직원이름, 담당업무(job_title)
select e.first_name || ' ' || e.last_name as "직원이름",
j.job_title as "담당업무"
from employees e
left join jobs j
on e.job_id = j.job_id;

-- 부서명, 부서위치(CITY, STREE_ADDRESS)
select d.department_name as "부서명",
l.city || ' ' || l.street_address as "부서위치"
from departments d
join locations l
on d.location_id = l.location_id;

-- 직원명, 부서명, 부서위치(CITY, STREE_ADDRESS)
select e.first_name || ' ' || e.last_name as "직원명",
d.department_name as "부서명",
l.city || ' ' || l.street_address as "부서위치"
from departments d
join employees e
on d.department_id = e.department_id
join locations l
on d.location_id = l.location_id
order by e.first_name || ' ' || e.last_name;
-- outer join + outer join
-- 직원명, 부서명, 국가, 부서위치(CITY, STREE_ADDRESS)
select e.first_name || ' ' || e.last_name as "직원명",
d.department_name as "부서명",
l.country_id as "국가",
l.city || ' ' || l.street_address as "부서위치"
from departments d
join employees e
on d.department_id = e.department_id
join locations l
on d.location_id = l.location_id;

select e.first_name || ' ' || e.last_name as "직원명",
d.department_name as "부서명",
c.country_id as "국가",
l.city || ' ' || l.street_address as "부서위치"
from employees e
join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
join countries c
on l.country_id = c.country_id;

-- 부서명, 국가 : 모든 부서 : 27줄이상
select d.department_name as "부서명",
l.country_id as "국가"
from departments d
full join locations l
on d.location_id = l.location_id
full join countries c
on l.country_id = c.country_id;

-- 직원명, 부서위치 단 it 부서만
select e.department_id as "부서번호",
e.first_name || ' ' || e.last_name as "직원명", 
d.department_name as "부서명",
l.CITY || ' ' || l.street_address as "부서위치"
from departments d
join employees e
on d.department_id = e.department_id -- 첫번째 join
join locations l
on d.location_id = l.location_id -- 두번째 join
where d.location_id = (select location_id from departments where department_name = 'IT') and d.location_id = 1400; -- 서브쿼리

-- SELF JOIN
select e1.first_name || ' ' || e1.last_name as "이름",
e1.employee_id as "사번",
e1.department_id as "부서번호",
e2.manager_id as "매니저번호"
from employees e1, employees e2
where e1.employee_id = e2.manager_id;

-- 127번의 직원의 상사 번호를 구한 후에 부서명을 구해라
select e.employee_id as "사번",
first_name || ' ' || last_name as "이름",
d.manager_id as "상사번호",
d.department_name as "부서명"
from employees e
join departments d
on e.department_id = d.department_id
where e.manager_id = (select manager_id from employees where employee_id = 127);

-- 60번 부서의 최소월급과 같은 월급자의 명단출력
select min(salary)
from employees
where department_id = 60;
select *
from employees
where salary = (select min(salary) from employees where department_id = 60) and department_id = 60;

-- 부서명별 월급평균
select d.department_name as "부서명",
round(avg(salary), 2) as "월급평균"
from departments d
join employees e
on d.department_id = e.department_id
group by d.department_name;

-- 3) 모든 부서, 평균월급이 NULL -> 없음
select d.department_name as "부서명",
decode(avg(salary), null, '없음', round(avg(salary),2)) as "평균월급"
from departments d
left join employees e
on d.department_id = e.department_id
group by d.department_name;

-- 직원의 근무연수
-- trunc(hire_date, 'MONTH') : 입사월의 첫번째 날
-- last_day(hire_date) : 입사월의 마지막 날
-- trunc((sysdate - hire_date) / 365.2422) as "근무연수",

select first_name || ' ' || last_name as "직원명",
to_char(hire_date, 'YYYY-MM-DD') as "입사일",
to_char(trunc(hire_date, 'MONTH'), 'YYYY-MM-DD') as "입사월의 첫번째 날", 
to_char(last_day(hire_date), 'YYYY-MM-DD') as "입사월의 마지막 날", 
trunc(sysdate - hire_date) as "근무일 수",
trunc(months_between(sysdate , hire_date) / 12) as "근무연수" 
from employees; 

-- 부서명, 부서장의 이름
select department_name as "부서명",
e.first_name || ' ' || e.last_name as "부서장의 이름"
from departments d
join employees e
on d.department_id = e.department_id
where e.manager_id = d.manager_id;

-- 직원정보, 담당업무(job_title)
select e.first_name || ' ' || e.last_name as "직원명",
j.job_id as "담당번호",
j.job_title as "담당업무"
from employees e
join jobs j
on e.job_id = j.job_id;

-- 사번, 업무시작일, 업무종료일, 담당업무, 부서번호
select e.employee_id, to_char(start_date, 'YYYY"년" MM"월" DD"일"') as "업무시작일",
to_char(end_date, 'YYYY"년" MM"월" DD"일"') as "업무종료일", job_title as "담당업무",
d.department_id as "부서번호"
from employees e
join departments d
on e.department_id = d.department_id
join job_history h
on e.employee_id = h.employee_id
join jobs j
on e.job_id = j.job_id
order by e.employee_id;

select employee_id as "사번",
first_name || ' ' || last_name as "직원명"
from employees 
union
select department_id as "부서번호"
from departments 
union
select job_title as "담당업무"
from jobs 
union
select to_char(start_date, 'YYYY"년" MM"월" DD"일"') as "업무시작일",
to_char(end_date, 'YYYY"년" MM"월" DD"일"') as "업무종료일"
from job_history;

-------------------------------------------------
결합 연산자 : 줄 단위 결합
조건 : 두 테이블의 칸수와 타입이 동일해야함
1) UNION : 중복 제거
2) UNION ALL : 중복도 포함
3) INTERSECT : 교집합 : 공통
4) MINUS : 차집합 : a - b
-- 칼럼 수와 칼럼들의 TYPE이 같으면 합쳐진다 -> 주의할 것
select * from employees where department_id = 80
union all
select * from employees where department_id = 50;

select * from employees where department_id = 80
union
select * from employees where department_id = 50;

-- INTERSECT : 합집합 : 모든 데이터 합치는 것
select job_id
from employees
where department_id = 100
intersect
select job_id
from employees
where department_id = 100;

-- MINUS : 차집합 : 공통 부분이 없는 것
select *
from employees
where department_id = 80
minus
select *
from employees
where department_id = 90;











