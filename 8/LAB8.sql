use Mich_BSTU

--– разбиение множества строк, сформированного  секциями FROM и WHERE, на группы в соответствии со значениями в заданных столбцах
--1-- данные об аудиториях в целом
SELECT MAX(AUDITORIUM_CAPACITY) [MAX], 
		MIN(AUDITORIUM_CAPACITY) [MIN], 
		AVG(AUDITORIUM_CAPACITY) [AVG], 
		SUM(AUDITORIUM_CAPACITY) [SUM],
		count(*) [COUNT]
from AUDITORIUM;


--2-- данные об аудиториях каждого типа
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [тип аудитории], 
		  max(AUDITORIUM_CAPACITY)  [Макс. вместимость],
		  min(AUDITORIUM_CAPACITY)  [Мин. вместимость],
		  avg(AUDITORIUM_CAPACITY)  [Ср. вместимость],
		  sum(AUDITORIUM_CAPACITY)  [Сум. вместимость],  
          count(*)  [Кол-во аудиторий]
From  AUDITORIUM inner join AUDITORIUM_TYPE
	on  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE  
		group by  AUDITORIUM_TYPENAME


--3-- количество оценок для диапазонов 4-5, 6-7, 8-9, 10//независ
SELECT  *
 FROM (select Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end  [Оценки], COUNT (*) [Количество]    
FROM PROGRESS Group by Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end ) as T
ORDER BY  Case [Оценки]
   when '4-5' then 4
   when '6-7' then 3
   when '8-9' then 2
   else 1
   end  


--4-- средняя оценка для каждой специальности каждого курса
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then 'выпуск'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else 'выпуск'
   end  [курс],  
 round(avg(cast(p.NOTE as float(4))),2) [средння оценка]--ROUND обеспечивает расчет значений с точностью до двух знаков после запя-той
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT                  
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [средння оценка] desc


--5-- п.4 только для ОАиП и БД
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then 'выпуск'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else 'выпуск'
   end  [курс],  
 round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT  
where p.[SUBJECT]='БД' or p.[SUBJECT] = 'ОАиП'                
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [средння оценка] desc


--6-- средние оценки по всем предметам всех групп ИДиП'а
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ИДиП'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT

--rollup--ROLLUP возвращает комбинацию групп и итоговых строк, которая опре-делена в порядке, в котором заданы группируемые столбцы
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ИДиП'                  
GROUP BY ROLLUP(g.PROFESSION, f.FACULTY, p.SUBJECT)


--7-- п.6 с cube-группировкой// CUBE возвращает любую возможную комбинацию групп и итоговых строк
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ИДиП'                  
GROUP BY CUBE(g.PROFESSION, f.FACULTY, p.SUBJECT)


--8-- union ИДиП и ХТиТ UNION выполняет теоретико-множественную операцию объединения, т.е. ре-зультатом является множество строк, в котором строки не могут повторяться
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ИДиП'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
UNION
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ХТиТ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--9-- intersect (нет общих строк)//INTERSECT является набор строк, являющийся пересечением двух исходных наборов строк
/*SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ИДиП'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
INTERSECT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ХТиТ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT*/


--10-- except (ничего не меняется, так как нет общих строк)
--EXCEPT является набор строк, являющийся разностью (в теоретико-множественном смысле) двух исходных наборов строк
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ИДиП'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
EXCEPT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ХТиТ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--10-- having - количество 8 и 9 для каждой дисциплины
--HAVING вычисляется для каждой строки результирующего набора, 
select p1.SUBJECT, p1.NOTE,
(select count(*) from PROGRESS p2
where p1.SUBJECT=p2.SUBJECT and p1.NOTE=p2.NOTE) [количество]
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE 
having p1.NOTE=8 or p1.NOTE=9






use Zakaz


--1-- данные о ценах на товары в целом
SELECT MAX(Цена) [MAX], 
		MIN(Цена) [MIN], 
		AVG(Цена) [AVG], 
		SUM(Цена) [SUM],
		count(*) [COUNT]
from ТОВАРЫ


--2-- данные об аудиториях каждого типа
SELECT ТОВАРЫ.Наименование, 
		  max(Количество)  [Макс. количество],
		  min(Количество)  [Мин. количество],
		  avg(Количество)  [Ср. количество],
		  sum(Количество)  [Сум. количество],  
          count(*)  [Кол-во заказов этого товара]
From  ЗАКАЗАНО inner join ТОВАРЫ
	on  ЗАКАЗАНО.ID_товара = ТОВАРЫ.ID_товара  
		group by  ТОВАРЫ.Наименование


--3-- количество товаро для диапазонов цен 
SELECT  *
 FROM (select Case 
   when цена  between 5 and  15  then '5-15'
   when Цена  between 50 and  100  then '50-100'
   when Цена  between 200 and  500  then '200-500'
   else '900'
   end  [Цены], COUNT (*) [Количество товаров из этого диапазона цен]    
FROM ТОВАРЫ Group by Case 
   when цена  between 5 and  15  then '5-15'
   when Цена  between 50 and  100  then '50-100'
   when Цена  between 200 and  500  then '200-500'
   else '900'
   end ) as T
ORDER BY  Case [Цены]
   when '5-15' then 4
   when '50-100' then 3
   when '200-500' then 2
   else 1
   end  


--4-- средняя цена в каждом заказе и какому заказчику этот заказ принадлежит
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара                 
GROUP BY ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик
ORDER BY ЗАКАЗЫ.ID_заказа asc

--6-- п.5 только для Евроопта
--rollup--ROLLUP возвращает комбинацию групп и итоговых строк, которая опре-делена в порядке, в котором заданы группируемые столбцы
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Евроопт'             
GROUP BY rollup (ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик)

--7-- п.6 с cube-группировкой
-- CUBE возвращает любую возможную комбинацию групп и итоговых строк
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Евроопт'             
GROUP BY cube (ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик)

--8—union(строки не могут повторяться) Евроопт и Ашан
--UNION выполняет теоретико-множественную операцию объединения, т.е. ре-зультатом является множество строк, в котором строки не могут повторяться
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Евроопт'             
GROUP BY ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик
UNION
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Ашан'             
GROUP BY ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик
--– разбиение множества строк, сформированного  секциями FROM и WHERE, на группы в соответствии со значениями в заданных столбцах
--9-- intersect (нет общих строк)//INTERSECT является набор строк, являющийся пересечением двух исходных наборов строк
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Евроопт'             
GROUP BY ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик
INTERSECT
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Ашан'             
GROUP BY ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик

--10-- except( (ничего не меняется, так как нет общих строк)
--EXCEPT является набор строк, являющийся разностью (в теоретико-множественном смысле) двух исходных наборов строк
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Евроопт'             
GROUP BY ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик
EXCEPT
SELECT  ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик, round(avg(cast(ТОВАРЫ.Цена as float(4))),2) [средння цена в заказе]
From ЗАКАЗЧИКИ inner join ЗАКАЗЫ 
            on ЗАКАЗЧИКИ.ID_заказчика = ЗАКАЗЫ.Покупатель
            inner join ЗАКАЗАНО  
            on ЗАКАЗАНО.ID_заказа = ЗАКАЗЫ.ID_заказа
			inner join ТОВАРЫ
			on ЗАКАЗАНО.ID_товара=ТОВАРЫ.ID_товара 
where ЗАКАЗЧИКИ.Заказчик='Ашан'             
GROUP BY ЗАКАЗЫ.ID_заказа, ЗАКАЗЧИКИ.Заказчик

--11-- having - количество товаров, которые в заказе заказали 10 и 20 раз
--HAVING вычисляется для каждой строки результирующего набора, 
select s1.ID_товара, s1.Количество,
(select count(*) from ЗАКАЗАНО s2
where s1.ID_товара=s2.ID_товара and s1.Количество=s2.Количество) [количество]
from ЗАКАЗАНО s1
group by s1.ID_товара, s1.Количество
having s1.Количество=10 or s1.Количество=20
--– разбиение множества строк, сформированного  секциями FROM и WHERE, на группы в соответствии со значениями в заданных столбцах

--/////////////////////////////////////////////
SELECT   ЗАКАЗЧИКИ.Заказчик,ЗАКАЗЧИКИ.Адрес
From ЗАКАЗЧИКИ 
where ЗАКАЗЧИКИ.Заказчик='Евроопт'             
UNION 
SELECT  ЗАКАЗЧИКИ.Заказчик, ЗАКАЗЧИКИ.Адрес
From ЗАКАЗЧИКИ
            where ЗАКАЗЧИКИ.Заказчик='Ашан'             


SELECT   ЗАКАЗЧИКИ.Заказчик,ЗАКАЗЧИКИ.Адрес
From ЗАКАЗЧИКИ 
where ЗАКАЗЧИКИ.Заказчик='Евроопт'             
UNION ALL
SELECT  ЗАКАЗЧИКИ.Заказчик, ЗАКАЗЧИКИ.Адрес
From ЗАКАЗЧИКИ
            where ЗАКАЗЧИКИ.Заказчик='Ашан'  