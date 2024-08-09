--춘 대학교 워크북 과제
--SQL03_SELECT(Option)

-- 1번
-- 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.
SELECT STUDENT_NAME 학생이름, STUDENT_ADDRESS 주소지
FROM TB_STUDENT
ORDER BY STUDENT_NAME ASC;

-- 2번
-- 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY GET_AGE(STUDENT_SSN);



-- 3번
-- 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오.
-- 단, 출력헤더에는 "학생이름", "학번", "거주지 주소"가 출력되도록 한다.
SELECT STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS 거주지주소
FROM TB_STUDENT
WHERE 
        SUBSTR(STUDENT_ADDRESS, 1, 2) IN ('경기', '강원')
-- (STUDENT_ADDRESS LIKE '경기%'
-- OR    STUDENT_ADDRESS NOT LIKE '강원%')
AND STUDENT_NO NOT LIKE 'A%'
ORDER BY STUDENT_NAME ASC;


-- 4번
-- 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오.
-- (법학과의 '학과 코드'는 학과 테이블을 조회해서 찾아 내도록 하자)
SELECT *
FROM TB_PROFESSOR P, TB_DEPARTMENT D
WHERE P.DEPARTMENT_NO = D.DEPARTMENT_NO
AND DEPARTMENT_NAME = '법학과'
ORDER BY GET_AGE(PROFESSOR_SSN) DESC;

-- ANSI
SELECT PROFESSOR_NAME, GET_AGE(PROFESSOR_SSN), D.DEPARTMENT_NO
FROM TB_PROFESSOR P
-- 컬럼명이 동일한 경우, USING 키워드를 이용
-- USING 키워드 이용시 테이블명을 명시할 경우 오류
-- USING 절의 열 부분은 식별자를 가질수 없음
JOIN TB_DEPARTMENT D USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '법학과'
ORDER BY GET_AGE(PROFESSOR_SSN) DESC;

-- 5번
-- 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
-- 학점이 높은 학생부터 표시하고,
-- 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해 보시오.
-- 9 : 유효한 숫자만 출력
-- 99 : 2자리 숫자로 표현해야 하지만 한자리 숫자인 경우 한자리만 표시
SELECT STUDENT_NO, TO_CHAR(POINT, '99.99') "9", TO_CHAR(POINT, '09.99') "0"
FROM TB_GRADE
WHERE TERM_NO = '200402'
AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;



-- 6번
-- 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL문을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT S, TB_DEPARTMENT D
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
ORDER BY STUDENT_NAME;

-- 7번
-- 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL문장을 작성하시오.
SELECT CLASS_NAME 과목명, DEPARTMENT_NAME 학과
FROM TB_CLASS C, TB_DEPARTMENT D
WHERE C.DEPARTMENT_NO = D.DEPARTMENT_NO;

-- 8번
-- 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL문을 작성하시오.
SELECT PROFESSOR_NAME 교수명, CLASS_NAME 과목
FROM TB_CLASS C, TB_PROFESSOR P, TB_CLASS_PROFESSOR CP
WHERE C.CLASS_NO = CP.CLASS_NO
AND P.PROFESSOR_NO = CP.PROFESSOR_NO;

SELECT SUM(COUNT(*))
FROM TB_PROFESSOR P, TB_CLASS_PROFESSOR CP
WHERE P.PROFESSOR_NO = CP.PROFESSOR_NO
GROUP BY P.PROFESSOR_NO
ORDER BY P.PROFESSOR_NO;

-- 9번
-- 8번의 결과 중 '인문 사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다.
-- 이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL문을 작성하시오.
SELECT PROFESSOR_NAME 교수명
FROM TB_CLASS C, TB_PROFESSOR P, TB_CLASS_PROFESSOR CP, TB_DEPARTMENT D
WHERE C.CLASS_NO = CP.CLASS_NO
AND P.PROFESSOR_NO = CP.PROFESSOR_NO
AND P.DEPARTMENT_NO = D.DEPARTMENT_NO
AND D.CATEGORY = '인문사회'
GROUP BY P.PROFESSOR_NO, PROFESSOR_NAME;

SELECT PROFESSOR_NAME
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR CP USING(CLASS_NO) 
JOIN TB_PROFESSOR P USING(PROFESSOR_NO) 
-- TB_CLASS에도 같은 이름의 컬럼이 있으므로 ON절을 이용하여 컬럼을 명시
JOIN TB_DEPARTMENT D ON (P.DEPARTMENT_NO = D.DEPARTMENT_NO) 
WHERE D.CATEGORY = '인문사회'
GROUP BY PROFESSOR_NO, PROFESSOR_NAME
ORDER BY 1;
--------------------------------------------------------
SELECT * FROM TB_DEPARTMENT WHERE CATEGORY = '인문사회';
                        
-- 10번
-- '음악학과' 학생들의 평점을 구하려고 한다. 
-- 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오.
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
SELECT S.STUDENT_NO 학번, STUDENT_NAME 이름, ROUND(AVG(POINT), 1) 평점
FROM TB_DEPARTMENT D, TB_STUDENT S, TB_GRADE G
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
AND S.STUDENT_NO = G.STUDENT_NO
AND DEPARTMENT_NAME = '음악학과'
GROUP BY S.STUDENT_NO, STUDENT_NAME
ORDER BY S.STUDENT_NO;

-- ANSI
SELECT S.STUDENT_NO 학번, STUDENT_NAME 이름, ROUND(AVG(POINT), 1) 평점
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
JOIN  TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO) 
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY S.STUDENT_NO, STUDENT_NAME
ORDER BY S.STUDENT_NO;

-- 11번
-- 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 
-- 학과 이름, 학생 이름과 지도 교수 이름이 필요하다.
-- 이때 사용할 SQL문을 작성하시오.
SELECT DEPARTMENT_NAME 학과, STUDENT_NAME 학생, PROFESSOR_NAME 지도교수
FROM TB_DEPARTMENT D, TB_STUDENT S, TB_PROFESSOR P
WHERE D.DEPARTMENT_NO = S.DEPARTMENT_NO
AND S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
AND STUDENT_NO = 'A313047';

-- 12번
-- 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 
-- 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오.
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT S, TB_CLASS C, TB_GRADE G
WHERE C.CLASS_NO = G.CLASS_NO
AND G.STUDENT_NO = S.STUDENT_NO
AND G.TERM_NO LIKE '2007%'
AND C.CLASS_NO = 'C2604100';

-- 13번
-- 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아
-- = TB_CLASS_PROFESSOR에 과목이 등록되지 않은 경우
-- LEFT JOIN(외부조인)을 이용해서 조건에 일치하지 않는 데이터를 찾아야 함
-- 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
-- 결과 행의 수는 동일하나 정렬 기준이 없어 다른 순서를 보임
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS C, TB_DEPARTMENT D, TB_CLASS_PROFESSOR CP
WHERE C.DEPARTMENT_NO = D.DEPARTMENT_NO
AND C.CLASS_NO = CP.CLASS_NO(+)
AND CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL;

-- 14번
-- 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 
-- 학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우
-- "지도교수 미지정"으로 표시하도록 하는 SQL 문을 작성하시오. 
-- 단 출력헤더는 "학생이름", "지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.
SELECT STUDENT_NAME 학생, NVL(COACH_PROFESSOR_NO, '미지정') 지도교수
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO DESC;


-- 15번
-- 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 
-- 그 학생의 학번, 이름, 학과, 이름, 평점을 출력하는 SQL문을 작성하시오.
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, DEPARTMENT_NAME, ROUND(AVG(POINT), 1) 평점
FROM TB_STUDENT S
JOIN TB_GRADE USING (STUDENT_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY STUDENT_NO;



-- 16번
-- 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
SELECT CLASS_NAME 과목, ROUND(AVG(POINT), 1) 평점
FROM TB_CLASS
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (CLASS_NO)
WHERE CLASS_TYPE LIKE '전공%'
AND DEPARTMENT_NAME = '환경조경학과'
GROUP BY CLASS_NAME
;
-- 17번
-- 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오.
SELECT DEPARTMENT_NO, STUDENT_NAME 이름, STUDENT_ADDRESS 주소
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                        FROM TB_STUDENT
                        WHERE STUDENT_NAME = '최경희');
-- 18번
-- 국어국문학과에서 총점수가 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (STUDENT_NO)
WHERE DEPARTMENT_NAME = '국어국문학과'
GROUP BY STUDENT_NO, STUDENT_NAME
HAVING SUM(POINT) =
                    (SELECT MAX(SUM(POINT))
                    FROM TB_DEPARTMENT
                    JOIN TB_STUDENT USING (DEPARTMENT_NO)
                    JOIN TB_GRADE USING (STUDENT_NO)
                    WHERE DEPARTMENT_NAME = '국어국문학과'
                    GROUP BY STUDENT_NO);

-- 19번
-- 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 
-- 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL문을 찾아내시오.
-- 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 
-- 평점은 소수점 한자리까지만 반올림하여 표시되도록 한다.