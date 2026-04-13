-----------------------------------------------------------------
DDL : Data Definition Language
- 구조를 생성, 변경, 제거

CREATE
ALTER
DROP

계정 생성
 아이디 : SKY
 비밀번호 : 1234
CMD sqlplus /nolog
Microsoft Windows [Version 10.0.19045.6218]
(c) Microsoft Corporation. All rights reserved.
Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0에서 분리되었습니다.

C:\Users\GGG>sqlplus /nolog

SQL*Plus: Release 21.0.0.0.0 - Production on 월 4월 13 14:06:15 2026
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SQL> conn /as sysdba
연결되었습니다.
SQL> show user
USER은 "SYS"입니다
SQL> ALTER SESSION SET "_ORACLE_SCRIPT"=true;

세션이 변경되었습니다.

SQL> CREATE USER SKY IDENTIFIED BY 1234;

사용자가 생성되었습니다.

SQL> GRANT CONNECT, RESOURCE TO SKY;

권한이 부여되었습니다.

SQL> ALTER USER SKY DEFAULT TABLESPACE
  2  USERS QUOTA UNLIMITED ON USERS;

사용자가 변경되었습니다.

SQL> conn sky/1234
연결되었습니다.
SQL> show user
USER은 "SKY"입니다

----------------------------------------------------------------
새 계정으로 접속한 뒤에 작업
window + r - cmd 
sky에서 hr 계정을 data 를 가져온다
sqlplus 에서 작업
1. 먼저 hr 로그인
sqlplus hr/1234
2. hr 에서 다른 계정인 sky 에게 select 할 수 있는 권한을 부여
SQL> GRANT SELECT ON EMPLOYEES TO SKY;
권한이 부여되었습니다.
3. sky 로그인 
SQL> conn sky/1234
연결되었습니다.
SQL> select * from hr.employees;
4. sky 에서 hr 계정의 employees 를 조회
select * from hr.employees; -- 조회 성공
select * from hr.departments; -- 조회 실패

ORACLE 의 table 복사하기
hr 의 employees table을 복사해서 sky 로 가져온다


[1] 테이블 생성 create
    1. 테이블 복사 
    - 대상 : 테이블 구조, 데이터 (제약 조건의 일부만 복사(NOT NULL))
    
    1) 구조, 데이터 전체 복사, 제약 조건을 일부만 복사
    CREATE TABLE EMP1 
    AS
        SELECT * FROM HR.EMPLOYEES;

    2) 구조, 데이터 전체 복사, 50번과 80번 부서만 복사 -- 79건
    CREATE TABLE EMP2 
    AS
        SELECT * FROM HR.EMPLOYEES where department_id in (50, 80);

    3) DATA 빼고 구조만 복사
    create table EMP3
    AS 
        select * from hr.employees 
        where 1 = 0;
    
    4) 구조만 복사된 TABLE EMP3 에 DATA 만 추가
    create table EMP4
    AS
        select * from hr.employees
        where 1 = 0;
        
    insert into EMP4
        select * from hr.employees;
    commit;
    
    5) 일부 칼럼만 복사해서 새로운 테이블 생성
    create table EMP5 
    AS 
        SELECT EMPLOYEE_ID EMPID,
        FIRST_NAME || ' ' || LAST_NAME ENAME,
        SALARY SAL,
        SALARY * COMMISSION_PCT BONUS,
        MANAGER_ID MGR,
        DEPARTMENT_ID DPTID
        FROM HR.EMPLOYEES;
    



















