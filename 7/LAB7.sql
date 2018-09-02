use Mich_BSTU

--1-- ������ ������, �� �����������, ���� ���� ��������� ����. ���������� ����������
SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PULPIT,FACULTY, PROFESSION  
 Where PULPIT.FACULTY = FACULTY.FACULTY and
PROFESSION.PROFESSION_NAME In (Select PROFESSION_NAME  FROM  PROFESSION  
        Where (PROFESSION_NAME Like '%����������%') or (PROFESSION_NAME like '%����������%'))  

--2-- �� �� �����, �� � inner join
SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PROFESSION, PULPIT inner join FACULTY
 on PULPIT.FACULTY = FACULTY.FACULTY 
	where PROFESSION.PROFESSION_NAME In (Select PROFESSION_NAME  FROM  PROFESSION  
        Where (PROFESSION_NAME Like '%����������%') or (PROFESSION_NAME like '%����������%'))  

--3-- �� �� �����, �� ��� ���������� 
SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PULPIT inner join FACULTY
 on PULPIT.FACULTY = FACULTY.FACULTY inner join PROFESSION 
	on FACULTY.FACULTY = PROFESSION.FACULTY
        Where (PROFESSION_NAME Like '%����������%') or (PROFESSION_NAME like '%����������%')

--4-- ����� ������������� ��������� ������� ����,�����
SELECT AUDITORIUM_TYPE, AUDITORIUM_CAPACITY 
		FROM AUDITORIUM a
	where  a.AUDITORIUM = ( select  top(1) AUDITORIUM from AUDITORIUM aa 
		where aa.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
			order by  AUDITORIUM_CAPACITY  desc )

--5-- ������ �����������, �� ������� ��� �� ����� ������� 
SELECT FACULTY.FACULTY_NAME 
		from FACULTY
		
	where Not EXISTS (SELECT * FROM PULPIT--������ ���� ��������� ������ �� ��������� ��������

		where FACULTY.FACULTY = PULPIT.FACULTY)

		Select * From Pulpit;
--6-- ������, ���������� ������� �������� ������ �� ����, �� � ����
SELECT top 1 
	  (select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like '����' ) [����],
	  (select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like '��' ) [��], 
	  (select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like '����') [����] 
  from PROGRESS 

--7-- ALL - ������ ���� ����� ������������� ��������� ,�����
SELECT * FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_CAPACITY>=ALL(SELECT AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM 
		where AUDITORIUM.AUDITORIUM LIKE '%2%')-->=ALL ��������� �������� �������� � ��� ������, ���� �������� �������  ����� ������ ��� ����� ������� �������� � ������, ��������� ������. 

--8-- ANY - ������ ���� ���������, ����� ����� ��������� (15 ����),�����
SELECT * FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_CAPACITY>ANY(SELECT AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM --��������� �������� �������� � ��� ������, ���� �������� �������  �����, ������ ��� ����� ���� �� ������ �������� � ������, ��������� ������. 
		where AUDITORIUM.AUDITORIUM LIKE '%2%')



SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PULPIT inner join FACULTY
 on PULPIT.FACULTY = FACULTY.FACULTY inner join PROFESSION 
	on FACULTY.FACULTY = PROFESSION.FACULTY
        Where (PROFESSION_NAME Like '%����������%') or (PROFESSION_NAME like '%����������%')


		use Zakaz

--1-- ������ �������, ���� �� ���� �� ��� ������� ���� (id 21111) //�������
SELECT  ������.������������, ������.ID_������ 
		FROM ������, ��������, ������
 Where ������.ID_������ = ��������.ID_������ and
��������.ID_������ = ������.ID_������ 
and ������.���������� In (Select ������.����������  FROM  ������  
        Where (������.���������� = '21111'))  

--2-- --3-- �� �� �����, �� ��� ���������� (� inner join'���)//�������
SELECT  ������.������������, ������.ID_������ 
		FROM �������� inner join ������
 on ������.ID_������ = ��������.ID_������ inner join ������
	on ��������.ID_������ = ������.ID_������ 
		where ������.���������� In (Select ������.����������  FROM  ������  
			Where (������.���������� = '21111')) 

--4-- ����� ����� ���������� ������ ������ �� ���� ����� (��� ������� ������)//�����
SELECT distinct ������.������������, ������.ID_������, ��������.���������� 
		FROM ��������, ������
	where  ��������.���������� = ( select  top(1) ��������.���������� from �������� 
		where ��������.ID_������ = ������.ID_������
		 order by ������.ID_������ desc)
					  




		use E_MyBase


	SELECT  ������.[����� ������], �����������.������������� 
		FROM �����������,������  
 Where �����������.������ = ������.[����� ������] and
�����������.�������������  In (Select �������������   FROM  �����������  
        Where (������������� Like '%�%') )  

		

					  SELECT distinct �����������.�������������, �����������.������, �������.������� 
		FROM �����������, �������
	where  �������.�������  = ( select  top(1) �������.�������  from ������� 

		 order by �������.������� desc)
					  



				SELECT ������������� , ������ 
		FROM ����������� a
	where  a.����������� = ( select  top(1) ����������� from ����������� aa 
		
			order by  ������ desc )
/*
use Mich_BSTU		

select distinct
(SELECT  count(*) from STUDENT) [���������� ���� ���������],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=1 ) [1],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=2 ) [2],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=3 ) [3],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=4 ) [4],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=5 ) [5],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=6 ) [6],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=7 ) [7],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=8 ) [8]
from student*/
