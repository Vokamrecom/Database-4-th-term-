use Mich_BSTU

--� ��������� ��������� �����, ���������������  �������� FROM � WHERE, �� ������ � ������������ �� ���������� � �������� ��������
--1-- ������ �� ���������� � �����
SELECT MAX(AUDITORIUM_CAPACITY) [MAX], 
		MIN(AUDITORIUM_CAPACITY) [MIN], 
		AVG(AUDITORIUM_CAPACITY) [AVG], 
		SUM(AUDITORIUM_CAPACITY) [SUM],
		count(*) [COUNT]
from AUDITORIUM;


--2-- ������ �� ���������� ������� ����
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [��� ���������], 
		  max(AUDITORIUM_CAPACITY)  [����. �����������],
		  min(AUDITORIUM_CAPACITY)  [���. �����������],
		  avg(AUDITORIUM_CAPACITY)  [��. �����������],
		  sum(AUDITORIUM_CAPACITY)  [���. �����������],  
          count(*)  [���-�� ���������]
From  AUDITORIUM inner join AUDITORIUM_TYPE
	on  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE  
		group by  AUDITORIUM_TYPENAME


--3-- ���������� ������ ��� ���������� 4-5, 6-7, 8-9, 10//�������
SELECT  *
 FROM (select Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end  [������], COUNT (*) [����������]    
FROM PROGRESS Group by Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end ) as T
ORDER BY  Case [������]
   when '4-5' then 4
   when '6-7' then 3
   when '8-9' then 2
   else 1
   end  


--4-- ������� ������ ��� ������ ������������� ������� �����
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then '������'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else '������'
   end  [����],  
 round(avg(cast(p.NOTE as float(4))),2) [������� ������]--ROUND ������������ ������ �������� � ��������� �� ���� ������ ����� ����-���
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT                  
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [������� ������] desc


--5-- �.4 ������ ��� ���� � ��
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then '������'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else '������'
   end  [����],  
 round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT  
where p.[SUBJECT]='��' or p.[SUBJECT] = '����'                
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [������� ������] desc


--6-- ������� ������ �� ���� ��������� ���� ����� ����'�
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT

--rollup--ROLLUP ���������� ���������� ����� � �������� �����, ������� ����-������ � �������, � ������� ������ ������������ �������
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY ROLLUP(g.PROFESSION, f.FACULTY, p.SUBJECT)


--7-- �.6 � cube-������������// CUBE ���������� ����� ��������� ���������� ����� � �������� �����
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY CUBE(g.PROFESSION, f.FACULTY, p.SUBJECT)


--8-- union ���� � ���� UNION ��������� ���������-������������� �������� �����������, �.�. ��-��������� �������� ��������� �����, � ������� ������ �� ����� �����������
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
UNION
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--9-- intersect (��� ����� �����)//INTERSECT �������� ����� �����, ���������� ������������ ���� �������� ������� �����
/*SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
INTERSECT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT*/


--10-- except (������ �� ��������, ��� ��� ��� ����� �����)
--EXCEPT �������� ����� �����, ���������� ��������� (� ���������-������������� ������) ���� �������� ������� �����
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
EXCEPT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--10-- having - ���������� 8 � 9 ��� ������ ����������
--HAVING ����������� ��� ������ ������ ��������������� ������, 
select p1.SUBJECT, p1.NOTE,
(select count(*) from PROGRESS p2
where p1.SUBJECT=p2.SUBJECT and p1.NOTE=p2.NOTE) [����������]
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE 
having p1.NOTE=8 or p1.NOTE=9






use Zakaz


--1-- ������ � ����� �� ������ � �����
SELECT MAX(����) [MAX], 
		MIN(����) [MIN], 
		AVG(����) [AVG], 
		SUM(����) [SUM],
		count(*) [COUNT]
from ������


--2-- ������ �� ���������� ������� ����
SELECT ������.������������, 
		  max(����������)  [����. ����������],
		  min(����������)  [���. ����������],
		  avg(����������)  [��. ����������],
		  sum(����������)  [���. ����������],  
          count(*)  [���-�� ������� ����� ������]
From  �������� inner join ������
	on  ��������.ID_������ = ������.ID_������  
		group by  ������.������������


--3-- ���������� ������ ��� ���������� ��� 
SELECT  *
 FROM (select Case 
   when ����  between 5 and  15  then '5-15'
   when ����  between 50 and  100  then '50-100'
   when ����  between 200 and  500  then '200-500'
   else '900'
   end  [����], COUNT (*) [���������� ������� �� ����� ��������� ���]    
FROM ������ Group by Case 
   when ����  between 5 and  15  then '5-15'
   when ����  between 50 and  100  then '50-100'
   when ����  between 200 and  500  then '200-500'
   else '900'
   end ) as T
ORDER BY  Case [����]
   when '5-15' then 4
   when '50-100' then 3
   when '200-500' then 2
   else 1
   end  


--4-- ������� ���� � ������ ������ � ������ ��������� ���� ����� �����������
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������                 
GROUP BY ������.ID_������, ���������.��������
ORDER BY ������.ID_������ asc

--6-- �.5 ������ ��� ��������
--rollup--ROLLUP ���������� ���������� ����� � �������� �����, ������� ����-������ � �������, � ������� ������ ������������ �������
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='�������'             
GROUP BY rollup (������.ID_������, ���������.��������)

--7-- �.6 � cube-������������
-- CUBE ���������� ����� ��������� ���������� ����� � �������� �����
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='�������'             
GROUP BY cube (������.ID_������, ���������.��������)

--8�union(������ �� ����� �����������) ������� � ����
--UNION ��������� ���������-������������� �������� �����������, �.�. ��-��������� �������� ��������� �����, � ������� ������ �� ����� �����������
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='�������'             
GROUP BY ������.ID_������, ���������.��������
UNION
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='����'             
GROUP BY ������.ID_������, ���������.��������
--� ��������� ��������� �����, ���������������  �������� FROM � WHERE, �� ������ � ������������ �� ���������� � �������� ��������
--9-- intersect (��� ����� �����)//INTERSECT �������� ����� �����, ���������� ������������ ���� �������� ������� �����
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='�������'             
GROUP BY ������.ID_������, ���������.��������
INTERSECT
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='����'             
GROUP BY ������.ID_������, ���������.��������

--10-- except( (������ �� ��������, ��� ��� ��� ����� �����)
--EXCEPT �������� ����� �����, ���������� ��������� (� ���������-������������� ������) ���� �������� ������� �����
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='�������'             
GROUP BY ������.ID_������, ���������.��������
EXCEPT
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������ 
where ���������.��������='����'             
GROUP BY ������.ID_������, ���������.��������

--11-- having - ���������� �������, ������� � ������ �������� 10 � 20 ���
--HAVING ����������� ��� ������ ������ ��������������� ������, 
select s1.ID_������, s1.����������,
(select count(*) from �������� s2
where s1.ID_������=s2.ID_������ and s1.����������=s2.����������) [����������]
from �������� s1
group by s1.ID_������, s1.����������
having s1.����������=10 or s1.����������=20
--� ��������� ��������� �����, ���������������  �������� FROM � WHERE, �� ������ � ������������ �� ���������� � �������� ��������

--/////////////////////////////////////////////
SELECT   ���������.��������,���������.�����
From ��������� 
where ���������.��������='�������'             
UNION 
SELECT  ���������.��������, ���������.�����
From ���������
            where ���������.��������='����'             


SELECT   ���������.��������,���������.�����
From ��������� 
where ���������.��������='�������'             
UNION ALL
SELECT  ���������.��������, ���������.�����
From ���������
            where ���������.��������='����'  