---------------------------------------------------------------
-- 부 프로그램 : 프로시저, 함수
1. 프로시저 ( PROCEDURE) - SUBROUTINE : 함수보다 더 많이 사용
    : 리턴 값이 0개 이상
    STORED PROCEDURE : 저장 프로시저
2. 함수 ( FUNCTION ) 
    : 반드시 리턴 값이 1개
    
User Define Function : 사용자가 정의한 함수
---------------------------------------------------------------


-- 107번 직원의 이름과 월급 조회
select first_name || ' ' || last_name as "이름", salary as "월급"
from employees
where employee_id = 107;

익명 블럭
-- if문 : if-then-else-end if
SET SERVEROUTPUT ON;
DECLARE 
    V_NAME VARCHAR2(46);
    V_SAL NUMBER(8, 2);
BEGIN
    V_NAME := '카리나';
    V_SAL := 10000;
    DBMS_OUTPUT.PUT_LINE(V_NAME);
    DBMS_OUTPUT.PUT_LINE(V_SAL);
    if V_SAL >= 1000 then
        DBMS_OUTPUT.PUT_LINE('Good');
    else
        DBMS_OUTPUT.PUT_LINE('Not Good');
    end if;
END;
/
파라미터는 IN_EMPID IN NUMBER 괄호와 숫자 사용하지 않는다. 
내부 변수는 V_NAME VARCHAR2(46); 반드시 괄호와 숫자가 필요한다.
저장 프로시저(IN(입력) : input, OUT(출력) : output, INOUT(입출력) : input/output)
--ORACLE로 프로시저를 생성
create procedure GET_EMPSAL (IN_EMPID IN NUMBER)
is
    V_NAME VARCHAR2(46);
    V_SAL NUMBER(8,2);
    begin
        select first_name || ' ' || last_name , salary 
        into V_NAME, V_SAL
        from employees
        where employee_id = IN_EMPID; 
        
        dbms_output.put_line('직원명: ' || V_NAME);
        dbms_output.put_line('월급: ' || V_SAL);
    end;
/

테스트
SET SERVEROUTPUT ON; --  dbms_output.put_line() 의 결과를 화면에 출력
CALL GET_EMPSAL(107);




-- 부서번호 입력, 해당부서의 최고월급자의 이름, 월급 출력
create or replace procedure GET_NAME_MAXSAL(
    IN_DEPTID IN NUMBER,
    O_NAME OUT VARCHAR2,
    O_SAL OUT NUMBER
)
is
    V_MAXSAL NUMBER(8,2);
    begin
        select max(salary)
        into V_MAXSAL
        from employees
        where department_id = IN_DEPTID;
        
        select first_name || ' ' || last_name, salary
        into O_NAME, O_SAL
        from employees
        where salary = V_MAXSAL
        and department_id = IN_DEPTID;
        
        dbms_output.put_line(O_NAME);
        dbms_output.put_line(O_SAL);
    end;
/
테스트 : 90, 60, 50 - 결과가 한줄일 때 문제 없다.
SET SERVEROUTPUT ON; --  dbms_output.put_line() 의 결과를 화면에 출력
VAR O_NAME VARCHAR2;
VAR O_SAL NUMBER;
CALL GET_NAME_MAXSAL(50, :O_NAME, :O_SAL);
PRINT O_NAME;
PRINT O_SAL;
--> JAVA에서 호출해서 사용


select d.department_id as "부서번호",
first_name || ' ' || last_name as "이름",
salary as "월급"
from departments d
join employees e
on d.department_id = e.department_id
where salary in (select max(salary) from employees);

--------------------------------------------------------------
-- 90번 부서번호 입력, 직원들 출력 : 결과가 여러 개 일 때 
--결과가 3줄인데 한번만 출력했음
-- *** select into 는 결과가 한줄일 때만 사용가능
-- 해결책) 커서 사용
-- 해결책(CURSOR)
--- 정상작동
CREATE OR REPLACE PROCEDURE GETEMPLIST(
    IN_DEPTID IN NUMBER,
    O_CUR OUT SYS_REFCURSOR
)
IS
  BEGIN
    OPEN O_CUR FOR
        SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER 
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = IN_DEPTID;
  END;
/
VARIABLE O_CUR REFCURSOR;
EXECUTE GETEMPLIST( 50, :O_CUR)
PRINT O_CUR;


select e.employee_id, d.department_id, e.first_name, e.last_name, e.salary
from employees e
join departments d
on e.department_id = d.department_id
where d.department_id = 90;

select *
from (select employee_id, first_name, last_name, email, phone_number, department_id from employees where department_id = 90)
;

