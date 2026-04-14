DROP TABLE EMP1;
CREATE TABLE EMP1 
AS
    SELECT * FROM EMPLOYEES;

DROP TABLE EMPLOYEES; -- 삭제 안됨
ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다


테이블이 삭제되지 않는다 : 부모키를 가진 부모테이블은 자식테이블에 데이터가 있다면


DROP TABLE EMPLOYEES CASCADE; -- 부모 자식 관계의 데이터를 전체 삭제






