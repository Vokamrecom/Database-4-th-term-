USE MASTER;
CREATE database MY_Prodagi
on primary--�������� ������
(name =N'PRODAGI_mdf',
 filename=N'D:\������\������\���� ������\����\4\4\PRODAGI_mdf.mdf', 
  size = 5Mb, 
  maxsize=10Mb,
  filegrowth=1Mb),
(NAME =N'PRODAGI_ndf',
filename=N'D:\������\������\���� ������\����\4\4\PRODAGI_ndf.ndf', 
  size = 5Mb,
  maxsize=10Mb,
  filegrowth=10%),
 FILEGROUP P1
 (NAME=N'PRODAGI_g1_1',
 filename=N'D:\������\������\���� ������\����\4\4\PRODAGI_g-1.ndf', 
 size = 10Mb,
 maxsize=15Mb,
 filegrowth=1Mb),
 (NAME=N'PRODAGI_g2_2',
 filename=N'D:\������\������\���� ������\����\4\4\PRODAGI_g-2.ndf', 
 size = 2Mb,
 maxsize=5Mb,
 filegrowth=1Mb),
 FILEGROUP P2
 (NAME=N'PRODAGI_2g_1',
 filename=N'D:\������\������\���� ������\����\4\4\PRODAGI_g-21.ndf', 
 size = 5Mb,
 maxsize=10Mb,
 filegrowth=1Mb),
 (NAME=N'PRODAGI_2g_2',
 filename=N'D:\������\������\���� ������\����\4\4\PRODAGI_g-22.ndf', 
 size = 2Mb,
 maxsize=5Mb,
 filegrowth=1Mb)
    log on
( name = N'PRODAGI_log',
 filename=N'D:\������\������\���� ������\����\4\4\PRODAGI_log.ldf',       
 size=5Mb,
 maxsize=UNLIMITED,
 filegrowth=1Mb)
  go

use MY_Prodagi;

create table Tovar(
	������������_������ nvarchar(50) primary key not null, ���� money, �������� nvarchar(50), ���_��_������ int)ON P1;
	
insert into Tovar(������������_������,����,��������,���_��_������)
	values ('�������',5400,'�������',50), ('��������',2000,'������������', 100), ('����������', 8000,'�������',20);

create table Zakazchiki(
  ���������� nvarchar(50) primary key not null, ������� nvarchar(50), ����� nvarchar(50))ON P2;

insert into Zakazchiki(����������,�������,�����)
	values ('�������� ��������','(+37529)1899545','�.���������,��.���������� 24'), ('������� �����','(+37529)1243548','�.�����,��.������ 4'), ('���� ������','(+37529)145789623','�.�����');

create table Zakaz(
   ����� int, ����_������ date, ������������_������ nvarchar(50) FOREIGN KEY REFERENCES TOVAR(������������_������), ���������� nvarchar(50) FOREIGN KEY REFERENCES Zakazchiki(����������), ���_�����������_������ int )ON P2;

insert into Zakaz(�����,����_������,������������_������,����������,���_�����������_������)
	values  (1,'02.03.2016','�������','�������� ��������',2), (2,'10.02.2016','����������','������� �����',1);    
	-- drop table Zakaz   
          
          
 SELECT * FROM Tovar; 
 SELECT  ������������_������,���� from Tovar;   
 SELECT  ������������_������ from Zakaz Where ����_������ = '02.03.2016';

drop table Tovar;
drop table Zakazchiki;
drop table Zakaz;        
