
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
ON ST.STID = SC.SCID
WHERE SUBJECT LIKE '%국어%';

3. 학번, 이름, 총점, 평균
SELECT ST.STID 학번, ST.STNAME 이름
FROM STUDENT ST
JOIN SCORES SC
ON ST.STID = SC.STID
;


SELECT SUM(SCORE) FROM SCORES WHERE STID = 1 GROUP BY STID;
SELECT SUM(SCORE) FROM SCORES WHERE STID = 2 GROUP BY STID;
SELECT SUM(SCORE) FROM SCORES WHERE STID = 4 GROUP BY STID;

SELECT AVG(SCORE) FROM SCORES WHERE STID = 1 GROUP BY STID;
SELECT AVG(SCORE) FROM SCORES WHERE STID = 2 GROUP BY STID;
SELECT ROUND(AVG(SCORE), 2) FROM SCORES WHERE STID = 4 GROUP BY STID;



--WHERE ST.STID = SC.STID;

4. 모든 학생의 학번, 이름, 총점, 평균
 점수가 NULL인 학생은 '미응시'
 
5. 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차









