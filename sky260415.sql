시퀀스 : SEQUENCE : 번호 자동 증가
-- 번호칼럼에 자동으로 번호를 증가
CREATE TABLE TABLE1 (
    ID NUMBER(6) PRIMARY KEY,
    TITLE VARCHAR2(400),
    MEMO VARCHAR2(4000)
);

--INSERT INTO TABLE1 VALUES(1, 'A', 'AAAA');
--INSERT INTO TABLE1 VALUES(2, 'B', 'ㅋㅋㅋㅋ');
--INSERT INTO TABLE1 VALUES(3, 'A', 'ㅇㅇ');

CREATE SEQUENCE SEQ_ID;
SEQ_ID.NEXTVAL
SEQ_ID.CURRVAL
------------------------------------------------------------------
SELECT SEQ_ID.CURRVAL FROM DUAL; -- 시퀀스 현재 번호
SELECT SEQ_ID.NEXTVAL FROM DUAL; -- 시퀀스의 새 번호 발급받는다
-- 중간에 데이터 삭제 되면 빈 번호 공간이 생긴다(단점)
-- 대체 방안 : (SELECT NVL(MAX(ID),0)+1 FROM TABLE1)
------------------------------------------------------------------
INSERT INTO TABLE1 VALUES(SEQ_ID.NEXTVAL, 'A', 'AAAA');
INSERT INTO TABLE1 VALUES(SEQ_ID.NEXTVAL, 'B', 'ㅋㅋㅋㅋ');
INSERT INTO TABLE1 VALUES(SEQ_ID.NEXTVAL, 'A', 'ㅇㅇ');
INSERT INTO TABLE1 VALUES((SELECT NVL(MAX(ID),0)+1 FROM TABLE1), 'A', 'AAAA');
COMMIT;

DELETE FROM TABLE1;
---------------------------------------------------------------------
번호자동증가
MSSQL : IDENTITY(), SEQUENCE()
    CREATE TABLE A_TAB (
        ID INT IDENTITY(1, 1) -- 1부터 시작해서 1씩 증가한다는 의미, IDENTITY(초기값, 증가값)
    )
MYSQL, MariaDB
    CREATE TABLE A_TAB (
        ID INT AUTO_INCREMENT
    )
----------------------------------------------------------------------
PRIMARY KEY 값 수정 가능/불가능
-- PRIMARY KEY : 업데이트 가능, 무결성 제약조건이 위배 되지 않았을 때 -> 자식 레코드가 없을 때
-- 외래키 설정이 안되어 있어서 수정 가능
UPDATE TABLE1
SET ID = 1
WHERE ID = 4;
-- 외래키 설정이 되어 있어서 수정 불가능 : 오류 발생
UPDATE STUDENT 
SET STID = 7
WHERE STID = 1;

인덱스 : INDEX (찾아보기 표)
검색할 때 해당칼럼에 인덱스를 사용하면 검색이 빨라진다.
단, INSERT, DELETE, UPDATE 를 사용할 때 새로 인덱스를 고쳐야하므로 
    추가, 수정 같은 작업이 많으면 더 느려질 수 있다.

WHERE 문에 사용하는 컬럼이나 JOIN ON 문에 사용하는 칼럼에 설정
PRIMARY KEY 와 UNIQUE -> 자동으로 인덱스 생성된다.
검색을 자주하는 컬럼에 적용하는 것이다.

CREATE TABLE emp_big AS
SELECT
    e.employee_id + (lv * 100000) AS employee_id,
    e.first_name,
    e.last_name,
    e.email || lv AS email,
    e.phone_number,
    e.hire_date,
    e.job_id,
    e.salary,
    e.commission_pct,
    e.manager_id,
    e.department_id
FROM hr.employees e
CROSS JOIN (
    SELECT LEVEL AS lv
    FROM dual
    CONNECT BY LEVEL <= 10000
);

SELECT COUNT(*) FROM EMP_BIG; -- 1090000

-- 인덱스가 지정된 컬럼으로 조건을 걸어서 검색할 때 작동
SET TIMING ON;
SELECT *
FROM EMP_BIG
WHERE EMAIL = 'SKING5000'; -- 00:00:00.446
-- 인덱스 생성
CREATE INDEX IDX_EMAIL 
    ON EMP_BIG(EMAIL);

SET TIMING ON;
SELECT *
FROM EMP_BIG
WHERE EMAIL = 'SKING5000'; -- 00:00:00.353

CREATE INDEX IDX_NAME
    ON EMP_BIG(FIRST_NAME || ' ' || LAST_NAME);
    
------------------------------------------------------------------------
트리거 TRIGGER 방아쇠
    회원정보가 추가되면 로그에 기록을 남기는 작업을 해야할 때
    
    상황
    1) INSERT 회원정보
    2) INSERT 로그기록
    두번 실행
    
    자동화
    1) INSERT 회원정보 -> TRIGGER 가 INSERT 로그기록 명령을 호출해서 실행
    
    단점 : 로직 추적이 쉽지 않다
            트리거를 자주 사용 금지
            
    BEFORE TRIGGER
    AFTER TRIGGER -> INSTEAD OF 
    
    CREATE OR REPLACE TRIGGER TRG_EMP
    AFTER INSERT ON EMP_BIG 
    FOR EACH ORW
        BEGIN
            INSERT 로그
        END;
    /
        
-----------------------------------------------------------------------
트랜잭션 : TRANSACTION 

송금

1) 내 계좌에서 금액 -
    UPDATE MTABLE 
    SET 내 계좌 = 내 계좌 - 100

2) 상대 계좌에서 금액 +
    UPDATE MTABLE
    SET 상대 계좌 = 상대 계좌 + 100

1)번 종료 후 문제 발생 시 2)번이 실행되지 않으면 문제 발생

BEGIN TRAN
    UPDATE MTABLE 
    SET 내 계좌 = 내 계좌 - 100
    UPDATE MTABLE
    SET 상대 계좌 = 상대 계좌 + 100
    COMMIT;
  EXCEPTION
    ROLLBACK;
  END;
  
  1) 2) 번을 다 한개의 작업단위로 묶어서 처리 
    문제 발생 시 처음으로 돌아간다
----------------------------------------------------------------
LOCK : DB 잠김 - 상태

1행에 오류:
ORA-00001: 무결성 제약 조건(SKY.SYS_C008405)에 위배됩니다
컴퓨터화면이 멈춤 : RECORD LOCK 걸린 상태가 된다.

INSERT INTO TABLE1 VALUES(7, 'C', 'GG');
SELECT * FROM TABLE1;
COMMIT;











