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

