/*
    <함수>
        컬럼값을 읽어서 계산 결과를 반환한다.
          - 단일행 함수 : N개의 값을 읽어서 N개의 결과를 리턴한다. (매 행 함수 실행 -> 결과 반환)
          - 그룹 함수   : N개의 값을 읽어서 1개의 결과를 리턴한다. (하나의 그룹별로 함수 실행 -> 결과 반환)
        SELECT 절에 단일행 함수와 그룹 함수를 함께 사용하지 못한다. (결과 행의 개수가 다르기 때문에)
        함수를 기술할 수 있는 위치는 SELECT, WHERE, ORDER BY, GROUP BY, HAVING 절에 기술할 수 있다.
        (FROM절에는 테이블이름이 기술되므로 사용 할 수 없다)
*/

-- 단일행 함수
/*
    <문자관련 함수>
    1) LENGTH : 글자수를 반환
       LENGTHB : 글자의 바이트수를 반환
       한글은 한글자당 3BYTE(지정된 문자셋에 따라 다를수 있음)
       영어, 숫자, 특수문자 1BYTE       
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM   DUAL;

SELECT SYSDATE
FROM DUAL;

/*
    DUAL 테이블
    - SYS 사용자가 소유하는 테이블
    - SYS 사용자가 소유하지만 모든 사용자가 접근 할 수 있다
    - 하나의 행, 하나의 컬럼을 가지고 있는 더미 테이블이다
    - 사용자가 함수를 계산하거나 오늘 날자를 출력할때 임시로 사용되는 테이블
*/

/*
    2) INSTR
        - INSTR(컬럼|'문자값', '문자'[, POSITION[, OCCURRENCE]])
        - 지정한 위치부터 지정된 숫자 번째로 나타나는 문자의 시작 위치를 반환한다.
*/
-- 첫번째 나오는 B의 위치를 반환
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;       
-- 두번째 나오는 B의 위치를 반환
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL; 
-- 세번째 나오는 B의 위치를 반환
SELECT INSTR('AABAACAABBAA', 'B', 1, 3) FROM DUAL; 
-- 뒤에서부터 첫번째로 나오는 B의 위치를 반환
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
-- 뒤에서부터 두번째 나오는 B의 위치를 반환
SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', -1, 3) FROM DUAL;
-- 문자열이 없는경우 0을 반환
SELECT INSTR('AABAACAABBAA', 'K', -1) FROM DUAL;

-- 주민등록번호의 '-' 위치
-- 이메일의 @의 위치
SELECT EMAIL, INSTR(EMAIL, '@'), EMP_NO, INSTR(EMP_NO, '-') FROM EMP;

/*
    3) SUBSTR
        - SUBSTR(컬럼|'문자값', POSITION[, LENGTH])
        - 문자데이터에서 지정한 위치부터 지정한 개수만큼의 문자열을 추출해서 반환한다.
*/
-- SUBSTR (컬럼명, 시작위치, 글자수)
SELECT SUBSTR('SHOW ME THE MONEY', 7)
FROM DUAL;
SELECT SUBSTR('SHOW ME THE MONEY', 5, 2)
FROM DUAL;
SELECT SUBSTR('SHOW ME THE MONEY', -9, 3)
FROM DUAL;
-- O 또는 1을 넣으면 첫번재 문자부터 가지고 나옴
SELECT SUBSTR('쇼우 미 더 머니', 1, 2)
FROM DUAL;

-- sun_di@or.kr -> 아이디@도메인
-- 1) INSTR 함수를 이용해서 @의 위치를 확인
SELECT EMAIL, INSTR(EMAIL, '@'), INSTR(EMAIL, '@')-1 FROM EMP;
SELECT SUBSTR(EMAIL, 1, INSTR(EMAIL,'@'))
, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1) -- ID
, SUBSTR(EMAIL, INSTR(EMAIL, '@') +1) -- 도메인
FROM EMP;
-- 2) SUBSTR 함수를 이용해서 문자열을 추출(시작위치, 문자의 갯수)
-- 사원 테이블의 주민등록 번호의 뒷번호 1번째 자리까지 추출
-- 621235-1985634 -> 621235-1******
SELECT EMP_NO, SUBSTR(EMP_NO, INSTR(EMP_NO, '-') + 1, 1) || '******'
        ,SUBSTR(EMP_NO, INSTR(EMP_NO, '-') + 1, 1) || '******'
        ,SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') + 1) || '******'
FROM EMP;

-- 사원테이블에서 여자사원의 모든컬럼을 조회 하세요
SELECT EMP_NAME, EMP_NO
FROM EMP
-- WHERE SUBSTR(EMP_NO, INSTR(EMP_NO, '-') + 1, 1) IN (2, 4);
WHERE SUBSTR(EMP_NO, 8, 1) IN (2, 4);
-- 부서테이블에서 부서코드가 D1, D2, D3인 부서만 조회 하세요
SELECT INSTR('D1|D2|D3', DEPT_ID)
FROM DEPT
-- WHERE DEPT_ID = 'D1'
-- OR DEPT_ID = 'D2'
-- OR DEPT_ID = 'D3';
-- WHERE DEPT_ID IN ('D1', 'D2', 'D3');
WHERE INSTR('D1|D2|D3', DEPT_ID) > 0;

/*
    4) LPAD/RPAD
    - LPAD/RPAD(값, 길이)[, '덧붙이려고 하는 문자']
    - 제시된 값에 임의의 문자를 왼쪽 또는 오른쪽에
      붙여 최종 N길이 만큼 문자열을 반환
    - 문자를 통일감있게 표시하고자 할때 사용
*/
-- 20만큼의 길이중 EMAIL은 오른쪽으로 정렬, 공백은 왼쪽으로 채움
-- 왼쪽공백
SELECT EMAIL, LPAD(EMAIL, 20)
FROM EMP;
-- 오른쪽공백
SELECT EMAIL, RPAD(EMAIL, 20)
FROM EMP;
-- 길이가 짧으면 지정된 자릿수만큼만 출력
-- 공백 또는 지정한 문자로 빈 공간을 채워줌
SELECT EMAIL, LPAD(EMAIL, 20, '*'), RPAD(EMAIL, 20, '$'), RPAD(EMAIL, 2)
FROM EMP;
-- 사원테이블에서 주민등록번호의 뒤 1자리까지 추출하고 오른쪽에 *문자를 채워서 출력
SELECT EMP_NO, SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') + 1) || '******'
FROM EMP;

/*
    5) LOWER / UPPER / INITCAP
    - LOWER|UPPER|INITCAP (컬럼|'문자값')
     LOWER : 모두 소문자로 변경
     UPPER : 모두 대문자로 변경
     INITCAP : 단어 앞 글자마다 대문자로 변경
*/

SELECT LOWER('ABCD'), UPPER('abcd'), INITCAP('abcd abcd')
FROM DUAL;

/* 6) CONCAT 
   - CONCAT(컬럼|'문자열', 컬럼|'문자열') == ||
   - 문자데이터 두개를 전달 받아서 하나로 합친후 결과를 반환
*/

-- 인수는 2개만 넣을수있음
-- > 3개이상 넣을경우 인수의 갯수가 부적합합니다 오류발생

SELECT CONCAT('hello', 'world')
FROM DUAL;

/*
    7) REPLACE : 치환, 바꾸기
    - REPLACE(컬럼|'문자값', 변경하려는 문자, 변경하고자 하는 문자)
    - 컬럼, 문자값에서 변경하고자 하는 문자를 변경하려는 문자로 변경하여 반환
*/

SELECT replace('서울시 강남구 역삼동', '역삼동', '삼성동')
FROM DUAL;

-- OR.KR > GMAIL.COM 으로 변경
SELECT EMP_NAME, EMAIL, replace(EMAIL, 'or.kr', 'gmail.com')
FROM EMP;