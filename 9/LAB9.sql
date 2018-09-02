use Mich_BSTU

--1-- ������������� ������� TEACHER
exec('CREATE VIEW [�������������] 
as select TEACHER [���], TEACHER_NAME [��� �������������], GENDER [���], PULPIT [��� �������] 
from  TEACHER;')

select * from �������������

drop view [�������������];


--2-- ���������� ������ �� ������ ����������
exec('CREATE VIEW [���������� ������]
as select FACULTY.FACULTY_NAME [���������], count(*) [����������]
from FACULTY join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;')

select * from [���������� ������]

drop view [���������� ������];


--3-- ��� ���������� ���������
go
CREATE VIEW ��������� (������������_���������, ���_���������)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%��%';        
go
select * from ���������

INSERT [���������] values ('33333322', '��');
INSERT [���������] values ('33999', '��-�');


drop view [���������]


--4-- �.3 with check option
go
CREATE VIEW ����������_��������� (������������_���������, ���)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%��%'        
WITH CHECK OPTION;
go
select * from ����������_���������

INSERT [����������_���������] values ('3333314213', '��');

drop view [����������_���������]


--5-- ���������� � ���������� �������
go
create view [����������] (���, ������������_����������, ���_�������)
as select top 15 SUBJECT.SUBJECT, SUBJECT.SUBJECT_NAME, SUBJECT.PULPIT
from SUBJECT 
order by SUBJECT.SUBJECT_NAME
go
select * from ����������

drop view [����������]


--6-- schemabinding
exec('
CREATE VIEW [���������� ������] WITH SCHEMABINDING
as select FACULTY.FACULTY_NAME [���������], count(*) [����������]
from dbo.FACULTY join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;

alter table FACULTY -- �� ����� ��������, ����� ������
alter column FACULTY char(50) not null;')

drop view [���������� ������];




use Zakaz
--1-- ������������� ������� ������
exec('CREATE VIEW [������ �������]
as select ������������ [�����], �������� [�������� ������], ���� [���� ������] 
from ������;')

select * from [������ �������]

drop view [������ �������];


--2-- ���������� ������� � ������� ���������
exec('CREATE VIEW [���������� ������� � ������� ���������]
as select ���������.�������� [��������], count(*) [����������]
from ��������� join ������
on ���������.ID_��������� = ������.����������
group by ���������.��������')

select * from [���������� ������� � ������� ���������]

drop view [���������� ������� � ������� ���������];


--3-- ��� ������, � ������� � �������� ���� "�����"
go
CREATE VIEW ����������� (�������������, �����, ��������_������)
as select ������.ID_������, ������.������������, ������.�������� 
from ������
where  ������.�������� like '%�����%';        
go

select * from [�����������]

insert ����������� values('45213', '�����', '�������� �����')

drop view [�����������]


--4-- �.3 with check option
go
CREATE VIEW �����������2 (�������������, �����, ��������_������)
as select ������.ID_������, ������.������������, ������.�������� 
from ������
where  ������.�������� like '%�����%'
with check option;        
go

select * from [�����������2]

insert �����������2 values('45213', '�����', '�������� �����')

drop view [�����������2]


--5-- ������ � ���������� �������
go
create view [���������]
as select top 5 ������������ [�����], �������� [�������� ������], ���� [���� ������] 
from ������ 
order by ������.������������
go

select * from [���������]

drop view [���������]


--6-- schemabinding
go
CREATE VIEW [���������� ������� � ������� ���������] with schemabinding
as select ���������.�������� [��������], count(*) [����������]
from dbo.��������� join dbo.������
on ���������.ID_��������� = ������.����������
group by ���������.��������
go

select * from [���������� ������� � ������� ���������]

--������ �������� ������� ��������� � ������

drop view [���������� ������� � ������� ���������];