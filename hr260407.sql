SELECT * FROM  tab; -- 테이블 목록 조회
/*
select 컬럼명 alias : 별칭, as alias 
from 테이블명
where 조건
order by 정렬할 컬럼1 asc, 정렬할 컬럼2 asc; 
*/

-- 직원의 이름을 성과 이름을 붙여서 출력
select first_name || ' ' || last_name as "직원 이름",
salary as "월급"
from EMPLOYEES
where salary between 3000 and 5000
order by "직원 이름";

-- 부서번호가 60인 부서의 직원정보(번호, 이름, 이메일, 부서번호)
-- 조건 : =, != (<>, ^=)
--      > , < , >= , <= 
--      NOT, AND, OR
select employee_id as "번호", 
first_name || ' ' || last_name as "이름",
email as "이메일",
department_id as "부서번호"
from employees e
where e.department_id = 60 or e.department_id = 90
order by e.employee_id;

-- 부서번호가 90인 부서의 직원정보(번호, 이름, 이메일, 부서번호)
select employee_id as "번호", 
first_name || ' ' || last_name as "이름",
email as "이메일",
department_id as "부서번호"
from employees
where department_id = 90;
-- in 명령을 이용해서 in(a, b) -> a = 90 or b = 60
select employee_id as "번호", 
first_name || ' ' || last_name as "이름",
email as "이메일",
department_id as "부서번호"
from employees
where department_id in (90, 60);

-- 월급이 12000 이상인 직원의 번호, 이름, 이메일, 월급을 월급순으로 출력
select employee_id as "번호",
first_name || ' ' || last_name as "이름", 
email as "이메일",
salary as "월급"
from employees 
where salary >= 12000
order by salary desc;

-- 월급이 10000~15000 인 직원의 사번, 이름, 월급, 부서번호
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
salary as "월급", 
department_id as "부서번호"
from employees 
where salary between 10000 and 15000
order by salary;

-- 직업 id가 it_prog인 직원 명단(사번, 이름, 직업id, 부서번호)
-- UPPER() : 대문자로 변환, LOWER() : 소문자로 변환
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
job_id as "직업 ID",
department_id as "부서번호"
from employees
where LOWER(job_id) Like '%it_prog%';

-- where 절 서브쿼리
select *
from employees
where job_id in (select job_id from jobs where job_id Like '%ST_CLERK%' and salary >= 3000)
order by salary desc;

select employee_id as "사번",
concat(concat(first_name, ' '), last_name) as "이름",
job_id as "직업 ID",
department_id as "부서번호"
from employees
where LOWER(job_id) Like '%it_prog%';

-- 직원이름이 GRANT 인 직원을 찾으세요
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
email as "이메일"
from employees
where upper(first_name) like '%GRANT%' or upper(last_name) like '%GRANT%';

-- 사번, 월급, 10% 인상한 월급
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
salary as "월급",
salary * 1.1 as "10% 인상한 월급"
from employees
order by salary desc;

-- 50번 부서의 직원명단, 월급, 부서번호
select employee_id as 사번,
first_name || ' ' || last_name as "이름",
salary as "월급",
department_id as "부서번호"
from employees e
where department_id = 50;

-- 20, 80, 60, 90 번 부서의 직원명단, 월급, 부서번호
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
salary as "월급",
department_id as "부서번호"
from employees
where department_id in (20, 80, 60, 90)
order by employee_id;

-- 중요 데이터 추가(107명 + 2명)
-- count(*) : 해당 테이블에 모든 컬럼 줄의 자료 수 
select count(*)
from employees; -- 107 Row의 COUNT
-- dual : 한줄 출력
select sysdate
from dual; -- 오늘 날짜 : 연월일시분초 

-- 신입사원 입사(박보검, 장원영)
-- 데이터 추가
insert into employees 
values(207, '보검', '박', 'BOKUM', '1.515.8888', SYSDATE, 'IT_PROG', NULL, NULL, NULL, NULL);
insert into employees
values(208, '원영', '장', 'WONYOUNG', '1.515.555.9999', SYSDATE, 'IT_PROG', NULL, NULL, NULL, NULL);
-- update : 데이터 수정 
update employees
set PHONE_NUMBER = '1.515.555.8888'
where employee_id = 207;

update employees
set first_name = '리나', last_name = '카', email = 'KARINA'
where employee_id = 208;

select * from employees;
-- 작업 확정 대상(insert, delete, update)
commit;
-- 이전 상태 복구 
rollback;


-- 8. 보너스 없는 직원 명단(COMMISSION_PCT 가 없다)
select *
from employees
where COMMISSION_PCT is null;
-- 9. 전화번호가 010으로 시작하는
-- Pattern Matching - LIKE 
-- % : 0자 이상의 모든숫자글자
-- _ : 1자의 모든 숫자글자
select *
from employees
where phone_number like '%010_';
-- 10. LAST_NAME 세번째, 네번째 글자가 LL인 것을 찾아라
select *
from employees 
where last_name like '__ll%';

-- 날짜 26/04/07 : 표현법이 틀림 년/월
-- 2026-04-07 : ANSI 표준
-- 04/07/26 : 월/일/년 -> 미국식
-- 07/04/26 : 일/월/년 -> 영국식

alter session set NLS_DATE_FORMAT= 'YYYY-MM-DD HH24:MI:SS';

select sysdate from dual;
select 7/2 from dual;
select 0/2 from dual;
--select 2/0 from dual; ORA-01476 : 제수(분모)가 0입니다
select systimestamp from dual;
/*
SYSDATE - 7 : 일주일 전 날짜
SYSDATE  : 오늘 날짜
SYSDATE + 7 : 일주일 후 날짜
날짜 + n, - n : 몇일 전/후
날짜1 - 날짜2 : 두 날짜 사이의 차이를 날 수로 나옴
날짜1 + 날짜2 : 오류
날짜 casting 함수
to_date, to_char, 
*/
-- 크리스마스에서 오늘 날짜의 차이 
select to_date('26/12/25') - sysdate
from dual;
-- round : 소수 이하 3자리로 반올림 - ROUND(value, 3) 
-- trunc : 소수 이하 3자리로 잘라서 버림 - TRUNC(value, 3)
-- 15일 기준으로 반올림 날짜 : ROUND(날짜, 'month')
-- 해당 달의 첫번째 날짜 : TRUNC(날짜, 'month')
select sysdate, round(sysdate, 'month'), trunc(sysdate, 'month')
from dual;

select next_day(sysdate, '월요일') from dual; -- 다음 월요일이 언제인지
select last_day(sysdate) from dual; -- 해당 달의 마지막 날짜
select trunc(sysdate, 'month') from dual; -- 해당 달의 첫번째 날짜
-- 11. 입사년월이 17년 2월인 사원출력
select *
from employees
where hire_date between '2017-02-01' and last_day('2017-02-01');

alter session set NLS_DATE_FORMAT= 'YYYY-MM-DD HH24:MI:SS';
-- 12. '17/02/07'에 입사한 사람 출력
--     '12/06/07' 에 입사한 사람 출력
select *
from employees
where hire_date between '2017-02-06' and '2017-02-07';

select *
from employees 
where to_char(hire_date, 'YY/MM/DD') = '17/02/07';

select * 
from employees
where to_char(hire_date, 'YY/MM/DD') = '12/06/07';
-- LIKE 로 '17/02/07'에 입사한 사람 출력
--     '12/06/07' 에 입사한 사람 출력
-- 되도록 like는 문자열에만
select *
from employees
where hire_date like '%17-02-07%';
-- LIKE 로 '17/02/07'에 입사한 사람 출력
--     '12/06/07' 에 입사한 사람 출력
select *
from employees 
where hire_date like '%12-06-07%';

select *
from employees
--where hire_date between '2012-06-06' and '2012-06-07';
where trunc(hire_date) = '2026-04-07 00:00:00';

-- type 변환
-- TO_DATE(문자) -> 날짜
-- TO_NUMBER(문자) -> 숫자
-- TO_CHAR(숫자, '포맷') -> 글자
-- TO_CHAR( 날짜, '포맷') -> 날짜 형태의 문자
-- 포맷 : YYYY-MM-DD HH24:MI:SS DAY AM
/*
YYYY : 연도
MM : 월
DD : 날짜 
HH24 : 시 24시 기준
MI : 분:
SS : 초 DAY : 요일, DY : 일 
AM : 오전/오후
dual : 연산을 수행할 수 있는 임시 공간
*/
alter session set NLS_DATE_FORMAT= 'YYYY-MM-DD HH24:MI:SS';
select *
from employees
where to_char(hire_date, 'YYYY/MM') = '2017/02';

-- 13. 오늘 '26/04/07'에 입사한 사람 출력
select *
from employees
--where trunc(hire_date) = trunc(sysdate);
where '2026-04-07 00:00:00' <= hire_date and hire_date < '2026-04-07 23:59:59';
--
-- 14 입사 후 일주일 이내인 직원 명단
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
hire_date as "입사 후 일주일 이내"
from employees
where hire_date >= sysdate - 7;
-- where hire_date <= hire_date + 7;


-- 15. 화요일 입사자를 출력
select concat(concat(first_name, ''), last_name), hire_date, to_char(hire_date, 'DY') as "화요일 입사자"
from employees
where to_char(hire_date, 'DY') = '화'
order by hire_date asc;


alter session set NLS_DATE_FORMAT= 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT= 'YYYY"年"-MM"月"-DD"日" HH24"時"MI"分"SS"秒" AM DAY';


-- 16. 08월 입사자의 사번, 이름, 입사일을 입사일 순으로 
-- select절에서 to_char은 모양을 바꾸는 것
-- where절에선 to_char은 원하는 결과 값을 출력하고 싶을 때 사용하는 것
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
to_char(hire_date, 'YY-MM-DD') as "입사일"
from employees
where to_char(hire_date, 'MM') = '08'
order by hire_date asc;


-- 부서번호 80이 아닌 직원
select *
from employees
--where department_id <> 80;
where department_id != 80 or department_id is null;


-- 2025년 07월 09일 10시 05분 04초 오전 수요일
select hire_date
from employees
where to_char(hire_date, 'YYYY年-MM月-DD日 HH24時 MI分 SS秒 AM DAY') = '2025-07-09-10:05:04 오전 수요일';
-- 한자로 출력

select sysdate, to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS AM DAY'),
to_char(sysdate, 'AM')
from dual;

-- 오전/오후 한자 午前 / 午後
-- 년/월/일 시분초 年,月,日,時,分,秒
-- 일월화수목금토 日 → 月 → 火 → 水 → 木 → 金 → 土
-- 요일 曜日
-- 1. to_char() 활용
select sysdate, to_char(sysdate, 'YYYY"年"MM"月"DD"日" HH24"時"MI"分"SS"秒" AM DAY') as "날짜1",
to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS AM DAY') as "날짜2",
to_char(sysdate, 'AM')
from dual;
-- 2. if를 구현 -> oracle 기준 : DECODE() 
-- 2-1) NVL(), NVL2()
------- 사번, 이름, 월급, COMMISSION_PCT(단 값이 NULL이면 0이라고 출력)
------------- NVL ------------------
select employee_id as "사번", 
first_name || ' ' || last_name as "이름",
salary as "월급",
NVL(COMMISSION_PCT, 0) as "보너스"
from employees;
------------- NVL2(expr1, expr2, expr3) : expr1이 null이면 expr3 반환, null이 아니면 expr2 반환 -----------------
select employee_id as "사번", 
first_name || ' ' || last_name as "이름",
salary as "월급",
NVL2(commission_pct, salary + (salary * commission_pct),salary) as "보너스"
from employees;

-- 2-2) NULLIF()

-- 2-3)decode()
-- 3. case when-then end

---------------------------------------------------------------------------------------------------
-- 앞으로 날짜 표현은 다음과 같이 표현하지 

select employee_id, hire_date
from employees
where to_char(hire_date, 'YYYY-MM-DD') = '2015-09-21';

select employee_id as "사번", hire_date as "입사일"
from employees
where to_char(hire_date, 'YYYY-MM') = '2026-04';












