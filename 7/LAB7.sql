use Mich_BSTU

--1-- список кафедр, их факультетов, если этот факультет осущ. подготовку технологов
SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PULPIT,FACULTY, PROFESSION  
 Where PULPIT.FACULTY = FACULTY.FACULTY and
PROFESSION.PROFESSION_NAME In (Select PROFESSION_NAME  FROM  PROFESSION  
        Where (PROFESSION_NAME Like '%технология%') or (PROFESSION_NAME like '%технологии%'))  

--2-- то же самое, но с inner join
SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PROFESSION, PULPIT inner join FACULTY
 on PULPIT.FACULTY = FACULTY.FACULTY 
	where PROFESSION.PROFESSION_NAME In (Select PROFESSION_NAME  FROM  PROFESSION  
        Where (PROFESSION_NAME Like '%технология%') or (PROFESSION_NAME like '%технологии%'))  

--3-- то же самое, но без подзапроса 
SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PULPIT inner join FACULTY
 on PULPIT.FACULTY = FACULTY.FACULTY inner join PROFESSION 
	on FACULTY.FACULTY = PROFESSION.FACULTY
        Where (PROFESSION_NAME Like '%технология%') or (PROFESSION_NAME like '%технологии%')

--4-- самая вместительная аудитория каждого типа,завис
SELECT AUDITORIUM_TYPE, AUDITORIUM_CAPACITY 
		FROM AUDITORIUM a
	where  a.AUDITORIUM = ( select  top(1) AUDITORIUM from AUDITORIUM aa 
		where aa.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
			order by  AUDITORIUM_CAPACITY  desc )

--5-- список факультетов, на которых нет ни одной кафедры 
SELECT FACULTY.FACULTY_NAME 
		from FACULTY
		
	where Not EXISTS (SELECT * FROM PULPIT--выполн если вложенный запрос не возращает значения

		where FACULTY.FACULTY = PULPIT.FACULTY)

		Select * From Pulpit;
--6-- строка, содержащая средние значения оценок по оаип, бд и субд
SELECT top 1 
	  (select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like 'ОАиП' ) [ОАиП],
	  (select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like 'БД' ) [БД], 
	  (select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like 'СУБД') [СУБД] 
  from PROGRESS 

--7-- ALL - список всех самых вместительных аудиторий ,завис
SELECT * FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_CAPACITY>=ALL(SELECT AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM 
		where AUDITORIUM.AUDITORIUM LIKE '%2%')-->=ALL формирует истинное значение в том случае, если значение стоящее  слева больше или равно каждому значению в списке, указанном справа. 

--8-- ANY - список всех аудиторий, кроме самых маленьких (15 мест),завис
SELECT * FROM AUDITORIUM
	where AUDITORIUM.AUDITORIUM_CAPACITY>ANY(SELECT AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM --формирует истинное значение в том случае, если значение стоящее  слева, больше или равно хотя бы одному значению в списке, указанном справа. 
		where AUDITORIUM.AUDITORIUM LIKE '%2%')



SELECT  PULPIT.PULPIT_NAME, FACULTY.FACULTY, PROFESSION.PROFESSION_NAME 
		FROM PULPIT inner join FACULTY
 on PULPIT.FACULTY = FACULTY.FACULTY inner join PROFESSION 
	on FACULTY.FACULTY = PROFESSION.FACULTY
        Where (PROFESSION_NAME Like '%технология%') or (PROFESSION_NAME like '%технологии%')


		use Zakaz

--1-- список товаров, если их хотя бы раз заказал Ашан (id 21111) //независ
SELECT  ТОВАРЫ.Наименование, ТОВАРЫ.ID_товара 
		FROM ЗАКАЗЫ, ЗАКАЗАНО, ТОВАРЫ
 Where ТОВАРЫ.ID_товара = ЗАКАЗАНО.ID_товара and
ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа 
and ЗАКАЗЫ.Покупатель In (Select ЗАКАЗЫ.Покупатель  FROM  ЗАКАЗЫ  
        Where (ЗАКАЗЫ.Покупатель = '21111'))  

--2-- --3-- то же самое, но без подзапроса (с inner join'ами)//независ
SELECT  ТОВАРЫ.Наименование, ТОВАРЫ.ID_товара 
		FROM ЗАКАЗАНО inner join ТОВАРЫ
 on ТОВАРЫ.ID_товара = ЗАКАЗАНО.ID_товара inner join ЗАКАЗЫ
	on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа 
		where ЗАКАЗЫ.Покупатель In (Select ЗАКАЗЫ.Покупатель  FROM  ЗАКАЗЫ  
			Where (ЗАКАЗЫ.Покупатель = '21111')) 

--4-- самое малое количество единиц товара за один заказ (для каждого товара)//завис
SELECT distinct ТОВАРЫ.Наименование, ТОВАРЫ.ID_товара, ЗАКАЗАНО.Количество 
		FROM ЗАКАЗАНО, ТОВАРЫ
	where  ЗАКАЗАНО.Количество = ( select  top(1) ЗАКАЗАНО.Количество from ЗАКАЗАНО 
		where ЗАКАЗАНО.ID_товара = ТОВАРЫ.ID_товара
		 order by ТОВАРЫ.ID_товара desc)
					  




		use E_MyBase


	SELECT  Группы.[Номер группы], Расписаниее.Преподаватель 
		FROM Расписаниее,Группы  
 Where Расписаниее.Группа = Группы.[Номер группы] and
Расписаниее.Преподаватель  In (Select Преподаватель   FROM  Расписаниее  
        Where (Преподаватель Like '%о%') )  

		

					  SELECT distinct Расписаниее.Преподаватель, Расписаниее.Группа, Предмет.Предмет 
		FROM Расписаниее, Предмет
	where  Предмет.Предмет  = ( select  top(1) Предмет.Предмет  from Предмет 

		 order by Предмет.Предмет desc)
					  



				SELECT Преподаватель , Группа 
		FROM Расписаниее a
	where  a.Расписаниее = ( select  top(1) Расписаниее from Расписаниее aa 
		
			order by  Группа desc )
/*
use Mich_BSTU		

select distinct
(SELECT  count(*) from STUDENT) [количество всех студентов],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=1 ) [1],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=2 ) [2],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=3 ) [3],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=4 ) [4],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=5 ) [5],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=6 ) [6],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=7 ) [7],
(SELECT	count(*) from STUDENT  where STUDENT.IDGROUP=8 ) [8]
from student*/
