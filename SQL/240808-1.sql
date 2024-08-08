--�� ���б� ��ũ�� ����
--SQL02_SELECT(Function)

-- 1��
-- ������а�(�а��ڵ� 002) �л����� �й��� �̸�, ���� �⵵�� ���� �⵵�� ���� ������ ǥ���ϴ� SQL������ �ۼ��Ͻÿ�.
-- (��, ����� "�й�", "�̸�", "���г⵵" �� ǥ�õǵ��� �Ѵ�.)
SELECT STUDENT_NO, STUDENT_NAME, ENTRANCE_DATE
FROM TB_STUDENT S, TB_DEPARTMENT D
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
AND DEPARTMENT_NAME = '������а�'
ORDER BY ENTRANCE_DATE;

-- 2��
-- �� ������б��� ���� �� �̸��� �� ���ڰ� �ƴ� ������ �� �� �ִٰ� �Ѵ�. �� ������ �̸��� �ֹι�ȣ�� ȭ�鿡 ����ϴ� SQL������ �ۼ��غ���.
-- (*�̶� �ùٸ��� �ۼ��� SQL ������ ��� ���� ����� �ٸ��� ���� �� �ִ�. ������ �������� �����غ� ��) 
SELECT PROFESSOR_NAME, LENGTH(PROFESSOR_NAME)
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3;

SELECT PROFESSOR_NAME, LENGTH(PROFESSOR_NAME)
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';
-- 3��
-- �� ������б��� ���� �������� �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�. �� �̶� ���̰� ���� ������� ���� ��� ����
-- (���̰� ���ٸ� �̸��� ������ ����)�� ȭ�鿡 ��µǵ��� ����ÿ�.
-- (��, ���� �� 2000�� ���� ����ڴ� ������ ��� ����� "�����̸�"���� �Ѵ�. ���̴� '��'���� ����Ѵ�.)
-- ���� ���� ���� ��� �� �ٸ� �� �����Ƿ� PROFESSOR_SSN ���� SELECT �ؼ� Ȯ���غ���!!
SELECT PROFESSOR_SSN �ֹε�Ϲ�ȣ
            ,TO_CHAR(SYSDATE, 'YYYY') - ('19' || SUBSTR(PROFESSOR_SSN, 1, 2)) + 1 ����
FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME �����̸�
            ,TO_CHAR(SYSDATE, 'YYYY') - ('19' || SUBSTR(PROFESSOR_SSN, 1, 2)) + 1 ����
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) IN (1, 3)
ORDER BY ����, 1 DESC;



SELECT PROFESSOR_NAME �����̸�, PROFESSOR_SSN �ֹι�ȣ
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = 1
ORDER BY PROFESSOR_SSN DESC;

SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(2023, 'YYYY')) / 12)
FROM DUAL;

-- 4��
-- �������� �̸� �� ���� ������ �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�. ��� ����� "�̸�"�� �������� �Ѵ�.
-- (���� 2���� ����� ������ ���ٰ� �����Ͻÿ�)
SELECT SUBSTR(PROFESSOR_NAME, 2) �̸�
FROM TB_PROFESSOR;

-- 5��
-- �� ������б��� ����� ������ �й��� �̸��� ǥ���Ͻÿ�.(�̶�, 19�쿡 �����ϸ� ����� ���� ���� ������ ����)
-- �������� �䱸�ϴ� ������ ������ ������� ��� ������ ������� �߷����� �� (������� ������ ����� 245��)
-- 0301���� ������ �л��� ���ܽ�Ű�� ���� 19 �ʰ� 20 ���϶�� ���ǽ� ���
-- ���г⵵ - ź���⵵
SELECT * FROM (SELECT ENTRANCE_DATE ���г⵵
                    , GET_AGE(STUDENT_SSN) ����
                    , TO_CHAR(ENTRANCE_DATE, 'YYYY')
                - (DECODE(SUBSTR(STUDENT_SSN, 8, 1),1 ,19, 2, 19, 3, 20, 4, 20) 
                || SUBSTR(STUDENT_SSN, 1, 2)) + 1 ���г��� 
FROM TB_STUDENT)
WHERE ���г��� = 20;

SELECT TO_CHAR(SYSDATE, 'YYYY')
- (DECODE(SUBSTR(PROFESSOR_SSN, 8, 1),1 ,19, 2, 19, 3, 20, 4, 20) || SUBSTR(PROFESSOR_SSN, 1, 2)) ����
FROM DUAL;


SELECT GET_AGE('111129-3411133')
FROM DUAL;

-- 6��
-- 2024�� ũ���������� ���� �����ΰ�?
--'DAY': �ݿ��� 'DY': �� 'D': 6
SELECT TO_CHAR(TO_DATE ('20241225'), 'DAY') FROM DUAL;
SELECT '2024-12-25' FROM DUAL;
-- 8��
-- �� ������б��� 2000�⵵ ���� �����ڵ��� �й��� A�� �����ϰ� �Ǿ��ִ�. 
-- 2000�⵵ ���� �й��� ���� �л����� �й��� �̸��� �����ִ� SQL ������ �ۼ��Ͻÿ�.
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_NO, 1, 1) != 'A';

-- 9��
-- �й��� A517178�� �ѾƸ� �л��� ���� �� ������ ���ϴ� SQL���� �ۼ��Ͻÿ�.
-- ��, �̶� ��� ȭ���� ����� "����"�̶�� ������ �ϰ�, ������ �ݿø��Ͽ� �Ҽ��� ���� ���ڸ������� ǥ���Ѵ�.
SELECT ROUND(AVG(POINT), 2) �������
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

-- 10��
-- �а��� �л� ���� ���Ͽ� "�а���ȣ", "�л���(��)"�� ���·� ����� ����� ������� ��µǵ��� �Ͻÿ�.
SELECT DEPARTMENT_NO �а���ȣ, COUNT(*) || '��' "�л���"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO;

-- 11��
-- ���� ������ �������� ���� �л��� ���� �� �� ���� �Ǵ��� �˾Ƴ��� SQL���� �ۼ��Ͻÿ�
SELECT *
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12��
-- �й��� A112113�� ���� �л��� �⵵ �� ������ ���ϴ� SQL���� �ۼ��Ͻÿ�.
-- ��, �̶� ���ȭ���� ����� "�⵵", "�⵵ �� ����"�̶�� ������ �ϰ�, ������ �ݿø��Ͽ� �Ҽ��� ���� ���ڸ������� ǥ���Ѵ�.
SELECT ROUND(POINT) �⵵������
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113';

-- 13��
-- �а� �� ���л� ���� �ľ��ϰ��� �Ѵ�. �а� ��ȣ�� ���л� ���� ǥ���ϴ� SQL������ �ۼ��Ͻÿ�.

-- COUNT(DECODE(ABSENCE_YN, 'Y', 1, NULL)) �� �ο�����
-- ���� ABSENCE_YN�� ���� 'Y'���� ��� COUNT(1)�� �Ǿ� ������ ���� �ǰ�
--     ABSENCE_YN�� ���� 'Y'�� �ƴϿ��� ��� COUNT(NULL)�� �Ǿ� ������ ���� �ʰԵǴ� ����!!

-- 14��
-- �� ���б��� �ٴϴ� �������� �л����� �̸��� ã���� �Ѵ�.
-- � SQL ������ ����ϸ� �����ϰڴ°�?

-- 15��
-- �й��� A112113�� ���� �л��� �⵵, �б� �� ������ �⵵ �� ���� ����, �� ������ ���ϴ� SQL���� �ۼ��Ͻÿ�.
-- (��, ������ �Ҽ��� 1�ڸ������� �ݿø��Ͽ� ǥ���Ѵ�.)