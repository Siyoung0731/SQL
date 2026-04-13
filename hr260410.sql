---------------------------------------------------------
-- 숫자 
1. ABS() : 절대값
select round(abs(-12.123), 2)
from dual;
2. CEIL(n) 과 FLOOR(n) -> 정수형
CEIL : 무조건 올림
select ceil(12.3466756) from dual;
FLOOR(n) : 버림
select floor(123.1232131) from dual;
3. POWER(n1, n2) : n2를 n1 제곱한 결과 반환
SQRT(n) : n의 제곱근 반환
select sqrt(power(4,4)) from dual;
INITCAP(char)
select initcap('never say goodbye'), initcap('never6say*good가bye') from dual;

select ltrim('ABCDEFGABC', 'ABC') from dual;
---------------------------------------------------------

create table ex4_1 (
    phone_num VARCHAR2(30)
);

insert into ex4_1 values('111-1111');
insert into ex4_1 values('111-2222');
insert into ex4_1 values('111-3333');

select * from ex4_1;

select lpad(phone_num, 12, '(02)')
from ex4_1;

select rpad(phone_num, 12, '(02)')
from ex4_1;

select to_char(123456789, '999,999,999'),
to_char(1234567, '99, 999, 999'),
to_char(123.45678, '00,000,000'),
to_char(123456789, '$999,999,999'),
to_char(123456789, 'L999,999,999')
from dual;

select greatest(1, 2, 3, 2), least(1, 2, 3, 2) from dual;
SELECT GREATEST('이순신', '강감찬', '세종대왕'), LEAST('이순신', '강감찬', '세종대왕')
FROM DUAL;
--------------------------------------------------------------------------------------

-- 직원이름, 담당업무(job_title)
select e.first_name || ' ' || e.last_name as "직원이름",
j.job_title as "담당업무"
from employees e
left join jobs j
on e.job_id = j.job_id;

-- 직원정보, 담당업무(job_title)
select e.first_name || ' ' || e.last_name as "직원명",
j.job_id as "담당번호",
j.job_title as "담당업무"
from employees e
join jobs j
on e.job_id = j.job_id;

select employee_id, job_id
from employees
union
select employee_id, job_id
from job_history;

select *
from (
    select employee_id, job_id
    from employees
    union
    select employee_id, job_id
    from job_history
) -- inline view : order by를 사용 가능, from 뒤에 사용
order by employee_id asc;

-- 사번, 업무시작일, 업무종료일, 담당업무, 부서번호
-- JOIN
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
-- UNION
select *
from(
select employee_id as "사번",
to_char(hire_date, 'YYYY-MM-DD') as "업무시작일",
'재직중' as "업무종료일",
job_id as "담당업무",
department_id as "부서번호"
from employees 
union 
select employee_id as "사번",
to_char(start_date, 'YYYY-MM-DD') as "업무시작일",
to_char(end_date, 'YYYY-MM-DD') as "업무종료일",
job_id as "담당업무",
department_id as "부서번호"
from job_history 
) T
order by t.사번;

----------------------------------------------------------
VIEW : 뷰 -- SQL문을 저장해놓고 TABLE처럼 호출해서 사용하는 객체

1) INLINE VIEW -> select 할 때만 VIEW 로 작동 : 임시 존재
    select a.employee_id, a.first_name || ' ' || a.last_name, a.department_id,
    b.department_name
    from employees a,
    departments b
    where a.department_id = b.department_id;
    -- VIEW or FROM절 서브쿼리
    select *
    from ( select employee_id as "사번", 
                first_name || ' ' || last_name as "이름",
                email || '@green.com' as "이메일",
                phone_number as "전화번호"
                from employees
                order by 이름
        ) T
    where T.사번 in (100, 101, 102);
-- FROM 절 서브쿼리나 INLINE VIEW 는 되도록 as 사용 X 
    select *
    from (
        select department_id DEPT_ID,
        sum(salary) SUM_SAL,
        round(avg(salary), 2) AVG_SAL,
        count(salary) CNT_SAL
        from employees
        group by department_id
        order by department_id
        ) emp
    where emp.AVG_SAL >= 4000;
        
        
        
2) 일반적인 VIEW -> 영구저장된 객체
VIEW 생성 - 영구 보관
create view "HR"."VIEW_EMP" ("사번", "이름", "이메일", "전화번호")
as 
                select employee_id as "사번", 
                first_name || ' ' || last_name as "이름",
                email || '@green.com' as "이메일",
                phone_number as "전화번호"
                from employees
                order by 이름;

select *
from view_emp
where 이름 LIKE '%King%';
-------------------------------------------------
2) WITH -- 가상의 테이블 생성
with A("사번", "이름", "이메일", "전화번호") as (
        select employee_id as "사번", 
        first_name || ' ' || last_name as "이름",
        email || '@green.com' as "이메일",
        phone_number as "전화번호"
        from employees
        order by 이름
)
select * from a;

SELF JOIN 
-- 직원번호, 직속상사번호
select employee_id as "직원번호", manager_id as "직속상사번호"
from employees
order by 직속상사번호;

-- 직원이름, 직속상사이름
select e2.first_name || ' ' || e2.last_name as "직원이름",
e1.first_name || ' ' || e1.last_name as "직속상사이름"
from employees e1
right join employees e2
on e1.employee_id = e2.manager_id
order by e1.employee_id asc; -- 모든 직원정보 

-- 계층형 쿼리, CASCADING
계층형 쿼리 : HIRERACHY 

select employee_id as "직원번호",
first_name || ' ' || last_name as "직원명",
level, 
lpad(' ', 3*(level-1)) || department_name as "부서명"
from employees e
join departments d
on e.department_id = d.department_id
start with e.manager_id is null
connect by prior e.employee_id = e.manager_id
order siblings by d.department_name;

EQUI JOIN, 등가조인 : 조인 조건이 = 인 것들

NON-EQUI JOIN, 비등가 조인 : 조인 조건이 != 인 것들

-- 등급 테이블 생성
drop table SALGRADE;
create table SALGRADE
(
    GRADE VARCHAR2(1)   PRIMARY KEY
    ,LOSAL NUMBER(11)   
    ,HIGHSAL NUMBER(11)
)
insert into SALGRADE values( 'S', 20001, 99999999999);
insert into SALGRADE values( 'A', 15001, 20000);
insert into SALGRADE values( 'B', 10001, 15000);
insert into SALGRADE values( 'C', 5001, 10000);
insert into SALGRADE values( 'D', 3001, 5000);
insert into SALGRADE values( 'E', 0, 3000);
commit;

-- 비 등가 조인
select e.employee_id as "직원번호",
e.first_name || ' ' || last_name as "직원명",
e.salary as "월급",
nvl(s.grade, '등급없음') as "등급" 
from employees e 
left join SALGRADE s
on e.salary between s.losal and s.highsal
order by e.salary desc;

select employee_id as "직원번호",
first_name || ' ' || last_name as "직원명",
salary as "월급",
case 
when salary > 20000 then 'S'
when salary between 15001 and 20000 then 'A'
when salary between 10001 and 15000 then 'B'
when salary between 5001 and 10000 then 'C'
when salary between 3001 and 5000 then 'D'
when salary between 0 and 3000 then 'E'
else '없음'
end as "등급"
from employees
order by employee_id;

---------------------------------------------------------
-- 분석함수와 WINDOW 함수
1. ROW_NUMBER() : 줄 번호
2. RANK() : 석차
3. DENSE_RANK() : 석차
4. NTILE() : 그룹으로 분류
5. LIST_AGG()

select employee_id, 
salary 월급,
RANK() over(order by salary desc) RANK_급여,
DENSE_RANK() over(order by salary desc) DENSE_RANK_급여,
ROW_NUMBER() over(order by salary desc) ROW_NUMBER_급여
from employees
order by salary nulls last;

-- 자료 10개만 출력 -- 페이징 기술
1) OLD 문법 : ROWNUM -- 의사(psuedo) 칼럼
select rownum, employee_id, first_name, last_name, salary
from employees
where rownum between 1 and 10
order by salary desc nulls last;

rownum, from절 서브쿼리
select rownum, employee_id, first_name, last_name, salary
from (
    select employee_id, first_name, last_name, salary
    from employees
    order by salary desc nulls last
) T
;

2) NEW ANSI 문법 : ROW_NUMBER() - 페이징 기법
-- ROW_NUMBER() 와 FROM절 인라인 뷰를 사용해서 자료 10개 출력
select * 
from (
select row_number() over(order by salary desc nulls last) rn,
e.employee_id, 
e.first_name, 
e.last_name, 
e.salary,
s.grade,
RANK() over(order by salary desc) rk
from employees e
join salgrade s
on e.salary between s.losal and s.highsal
) T
where t.rn between 1 and 10;
--> 
/*
select *
from T
where t.rn between 1 and 10;
*/

oracle 12C 부터는 OFFSET 
select *
from employees
order by salary desc nulls last
offset 11 rows fetch next 10 rows only;
-- 11부터 10개 : ROW_NUMBER 보다 속도가 빠르다.

-------------------------------------------------------------
2) RANK() : 석차
DENSE_RANK() : 석차

-- 월급순으로 석차 출력
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
salary as "월급",
rank() over(order by salary desc) as "석차"
from employees;

-- 월급순으로 석차 출력 10등까지
select *
from (
    select e.employee_id as "사번",
    e.first_name || ' ' || last_name as "이름",
    e.salary as "월급",
    s.grade as "등급",
    dense_rank() over(order by salary desc nulls last) 석차
    from employees e
    join SALGRADE s
    on e.salary between s.losal and s.highsal
) T
where t.석차 between 1 and 10;
-------------------------------------------------
LISTAGG() 여러줄을 한줄짜리 문자열로 변경

select department_id
from employees;

select listagg(distinct department_id , ',')
from employees;

select listagg(distinct department_id , ',')
within group(order by department_id asc)
from employees;
------------------------------------------------------------
날짜함수
-- ADD_MONTHS(date, n) : date의 정수형 n 만큼의 월을 더한 날짜 
SELECT
    add_months(sysdate, 1),
    add_months(sysdate, -1)
FROM
    dual;
-- MONTHS_BETWEEN(d1, d2) : 두 날짜 사이의 개월 수 반환
SELECT
    months_between(sysdate,
                   add_months(sysdate, -1)) mon1,
    months_between(sysdate,
                   add_months(sysdate, 1))  mon2
FROM
    dual;
-- LAST_DAY(date) : 해당 월의 마지막 일자 반환
SELECT
    last_day(sysdate)
FROM
    dual;

select * 
from (
select row_number() over(order by salary desc nulls last) rn,
e.employee_id, 
e.first_name, 
e.last_name, 
e.salary,
s.grade,
RANK() over(order by salary desc) rk
from employees e
join salgrade s
on e.salary between s.losal and s.highsal
) T
where t.rn between 1 and 10;
    
select * 
from ( select e.employee_id 사번,
       concat(concat(first_name, ' '), last_name) 이름,
       e.salary 월급,
       s.grade 등급,
       rank() over(order by salary desc nulls last) rk
       from employees e
       join salgrade s
       on e.salary between s.losal and s.highsal
       ) T
where t.rk between 1 and 10;
       
select * 
from (
select row_number() over(order by salary desc nulls last) rn,
e.employee_id, 
e.first_name, 
e.last_name, 
e.salary,
s.grade,
RANK() over(order by salary desc) rk
from employees e
join salgrade s
on e.salary between s.losal and s.highsal
) T
where t.rn between 1 and 10;

select *
from ( 
select row_number() over(order by salary desc nulls last) rn,
e.employee_id 사번,
concat(concat(first_name, ' '), last_name) 직원명,
e.salary 월급, 
s.grade 등급,
rank() over(order by salary desc) rk
from employees e
join salgrade s
on e.salary between s.losal and s.highsal
) T
where t.rk between 1 and 10;



