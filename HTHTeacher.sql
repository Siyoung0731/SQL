/*
CSY 계정 생성 후 
+ 버튼 클릭 후 
이름 : HTHTeacher 
사용자이름/비밀번호 : hth/1234
호스트이름 : 접속할 Ip 주소 192.168.0.246 -> cmd에 ipconfig 하면 됌
포트 : 1521 -> 방화벽 인바운드, 아웃바운드에 포트 1521 추가 필요
SID : xe
*/
INSERT INTO MYCLASS 
VALUES(12, '최시영', '010-9620-2035', 'azxx0731@gmail.com', SYSDATE);
COMMIT;

SELECT * FROM MYCLASS ORDER BY 번호;