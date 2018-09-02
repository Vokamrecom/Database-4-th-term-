use Mich_BSTU

--1-- представление таблицы TEACHER
exec('CREATE VIEW [Преподаватели] 
as select TEACHER [Код], TEACHER_NAME [Имя преподавателя], GENDER [Пол], PULPIT [Код кафедры] 
from  TEACHER;')

select * from Преподаватели

drop view [Преподаватели];


--2-- количество кафедр на каждом факультете
exec('CREATE VIEW [Количество кафедр]
as select FACULTY.FACULTY_NAME [Факультет], count(*) [Количество]
from FACULTY join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;')

select * from [Количество кафедр]

drop view [Количество кафедр];


--3-- все лекционные аудитории
go
CREATE VIEW Аудитории (Наименование_аудитории, код_аудитории)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%ЛК%';        
go
select * from Аудитории

INSERT [Аудитории] values ('33333322', 'ЛК');
INSERT [Аудитории] values ('33999', 'ЛБ-К');


drop view [Аудитории]


--4-- п.3 with check option
go
CREATE VIEW Лекционные_аудитории (Наименование_аудитории, тип)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%ЛК%'        
WITH CHECK OPTION;
go
select * from Лекционные_аудитории

INSERT [Лекционные_аудитории] values ('3333314213', 'ЛБ');

drop view [Лекционные_аудитории]


--5-- дисциплины в алфавитном порядке
go
create view [Дисциплины] (Код, Наименование_дисциплины, Код_кафедры)
as select top 15 SUBJECT.SUBJECT, SUBJECT.SUBJECT_NAME, SUBJECT.PULPIT
from SUBJECT 
order by SUBJECT.SUBJECT_NAME
go
select * from Дисциплины

drop view [Дисциплины]


--6-- schemabinding
exec('
CREATE VIEW [Количество кафедр] WITH SCHEMABINDING
as select FACULTY.FACULTY_NAME [Факультет], count(*) [Количество]
from dbo.FACULTY join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;

alter table FACULTY -- не можем изменять, будет ошибка
alter column FACULTY char(50) not null;')

drop view [Количество кафедр];




use Zakaz
--1-- представление таблицы товары
exec('CREATE VIEW [Товары вкратце]
as select Наименование [Товар], Описание [Описание товара], Цена [Цена товара] 
from ТОВАРЫ;')

select * from [Товары вкратце]

drop view [Товары вкратце];


--2-- количество заказов у каждого заказчика
exec('CREATE VIEW [Количество заказов у каждого заказчика]
as select ЗАКАЗЧИКИ.Заказчик [Заказчик], count(*) [Количество]
from ЗАКАЗЧИКИ join ЗАКАЗЫ
on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
group by ЗАКАЗЧИКИ.Заказчик')

select * from [Количество заказов у каждого заказчика]

drop view [Количество заказов у каждого заказчика];


--3-- все товары, у которых в описании есть "стекл"
go
CREATE VIEW Стекляшечки (Идентификатор, Товар, Описание_товара)
as select ТОВАРЫ.ID_товара, ТОВАРЫ.Наименование, ТОВАРЫ.Описание 
from ТОВАРЫ
where  ТОВАРЫ.Описание like '%стекл%';        
go

select * from [Стекляшечки]

insert Стекляшечки values('45213', 'Вилка', 'Железная вилка')

drop view [Стекляшечки]


--4-- п.3 with check option
go
CREATE VIEW Стекляшечки2 (Идентификатор, Товар, Описание_товара)
as select ТОВАРЫ.ID_товара, ТОВАРЫ.Наименование, ТОВАРЫ.Описание 
from ТОВАРЫ
where  ТОВАРЫ.Описание like '%стекл%'
with check option;        
go

select * from [Стекляшечки2]

insert Стекляшечки2 values('45213', 'Вилка', 'Железная вилка')

drop view [Стекляшечки2]


--5-- товары в алфавитном порядке
go
create view [Товарчики]
as select top 5 Наименование [Товар], Описание [Описание товара], Цена [Цена товара] 
from ТОВАРЫ 
order by ТОВАРЫ.Наименование
go

select * from [Товарчики]

drop view [Товарчики]


--6-- schemabinding
go
CREATE VIEW [Количество заказов у каждого заказчика] with schemabinding
as select ЗАКАЗЧИКИ.Заказчик [Заказчик], count(*) [Количество]
from dbo.ЗАКАЗЧИКИ join dbo.ЗАКАЗЫ
on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
group by ЗАКАЗЧИКИ.Заказчик
go

select * from [Количество заказов у каждого заказчика]

--нельзя изменять таблицы ЗАКАЗЧИКИ И ЗАКАЗЫ

drop view [Количество заказов у каждого заказчика];