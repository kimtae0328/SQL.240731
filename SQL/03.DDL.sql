/*
    <DDL(Data Definition Language)>
        (쿼리를 실행하는 순간 반영됨)
        데이터 정의 언어로 오라클에서 제공하는 객체를 만들고(CREATE), 변경하고(ALTER), 삭제하는(DROP) 등
        실제 데이터 값이 아닌 데이터의 구조 자체를 정의하는 언어로 DB 관리자, 설계자가 주로 사용한다.

        * 오라클에서의 객체 : 테이블, 뷰, 시퀀스, 인덱스, 트리거, 프로시져, 함수, 사용자 등등
        
    <CREATE>
        데이터베이스의 객체를 생성하는 구문이다.
    
    <TABLE(테이블)>
        테이블은 행과 열로 구성되는 가장 기본적인 데이터베이스 객체로 데이터베이스 내에서 모든 데이터는 테이블에 저장된다.
        
    <테이블 생성>
        [표현법]
            CREATE TABLE 테이블명 (
                컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
                컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
                ...
            );
*/
-- MEMBER 테이블 생성
CREATE TABLE MEMBER(
    ID VARCHAR(20)
    , PW VARCHAR(20)
    , NAME VARCHAR2(20)
    , REGARD DATE
    , DELYN CHAR(1)
);

-- DML 문장(INSERT, UPDATE, DELETE)은 커밋(SAVE)/롤백(CANCEL)이 필요
INSERT INTO MEMBER VALUES ('ID1', '1234', '홍길동', DEFAULT, 'N');
COMMIT;
SELECT * FROM MEMBER;
-- TABLE DELETE
DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    ID VARCHAR(20)
    , PW VARCHAR(20)
    , NAME VARCHAR2(20)
    , REGARD DATE DEFAULT SYSDATE -- 기본값
    , DELYN CHAR(1)
);

INSERT INTO MEMBER VALUES ('ID1', '1234', '홍길동', NULL, 'N');
INSERT INTO MEMBER VALUES ('ID1', '1234', '홍길동', DEFAULT, 'N');
-- 입력할 컬럼을 지정 - 테이블 이름뒤에 입력할 컬럼명을 명시
INSERT INTO MEMBER (ID) VALUES ('ID2');
-- 테이블에 추가한 데이터를 실제 데이터베이스에 반영
-- (메모리 버퍼에 임시 저장된 데이터)
COMMIT;
SELECT * FROM MEMBER;

/*
    <컬럼에 주석 달기>
        [표현법]
            COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
*/
COMMENT ON TABLE MEMBER IS '멤버';
COMMENT ON COLUMN MEMBER.ID IS '아이디';
COMMENT ON COLUMN MEMBER.PW IS '비밀번호';
COMMENT ON COLUMN MEMBER.NAME IS '이름';
COMMENT ON COLUMN MEMBER.REGARD IS '등록일';
COMMENT ON COLUMN MEMBER.DELYN IS '삭제여부';

/*
    데이터 딕셔너리(데이터 사전)
    사용자가 객체를 생성하거나 객체를 변경하는 등의 작업을 할때
    데이터베이스에 의해서 자동으로 갱신되는 테이블이다.

    DBA_XXX : 관리자만 접근 가능한 객체등의 정보조회
    USER_XXX : 계정이 소유한 객체등에 관한 정보 조회
    ALL_XXX : 계정소유 또는 권한을 부여받은 객체등에 관한 정보 조회

    데이터에 관한 데이터가 저장되어 있어 메타 데이터 라고도 한다.
*/

SELECT * FROM USER_TABLES;

/*
    <제약 조건(CONSTRAINT)>
        사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 저장될 값에 대한 제약조건을 설정할 수 있다.
        제약 조건은 데이터 무결성 보장을 목적으로 한다. (데이터의 정확성과 일관성을 유지시키는 것)
        
        * 종류 : NOT NULL : 비워둘수 없음
                UNIQUE : 중복될수 없음
                CHECK : 값을 제한(ex)Y, N 만 입력 가능
                PRIMARY KEY : 기본키 NOT NULL + UNIQUE
                FOREIGN KEY : 외래키
        
        [표현법]
            1) 컬럼 레벨
                CRATE TABLE 테이블명 (
                    컬럼명 자료형(크기) [CONSTRAINT 제약조건명] 제약조건,
                    ...
                );

                제약조건명은 생략이 가능하며 생략할 경우
                SYS_C 일련버호 형태로 이름이 지정
            
            2) 테이블 레벨
                CRATE TABLE 테이블명 (
                    컬럼명 자료형(크기),
                    ...,
                    [CONSTRAINT 제약조건명] 제약조건(컬럼명)
                );
*/

SELECT * FROM USER_CONSTRAINTS;

/*
    <NOT NULL 제약조건>
        해당 컬럼에 반드시 값이 있어야만 하는 경우 사용한다.
        삽입/수정 시 NULL 값을 허용하지 않도록 제한한다.
*/
DROP TABLE MEMBER;
CREATE TABLE MEMBER(
    ID VARCHAR2(20) CONSTRAINT PM_MEMBER PRIMARY KEY -- 기본키 제약조건(NOT NULL + UNIQUE)
    , PW VARCHAR(20) CONSTRAINT NN_MEMBER_PW NOT NULL
    , NAME VARCHAR2(20) CONSTRAINT NN_MEMBER_NAME NOT NULL
    , REGARD DATE DEFAULT SYSDATE -- 기본값
    , DELYN CHAR(1)
);
-- TABLE 레벨 방식
CREATE TABLE MEMBER(
    ID VARCHAR2(20) UNIQUE NOT NULL
    , PW VARCHAR(20) CONSTRAINT NN_MEMBER_PW NOT NULL
    , NAME VARCHAR2(20) CONSTRAINT NN_MEMBER_NAME NOT NULL
    , REGARD DATE DEFAULT SYSDATE -- 기본값
    , DELYN CHAR(1)
    , CONSTRAINT PK_MEMBER_ID UNIQUE(ID)
);
DESC MEMBER;
-- NOT NULL 제약조건에 의해 ID, PW, NAME 컬럼에
-- 값이 입력되지 않은경우 오류 발생
INSERT INTO MEMBER (ID) VALUES ('ID1');
-- 아이디를 중복해서 입력할 경우 오류 발생
INSERT INTO MEMBER (ID, PW, NAME) VALUES ('ID3', 'PW', '홍홍홍');
SELECT * FROM MEMBER;

/*
    <UNIQUE 제약조건>
        컬럼의 입력 값에 중복 값을 제한하는 제약조건이다.
        데이터를 삽입/수정 시 기존에 있는 데이터 값 중에 중복되는 값이 있을 경우 삽입/수정되지 않는다.
        제약조건 지정 방식으로 컬럼 레벨, 테이블 레벨 방식 모두 사용 가능하다.
*/

/*
    <CHECK 제약조건>
        컬럼에 기록되는 값에 조건을 설정하고 조건을 만족하는 값만 기록할 수 있다.
        비교 값은 리터럴만 사용 가능하다.(변하는 값이나 함수 사용하지 못한다.)
        
        [표현법]
            CHECK(비교연산자)
                CHECK(컬럼 [NOT] IN(값, 값, ...))
                CHECK(컬럼 = 값)
                CHECK(컬럼 BETWEEN 값 AND 값)
                CHECK(컬럼 LIKE '_문자' OR 컬럼 LIKE '문자%')
                ...
*/

DROP TABLE MEMBER;
CREATE TABLE MEMBER(
    ID VARCHAR2(20) NOT NULL
    , PW VARCHAR(20) CONSTRAINT NN_MEMBER_PW NOT NULL
    , NAME VARCHAR2(20) CONSTRAINT NN_MEMBER_NAME NOT NULL
    , REGARD DATE DEFAULT SYSDATE -- 기본값
    , DELYN CHAR(1) CONSTRAINT CHECK_MEMBER_DELYN CHECK(DELUN IN ('Y', 'N'))
    , GENDER CHAR(1) CHECK(GENDER IN ('M', 'F'))
    , AGE NUMBER CHECK(AGE > 0)
    , CONSTRAINT PK_MEMBER_ID UNIQUE(ID)
);

-- 정상
INSERT INTO MEMBER (ID, PW, NAME, DELYN, GENDER, AGE)
                VALUES ('ID', 'PW', '홍홍홍', 'Y', 'M', 10);
-- 오류
-- AGE는 0보다 큰값이 입력되어야 하고
-- GENDER 는 M,F만 입력 가능
-- ID는 중복될수 없다
INSERT INTO MEMBER (ID, PW, NAME, DELYN, GENDER, AGE)
                VALUES ('ID', 'PW', '홍홍홍', 'Y', 'A', -10);

/*
    <PRIMARY KEY(기본 키) 제약조건>
        테이블에서 한 행의 정보를 식별하기 위해 사용할 컬럼에 부여하는 제약조건이다.
        각 행들을 구분할 수 있는 식별자 역할(사번, 부서 코드, 직급 코드, ..)
        기본 키 제약조건을 설정하게 되면 자동으로 해당 컬럼에 NOT NULL + UNIQUE 제약조건이 설정된다.
        한 테이블에 한 개만 설정할 수 있다.(단, 한 개 이상의 컬럼을 묶어서 PRIMARY KEY로 제약조건을 설정할 수 있다.)
        컬럼 레벨, 테이블 레벨 방식 모두 설정 가능하다.
*/

DROP TABLE MEMBER;
CREATE TABLE MEMBER(
    ID VARCHAR2(20) NOT NULL
    , PW VARCHAR(20) CONSTRAINT NN_MEMBER_PW NOT NULL
    , NAME VARCHAR2(20) CONSTRAINT NN_MEMBER_NAME NOT NULL
    , REGARD DATE DEFAULT SYSDATE -- 기본값
    , DELYN CHAR(1) CONSTRAINT CHECK_MEMBER_DELYN CHECK(DELUN IN ('Y', 'N'))
    , GENDER CHAR(1) CHECK(GENDER IN ('M', 'F'))
    , AGE NUMBER CHECK(AGE > 0)
    -- 복합키 : 두 컬럼을 묶어서 하나의 기본키를 생성
    -- 테이블레벨로 설정이 가능
    , CONSTRAINT PK_MEMBER_ID UNIQUE(ID, NO)
);

-- 2. 도서들에 대한 데이터를 담기 위한 도서 테이블 (TB_BOOK)
--  1) 컬럼 : BK_NO (도서번호) -- 기본 키
--           BK_TITLE (도서명) -- NOT NULL
--           BK_AUTHOR(저자명) -- NOT NULL
--           BK_PRICE(가격)   -- > 0
--           RENTYN           -- Y/N
--           BK_PUB_NO(출판사 번호) -- 외래 키(TB_PUBLISHER 테이블을 참조하도록)
--                                    이때 참조하고 있는 부모 데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정

DROP TABLE TB_BOOK;
CREATE TABLE TB_BOOK(
    NO       CHAR(6)         CONSTRAINT PK_TB_BOOK_NO PRIMARY KEY
    , TITLE  VARCHAR2(100) CONSTRAINT NN_TB_BOOK_TITLE NOT NULL
    , AUTHOR VARCHAR(30)   CONSTRAINT NN_TB_BOOK_AUTHOR NOT NULL
    , PRICE  NUMBER         CONSTRAINT CK_TB_BOOK_PRICE CHECK(PRICE > 0)
    , RENTYN CHAR(1)        DEFAULT 'N' 
                            CONSTRAINT CK_TB_BOOK_RENTYN CHECK(RENTYN IN('Y', 'N'))
    , PUB_NO NUMBER
);
SELECT * FROM TB_BOOK;

DROP TABLE TB_BOOK;
-- 자동형변환 되어서 입력이 됨
-- B00001
-- 일련번호 : 자동으로 1씩 증가하는 숫자
INSERT INTO TB_BOOK (NO, TITLE, AUTHOR, PRICE, PUB_NO)
        VALUES ('1', 'BOOK1', 'AUTHOR1', 10000, 1);
-- 코드값을 생성할때 자릿수를 맞추기 위해 함수를 사용할수 있다.
SELECT 'B' || LPAD(SEQ_TB_BOOK.NEXTVAL,5,'0')
FROM DUAL;

INSERT INTO TB_BOOK (NO, TITLE, AUTHOR, PRICE, PUB_NO)
        VALUES ('B' || LPAD(SEQ_TB_BOOK.NEXTVAL,5,'0')
                        , 'BOOK1', 'AUTHOR1', 10000, 1);
SELECT * FROM TB_BOOK;


-- 일련번호 생성기
-- 1부터 시작하는 1씩 증가하는
CREATE SEQUENCE SEQ_TB_BOOK;
-- 시퀀스 삭제
DROP SEQUENCE SEQ_TB_BOOK;
-- NEXTVAL : 다음값
-- CURRVAL : 현재값 (NEXTVAL 이후 사용가능 - 생성후 바로 사용 불가)
SELECT SEQ_TB_BOOK.CURRVAL, SEQ_TB_BOOK.NEXTVAL
FROM DUAL;

-- 도서등록 5권

-- 1. 출판사들에 대한 데이터를 담기 위한 출판사 테이블(TB_PUBLISHER)
-- 1) 컬럼 : PUB_NO(출판사 번호) -- 기본키
--          PUB_NAME(출판사명) -- NOT NULL
--          PHONE(출판사 전화번호) -- 제약조건 없음
--          DELYN(삭제여부) -- Y / N
--          REGDATE(등록일) -- 기본값 : 오늘날짜

DROP TABLE TB_PUBLISHER;
CREATE TABLE TB_PUBLISHER(
      NO       CHAR(6)      CONSTRAINT PK_TB_PUBLISHER_NO PRIMARY KEY
    , NAME  VARCHAR2(60)   CONSTRAINT NN_TB_PUBLISHER_NAME NOT NULL
    , PHONE NUMBER     
    , REGDATE DATE           DEFAULT SYSDATE 
    , DELYN CHAR(1)       DEFAULT 'N' 
                            CONSTRAINT CK_TB_PUBLISHER_DELYN CHECK(DELYN IN('Y', 'N'))
);

INSERT INTO TB_PUBLISHER (NO, NAME, PHONE, REGDATE, DELYN)
        VALUES ('P00001', '출판사명', '02000000',SYSDATE, 'N');

SELECT * FROM TB_PUBLISHER;

-- 2. 일련번호
--      SEQ_TB_PUB
--      P00001

CREATE SEQUENCE SEQ_TB_PUBLISHER;
SELECT 'P' || LPAD(SEQ_TB_PUBLISHER.NEXTVAL, 5, '0') FROM DUAL;

INSERT INTO TB_PUBLISHER (PUBLISHER_NO, PUBLISHER_NAME)
        VALUES ('P' || LPAD(SEQ_TB_PUBLISHER.NEXTVAL, 5, '0'), '출판사명');

SELECT * FROM TB_PUBLISHER;

COMMIT;

-- 4. 도서를 대여한 회원에 대한 데이터를 담기 위한 대여 목록 테이블(TB_RENT)
--  1) 컬럼 : RENT_NO(대여번호) -- 기본 키
--           RENT_MEM_NO(대여 회원번호) -- 외래 키(TB_MEMBER와 참조)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_BOOK_NO(대여 도서번호) -- 외래 키(TB_BOOK와 참조)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_DATE(대여일) -- 기본값 SYSDATE

-- 시퀀스 생성 SEQ_TB_RENT
SELECT * FROM TB_BOOK;
SELECT * FROM TB_PUBLISHER;
SELECT * FROM MEMBER;

DESC TB_BOOK; ----- NO
SELECT * FROM TB_BOOK;
DESC MEMBER; ----- ID
SELECT * FROM MEMBER;
INSERT INTO MEMBER (ID, PW, NAME) VALUES ('ID', 'PW', 'NAME');
DROP TABLE TB_RENT;
-- 외래키 제약조건을 추가할때 컬럼의 이름이 같지 않아도 된다
-- 자식테이블은 입력에 제한을 받는다
CREATE TABLE TB_RENT(
    RENT_NO      CHAR(6) PRIMARY KEY
    -- MEMBER - 참조하는 테이블의 컬럼의 타입과 동일하게 지정
    , RENT_MEM_NO  VARCHAR2(20) REFERENCES MEMBER(ID)
    -- BOOK
    , RENT_BOOK_NO   CHAR(6) REFERENCES TB_BOOK(NO)
    , RENT_DATE      DATE    DEFAULT SYSDATE 
);
INSERT INTO TB_RENT (RENT_NO, RENT_BOOK_NO, RENT_MEM_NO) VALUES ('R00001', 'B00001', 'ID');
INSERT INTO TB_RENT (RENT_NO) VALUES ('R00001');
CREATE SEQUENCE SEQ_TB_RENT;
SELECT 'R' || LPAD(SEQ_TB_RENT.NEXTVAL, 5, '0') FROM DUAL;
INSERT INTO TB_RENT VALUES ('R' || LPAD(SEQ_TB_RENT.NEXTVAL, 5, '0'), 'A', 'B', SYSDATE);
SELECT * FROM TB_RENT;

/*
    <FOREIGN KEY(외래 키) 제약조건>
        다른 테이블에 존재하는 값만을 가져야 하는 컬럼에 부여하는 제약조건이다.(단, NULL 값도 가질 수 있다.)
        즉, 참조된 다른 테이블이 제공하는 값만 기록할 수 있다. (FOREIGN KEY 제약조건에 의해서 테이블 간에 관계가 형성된다.)
        
        [표현법]
            1) 컬럼 레벨
                컬럼명 자료형(크기) [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 [(기본키)] [삭제룰]
                
            2) 테이블 레벨
                [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(기본키)] [삭제룰]
                
        [삭제룰]
            부모 테이블의 데이터가 삭제됐을 때의 옵션을 지정해 놓을 수 있다.
            1) ON DELETE RESTRICT : 자식 테이블의 참조 키가 부모 테이블의 키 값을 
               참조하는 경우 부모 테이블의 행을 삭제할 수 없다. (기존적으로 적용되는 옵션)
            2) ON DELETE SET NULL : 부모 테이블의 데이터가 삭제 시 참조하고 있는 
               자식 테이블의 컬럼 값이 NULL로 변경된다.
            3) ON DELETE CASCADE  : 부모 테이블의 데이터가 삭제 시 참조하고 있는 
               자식 테이블의 컴럼 값이 존재하는 행 전체가 삭제된다.
*/

-- 회원등급 테이블
-- MEMBER_GRADE(GRADE_CODE 기본키 숫자타입
--                , GRADE_NAME 문자타입 30BYTE NOTNULL)
-- 부모테이블
CREATE TABLE MEMBER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY
    , GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO MEMBER_GRADE VALUES (10, '일반회원');
INSERT INTO MEMBER_GRADE VALUES (20, '우수회원');
INSERT INTO MEMBER_GRADE VALUES (30, '특별회원'); 

SELECT * FROM MEMBER_GRADE;
COMMIT;

DROP TABLE MEMBER;
-- 테이블레벨
CREATE TABLE MEMBER(
    ID VARCHAR2(20) NOT NULL
    , PW VARCHAR2(20) CONSTRAINT NN_MEMBER_PW NOT NULL
    , NAME VARCHAR2(20) CONSTRAINT NN_MEMBER_NAME NOT NULL
    , REGDATE  DATE DEFAULT SYSDATE -- 기본값
    , DELYN CHAR(1) CONSTRAINT CHECK_MEMBER_DELYN CHECK(DELYN IN ('Y', 'N'))
    , GENDER CHAR(1) CHECK(GENDER IN ('M', 'F'))
    , AGE NUMBER CHECK(AGE > 0)
    , CONSTRAINT PK_MEMBER_ID UNIQUE(ID)
    , GRADE_CODE NUMBER
    -- 제약조건이름 FOREIGN KEY(컬럼명) REFERENCES 테이블명(컬럼명)
    , CONSTRAINT FK_MEMBER_GRADE_CODE FOREIGN KEY(GRADE_CODE) REFERENCES MEMBER_GRADE (GRADE_CODE) ON DELETE SET NULL
);

-- 컬럼레벨
CREATE TABLE MEMBER(
    ID VARCHAR2(20) NOT NULL
    , PW VARCHAR2(20) CONSTRAINT NN_MEMBER_PW NOT NULL
    , NAME VARCHAR2(20) CONSTRAINT NN_MEMBER_NAME NOT NULL
    , REGDATE  DATE DEFAULT SYSDATE -- 기본값
    , DELYN CHAR(1) CONSTRAINT CHECK_MEMBER_DELYN CHECK(DELYN IN ('Y', 'N'))
    , GENDER CHAR(1) CHECK(GENDER IN ('M', 'F'))
    , AGE NUMBER CHECK(AGE > 0)
    , CONSTRAINT PK_MEMBER_ID UNIQUE(ID)
    -- 제약조건이름 REFERENCES 테이블명(컬럼명)
    , GRADE_CODE NUMBER CONSTRAINT FK_MEMBER_GRADE_CODE REFERENCES MEMBER_GRADE (GRADE_CODE) ON DELETE SET NULL
);

-- 부모테이블의 컬럼에 입력된 값만 입력이 가능
-- 자식테이블에서 입력할때 오류가 발생할수 있다
-- 부모테이블을 참조하고 있는 경우 부모테이블에 입력된 데이터만 입력가능
INSERT INTO MEMBER (ID, PW, NAME, GRADE_CODE) VALUES ('ID', 'PW', '홍홍홍', 10);
-- NULL 입력 가능
INSERT INTO MEMBER (ID, PW, NAME, GRADE_CODE) VALUES ('ID1', 'PW', '홍홍홍', NULL);
INSERT INTO MEMBER (ID, PW, NAME, GRADE_CODE) VALUES ('ID2', 'PW', '홍홍홍', 10);

-- 외래키 제약조건을 사용중인 경우 자식이 존재하는경우 삭제 불가
-- 부모테이블에 있는 데이터를 삭제할때 오류가 발생할수 있다.
-- 자식이 참조하고 있는 데이터는 삭제불가 (DEFAULT) -> 옵션을 주어서 삭제 가능
-- 옵션 : 1. 자식이 참조하고 있는 부모데이터를 NULL로 업데이트
--        2. 자식행을 함께 삭제
DELETE MEMBER_GRADE WHERE GRADE_CODE = 10;
SELECT * FROM MEMBER;
SELECT * FROM MEMBER_GRADE;

-- 무결성 : 데이터의 정확성과 일관성이 유지되고, 데이터에 결손과 부정합이 없음을 보증하는것
SELECT * FROM TB_BOOK;
DESC TB_BOOK;
SELECT * FROM TB_PUBLISHER;
DESC TB_PUBLISHER;

DROP TABLE TB_BOOK;
CREATE TABLE TB_BOOK(
    NO       CHAR(6)         CONSTRAINT PK_TB_BOOK_NO PRIMARY KEY
    , TITLE  VARCHAR2(100) CONSTRAINT NN_TB_BOOK_TITLE NOT NULL
    , AUTHOR VARCHAR(30)   CONSTRAINT NN_TB_BOOK_AUTHOR NOT NULL
    , PRICE  NUMBER         CONSTRAINT CK_TB_BOOK_PRICE CHECK(PRICE > 0)
    , RENTYN CHAR(1)        DEFAULT 'N' 
                            CONSTRAINT CK_TB_BOOK_RENTYN CHECK(RENTYN IN('Y', 'N'))
    , PUB_NO CHAR(6)        REFERENCES TB_PUBLISHER(PUBLISHER_NO)
);

-- 외래키 제약조건에 의해 TB_PUBLISHER 에 등록된 값만 입력할수 있다
INSERT INTO TB_BOOK VALUES ('B00001', '제목', '작가', 20000, 'N', 'P00001');
-- 부모테이블에 입력된 값이 아니면 오류 발생
INSERT INTO TB_BOOK VALUES ('B00001', '제목', '작가', 20000, 'N', 'P00');


-- DELETE 문이나 UPDATE 문을 사용할 경우 
-- 조건을 주지 않으면 모든 테이블의 데이터가 삭제되거나 업데이트됨
-- 건수를 확인 후 실행 (★★★★★★★★)
-- 만약 건수가 잘못되었다 싶으면 롤백
ROLLBACK;
SELECT * FROM TB_BOOK;

DELETE BOOK;
DELETE FROM BOOK;