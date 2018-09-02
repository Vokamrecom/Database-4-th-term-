use Mich_BSTU

--1--
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE Inner Join AUDITORIUM
		on AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE;

--2--
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE Inner Join AUDITORIUM
		on AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE
		and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%���������%';

--3-- �� �� �����, �� ��� inner join
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE, AUDITORIUM
		where AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE;

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE, AUDITORIUM
		where AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE
		and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%���������%';

--4--
SELECT  FACULTY.FACULTY_NAME as [���������], 
		PULPIT.PULPIT_NAME as [�������],
		GROUPS.PROFESSION as [�������������],
		SUBJECT.SUBJECT_NAME as [����������],
		STUDENT.NAME as [���],
   Case 
   when ( PROGRESS.NOTE=6) then '�����'
   when ( PROGRESS.NOTE=7) then '����'
   when ( PROGRESS.NOTE=8) then '������'
    end     [������]  
FROM    FACULTY, GROUPS, PULPIT, SUBJECT, STUDENT, PROGRESS
where FACULTY.FACULTY = GROUPS.FACULTY and
		STUDENT.IDGROUP=GROUPS.IDGROUP and
		SUBJECT.PULPIT=PULPIT.PULPIT and
		SUBJECT.SUBJECT = PROGRESS.SUBJECT and
		PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and
		PROGRESS.NOTE between 6 and 8
		order by 
		FACULTY.FACULTY asc 
		--PULPIT.PULPIT asc 
		--SUBJECT.SUBJECT_NAME asc 
		--PROGRESS.NOTE desc
		

--5--
SELECT  FACULTY.FACULTY_NAME as [���������], 
		PULPIT.PULPIT_NAME as [�������],
		GROUPS.PROFESSION as [�������������],
		SUBJECT.SUBJECT_NAME as [����������],
		STUDENT.NAME as [���],
   Case 
   when ( PROGRESS.NOTE=6) then '�����'
   when ( PROGRESS.NOTE=7) then '����'
   when ( PROGRESS.NOTE=8) then '������'
    end     [������]  
FROM    FACULTY, GROUPS, PULPIT, SUBJECT, STUDENT, PROGRESS
where FACULTY.FACULTY = GROUPS.FACULTY and
		STUDENT.IDGROUP=GROUPS.IDGROUP and
		SUBJECT.PULPIT=PULPIT.PULPIT and
		SUBJECT.SUBJECT = PROGRESS.SUBJECT and
		PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and
		PROGRESS.NOTE between 6 and 8
		order by (Case when (PROGRESS.NOTE = 7) then 1
					   when (PROGRESS.NOTE = 8) then 2
					   when (PROGRESS.NOTE = 6) then 3    
					   end   )


--6--
SELECT PULPIT.PULPIT_NAME[�������], isnull(TEACHER.TEACHER_NAME, '***')[�������������]
FROM  PULPIT Left Outer JOIN  TEACHER 
ON TEACHER.PULPIT = PULPIT.PULPIT 

--7-- �������� ������� ������� � left outer join
SELECT PULPIT.PULPIT_NAME[�������], isnull(TEACHER.TEACHER_NAME, '***')[�������������]
FROM  TEACHER Left Outer JOIN  PULPIT 
ON TEACHER.PULPIT = PULPIT.PULPIT 

--8-- ��� � � �. 7, �� � right outer join (����� �������� ������� �������)
SELECT PULPIT.PULPIT_NAME[�������], isnull(TEACHER.TEACHER_NAME, '***')[�������������]
FROM  PULPIT Right Outer JOIN  TEACHER 
ON TEACHER.PULPIT = PULPIT.PULPIT 
/*
--9-- full outer join 
use Products_Base
SELECT * from ������ FULL OUTER JOIN ������ 
on ������.������������_������ = ������.������������
Order by ������.������������_������
-- ���������������
SELECT * from ������ FULL OUTER JOIN ������ 
on ������.������������_������ = ������.������������
Order by ������.������������_������
-- ���������� left � right outer join'��
SELECT * from ������ LEFT OUTER JOIN ������
on ������.������������_������ = ������.������������
Order by ������.������������_������
SELECT * from ������ RIGHT OUTER JOIN ������ 
on ������.������������_������ = ������.������������
Order by ������.������������_������
-- �������� inner join ���� ������
SELECT * from ������ INNER JOIN ������ 
on ������.������������_������ = ������.������������
Order by ������.������������_������

-- ���� ����� ���� ������ ���
SELECT * FROM ������ left outer join ������ union select * from ������ right outer join ������ except select * from ������ full outer join ������
on ������.������������_������ = ������.������������
Order by ������.������������_������

--10-- is null / is not null
SELECT ������.����_��������, ������.��������, ������.����������, ������.������������_������,
������.�����_������, ������.����_������� from ������ FULL OUTER JOIN ������ 
on ������.������������_������ = ������.������������

SELECT ������.����������, ������.������������, ������.���� from ������ FULL OUTER JOIN ������ 
on ������.������������_������ = ������.������������
where ������.���������� is null

SELECT * from ������ FULL OUTER JOIN ������ 
on ������.������������ = ������.������������_������
where ������.���������� is not null
*/
--11-- cross join
USE Mich_BSTU
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
  From AUDITORIUM Cross Join AUDITORIUM_TYPE 
  Where AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE