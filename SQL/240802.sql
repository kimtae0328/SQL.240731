-- 도서관리 프로그램을 만들기 위한 테이블 만들기 
-- 제약조건에 이름을 부여및 COMMENT 추가

-- 1. 출판사들에 대한 데이터를 담기 위한 출판사 테이블(TB_PUB) 
--  1) 컬럼 : P_NO(출판사 번호 - P00001) -- 기본 키
--           PUB_NAME(출판사명) -- NOT NULL
--           PHONE(출판사 전화번호)
--           DELYN(삭제 여부)     -- 기본값으로 'N' 그리고 'Y' 혹은 'N'으로 입력되도록 제약조건
--           REGDATE(등록일)  -- 기본값으로 SYSDATE, NOT NULL

drop table tb_pub;
create table tb_pub (
	p_no    char(6) primary key,
	name    varchar2(20) not null,
	phone   varchar2(20),
	delyn   char(1) default 'N' check ( delyn in ( 'Y',
	                                             'N' ) ),
	regdate date default sysdate
);
-- 테이블에 커멘트 추가
comment on table tb_pub is
	'출판사';
-- 컬럼에 커멘트 추가
comment on column tb_pub.p_no is
	'출판사 번호';
comment on column tb_pub.name is
	'출판사 이름';
comment on column tb_pub.phone is
	'출판사 전화번호';
comment on column tb_pub.delyn is
	'삭제여부';
comment on column tb_pub.regdate is
	'등록일';




--  2) 3개 정도의 샘플 데이터 추가하기
insert into tb_pub values ( 'P00001',
                            '문학동네',
                            '02-223-2222',
                            default,
                            default );
insert into tb_pub (
	p_no,
	name
) values ( 'P00002',
           '한빛미디어' );
insert into tb_pub (
	p_no,
	name,
	phone
) values ( 'P00003',
           '갈벗',
           '031-232-1123' );

select *
  from pb_pub;



--  3) 커멘트 달기


-- 2. 도서들에 대한 데이터를 담기 위한 도서 테이블 (TB_BOOK)
--  1) 컬럼 : B_NO (도서번호 - B00001) -- 기본 키
--           TITLE (도서명)        -- NOT NULL
--           AUTHOR(저자명)        -- NOT NULL
--           PRICE(가격)
--           P_NO(출판사 번호)     -- 외래 키(TB_PUB 테이블을 참조)
--           RENTYN(대여여부)      -- 기본값으로 'N' 그리고 'Y' 혹은 'N'으로 입력되도록 제약조건
--           DELYN(삭제 여부)      -- 기본값으로 'N' 그리고 'Y' 혹은 'N'으로 입력되도록 제약조건
--           REGDATE(등록일)       -- 기본값으로 SYSDATE, NOT NULL

create table tb_book (
	b_no    char(6) primary key,
	title   varchar2(100) not null,
	author  varchar2(20) not null,
	price   number
    -- 외래키 제약조건 : 자식 데이터가 있으면 삭제 불가
    -- ON DELETE CASCADE 옵션을 주면 부모테이블의 데이터가 삭제될때 자식테이블의 데이터도 함께 삭제
    -- ON DELETE SET NULL 옵션 : 부모테이블의 데이터가 삭제될때 자식테이블의 데이터는 NULL로 업데이트
	,
	p_no    char(6)
		references tb_pub ( p_no )
			on delete cascade,
	rentyn  char(1) default 'N' check ( rentyn in ( 'Y',
	                                               'N' ) ),
	delyn   char(1) default 'N' check ( delyn in ( 'Y',
	                                             'N' ) ),
	regdate date default sysdate
);

-- 외래키 제약조건에 걸린 컬럼에는 NULL 또는 부모가 가진 데이터만 입력 가능
insert into tb_book (
	b_no,
	title,
	author,
	p_no
) values ( 'B00001',
           '오늘도 맑음1',
           '홍영웅',
           'P00001' );
insert into tb_book (
	b_no,
	title,
	author,
	p_no
) values ( 'B00002',
           '오늘도 맑음2',
           '홍영경',
           'P00002' );
insert into tb_book (
	b_no,
	title,
	author,
	p_no
) values ( 'B00003',
           '오늘도 맑음3',
           '홍영조',
           'P00003' );
insert into tb_book (
	b_no,
	title,
	author,
	p_no
) values ( 'B00004',
           '오늘도 맑음4',
           '홍영창',
           'P00004' );
insert into tb_book (
	b_no,
	title,
	author,
	p_no
) values ( 'B00005',
           '오늘도 맑음5',
           '홍영재',
           'P00005' );

commit;
select *
  from tb_book;
-- 자식테이블에서 사용중이므로 삭제불가(DEFAULT)
delete tb_pub
 where p_no = 'P00001';

comment on table tb_book is
	'도서';
comment on column tb_book.b_no is
	'도서번호';
comment on column tb_book.title is
	'도서명';
comment on column tb_book.author is
	'작가';
comment on column tb_book.price is
	'가격';
comment on column tb_book.p_no is
	'출판사 번호';
comment on column tb_book.rentyn is
	'대여여부';
comment on column tb_book.delyn is
	'삭제여부';
comment on column tb_book.regdate is
	'등록일';



--  2) 5개 정도의 샘플 데이터 추가하기





-- FK제약조건 위배시 데이터 입력 제한


-- 부모테이블 데이터 삭제시 참조하고 있는 자식테이블의 데이터도 함께 제거



-- 3. 회원에 대한 데이터를 담기 위한 회원 테이블 (TB_MEMBER)
--  1) 컬럼 : M_NO(회원번호 - M00001) -- 기본 키
--           ID(아이디)   -- 중복 금지
--           PW(비밀번호) -- NOT NULL
--           NAME(회원명) -- NOT NULL
--           GENDER(성별)        -- 'M' 또는 'F'로 입력되도록 제한
--           ADDR(주소)       
--           PHONE(연락처)       
--           DELYN(탈퇴 여부)     -- 기본값으로 'N' 그리고 'Y' 혹은 'N'으로 입력되도록 제약조건
--           REGDATE(가입일)  -- 기본값으로 SYSDATE, NOT NULL

create table tb_member (
	m_no    char(6) primary key,
	id      varchar2(20) unique,
	pw      varchar2(20) not null,
	name    varchar2(20) not null,
	gender  char(1) check ( gender in ( 'F',
	                                   'M' ) ),
	addr    varchar2(100),
	phone   varchar2(20),
	delyn   char(1) default ( 'N' ) check ( delyn in ( 'Y',
	                                                 'N' ) ),
	regdate date default sysdate
);

insert into tb_member (
	m_no,
	id,
	pw,
	name
) values ( 'M00001',
           'USER01',
           'USER01',
           '김' );
insert into tb_member (
	m_no,
	id,
	pw,
	name
) values ( 'M00002',
           'USER02',
           'USER02',
           '이' );
insert into tb_member (
	m_no,
	id,
	pw,
	name
) values ( 'M00003',
           'USER03',
           'USER03',
           '박' );
insert into tb_member (
	m_no,
	id,
	pw,
	name
) values ( 'M00004',
           'USER04',
           'USER04',
           '최' );
insert into tb_member (
	m_no,
	id,
	pw,
	name
) values ( 'M00005',
           'USER05',
           'USER05',
           '조' );
insert into tb_member (
	m_no,
	id,
	pw,
	name
) values ( 'M00006',
           'USER06',
           'USER06',
           '백' );
select *
  from tb_member;





--  2) 3개 정도의 샘플 데이터 추가하기


-- 4. 도서를 대여한 회원에 대한 데이터를 담기 위한 대여 목록 테이블(TB_RENT)
--  1) 컬럼 : R_NO(대여번호 R00001) -- 기본 키
--           M_NO(대여 회원번호 M00001) -- 외래 키(TB_MEMBER와 참조)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           B_NO(대여 도서번호 B00001) -- 외래 키(TB_BOOK와 참조)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_DATE(대여일) -- 기본값 SYSDATE
--           RETURN_DATE(반납일)

create table tb_rent (
	R_NO CHAR(6) PRIMARY KEY
	, M_NO CHAR (6) REFERENCES TB_MEMBER(M_NO)
	, B_NO CHAR (6) REFERENCES TB_BOOK(B_NO)
	, RENT_DATE DATE DEFAULT SYSDATE
	, RETURN_DATE DATE
);

SELECT * FROM TB_MEMBER;
SELECT * FROM TB_BOOK;


-- 아이디가 M00001번인 사람이 B00003번책을 대여
INSERT INTO TB_RENT (R_NO, M_NO, B_NO)
            VALUES ('R00001', 'M00001', 'B00001');

-- 테이블의 데이터를 수집
UPDATE TB_BOOK
SET RENTYN = 'Y'--,....
WHERE B_NO = 'B00001';

SELECT * FROM TB_BOOK;

-- 아이디가 M00002인 사람이 B00002번책을 대여
-- 1. 책의 상태를 확인
SELECT RENTYN FROM TB_BOOK WHERE B_NO = 'B00002';
-- RENTYN == N 이면 대여처리, 아니면 오류 메세지
-- 2. RENT 테이블에 대여 이력을 입력
INSERT INTO TB_RENT (R_NO, M_NO, B_NO) VALUES ('R00002', 'M00002', 'B00002');
-- 3. BOOK 테이블의 대여 여부를 업데이트
UPDATE TB_BOOK SET RENTYN = 'Y' WHERE B_NO ='B00002';


---------------------------------------------

-- 도서반납

---------------------------------------------

-- 1. 책의 상태를 확인
SELECT RENTYN FROM TB_BOOK WHERE B_NO = 'B00002';
-- RENT 테이블의 반납일을 업데이트

-- 도서테이블에 대여번호컬럼 추가
ALTER TABLE TB_BOOK ADD R_NO CHAR(6) REFERENCES TB_RENT(R_NO);
SELECT * FROM TB_BOOK WHERE B_NO = 'B00002';
UPDATE TB_BOOK SET R_NO = 'R00001' WHERE B_NO = 'B00002';

SELECT * FROM TB_RENT WHERE B_NO = 'B00002' AND RETURN_DATE IS NULL;
-- BOOK 테이블의 대여여부 업데이트
UPDATE TB_RENT
SET RETURN_DATE = SYSDATE
WHERE B_NO = 'B00002' AND RETURN_DATE IS NULL;

UPDATE TB_BOOK
SET RENTYN = 'N'
WHERE B_NO = 'B00002';

COMMIT;

SELECT *
FROM TB_RENT, TB_BOOK
WHERE TB_RENT.B_NO = TB_BOOK.B_NO
AND TB_RENT.M_NO = TB_MEMBER.M_NO
;

SELECT * FROM TB_MEMBER WHERE M_NO = 'M00001';
