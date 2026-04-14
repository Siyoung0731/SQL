-----------------------------------------------------------------
DDL : Data Definition Language
- 구조를 생성(CREATE), 변경(ALTER), 제거(DROP)

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


[1] 테이블 생성 CREATE
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
        
select * from tab;

----------------------------------------------------------------
2. SQL DEVELOPER 메뉴에서 TABLE 생성
    SKY 계정
        테이블 메뉴 클릭 -> 새 테이블 클릭 -> TABLE1 생성 : EMP6

          EMPID NUMBER(8,2) NOT NULL PRIMARY KEY
        , ENAME VARCHAR2(46) NOT NULL
        , TEL VARCHAR2(20) 
        , EMAIL VARCHAR2(320)
    
3. SCRIPT 로 생성
CREATE TABLE EMP7
(
  EMPID NUMBER(8,2) NOT NULL 
, ENAME VARCHAR2(46) NOT NULL
, TEL VARCHAR2(20)  
, EMAIL VARCHAR2(320)
, CONSTRAINT EMP7_PK PRIMARY KEY 
  (
    EMPID 
  )
  ENABLE 
);

[2] 테이블 제거 - 영구적으로 구조/데이터 제거 (DROP)

    DROP TABLE EMP1; 
    -- DROP 되는 테이블이 부모 테이블일 경우 자식을 먼저 지워야 제거가 가능하다.(중요!)
    
    DROP TABLE EMPLOYEES CASCADE; -- 부모 자식 관계의 데이터를 전체 삭제
     
[3] 구조 변경(ALTER) 
    1. 칼럼 추가
    ALTER TABLE EMP5
    ADD(LOC  VARCHAR2(6)); -- 추가된 칼럼은 NULL 로 채워짐
    
    2. 칼럼 제거
    ALTER TABLE EMP5
    DROP COLUMN LOC;
    
    3. 테이블 이름 변경 - ORACLE 전용 명령
    RENAME EMP4 TO NEWEMP;
    
    4. 칼럼 속성 변경 -- 크기를 늘려주거나 줄인다
    ALTER TABLE EMP5 
    MODIFY (ENAME VARCHAR2(60)); -- 46 -> 60
    줄일 때 데이터의 내용이 있으면 내용이 잘려나갈 수 있다.
    
-----------------------------------------------------------------------
테이블을 생성하고 데이터를 파일에서 가져온다.
CREATE TABLE ZIPCODE
(
    ZIPCODE VARCHAR2(7)             --우편번호
    ,SIDO VARCHAR2(6)               --시도
    ,GUGUN VARCHAR2(26)             -- 구군 
    ,DONG VARCHAR2(78)              --읍면동리건물명
    ,BUNJI VARCHAR2(26)             --번지
    ,SEQ NUMBER(5)  PRIMARY KEY     --일련번호
);

테이블 생성 후 ZIPCODE 테이블 선택하고 
-> 오른쪽 마우스 버튼으로 -> 데이터 임포트 클릭 -> ZIPCODE_UTF8.CSV 선택

SELECT COUNT(*) FROM ZIPCODE;

SELECT * FROM ZIPCODE WHERE SIDO = '부산';

-- 시도별 우편번호 갯수
SELECT SIDO 시도, COUNT(ZIPCODE) 우편번호갯수
FROM ZIPCODE
GROUP BY SIDO;

SELECT COUNT(ZIPCODE) 우편번호갯수,
COUNT(DISTINCT(ZIPCODE))
FROM ZIPCODE;

SELECT DONG, ZIPCODE
FROM ZIPCODE
WHERE DONG LIKE '%부전2동%';

SELECT '[' || ZIPCODE || ']' ||
SIDO || ' ' ||
GUGUN || ' ' ||
DONG || ' ' ||
BUNJI || ' ' AS ADDRESS
FROM ZIPCODE
WHERE DONG LIKE '%부전2동%'
ORDER BY SEQ ASC;



    















