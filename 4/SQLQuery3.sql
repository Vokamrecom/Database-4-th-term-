USE MASTER;
CREATE database MY_Prodagi
on primary--файловая группа
(name =N'PRODAGI_mdf',
 filename=N'D:\Кирилл\Универ\Базы Данных\лабы\4\4\PRODAGI_mdf.mdf', 
  size = 5Mb, 
  maxsize=10Mb,
  filegrowth=1Mb),
(NAME =N'PRODAGI_ndf',
filename=N'D:\Кирилл\Универ\Базы Данных\лабы\4\4\PRODAGI_ndf.ndf', 
  size = 5Mb,
  maxsize=10Mb,
  filegrowth=10%),
 FILEGROUP P1
 (NAME=N'PRODAGI_g1_1',
 filename=N'D:\Кирилл\Универ\Базы Данных\лабы\4\4\PRODAGI_g-1.ndf', 
 size = 10Mb,
 maxsize=15Mb,
 filegrowth=1Mb),
 (NAME=N'PRODAGI_g2_2',
 filename=N'D:\Кирилл\Универ\Базы Данных\лабы\4\4\PRODAGI_g-2.ndf', 
 size = 2Mb,
 maxsize=5Mb,
 filegrowth=1Mb),
 FILEGROUP P2
 (NAME=N'PRODAGI_2g_1',
 filename=N'D:\Кирилл\Универ\Базы Данных\лабы\4\4\PRODAGI_g-21.ndf', 
 size = 5Mb,
 maxsize=10Mb,
 filegrowth=1Mb),
 (NAME=N'PRODAGI_2g_2',
 filename=N'D:\Кирилл\Универ\Базы Данных\лабы\4\4\PRODAGI_g-22.ndf', 
 size = 2Mb,
 maxsize=5Mb,
 filegrowth=1Mb)
    log on
( name = N'PRODAGI_log',
 filename=N'D:\Кирилл\Универ\Базы Данных\лабы\4\4\PRODAGI_log.ldf',       
 size=5Mb,
 maxsize=UNLIMITED,
 filegrowth=1Mb)
  go

use MY_Prodagi;

create table Tovar(
	Наименование_товара nvarchar(50) primary key not null, Цена money, Описание nvarchar(50), Кол_на_складе int)ON P1;
	
insert into Tovar(Наименование_товара,Цена,Описание,Кол_на_складе)
	values ('Зеркало',5400,'Цветное',50), ('Хрусталь',2000,'Разноцветный', 100), ('Столешница', 8000,'кругаля',20);

create table Zakazchiki(
  Покупатель nvarchar(50) primary key not null, Телефон nvarchar(50), Адрес nvarchar(50))ON P2;

insert into Zakazchiki(Покупатель,Телефон,Адрес)
	values ('Слепцова Анжелика','(+37529)1899545','г.Солигорск,ул.Набережная 24'), ('Соловей Дарья','(+37529)1243548','г.Слуцк,ул.Ленина 4'), ('Иван Иваныч','(+37529)145789623','г.Минск');

create table Zakaz(
   Номер int, Дата_сделки date, Наименование_товара nvarchar(50) FOREIGN KEY REFERENCES TOVAR(Наименование_товара), Покупатель nvarchar(50) FOREIGN KEY REFERENCES Zakazchiki(Покупатель), Кол_заказанного_товара int )ON P2;

insert into Zakaz(Номер,Дата_сделки,Наименование_товара,Покупатель,Кол_заказанного_товара)
	values  (1,'02.03.2016','Зеркало','Слепцова Анжелика',2), (2,'10.02.2016','Столешница','Соловей Дарья',1);    
	-- drop table Zakaz   
          
          
 SELECT * FROM Tovar; 
 SELECT  Наименование_товара,Цена from Tovar;   
 SELECT  Наименование_товара from Zakaz Where Дата_сделки = '02.03.2016';

drop table Tovar;
drop table Zakazchiki;
drop table Zakaz;        
