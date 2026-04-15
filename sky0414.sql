
성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 -- 제약조건(CONSTRAINTS) - 무결성  
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입력되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
      CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건
  

학생 테이블
CREATE TABLE STUDENT
(
    STID NUMBER(6) PRIMARY KEY -- 학번 숫자(6) 기본키
    ,STNAME VARCHAR2(30) NOT NULL -- 이름 문자(30) 필수 입력
    ,PHONE VARCHAR2(20) UNIQUE -- 전화 문자(20) 중복 방지 
    ,INDATE DATE DEFAULT SYSDATE -- 입학일 날짜 기본값 오늘
);
-- PRIMARY KEY : NULL 값을 가질 수 없음, 중복 X
-- 학생정보 입력
INSERT INTO STUDENT(STID, STNAME, PHONE, INDATE) VALUES(1, '가나', '010', SYSDATE);
INSERT INTO STUDENT VALUES(2, '나나', '011', SYSDATE);
INSERT INTO STUDENT VALUES(3, '다나', '012', SYSDATE);
INSERT INTO STUDENT VALUES(4, '라나', '013', SYSDATE);
INSERT INTO STUDENT VALUES(5, '마나', '014', SYSDATE);
--INSERT INTO STUDENT VALUES(6, '하나', '014', SYSDATE); -- 전화번호는 중복 X
INSERT INTO STUDENT VALUES(6, '하나', '019', SYSDATE);

select * from student;

COMMIT;


성적 테이블 
CREATE TABLE SCORES
(
    SCID NUMBER(7) NOT NULL -- 일련번호 숫자(7) 기본키 , 번호자동증가
    ,SUBJECT VARCHAR(60) NOT NULL -- 교과목 문자(60) 필수입력
    ,SCORE NUMBER(3) CHECK(SCORE BETWEEN 0 AND 100) -- 점수 숫자(3) 범위 0 ~ 100  
    ,STID NUMBER(6) -- 학번 숫자(6) 외래키
    , CONSTRAINT SCID_PK PRIMARY KEY (SCID, SUBJECT)
    , CONSTRAINT STID_FK FOREIGN KEY (STID)
    REFERENCES STUDENT(STID)
);

INSERT INTO SCORES(SCID, SUBJECT, SCORE, STID) VALUES(1, '국어', 100, 1);
INSERT INTO SCORES(SCID, SUBJECT, SCORE, STID) VALUES(2, '영어', 100, 1);
INSERT INTO SCORES(SCID, SUBJECT, SCORE, STID) VALUES(3, '수학', 100, 1);

INSERT INTO SCORES VALUES(4, '국어', 100, 2);
INSERT INTO SCORES VALUES(5, '수학', 80, 2);


INSERT INTO SCORES VALUES(6, '국어', 70, 4);
INSERT INTO SCORES VALUES(7, '영어', 80, 4);
INSERT INTO SCORES VALUES(8, '수학', 85, 4);


SELECT * FROM SCORES;

DML 추가, 수정, 삭제 COMMIT 필수!!!!
1. INSERT(추가) : 줄 단위의 데이터를 추가(단, 제약조건에 문제가 없으면)
    1) INSERT INTO SCORES(SCID, SUBJECT, SCORE, STID) VALUES(1, '국어', 100, 1);
    
    2) 여러줄 추가
    INSERT INTO EMP4
        SELECT *
        FROM HR.EMPLOYEES;                  
    3) INSERT 문을 여러개를 한번에 실행하는 명령 - 여러줄 추가 : 새 문법
    CREATE TABLE EX_SKY
    (
        ID NUMBER(7) PRIMARY KEY,
        NAME VARCHAR2(30) NOT NULL
    );
    
    
        INSERT ALL 
            INTO EX_SKY VALUES(103, '이순신')
            INTO EX_SKY VALUES(104, '김유신')
            INTO EX_SKY VALUES(105, '강감찬')
        SELECT *
        FROM DUAL;
        COMMIT;
        
2. DELETE -- 줄(DATA) 을 삭제한다, 기본적으로 여러 줄이 대상
          -- WHERE을 빼면 전체 데이터 삭제됨!!!!!!!!
    DELETE 
    FROM 테이블명
    WHERE 조건;
    
3. UPDATE -- 줄(DATA)에 변화는 없고 칸에 정보를 수정할 때 사용
          -- WHERE이 없으면 전체를 대상으로 수정
    
    UPDATE 테이블
        SET 칼럼1 = 고칠값1,
        SET 칼럼2 = 고칠값2,
        SET 칼럼3 = 고칠값3
    WHERE 조건;

SELECT * FROM SCORES;

    UPDATE SCORES
        SET SCORE = 75
    WHERE SCID = 6;

ROLLBACK;


-----------------------------------------------------------
DATA 제거
1. DROP TABLE SCORES; -- 구조(테이블), DATA 모두 삭제, 복구불가능

2. TRUNCATE TABLE SCORES; -- 구조는 남기고 DATA만 삭제 - 처리속도가 빠름

3. DELETE FROM SCORES; -- 구조는 남기고 DATA만 삭제 - 처리속도가 느림

SCORES DATA 삭제

--SET TIMING ON
SELECT * FROM SCORES;
DELETE FROM SCORES;
SELECT * FROM SCORES;
ROLLBACK;

SELECT * FROM STUDENT;
DELETE FROM STUDENT;
SELECT * FROM STUDENT;

DELETE FROM STUDENT
WHERE STID = 1;

DELETE FROM STUDENT
WHERE STID = 11;


INSERT INTO STUDENT VALUES(11, '히나', '0111', SYSDATE);
COMMIT;

외래키 관계에서 자식 테이블의 DATA 를 지우고 부모 테이블의 DATA를 삭제하면 지울 수 있다!

DELETE FROM SCORES
WHERE STID = 1;

DELETE FROM STUDENT
WHERE STID = 1;

DROP TABLE SCORES;
DROP TABLE STUDENT;

ROLLBACK;

-- 무결성 제약조건 위배
--INSERT INTO SCORES VALUES(9, '국어', 805, 5);
--INSERT INTO SCORES VALUES(10, '영어', 80, 8);
성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.

----------------------------------------------------------------------------

1. 조회
SELECT * FROM STUDENT;
SELECT * FROM SCORES;

2. 학번, 이름, 점수(국어)
SELECT ST.STID AS "학번", ST.STNAME AS "이름", SC.SUBJECT AS "국어", SC.SCORE AS "점수"
FROM STUDENT ST
JOIN SCORES SC
ON ST.STID = SC.STID
WHERE SUBJECT LIKE '%국어%';


3. 학번, 이름, 총점, 평균

SELECT ST.STID 학번, ST.STNAME 이름, SUM(SC.SCORE) 총점, ROUND(AVG(SC.SCORE), 2) 평균
FROM STUDENT ST, SCORES SC
WHERE ST.STID = SC.STID
GROUP BY ST.STID, ST.STNAME
ORDER BY ST.STID, ST.STNAME ASC;

--WHERE ST.STID = SC.STID;

4. 모든 학생의 학번, 이름, 총점, 평균
 점수가 NULL인 학생은 '미응시'
 
SELECT ST.STID      학번, 
ST.STNAME       이름,
DECODE(SUM(SC.SCORE), NULL, '미응시', SUM(SC.SCORE))      총점, 

CASE
WHEN ROUND(AVG(SC.SCORE), 2) IS NULL   THEN '미응시'
ELSE    TO_CHAR(AVG(SC.SCORE), '990.00')    END     평균

FROM STUDENT ST, SCORES SC
WHERE ST.STID = SC.STID
GROUP BY ST.STID, ST.STNAME
ORDER BY ST.STID, ST.STNAME ASC;

5. 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차
-- 점수가 NULL인 학생은 미응시

SELECT *
FROM (
    SELECT ST.STID, ST.STNAME, SC.SUBJECT, SC.SCORE
    FROM SCORES SC
    JOIN STUDENT ST
    ON SC.STID = ST.STID
)
PIVOT( 
    SUM(SCORE) as "총점" FOR SUBJECT IN ('국어', '영어', '수학')
);



5. 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차
-- 점수가 NULL인 학생은 미응시
SELECT ST.STID 학번, ST.STNAME 이름,
CASE
    WHEN SUM(SC.SCORE) IS NULL THEN '미응시'
    ELSE TO_CHAR(SUM(SC.SCORE), '990') -- ROUND 대신 TO_CHAR로 
    END 총점,
CASE 
    WHEN AVG(SC.SCORE) IS NULL THEN '미응시' -- AVG(SC.SCORE) 이 NULL이면 미응시
    ELSE TO_CHAR(AVG(SC.SCORE), '990.00') -- ROUND 대신 TO_CHAR로, 990.00 소수 이하 2자리 반올림
    END 평균,
CASE
    WHEN ROUND(AVG(SC.SCORE), '2') BETWEEN 90 AND 100 THEN 'A'
    WHEN ROUND(AVG(SC.SCORE), '2') BETWEEN 80 AND 89.99 THEN 'B'
    WHEN ROUND(AVG(SC.SCORE), '2') BETWEEN 70 AND 79.99 THEN 'C'
    WHEN ROUND(AVG(SC.SCORE), '2') BETWEEN 60 AND 69.99 THEN 'D'
    ELSE 'F'
    END 등급,
    RANK() OVER(ORDER BY SUM(SC.SCORE) DESC NULLS LAST) 석차 -- NULL 이면 무조건 하위
FROM STUDENT ST
LEFT JOIN SCORES SC -- STUDENT TABLE 기준으로 JOIN
ON ST.STID = SC.STID
GROUP BY ST.STID, ST.STNAME;
-- 일반 칼럼과 집계함수가 같이 나오면 통계 -> GROUP BY를 사용해서 만들어라


-------------------------------------------------------------------
-- 모든 학생의 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차



-- 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차
-- 점수가 NULL인 학생은 미응시
1. ORACLE  10G 방식
1-1) 학번, 국어, 영어, 수학
SELECT SC.STID 학번,
DECODE(SC.SUBJECT, '국어', SC.SCORE) 국어,
DECODE(SC.SUBJECT, '영어', SC.SCORE) 영어,
DECODE(SC.SUBJECT, '수학', SC.SCORE) 수학
FROM SCORES SC;
-------------------------------------------------------
1-2) 학번, 국어, 영어, 수학
SELECT SC.STID 학번,
SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학
FROM SCORES SC
GROUP BY SC.STID;
---------------------------------------------------
1-3) 학번, 이름, 국어, 영어, 수학 : JOIN
SELECT ST.STID 학번, ST.STNAME 이름,
SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학
FROM STUDENT ST
LEFT JOIN SCORES SC
ON ST.STID = SC.STID
GROUP BY ST.STID, ST.STNAME
ORDER BY ST.STID, ST.STNAME;
---------------------------------------------------
1-4) 모든 학생의 학번, 이름, 국어, 영어, 수학, 총점, 평균
SELECT ST.STID 학번, ST.STNAME 이름,
SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학,
SUM(SC.SCORE) 총점,
ROUND(AVG(SC.SCORE), 2) 평균
FROM STUDENT ST
LEFT JOIN SCORES SC
ON ST.STID = SC.STID
GROUP BY ST.STID, ST.STNAME
ORDER BY ST.STID, ST.STNAME;
----------------------------------------------------------------
1-5)학생의 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차
-- 미응시
-- 등급 : 비등가 조인으로 해결
    CREATE TABLE SCGRADE 
    (
        GRADE VARCHAR2(1) PRIMARY KEY,
        LOSCORE NUMBER(6, 2),
        HIGHSCORE NUMBER(6, 2)
    );
INSERT INTO SCGRADE VALUES('A', 90, 100);
INSERT INTO SCGRADE VALUES('B', 80, 89.99);
INSERT INTO SCGRADE VALUES('C', 70, 79.99);
INSERT INTO SCGRADE VALUES('D', 60, 69.99);
INSERT INTO SCGRADE VALUES('F', 0, 59.99);
COMMIT;
-------------------------------------------------------
SELECT T.학번, 
T.이름, 
DECODE(T.국어, NULL, '미응시', T.국어) 국어, 
DECODE(T.영어, NULL, '미응시', T.영어) 영어, 
DECODE(T.수학, NULL, '미응시', T.수학) 수학, 
DECODE(T.총점, NULL, '미응시', T.총점) 총점,
DECODE(T.평균, NULL, '미응시', T.평균) 평균,
DECODE(SG.GRADE, NULL, '미응시', SG.GRADE) 등급,
RANK() OVER(ORDER BY T.총점 DESC NULLS LAST) 석차
FROM (
SELECT ST.STID 학번, ST.STNAME 이름,
SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학,
SUM(SC.SCORE) 총점,
ROUND(AVG(SC.SCORE), 2) 평균
FROM STUDENT ST
LEFT JOIN SCORES SC
ON ST.STID = SC.STID
GROUP BY ST.STID, ST.STNAME
ORDER BY ST.STID, ST.STNAME
) T
LEFT JOIN SCGRADE SG
ON T.평균 BETWEEN SG.LOSCORE AND SG.HIGHSCORE
;
------------------------------------------------------------------------------------
2. ORACLE 11G 방식 PIVOT 명령 사용 : 통계를 생성 -- 일반적으로 집계 함수랑 같이 사용
-- PIVOT : 로우를 컬럼으로 변환해주는 기능
학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차
1) 학번, 국어, 영어, 수학
SELECT *
FROM (
    SELECT STID 학번, SUBJECT, SCORE
    FROM SCORES
)
PIVOT(
    SUM(SCORE)
    FOR SUBJECT IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
);
2) 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차
SELECT ST.STID 학번, 
ST.STNAME 이름,
DECODE(T.국어, NULL, '미응시', T.국어) 국어, 
DECODE(T.영어, NULL, '미응시', T.영어) 영어, 
DECODE(T.수학, NULL, '미응시', T.수학) 수학, 
(NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학, 0)) 총점, 
(NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학, 0)) / 3 평균,
SG.GRADE 등급,
RANK() OVER(ORDER BY (NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학, 0)) DESC NULLS LAST) 석차
FROM(
        SELECT *
        FROM (
            SELECT STID, SUBJECT, SCORE
            FROM SCORES
        )
        PIVOT(
            SUM(SCORE)
            FOR SUBJECT IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
        )
    ) T
RIGHT JOIN STUDENT ST
ON T.STID = ST.STID
LEFT JOIN SCGRADE SG 
ON (NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학, 0)) / 3 BETWEEN SG.LOSCORE AND SG.HIGHSCORE;













