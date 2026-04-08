-- 2. if를 구현 -> oracle 기준 : DECODE() 
-- 2-1) NVL(), NVL2()
------- 사번, 이름, 월급, COMMISSION_PCT(단 값이 NULL이면 0이라고 출력)
------------- NVL(expr1, expr2) : expr1이 NULL이면 expr2 반환 ------------------
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

-- 2-2) NULLIF(expr1, expr2) : expr1과 expr2가 같으면 null, 다르면 expr1을 반환

-- 2-3)decode() : DECODE : DECODE는 데이터 값이 조건 값과 일치하면 치환 값을 출력하고 일치하지 않으면 기본값을 출력합니다. 
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
department_id as "부서번호",
salary as "급여",
decode(department_id, 60, salary*1.1, salary) as "조정된 급여", -- department_id = 60이면 급여를 10% 인상한 값을 계산하여 출력, != 원래의 급여 출력
decode(department_id, 60, '10%인상', '미인상') as "인상 여부" -- department_id = 60이면 10%인상 출력, 아니면 미인상 출력
from employees;

-- 오전/오후 한자 午前 / 午後
-- 년/월/일 시분초 年,月,日,時,分,秒
-- 일월화수목금토 日 → 月 → 火 → 水 → 木 → 金 → 土
-- 요일 曜日

select to_char(sysdate, 'AM'),
decode(to_char(sysdate, 'AM'), '오전', '午前', '午後')
from dual;

-- DECODE로 사번, 이름, 부서명
select department_id as "사번",
first_name || ' ' || last_name as "이름",
decode(department_id, 
10, 'Administration', 
20, 'Marketing',
30, 'Purchasing',
40, 'Human Resources',
50, 'Shipping',
60, 'IT',
70, 'Public Relations',
80,	'Sales',
90,	'Executive',
100,'Finance',
110, 'Accounting',
120, 'Treasury',
130, 'Corporate Tax',
140, 'Control And Credit',
150, 'Shareholder Services',
160, 'Benefits',
170, 'Manufacturing',
180, 'Construction',
190, 'Contracting',
200, 'Operations',
210, 'IT Support',
220, 'NOC',
230, 'IT Helpdesk',
240, 'Government Sales',
250, 'Retail Sales',
260, 'Recruiting',
270, 'Payroll',
'부서없음') as "부서명"
from employees;

--NULL이 계산에 포함되면 결과는 NULL
-- 직원명단, 직원의 월급, 보너스 출력 연봉 출력
select employee_id as "사번",
first_name || ' ' || last_name as "이름",
NVL2(salary, salary ,0) as "월급",
NVL2(commission_pct, commission_pct, 0) as "보너스",
decode(commission_pct, null, salary, salary * commission_pct) as "연봉"
from employees
order by salary desc;
-- 3. case 컬럼명 when 조건 then 값 end default 값
select employee_id as "사번", 
first_name || ' ' || last_name as "이름",
case department_id
when 60 then 'IT'
when 20 then 'Marketing'
when 110 then 'Accounting'
when 70  then 'Public Relations'
else     '그 외'
end as "부서명"
from employees;

---------- 변형 ------------
select employee_id as "사번", 
first_name || ' ' || last_name as "이름",
case 
when department_id = 60 then 'IT'
when department_id =  20 then 'Marketing'
when department_id =  110 then 'Accounting'
when department_id =  70  then 'Public Relations'
else     '그 외'
end as "부서명"
from employees;

-- when score between 90 and 100 then 'A' 가능
-- 조건 사용 가능 - 단 겹치면 안됌!

--- 집개 함수 : AGGREGATE 함수
-- 모든 집계함수는 NULL값을 포함하지 않는다.
-- 합계 : SUM(),평균: AVG(),최저: MIN(),최고: MAX(),줄수: COUNT(),표준편차: VARIANCE()
-- GROUP BY : 그루핑

select count(*) from employees;

select 
sum(salary), 
avg(salary), 
max(salary),
min(salary),
count(department_id), -- null 값을 뺀 값
count(employee_id) 
from employees;

select employee_id as "직원번호"
from employees
where department_id is null;

-- 전체 직원의 월급합 : 세로합( NULL 제외)
select count(salary) from employees; -- 107
select sum(salary) from employees; -- 691416
select avg(salary) from employees; -- 6461.831775700934579439252336448598130841
select max(salary) from employees; -- 24000
select min(salary) from employees; -- 2100

select sum(salary) / count(salary) from employees; -- null 값을 제외한 나머지로 sum(salary)을 나눈 값

select sum(salary) / count(*) from employees; -- null 값을 포함한 값으로 sum(salary)을 나눈 값

-- 60번 부서의 평균 월급
select avg(salary)
from employees
where department_id = 60; -- 5760
-- employees 테이블에서 부서 수
select department_id -- count() : null 값을 제외
from employees;

-- 중복을 제거한 부서의 수를 출력 count(distinct(department_id))
-- 중복을 제거한 부서번호 리스트 : null 출력함
select distinct(department_id)
from employees;
select count(distinct(department_id))
from employees;

-- 직원이 근무하는 부서의 수 : 부서장이 있는 부서수 : departments
select count(department_id) as "직원이 근무하는 부서의 수"
from departments
where manager_id is not null ;

-- round(val, n) : val 값의 지정한 자리에서 반올림
-- trunc(val, n) : val 값의 지정한 자리 버리기

-- 직원수, 월급합, 월급평균, 최대 월급 , 최소월급
select count(employee_id) as "직원수",
sum(salary) as "월급 총합",
trunc(avg(salary)) as "월급 평균",
max(salary) as "최대 월급",
min(salary) as "최소 월급"
from employees;

-- 부서 60번 부서 인원수, 월급합, 월급평균
select count(department_id) as "60번 부서 인원수",
sum(salary) as "월급합",
trunc(avg(salary)) as "월급평균"
from employees
where department_id = 60;

-- 부서 50, 60, 80번 부서가 아닌 인원수, 월급합, 월급평균
select department_id as "부서번호",
count(*) as "부서별 수",
sum(salary) as "월급합",
trunc(avg(salary)) as "월급평균"
from employees
where department_id not in(50, 60, 80)
group by department_id;

select count(*) as "부서별 수",
sum(salary) as "월급합",
trunc(avg(salary)) as "월급평균"
from employees
where department_id <> 50 and department_id <> 60 and department_id <> 80;

select department_id as "부서번호",
count(*) as "부서별 수",
sum(salary) as "월급합",
trunc(avg(salary)) as "월급평균"
from employees
where department_id not in(50, 60, 80)
group by department_id;

select count(department_id)
from employees
where department_id in (10, 20, 40, 70, 90, 100, 110);

select count(department_id)
from employees
where department_id in (50, 60, 80);

select count(department_id)
from employees;

------------------------------------------------
SQL 문의 실행 순서
1. FROM
2. WHERE
3. SELECT
4. ORDER BY
------------------------------------------------

부서별 사원수
select department_id as "부서번호",
count(*) as "부서별 사원 수"
from employees
group by department_id;

select department_id as "부서번호",
count(employee_id) as "부서별 사원 수"
from employees
group by department_id
having department_id is not null;

select department_id as "부서번호",
count(*) as "부서별 사원 수",
sum(salary) as "부서별 월급합"
from employees
group by department_id
having department_id is not null
order by department_id asc;

-- 부서별 월급합, 월급 평균
select department_id as "부서번호",
sum(salary) as "월급합",
round(avg(salary), 2) as "월급평균"
from employees
group by department_id
having department_id is not null
order by department_id;

-- 부서별 사원수 통계
select department_id as "부서번호",
department_name as "부서명",
count(*) as "부서별 사원수"
from departments
group by department_id, department_name;

-- 부서별 인원수, 월급합
select department_id as "부서번호",
count(*) as "부서별 인원수",
sum(salary)
from employees
group by department_id
order by department_id;

-- 부서별 인원수가 5명 이상인 부서번호
select department_id as "부서번호",
count(employee_id) as "부서별 인원수"
from employees
group by department_id
having count(employee_id) >= 5
order by department_id;

-- 부서별 월급 총계가 20000 이상인 부서번호
select department_id as "부서번호",
sum(salary) as "월급 총계"
from employees
group by rollup(department_id)
having sum(salary) >= 20000
order by department_id;

-- job_id 별 인원수
select job_id,
count(job_id) 
from employees
group by job_id
order by job_id;

-- job_TITLE 별 인원수
select job_id, 
decode(job_id, 
'AD_PRES', 'President',
'AD_VP', 'Administration Vice President',
'AD_ASST', 'Administration Assistant',
'FI_MGR', 'Finance Manager',
'FI_ACCOUNT', 'Accountant',
'AC_MGR', 'Accounting Manager',
'AC_ACCOUNT', 'Public Accountant',
'SA_MAN', 'Sales Manager',
'SA_REP', 'Sales Representative',
'PU_MAN', 'Purchasing Manager',
'PU_CLERK', 'Purchasing Clerk',
'ST_MAN', 'Stock Manager',
'ST_CLERK', 'Stock Clerk',
'SH_CLERK', 'Shipping Clerk',
'IT_PROG', 'Programmer',
'MK_MAN', 'Marketing Manager',
'MK_REP', 'Marketing Representative',
'HR_REP', 'Human Resources Representative',
'PR_REP', 'Public Relations Representative',
'no title'
) as "job_title",
count(job_id)
from employees
group by job_id;


select job_title, count(*)
from employees e
join jobs j
on e.job_id = j.job_id
group by job_title
order by job_title;

-- 입사일 기준 월별 인원수, 2017년 기준
select to_char(hire_date, 'MM') as "입사일",
count(employee_id) as "월별 인원수"
from employees
where to_char(hire_date, 'YYYY') = '2017'
group by to_char(hire_date, 'MM')
order by to_char(hire_date, 'MM');

select hire_date as "입사일",
to_char(hire_date, 'YYYY/MM') as "2017년 기준 월별",
count(*) as "인원수"
from employees
group by hire_date
having to_char(hire_date, 'YYYY') = '2017'
order by hire_date;

-- 부서별 최대월급이 14000 이상인 부서의 부서번호와 최대월급
select department_id as "부서번호",
max(salary) as "최대월급"
from employees
group by department_id
having max(salary) >= 14000
order by department_id;

-- 부서별 모으고 같은 부서는 직업별 인원수 , 월급 평균
select department_id as "부서번호",
job_id as "직업번호", -- job_title
decode(job_id, 
'AD_PRES', 'President',
'AD_VP', 'Administration Vice President',
'AD_ASST', 'Administration Assistant',
'FI_MGR', 'Finance Manager',
'FI_ACCOUNT', 'Accountant',
'AC_MGR', 'Accounting Manager',
'AC_ACCOUNT', 'Public Accountant',
'SA_MAN', 'Sales Manager',
'SA_REP', 'Sales Representative',
'PU_MAN', 'Purchasing Manager',
'PU_CLERK', 'Purchasing Clerk',
'ST_MAN', 'Stock Manager',
'ST_CLERK', 'Stock Clerk',
'SH_CLERK', 'Shipping Clerk',
'IT_PROG', 'Programmer',
'MK_MAN', 'Marketing Manager',
'MK_REP', 'Marketing Representative',
'HR_REP', 'Human Resources Representative',
'PR_REP', 'Public Relations Representative',
'no title'
) as "job_title",
count(job_id) as "직업별 인원수",
round(avg(salary),2) as "평균월급"
from employees
group by rollup(department_id, job_id)
order by department_id, job_id;

-- rollup(expr1, expr2) : 레벨별로 순차적 집계
-- cube(expr1, expr2, ...) : 모든 조합별로 집계한 결과를 반환


select department_id as "사번",
sum(salary) as "월급 합계",
round(avg(salary),2) as "월급 평균"
from employees
group by cube(department_id, salary);








select substr(department_name, i, n) -- department_name 컬럼의 i번째부터 n개 문자를 출력
from departments;






















------- greatest() : 매개변수로 들어오는 값들 중 가장 큰 값
------- least() : 가장 작은 값을 반환
select greatest(salary), least(salary)
from employees
where salary is not null;



