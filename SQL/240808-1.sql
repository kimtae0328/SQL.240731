--춘 대학교 워크북 과제
--SQL02_SELECT(Function)

-- 1번
-- 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는 SQL문장을 작성하시오.
-- (단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
SELECT STUDENT_NO, STUDENT_NAME, ENTRANCE_DATE
FROM TB_STUDENT S, TB_DEPARTMENT D
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
AND DEPARTMENT_NAME = '영어영문학과'
ORDER BY ENTRANCE_DATE;

-- 2번
-- 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 그 교수의 이름과 주민번호를 화면에 출력하는 SQL문장을 작성해보자.
-- (*이때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇인지 생각해볼 것) 
SELECT PROFESSOR_NAME, LENGTH(PROFESSOR_NAME)
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3;

SELECT PROFESSOR_NAME, LENGTH(PROFESSOR_NAME)
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';
-- 3번
-- 춘 기술대학교의 남자 교수들의 이름을 출력하는 SQL 문장을 작성하시오. 단 이때 나이가 적은 사람에서 많은 사람 순서
-- (나이가 같다면 이름의 가나다 순서)로 화면에 출력되도록 만드시오.
-- (단, 교수 중 2000년 이후 출생자는 없으며 출력 헤더는 "교수이름"으로 한다. 나이는 '만'으로 계산한다.)
-- 실행 월에 따라 결과 값 다를 수 있으므로 PROFESSOR_SSN 같이 SELECT 해서 확인해보기!!
SELECT PROFESSOR_SSN 주민등록번호
            ,TO_CHAR(SYSDATE, 'YYYY') - ('19' || SUBSTR(PROFESSOR_SSN, 1, 2)) + 1 나이
FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME 교수이름
            ,TO_CHAR(SYSDATE, 'YYYY') - ('19' || SUBSTR(PROFESSOR_SSN, 1, 2)) + 1 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) IN (1, 3)
ORDER BY 나이, 1 DESC;



SELECT PROFESSOR_NAME 교수이름, PROFESSOR_SSN 주민번호
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = 1
ORDER BY PROFESSOR_SSN DESC;

SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(2023, 'YYYY')) / 12)
FROM DUAL;

-- 4번
-- 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 출력 헤더는 "이름"이 찍히도록 한다.
-- (성이 2자인 경우의 교수는 없다고 가정하시오)
SELECT SUBSTR(PROFESSOR_NAME, 2) 이름
FROM TB_PROFESSOR;

-- 5번
-- 춘 기술대학교의 재수생 입학자 학번과 이름을 표시하시오.(이때, 19살에 입학하면 재수를 하지 않은 것으로 간주)
-- 문제에서 요구하는 내용은 현역과 삼수생을 모두 제외한 재수생만 추려내는 것 (삼수생도 포함한 결과는 245행)
-- 0301생인 김정현 학생을 제외시키기 위해 19 초과 20 이하라는 조건식 사용
-- 입학년도 - 탄생년도
SELECT * FROM (SELECT ENTRANCE_DATE 입학년도
                    , GET_AGE(STUDENT_SSN) 나이
                    , TO_CHAR(ENTRANCE_DATE, 'YYYY')
                - (DECODE(SUBSTR(STUDENT_SSN, 8, 1),1 ,19, 2, 19, 3, 20, 4, 20) 
                || SUBSTR(STUDENT_SSN, 1, 2)) + 1 입학나이 
FROM TB_STUDENT)
WHERE 입학나이 = 20;

SELECT TO_CHAR(SYSDATE, 'YYYY')
- (DECODE(SUBSTR(PROFESSOR_SSN, 8, 1),1 ,19, 2, 19, 3, 20, 4, 20) || SUBSTR(PROFESSOR_SSN, 1, 2)) 나이
FROM DUAL;


SELECT GET_AGE('111129-3411133')
FROM DUAL;

-- 6번
-- 2024년 크리스마스는 무슨 요일인가?
--'DAY': 금요일 'DY': 금 'D': 6
SELECT TO_CHAR(TO_DATE ('20241225'), 'DAY') FROM DUAL;
SELECT '2024-12-25' FROM DUAL;
-- 8번
-- 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 
-- 2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
SELECT STUDENT_NO 학번, STUDENT_NAME 이름
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_NO, 1, 1) != 'A';

-- 9번
-- 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL문을 작성하시오.
-- 단, 이때 출력 화면의 헤더는 "평점"이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.
SELECT ROUND(AVG(POINT), 2) 평균학점
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

-- 10번
-- 학과별 학생 수를 구하여 "학과번호", "학생수(명)"의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
SELECT DEPARTMENT_NO 학과번호, COUNT(*) || '명' "학생수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO;

-- 11번
-- 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 SQL문을 작성하시오
SELECT *
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12번
-- 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL문을 작성하시오.
-- 단, 이때 출력화면의 헤더는 "년도", "년도 별 평점"이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.
SELECT ROUND(POINT) 년도별학점
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113';

-- 13번
-- 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL문장을 작성하시오.

-- COUNT(DECODE(ABSENCE_YN, 'Y', 1, NULL)) 의 부연설명
-- 만일 ABSENCE_YN의 값이 'Y'였을 경우 COUNT(1)이 되어 갯수를 세게 되고
--     ABSENCE_YN의 값이 'Y'가 아니였을 경우 COUNT(NULL)이 되어 갯수를 세지 않게되는 원리!!

-- 14번
-- 춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다.
-- 어떤 SQL 문장을 사용하면 가능하겠는가?

-- 15번
-- 학번이 A112113인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점, 총 평점을 구하는 SQL문을 작성하시오.
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)