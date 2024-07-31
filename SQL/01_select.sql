---------------------------- sql 1일차 ----------------------------
/*

-- system 계정으로 접근하고 계정을 생성하고 권한을 부여한다.
----------------------------------------------------
-- 사용자 생성및 권한 부여
-- 오라클에서 제공하는 객체를 만들고 수정하고 삭제
-- DDL
-- ctrl + enter
create user user01 IDENTIFIED by 1234;

-- 권한 부여 (접근, 리소스)
-- 실습테이블 설정
grant connect, resource to user01;
-----------------------------------------------------
-- 실습용 테이블생성
-----------------------------------------------------
-- user01계정으로 접속을 생성
-- 사용자 계정으로 접속하여 실습스크립트를 실행

select *         -- 조회할 컬럼명을 나열, * 테이블이 가진 모든 컬럼을 조회
from employee;    -- 테이블 이름
-- where
-- order by;
-- 테이블 이름 변경
-- sql 문장으로 실행 할 수도 있고 sqlDeveloper의 기능을 이용 할 수도 있다.
rename department to dept;

-- 사원 테이블에서 사원의 이름, 급여, 입사일을 조회 해보세요
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM emp
-- 조건절
-- ~으로 시작하는, ~으로 끝나는, ~을 포함하는, ~과 일치하는
-- 날짜, 숫자 비교
WHERE EMP_NAME = '송종기';

-- 급여가 300만원 이상인 사원의 이름과 직급코드를 조회 하시오.

SELECT EMP_NAME, JOB_CODE
FROM EMP
WHERE SALARY >= 3000000;
-- 정렬
-- ASC - 오름차순(기본)
-- DESC - 내림차순
-- ORDER BY EMP-NAME desc;

-- 한줄 주석
/*
여러줄 주석
SELECT 구문 : 테이블에 있는 데이터를 조회 할때 사용
SELECT 컬럼명, ...
FROM 테이블명
WHERE 조건 AND(OR) 조건
ORDER BY 정렬컬럼

- SELECT절을 통해서 조회된 결과물을 RESULT SET이라고 한다(조회된 행들의 집합)
- SELECT절에 나열되는 컬럼명은 FROM절에 기술된 테이블에 존재 하는 컬럼 이여야 한다!!!!!!!!
*/

-- EMPLOYEE 테이블에서 전체 사원의 사번, 이름, 월급을 조회
-- 별칭주기
-- 컬럼명 별칭
-- as 키워드를 붙일수도 있고 생략 할 수도 있다.
-- 별칭에 공백이나 특수문자가 있는경우 ""로 묶어주어야 한다.
SELECT EMP_ID 사번, EMP_NAME 이름, SALARY 월급
FROM EMP;
/*
<컬럼명에 별칭 지정하기>
[표현법] 컬럼명 AS 별칭 / 컬럼명 AS "별칭" / 컬럼명 별칭 / 컬럼명 "별칭"
- 산술연산을 하게 되면 컬럼명이 지저분해진다. 이때 컬럼명에 별칭을 부여해서 깔끔하게 보여줄 수 있다.
- 별칭을 부여할 때 띄어쓰기 혹은 특수문자가 포함될 경우에는 반드시 큰 따옴표("")로 감싸줘야 한다.
*/

SELECT EMP_ID as "사번", EMP_NAME as "이름", SALARY as "월급"
FROM EMP;

/*
<컬럼 값을 통한 산술연산>
SELECT 절에 컬럼명 입력 부분에서 산술 연산을 이용해서 결과를 조회할 수 있다.
*/

SELECT EMP_NAME, SALARY, SALARY * 12, BONUS
FROM EMP;

-- 보너스 구하기
-- 보너스율과 보너스를 함께 출력
-- 보너스를 포함한 급여 구하기
-- null의 연산결과는 null ---> nvl(컬럼,변경할값)함수를 이용해서 null이면 0으로 치환
-- nvl(bonus,0) : bonus컬럼의 값이 null 이라면 0으로 바꿔줘
-- 연산식이나 함수를 이용할 경우, 컬럼명이 연산식으로 변경됨
SELECT BONUS 보너스율, SALARY * NVL(BONUS,0)보너스, SALARY + SALARY * NVL(BONUS,0) "보너스를 포함한 급여"
FROM EMP;

-- DUAL : 테스트용 테이블
SELECT SYSDATE FROM DUAL;

-- 날짜출력형식 변경
-- 도구 > 환경설정 > 데이터베이스 > NLS
-- 오늘날짜 : sysdate
-- FLOOR : 소수점 버림 함수
-- 날짜와 날짜의 연산, 날짜와 숫자의 연산 -> 일수로 출력
SELECT SYSDATE, HIRE_DATE, SYSDATE - 2, FLOOR(SYSDATE - HIRE_DATE)
FROM EMP;

-- EMP 테이블에서 직원명, 연봉, 보너스가 포함된 연봉 조회
-- 컬럼명은 직원명, 연봉, 보너스가 포함된 연봉으로 한다.

SELECT EMP_NAME "직원명", SALARY*12 "연봉", (NVL(BONUS,0) * SALARY + SALARY)*12 "보너스가 포함된 연봉"
FROM EMP;
---------------------------- sql 2일차 ----------------------------
/*
    <리터럴>
        SELECT 절에 리터럴을 사용하면 테이블에 존재하는 데이터처럼 조회가 가능하다.
        리터럴은 RESULT SET의 모든 행에 반복적으로 출력된다.
*/
select '안녕' "안녕" ,emp_name|| '님의 급여는' || salary || '원 입니다' as "급여"
from    emp;

/* 
    <연결 연산자> 문자열 연결 || 
    여러 컬럼 값을 하나의 컬럼인것 처럼 연결 하거나 컬럼과 리터럴을 연결 하기 위해 사용 
*/

-- 형식을 지정해서 문자열로 변경하는 함수
select to_char(salary, '999,999,999')
from emp;

-- 00사원의 급여는 00원 입니다.
select emp_name|| '사원의 급여는' || 
            to_char(salary, '999,999,999')
             || '원 입니다' as "사원급여"
from    emp;

/*
    <DISTINCT> 중복제거
        컬럼에 포함된 중복 값을 한 번씩만 표시하고자 할 때 사용한다.
        SELECT 절에 한 번만 기술할 수 있다.
        컬럼이 여러 개이면 컬럼 값들이 모두 동일해야 중복 값으로 판단되어 중복이 제거된다.
*/
SELECT JOB_CODE
FROM    EMP;
SELECT DISTINCT JOB_CODE
FROM    EMP;

SELECT DISTINCT JOB_CODE 직급코드, DEPT_CODE 부서코드
FROM EMP;

/*
    <WHERE 절>
        [표현법]
            SELECT 컬럼, 컬럼, ..., 컬럼
              FROM 테이블명
             WHERE 조건식;
             
        - 조회하고자 하는 테이블에서 해당 조건에 만족하는 결과만을 조회하고자 할 때 사용한다.
        - 조건식에는 다양한 연산자들을 사용할 수 있다.
        
    <비교 연산자>
        >, <, >=, <= : 대소 비교
        =            : 동등 비교
        !=, ^=, <>   : 같지 않다
*/

-- EMP 테이블에서 부서 코드가 D9와 일치하는 사원들의 모든 컬럼 정보 조회
select  * 
from    emp
-- 쿼리는 대소문자를 구분하지 않지만 데이터는 대소문자를 구분한다
WHERE   dept_code != 'D9';

-- 부서테이블의 부서 코드가 D9와 일치하는 모든 내용을 조회
select  * 
from    DEPT
WHERE   DEPT_ID = 'D9';

-- EMP 테이블에서 부서 코드가 D9가 아닌 사원들의 사번, 사원명, 부서 코드 조회
select  EMP_ID "사번", EMP_NAME "사원명", DEPT_CODE "부서 코드"
from    emp
WHERE   dept_code != 'D9';

-- EMP 테이블에서 급여가 400만원 이상인 직원들의 직원명, 부서코드, 급여 조회
select  EMP_NAME "직원명", DEPT_CODE "부서 코드", SALARY "급여"
from    emp
WHERE   SALARY >= '4000000';

------------------ 실습 문제 -----------------
-- 1. EMP 테이블에서 재직 중(ENT_YN 컬럼 값이 'N')인 직원들의 사번, 이름, 입사일 조회 
SELECT EMP_ID "사번", EMP_NAME "이름", HIRE_DATE "입사일"
FROM EMP
WHERE ENT_YN = 'N';
-- 2. EMP 테이블에서 연봉이 5000만원 이상인 직원의 직원명, 급여, 연봉, 입사일 조회
SELECT EMP_NAME "직원명", SALARY "급여", (SALARY * NVL(BONUS, 0) + SALARY) * 12 "연봉", HIRE_DATE "입사일"
FROM EMP
WHERE (SALARY * NVL(BONUS, 0) + SALARY) * 12 >= 50000000;

/*
    <논리 연산자>
        여러 개의 조건을 엮을 때 사용한다.
        AND (~ 이면서, 그리고)
        OR  (~ 이거나, 또는)
*/

-- EMP 테이블에서 부서 코드가 D6이면서 급여가 300만원 이상인 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_NO, EMP_NAME, DEPT_CODE, SALARY
FROM EMP
WHERE DEPT_CODE = 'D6'
AND   SALARY >= 3000000;
-- EMP 테이블에서 급여가 400만원 이상 이고, 직급 코드가 J2인 사원의 모든 컬럼 조회
SELECT *
FROM EMP
WHERE JOB_CODE = 'J2'
AND   SALARY >= 4000000;
-- EMP 테이블에서 급여가 350만원 이상 600만원 이하를 받는 직원의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID "사번", EMP_NAME "직원명", DEPT_CODE "부서 코드", SALARY "급여"
FROM EMP
WHERE   SALARY >= 3500000
AND   SALARY <= 6000000;

/*
    <BETWEEN AND>
        [표현법]
            WHERE 비교대상컬럼 BETWEEN 하한값 AND 상한값
            
        - WHERE 절에서 사용되는 구문으로 범위에 대한 조건을 제시할 때 사용한다.
        - 비교대상컬럼 값이 하한값 이상이고, 상한값 이하인 경우 TRUE를 리턴한다.
*/

SELECT EMP_ID "사번", EMP_NAME "직원명", DEPT_CODE "부서 코드", SALARY "급여"
FROM EMP
-- WHERE 비교대상컬럼 BETWEEN 하한값 AND 상한값
WHERE   SALARY BETWEEN 3500000 AND 6000000;

-- EMP 테이블에서 입사일 '90/01/01' ~ '01/01/01'인 사원의 모든 칼럼 조회
SELECT *
FROM EMP
WHERE HIRE_DATE BETWEEN '1990/01/01' AND '2001/01/01';

/*
    <LIKE>
        [표현법]
            WHERE 비교대상컬럼 LIKE '특정 패턴';
            
        - 비교하려는 컬럼 값이 지정된 특정 패턴에 만족할 경우 TRUE를 리턴한다.
        - 특정 패턴에는 '%', '_'를 와일드카드로 사용할 수 있다.
          '%' : 0글자 이상
            ex) 시작하는 - 비교대상컬럼 LIKE '문자%'  => 비교대상컬럼 값 중에 '문자'로 시작하는 모든 행을 조회한다.
                끝나는 - 비교대상컬럼 LIKE '%문자'  => 비교대상컬럼 값 중에 '문자'로 끝나는 모든 행을 조회한다.
                포함하는 - 비교대상컬럼 LIKE '%문자%' => 비교대상컬럼 값 중에 '문자'가 포함되어 있는 모든 행을 조회한다.
                
          '_' : 1글자
            ex) 비교대상컬럼 LIKE '_문자'  => 비교대상컬럼 값 중에 '문자'앞에 무조건 한 글자가 오는 모든 행을 조회한다.
                비교대상컬럼 LIKE '__문자' => 비교대상컬럼 값 중에 '문자'앞에 무조건 두 글자가 오는 모든 행을 조회한다.
*/

-- EMP 테이블에서 성이 '전'씨인 사원의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMP
WHERE EMP_NAME LIKE '전%';

-- EMP 테이블에서 이름중에 '하'가 포함된 사원의 사원명, 주민번호, 부서코드 조회
SELECT EMP_NAME, EMP_NO, DEPT_CODE
FROM EMP
WHERE EMP_NAME LIKE '%하%';
-- EMP 테이블에서 전화번호 4번째 자리가 9로 시작하는 사원의 사번, 사원명, 전화번호, 이메일 조회
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMP
WHERE PHONE LIKE '___9%';
-- EMP 테이블에서 이메일 중 _ 앞 글자가 3자리인 이메일 주소를 가진 사원의 사번 사원명, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMP
-- WHERE EMAIL LIKE '____%'; -- 와일드카드와 문자가 구분X
-- 데이터로 처리할 값 앞에 임의의 문자를 제시하고 임의의 문자를 ESCAPE 옵션에 등록한다.
WHERE EMAIL LIKE '___$_%' ESCAPE '$';

-- EMP테이블에서 김씨 성이 아닌 직원 사번, 사원명, 입사일 조회
-- NOT 컬럼이름 LIKE ''
SELECT *
FROM EMP
WHERE NOT EMP_NAME LIKE '김%';

------------------- 실습 문제 -------------------
-- 1. EMP 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMP
WHERE NOT PHONE LIKE '010%';
-- 2. DEPT 테이블에서 해외영업부에 대한 모든 컬럼 조회
SELECT * FROM DEPT;

SELECT *
FROM DEPT
WHERE DEPT_TITLE LIKE '해외영업%';

-- 현재 날짜 형식 출력포맷 확인
SELECT * 
FROM NLS_SESSION_PARAMETERS 
WHERE PARAMETER = 'NLS_DATE_FORMAT';

-- 날짜형식 출력포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- 날짜 형식으로 자동 변환되어 조회
-- '2000/01/01'. '2000-01-01'
SELECT * FROM EMP
WHERE HIRE_DATE >= '2000-01-01';

/*
    <IS NULL / IS NOT NULL>
        [표현법]
            WHERE 비교대상컬럼 IS [NOT] NULL;
            
        - 컬럼 값에 NULL이 있을 경우 NULL 값 비교에 사용된다.
          IS NULL : 비교대상컬럼 값이 NULL인 경우 TRUE를 리턴한다.
          IS NOT NULL : 비교대상컬럼 값이 NULL이 아닌 경우 TRUE 리턴한다.
*/
-- 보너스를 받고있는 사람을 조회
SELECT *
FROM EMP
WHERE BONUS IS NOT NULL;
-- 사원명, 보너스율
SELECT EMP_NAME, BONUS
FROM EMP
WHERE BONUS IS NOT NULL;
-- 보너스를 받지 못하는 사람을 조회
SELECT EMP_NAME, BONUS
FROM EMP
WHERE BONUS IS NULL;
-- EMP 테이블에서 관리자(사수)가 없는 사원 이름, 부서 코드 조회 
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE MANAGER_ID IS NULL;
-- EMP 테이블에서 부서 배치를 받진 않았지만 보너스는 받는 사원의 사원명, 부서 코드, 보너스 조회
SELECT EMP_NAME, DEPT_CODE, BONUS
FROM EMP
WHERE DEPT_CODE IS NULL
AND BONUS IS NOT NULL;

/*
    <IN>
        [표현법]
            WHERE 비교대상컬럼 IN('값', '값', '값', ..., '값');
        
        - 값 목록 중에 일치하는 값이 있을 때 TRUE 리턴한다.
*/
-- EMP테이블에서 D5부서원들과 D6부서원들, D8부서원들의 사원명, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMP
/*WHERE DEPT_CODE = 'D5'
OR    DEPT_CODE = 'D6'
OR    DEPT_CODE = 'D8';
*/
WHERE DEPT_CODE IN ('D5', 'D6', 'D8');

-- EMP 테이블에서 직급 코드가 J2 또는 J7 직급인 사원들 중 
-- 급여가 200만원 이상인 사원들의 모든 컬럼 조회
SELECT *
FROM EMP
WHERE JOB_CODE IN ('J2', 'J7')
AND SALARY >= '2000000';

/*
    <ORDER BY>
        [표현법]
            SELECT 컬럼, 컬럼, ..., 컬럼
            FROM 테이블명
            WHERE 조건식
            ORDER BY 정렬시키고자 하는 컬럼명|별칭|컬럼 순번 [ASC|DESC] [NULLS FIRST | NULLS LAST];
          
        - SELECT 문에서 가장 마지막에 기입하는 구문으로 실행 또한 가장 마지막에 진행된다.
        - ASC : 오름차순으로 정렬한다. (DEFAULT)
        - DESC : 내림차순으로 정렬한다.
        - NULLS FIRST : 정렬하고자 하는 컬럼 값에 NULL이 있는 경우 해당 데이터 값을 맨 앞으로 정렬한다.
        - NULLS LAST : 정렬하고자 하는 컬럼 값에 NULL이 있는 경우 해당 데이터 값을 맨 뒤로 정렬한다. (DEFAULT)
*/

SELECT BONUS FROM EMP ORDER BY BONUS NULLS FIRST;

-- EMP 테이블에서 BONUS로 내림차순 정렬(단, BONUS 값이 일치할 경우 그때는 SALARY 가지고 오름차순정렬)
SELECT EMP_NAME 사원명, BONUS 보너스, SALARY 급여
FROM EMP
-- ORDER BY BONUS DESC, SALARY; --컬럼명을 이용
-- WHERE 조건절에서는 컬럼의 별칭이나 순서를 사용할수 없다
-- ORDER BY 2 DESC, 3;          -- 조회되는 컬럼의 순서로
ORDER BY 보너스 DESC, 급여 NULLS LAST; -- 별칭을 이용