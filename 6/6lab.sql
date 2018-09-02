use Mich_BSTU

--1--
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE Inner Join AUDITORIUM
		on AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE;

--2--
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE Inner Join AUDITORIUM
		on AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE
		and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%компьютер%';

--3-- то же самое, но без inner join
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE, AUDITORIUM
		where AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE;

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		From AUDITORIUM_TYPE, AUDITORIUM
		where AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE
		and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%компьютер%';

--4--
SELECT  FACULTY.FACULTY_NAME as [факультет], 
		PULPIT.PULPIT_NAME as [кафедра],
		GROUPS.PROFESSION as [специальность],
		SUBJECT.SUBJECT_NAME as [дисциплина],
		STUDENT.NAME as [ФИО],
   Case 
   when ( PROGRESS.NOTE=6) then 'шесть'
   when ( PROGRESS.NOTE=7) then 'семь'
   when ( PROGRESS.NOTE=8) then 'восемь'
    end     [оценка]  
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
SELECT  FACULTY.FACULTY_NAME as [факультет], 
		PULPIT.PULPIT_NAME as [кафедра],
		GROUPS.PROFESSION as [специальность],
		SUBJECT.SUBJECT_NAME as [дисциплина],
		STUDENT.NAME as [ФИО],
   Case 
   when ( PROGRESS.NOTE=6) then 'шесть'
   when ( PROGRESS.NOTE=7) then 'семь'
   when ( PROGRESS.NOTE=8) then 'восемь'
    end     [оценка]  
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
SELECT PULPIT.PULPIT_NAME[кафедра], isnull(TEACHER.TEACHER_NAME, '***')[преподаватель]
FROM  PULPIT Left Outer JOIN  TEACHER 
ON TEACHER.PULPIT = PULPIT.PULPIT 

--7-- поменяли местами таблицы в left outer join
SELECT PULPIT.PULPIT_NAME[кафедра], isnull(TEACHER.TEACHER_NAME, '***')[преподаватель]
FROM  TEACHER Left Outer JOIN  PULPIT 
ON TEACHER.PULPIT = PULPIT.PULPIT 

--8-- как и в п. 7, но с right outer join (опять поменяли местами таблицы)
SELECT PULPIT.PULPIT_NAME[кафедра], isnull(TEACHER.TEACHER_NAME, '***')[преподаватель]
FROM  PULPIT Right Outer JOIN  TEACHER 
ON TEACHER.PULPIT = PULPIT.PULPIT 
/*
--9-- full outer join 
use Products_Base
SELECT * from ЗАКАЗЫ FULL OUTER JOIN ТОВАРЫ 
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование
Order by ЗАКАЗЫ.Наименование_товара
-- коммутативность
SELECT * from ЗАКАЗЫ FULL OUTER JOIN ТОВАРЫ 
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование
Order by ЗАКАЗЫ.Наименование_товара
-- соединение left и right outer join'ов
SELECT * from ЗАКАЗЫ LEFT OUTER JOIN ТОВАРЫ
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование
Order by ЗАКАЗЫ.Наименование_товара
SELECT * from ЗАКАЗЫ RIGHT OUTER JOIN ТОВАРЫ 
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование
Order by ЗАКАЗЫ.Наименование_товара
-- включает inner join этих таблиц
SELECT * from ЗАКАЗЫ INNER JOIN ТОВАРЫ 
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование
Order by ЗАКАЗЫ.Наименование_товара

-- лефт юнион райт експет фул
SELECT * FROM ЗАКАЗЫ left outer join ТОВАРЫ union select * from ЗАКАЗЫ right outer join ТОВАРЫ except select * from ЗАКАЗЫ full outer join ТОВАРЫ
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование
Order by ЗАКАЗЫ.Наименование_товара

--10-- is null / is not null
SELECT ЗАКАЗЫ.Дата_поставки, ЗАКАЗЫ.Заказчик, ЗАКАЗЫ.Количество, ЗАКАЗЫ.Наименование_товара,
ЗАКАЗЫ.Номер_заказа, ЗАКАЗЫ.Цена_продажи from ЗАКАЗЫ FULL OUTER JOIN ТОВАРЫ 
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование

SELECT ТОВАРЫ.Количество, ТОВАРЫ.Наименование, ТОВАРЫ.Цена from ЗАКАЗЫ FULL OUTER JOIN ТОВАРЫ 
on ЗАКАЗЫ.Наименование_товара = ТОВАРЫ.Наименование
where ТОВАРЫ.Количество is null

SELECT * from ТОВАРЫ FULL OUTER JOIN ЗАКАЗЫ 
on ТОВАРЫ.Наименование = ЗАКАЗЫ.Наименование_товара
where ТОВАРЫ.Количество is not null
*/
--11-- cross join
USE Mich_BSTU
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
  From AUDITORIUM Cross Join AUDITORIUM_TYPE 
  Where AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE