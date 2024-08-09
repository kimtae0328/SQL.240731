--�� ���б� ��ũ�� ����
--SQL03_SELECT(Option)

-- 1��
-- �л��̸��� �ּ����� ǥ���Ͻÿ�. ��, ��� ����� "�л� �̸�", "�ּ���"�� �ϰ�, ������ �̸����� �������� ǥ���ϵ��� �Ѵ�.
SELECT STUDENT_NAME �л��̸�, STUDENT_ADDRESS �ּ���
FROM TB_STUDENT
ORDER BY STUDENT_NAME ASC;

-- 2��
-- �������� �л����� �̸��� �ֹι�ȣ�� ���̰� ���� ������ ȭ�鿡 ����Ͻÿ�
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY GET_AGE(STUDENT_SSN);



-- 3��
-- �ּ����� �������� ��⵵�� �л��� �� 1900��� �й��� ���� �л����� �̸��� �й�, �ּҸ� �̸��� ������������ ȭ�鿡 ����Ͻÿ�.
-- ��, ���������� "�л��̸�", "�й�", "������ �ּ�"�� ��µǵ��� �Ѵ�.
SELECT STUDENT_NAME �л��̸�, STUDENT_NO �й�, STUDENT_ADDRESS �������ּ�
FROM TB_STUDENT
WHERE 
        SUBSTR(STUDENT_ADDRESS, 1, 2) IN ('���', '����')
-- (STUDENT_ADDRESS LIKE '���%'
-- OR    STUDENT_ADDRESS NOT LIKE '����%')
AND STUDENT_NO NOT LIKE 'A%'
ORDER BY STUDENT_NAME ASC;


-- 4��
-- ���� ���а� ���� �� ���� ���̰� ���� ������� �̸��� Ȯ���� �� �ִ� SQL ������ �ۼ��Ͻÿ�.
-- (���а��� '�а� �ڵ�'�� �а� ���̺��� ��ȸ�ؼ� ã�� ������ ����)
SELECT *
FROM TB_PROFESSOR P, TB_DEPARTMENT D
WHERE P.DEPARTMENT_NO = D.DEPARTMENT_NO
AND DEPARTMENT_NAME = '���а�'
ORDER BY GET_AGE(PROFESSOR_SSN) DESC;

-- ANSI
SELECT PROFESSOR_NAME, GET_AGE(PROFESSOR_SSN), D.DEPARTMENT_NO
FROM TB_PROFESSOR P
-- �÷����� ������ ���, USING Ű���带 �̿�
-- USING Ű���� �̿�� ���̺���� ����� ��� ����
-- USING ���� �� �κ��� �ĺ��ڸ� ������ ����
JOIN TB_DEPARTMENT D USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '���а�'
ORDER BY GET_AGE(PROFESSOR_SSN) DESC;

-- 5��
-- 2004�� 2�б⿡ 'C3118100' ������ ������ �л����� ������ ��ȸ�Ϸ��� �Ѵ�. 
-- ������ ���� �л����� ǥ���ϰ�,
-- ������ ������ �й��� ���� �л����� ǥ���ϴ� ������ �ۼ��� ���ÿ�.
-- 9 : ��ȿ�� ���ڸ� ���
-- 99 : 2�ڸ� ���ڷ� ǥ���ؾ� ������ ���ڸ� ������ ��� ���ڸ��� ǥ��
SELECT STUDENT_NO, TO_CHAR(POINT, '99.99') "9", TO_CHAR(POINT, '09.99') "0"
FROM TB_GRADE
WHERE TERM_NO = '200402'
AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;



-- 6��
-- �л� ��ȣ, �л� �̸�, �а� �̸��� �л� �̸����� �������� �����Ͽ� ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT S, TB_DEPARTMENT D
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
ORDER BY STUDENT_NAME;

-- 7��
-- �� ������б��� ���� �̸��� ������ �а� �̸��� ����ϴ� SQL������ �ۼ��Ͻÿ�.
SELECT CLASS_NAME �����, DEPARTMENT_NAME �а�
FROM TB_CLASS C, TB_DEPARTMENT D
WHERE C.DEPARTMENT_NO = D.DEPARTMENT_NO;

-- 8��
-- ���� ���� �̸��� ã������ �Ѵ�. ���� �̸��� ���� �̸��� ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT PROFESSOR_NAME ������, CLASS_NAME ����
FROM TB_CLASS C, TB_PROFESSOR P, TB_CLASS_PROFESSOR CP
WHERE C.CLASS_NO = CP.CLASS_NO
AND P.PROFESSOR_NO = CP.PROFESSOR_NO;

SELECT SUM(COUNT(*))
FROM TB_PROFESSOR P, TB_CLASS_PROFESSOR CP
WHERE P.PROFESSOR_NO = CP.PROFESSOR_NO
GROUP BY P.PROFESSOR_NO
ORDER BY P.PROFESSOR_NO;

-- 9��
-- 8���� ��� �� '�ι� ��ȸ' �迭�� ���� ������ ���� �̸��� ã������ �Ѵ�.
-- �̿� �ش��ϴ� ���� �̸��� ���� �̸��� ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT PROFESSOR_NAME ������
FROM TB_CLASS C, TB_PROFESSOR P, TB_CLASS_PROFESSOR CP, TB_DEPARTMENT D
WHERE C.CLASS_NO = CP.CLASS_NO
AND P.PROFESSOR_NO = CP.PROFESSOR_NO
AND P.DEPARTMENT_NO = D.DEPARTMENT_NO
AND D.CATEGORY = '�ι���ȸ'
GROUP BY P.PROFESSOR_NO, PROFESSOR_NAME;

SELECT PROFESSOR_NAME
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR CP USING(CLASS_NO) 
JOIN TB_PROFESSOR P USING(PROFESSOR_NO) 
-- TB_CLASS���� ���� �̸��� �÷��� �����Ƿ� ON���� �̿��Ͽ� �÷��� ���
JOIN TB_DEPARTMENT D ON (P.DEPARTMENT_NO = D.DEPARTMENT_NO) 
WHERE D.CATEGORY = '�ι���ȸ'
GROUP BY PROFESSOR_NO, PROFESSOR_NAME
ORDER BY 1;
--------------------------------------------------------
SELECT * FROM TB_DEPARTMENT WHERE CATEGORY = '�ι���ȸ';
                        
-- 10��
-- '�����а�' �л����� ������ ���Ϸ��� �Ѵ�. 
-- �����а� �л����� "�й�", "�л� �̸�", "��ü ����"�� ����ϴ� SQL ������ �ۼ��Ͻÿ�.
-- (��, ������ �Ҽ��� 1�ڸ������� �ݿø��Ͽ� ǥ���Ѵ�.)
SELECT S.STUDENT_NO �й�, STUDENT_NAME �̸�, ROUND(AVG(POINT), 1) ����
FROM TB_DEPARTMENT D, TB_STUDENT S, TB_GRADE G
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
AND S.STUDENT_NO = G.STUDENT_NO
AND DEPARTMENT_NAME = '�����а�'
GROUP BY S.STUDENT_NO, STUDENT_NAME
ORDER BY S.STUDENT_NO;

-- ANSI
SELECT S.STUDENT_NO �й�, STUDENT_NAME �̸�, ROUND(AVG(POINT), 1) ����
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
JOIN  TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO) 
WHERE DEPARTMENT_NAME = '�����а�'
GROUP BY S.STUDENT_NO, STUDENT_NAME
ORDER BY S.STUDENT_NO;

-- 11��
-- �й��� A313047�� �л��� �б��� ������ ���� �ʴ�. ���� �������� ������ �����ϱ� ���� 
-- �а� �̸�, �л� �̸��� ���� ���� �̸��� �ʿ��ϴ�.
-- �̶� ����� SQL���� �ۼ��Ͻÿ�.
SELECT DEPARTMENT_NAME �а�, STUDENT_NAME �л�, PROFESSOR_NAME ��������
FROM TB_DEPARTMENT D, TB_STUDENT S, TB_PROFESSOR P
WHERE D.DEPARTMENT_NO = S.DEPARTMENT_NO
AND S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
AND STUDENT_NO = 'A313047';

-- 12��
-- 2007�⵵�� '�ΰ������' ������ ������ �л��� ã�� 
-- �л��̸��� �����б⸦ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT S, TB_CLASS C, TB_GRADE G
WHERE C.CLASS_NO = G.CLASS_NO
AND G.STUDENT_NO = S.STUDENT_NO
AND G.TERM_NO LIKE '2007%'
AND C.CLASS_NO = 'C2604100';

-- 13��
-- ��ü�� �迭 ���� �� ���� ��米���� �� �� �������� ���� ������ ã��
-- = TB_CLASS_PROFESSOR�� ������ ��ϵ��� ���� ���
-- LEFT JOIN(�ܺ�����)�� �̿��ؼ� ���ǿ� ��ġ���� �ʴ� �����͸� ã�ƾ� ��
-- �� ���� �̸��� �а� �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�.
-- ��� ���� ���� �����ϳ� ���� ������ ���� �ٸ� ������ ����
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS C, TB_DEPARTMENT D, TB_CLASS_PROFESSOR CP
WHERE C.DEPARTMENT_NO = D.DEPARTMENT_NO
AND C.CLASS_NO = CP.CLASS_NO(+)
AND CATEGORY = '��ü��'
AND PROFESSOR_NO IS NULL;

-- 14��
-- �� ������б� ���ݾƾ��а� �л����� ���������� �Խ��ϰ��� �Ѵ�. 
-- �л��̸��� �������� �̸��� ã�� ���� ���� ������ ���� �л��� ���
-- "�������� ������"���� ǥ���ϵ��� �ϴ� SQL ���� �ۼ��Ͻÿ�. 
-- �� �������� "�л��̸�", "��������"�� ǥ���ϸ� ���й� �л��� ���� ǥ�õǵ��� �Ѵ�.
SELECT STUDENT_NAME �л�, NVL(COACH_PROFESSOR_NO, '������') ��������
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '���ݾƾ��а�'
ORDER BY STUDENT_NO DESC;


-- 15��
-- ���л��� �ƴ� �л� �� ������ 4.0 �̻��� �л��� ã�� 
-- �� �л��� �й�, �̸�, �а�, �̸�, ������ ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�, DEPARTMENT_NAME, ROUND(AVG(POINT), 1) ����
FROM TB_STUDENT S
JOIN TB_GRADE USING (STUDENT_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY STUDENT_NO;



-- 16��
-- ȯ�������а� ����������� ���� �� ������ �ľ��� �� �ִ� SQL ���� �ۼ��Ͻÿ�.
SELECT CLASS_NAME ����, ROUND(AVG(POINT), 1) ����
FROM TB_CLASS
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (CLASS_NO)
WHERE CLASS_TYPE LIKE '����%'
AND DEPARTMENT_NAME = 'ȯ�������а�'
GROUP BY CLASS_NAME
;
-- 17��
-- �� ������б��� �ٴϰ� �ִ� �ְ��� �л��� ���� �� �л����� �̸��� �ּҸ� ����ϴ� SQL ���� �ۼ��Ͻÿ�.
SELECT DEPARTMENT_NO, STUDENT_NAME �̸�, STUDENT_ADDRESS �ּ�
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                        FROM TB_STUDENT
                        WHERE STUDENT_NAME = '�ְ���');
-- 18��
-- ������а����� �������� ���� ���� �л��� �̸��� �й��� ǥ���ϴ� SQL���� �ۼ��Ͻÿ�
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (STUDENT_NO)
WHERE DEPARTMENT_NAME = '������а�'
GROUP BY STUDENT_NO, STUDENT_NAME
HAVING SUM(POINT) =
                    (SELECT MAX(SUM(POINT))
                    FROM TB_DEPARTMENT
                    JOIN TB_STUDENT USING (DEPARTMENT_NO)
                    JOIN TB_GRADE USING (STUDENT_NO)
                    WHERE DEPARTMENT_NAME = '������а�'
                    GROUP BY STUDENT_NO);

-- 19��
-- �� ������б��� "ȯ�������а�"�� ���� ���� �迭 �а����� 
-- �а� �� �������� ������ �ľ��ϱ� ���� ������ SQL���� ã�Ƴ��ÿ�.
-- ��, �������� "�迭 �а���", "��������"���� ǥ�õǵ��� �ϰ�, 
-- ������ �Ҽ��� ���ڸ������� �ݿø��Ͽ� ǥ�õǵ��� �Ѵ�.