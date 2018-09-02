DECLARE @i  int = 1,
             @b varchar(4) = 'БГТУ',
             @c datetime = getdate();       
SELECT @i  i, @b b, @c c
DECLARE  @h TABLE
    ( num int identity(1,1), 
      fil varchar(30) default 'XXX'
     );
  insert @h  default values;  -- добавление одной строки в табличную переменную  
      SELECT * from @h;


	  DECLARE @d  numeric(5,2) = 4.7, @a  char(2), @f float(4)=1;
SET @a = 'РБ'; SET @f = 11.4+@f;
print 'd= ' +cast(@d as varchar(10)); 
print 'a= ' +cast(@a as varchar(10));
print 'f= ' +cast(@f as varchar(10));





DECLARE @Количество int = (select count(*) from Заказы)
    print 'Количество  : ' + cast (@Количество as varchar(10));
DECLARE @y1 numeric(8,3)= (select cast(sum(Цена_продажи)
 as numeric(8,3)) from Заказы),  @y2 real, @y3 numeric(8,3), @y4 real
If @y1>1000 
begin
SELECT @y2 = (select cast( count(*) as numeric(8,3)) from Заказы),
              @y3 = (select cast(AVG(Цена_продажи )  
                                                                               as numeric(8,3)) from Заказы)
SET @y4= (select cast(COUNT(*) as numeric(8,3)) from Заказы
                                                                                 where Цена_продажи > @y3)
SELECT @y1   'Общая сумма',  @y2   'Количество',  @y3   'Средняя цена',
 @y4   'Количество товаров с ценой выше средней'
End
else If @y1>500   print 'Общая сумма от 500 до 1000'
else If @y1>100   print 'Общая сумма от 100 до 500'
else   print 'Общая сумма < 100'
