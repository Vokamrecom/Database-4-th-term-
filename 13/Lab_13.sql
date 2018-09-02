use Mich_BSTU;


--1-- РЕЖИМ НЕЯВНОЙ ТРАНЗАКЦИИ
-- транзакция начинается, если выполняется один из следующих операторов: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- неявная транзакция продолжается до тех пор, пока не будет выполнен COMMIT или ROLLBACK
set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
drop table TAB;           
declare @c int, @flag char = 'c'; -- если поменять с на r, то таблица не сохранится

SET IMPLICIT_TRANSACTIONS ON -- включение режим неявной транзакции
	create table TAB(K int );       -- начало транзакции                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print 'количество строк в таблице TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- завершение транзакции: фиксация 
		else rollback;     -- завершение транзакции: откат                           
SET IMPLICIT_TRANSACTIONS OFF   -- выключение режим неявной транзакции
	-- действует режим автофиксации
if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print 'таблица TAB есть';  
else print 'таблицы TAB нет'



--2-- СВОЙСТВО АТОМАРНОСТИ ЯВНОЙ ТРАНЗАКЦИИ
-- BEGIN TRANSACTION -> COMMIT TRAN или ROLLBACK TRAN
-- после завершения явной транзакции происходит возврат в исходный режим (автофиксации или неявной транзакции)
-- атомарность транзакции: никакая транзакция не будет зафиксирована в БД частично: операторы изменения БД, 
-- включенные в транзакцию, либо выполнятся все, либо не выполнится ни один. В БД это свойство реализуется 
-- с помощью механизма отката, позволяющего отменить выполненные, но незафиксированные изменения БД
begin try        
	begin tran                 -- начало  явной транзакции
		insert FACULTY values ('ДФ', 'Факультет других наук');
	    --insert FACULTY values ('ПиМ', 'Факультет print-технологий и медиакоммуникаций');
	commit tran;               -- фиксация транзакции
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then 'дублирование '
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- если значение больше нуля, то транзакция не завершена 	  
end catch;

select * from FACULTY;



--3-- ОПЕРАТОР SAVETRAN
-- если транзакция состоит из нескольких независимых блоков операторов T-SQL, то может быть использован 
-- оператор SAVE TRANSACTION, формирующий контрольную точку транзакции
declare @point varchar(32);
 
begin try
	begin tran                              

		set @point = 'p1'; 
		save tran @point;  -- контрольная точка p1

		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values (20,'Екатерина', '1997-08-02', NULL, NULL),
							  (20,'Александра', '1997-08-06', NULL, NULL),
							  (20,'Елизавета', '1997-08-01', NULL, NULL),
							  (20,'Ольга', '1997-08-03', NULL, NULL);    

		set @point = 'p2'; 
		save tran @point; -- контрольная точка p2 (перезаписали, назвали по-другому)

		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values (20, 'Особенный Студент', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then 'дублирование студента' 
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- если транзакция не завершена //уровень вложенности
	begin
	   print 'контрольная точка: '+ @point;
	   rollback tran @point; -- откат к последней контрольной точке
	   commit tran; -- фиксация изменений, выполненных до контрольной точки 
	end;     
end catch;

select * from STUDENT where IDGROUP=20; 
delete STUDENT where IDGROUP=20; 



--4. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ UNCOMMITED, 
--сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолчанию). 
--Сценарий A должен демонстрировать, что уровень READ UNCOMMITED допускает неподтвержденное, 
--неповторяющееся и фантомное чтение. 

--Неподтвержденное чтение чтение фактически свидетельствует об отсутствии изолированности транзакций.

--Неповторяющееся чтение. Одна транзакция читает данные несколько раз, а другая изме-няет те же данные между двумя операциями чтения в первом процессе. По этой причине данные, прочитанные в различных операциях, будут разными. 
--Фантомное чтение. Две последовательные операции чтения могут получать различные значения, т. к. дополнительные строки, называемые фантом¬ными, могут добавляться други-ми транзакциями.
------A----------

set transaction isolation level READ UNCOMMITTED
begin transaction


-----t1----------

select @@SPID, 'insert FACULTY' 'результат', *
from FACULTY WHERE FACULTY = 'ИТ';
select @@SPID, 'update PULPIT' 'результат', *
from PULPIT WHERE FACULTY = 'ИТ';
commit;

-----t2----------

-----B-----------

begin transaction
select @@SPID
insert FACULTY VALUES ('ИТ3','Информационных технологий');
update PULPIT set FACULTY = 'ИТ' WHERE PULPIT = 'ИСиТ'

-----t1----------
-----t2----------

ROLLBACK;




--5. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, 
--но при этом возможно  неповторяющееся и фантомное чтение. 

-----A--------

set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT
where FACULTY = 'ИТ';

-----t1-------
-----t2-------

select 'update PULPIT' 'результат', count(*)
from PULPIT where FACULTY = 'ИТ';
commit;

------B----

begin transaction

------t1-----

update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ПОиСОИ';
commit;

------t2------

--6. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. 
--Сце-нарий B – явную транзакцию с уровнем изолированности READ COMMITED. 

--------A---------

set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = 'ПОиСОИ';

--------t1---------
--------t2---------

select case
    when TEACHER = 'ПТР' THEN 'insert TEACHER'
	else ' '
	end 'результат', TEACHER
FROM TEACHER WHERE PULPIT = 'ПОиСОИ';
commit;

--- B ---	
begin transaction 	  
--- t1 --------------------
insert TEACHER values ('ААА', 'Иванов Иван Иванович', 'м', 'ИСиТ                ');
commit; 
--- t2 --------------------

select * from TEACHER

--7. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий представляет собой явную транзакцию с уровнем изолированности SNAPSHOT. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COM-MITED. 

   use master;
	go
	alter database Mich_BSTU set allow_snapshot_isolation on


	-- A ---
	use Mich_BSTU
    set transaction isolation level SNAPSHOT 
	begin transaction 
	waitfor delay '00:00:05'
	select TEACHER from TEACHER where PULPIT = 'ПОиСОИ';

	-------------------------- t1 ------------------ 
          delete TEACHER where TEACHER = 'АРС';  
          insert TEACHER values ('ВВВ', 'Петров Сергей Борисович', 'м', 'ПОиСОИ');
          update TEACHER set TEACHER = 'ШМКВ' where TEACHER = 'ШМК';
	-------------------------- t2 -----------------
	select TEACHER from TEACHER  where PULPIT = 'ПОиСОИ';
	commit; 
	
	
	--- B ---	


	begin transaction 	  
	waitfor delay '00:00:05'
	-------------------------- t1 --------------------
delete TEACHER where TEACHER = 'ЮДНКВ';  
          insert TEACHER values ('ПТР', 'Петров Петр Петрович', 'м', 'ПОиСОИ');
          update TEACHER set TEACHER = 'БРТ' where TEACHER = 'БРТШВЧ';
          commit; 
	-------------------------- t2 --------------------


--8. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий представляет собой явную транзакцию с уровнем изолированности SE-RIALIZABLE. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COM-MITED. 
--Сценарий A должен демонстрировать отсутствие фантомного, неподтвержденного и не-повторяющегося чтения.

use Mich_BSTU ;
ь      -- A ---
          set transaction isolation level SERIALIZABLE 
	begin transaction 
		  delete TEACHER where TEACHER = 'АРС';  
          insert TEACHER values ('ИВНaй', 'Ивановaф Сергей Борисович', 'м', 'ЛУ');
          update TEACHER set TEACHER = 'ШМКВй' where TEACHER = 'ШМК';
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';
	-------------------------- t1 -----------------
	begin tran
	 select TEACHER from TEACHER  where PULPIT = 'ЛУ';
	-------------------------- t2 ------------------ 
	commit; 	
	--- B ---	
	begin transaction 	  
	delete TEACHER where TEACHER = 'АРС';  
          insert TEACHER values ('ИВНaф', 'Ивановa Сергей Борисович', 'м', 'ПОиСОИ              ');
          update TEACHER set TEACHER = 'ШМКВ' where TEACHER = 'ШМК';
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';
          -------------------------- t1 --------------------
          commit; 
           select TEACHER from TEACHER  where PULPIT = 'ЛУ';
      -------------------------- t2 --------------------







--9-- ВЛОЖЕННЫЕ ТРАНЗАКЦИИ
-- Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
-- оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции; 
-- оператор ROLLBACK вложенной транзакции действует на опе-рации внешней и внутренней транзакции, 
-- а также завершает обе транзакции; 
-- уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT. 

select (select count(*) from dbo.PULPIT where FACULTY = 'ИДиП') 'Кафедры ИДИПа', 
(select count(*) from FACULTY where FACULTY.FACULTY = 'ИДиП') 'ИДИП'; 

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='Кафедра ИДиПа' where PULPIT.FACULTY = 'ИДиП';
	commit;
if @@TRANCOUNT > 0 rollback;

-- Здесь внутренняя транзакция завершается фиксацией своих операций; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции. 



use Jod_MyBase_new

--1
begin transaction
    update ОРДЕР 
	   set ID_Товара = 1
	   where ID_Товара = 2

	if (@@ERROR <> 0)
	    rollback

	update ТОВАР
	    set Цена = 45
		where Цена = 40

	if (@@ERROR <> 0)
	rollback

commit


--2
begin transaction
    insert into ВИД_ДОСТАВКИ (Код_вида_доставки, Вид_доставки)
	    values ('117', 'в');
	save transaction a;

	insert into ВИД_ДОСТАВКИ (Код_вида_доставки, Вид_доставки)
	    values ('118', 'н');
	save transaction b;

	insert into ВИД_ДОСТАВКИ (Код_вида_доставки, Вид_доставки)
	    values ('119', 'в');

	rollback transaction b;

	insert into ВИД_ДОСТАВКИ (Код_вида_доставки, Вид_доставки)
	    values ('120', 'н');

	rollback transaction a;

commit transaction;


--3
BEGIN TRAN
INSERT ТОВАР (ID_Товара, Наименование_товара, Описание, Цена, Количество_на_складе)
VALUES (6, 'Кресло', 'Ясень', 70, 40)
   BEGIN TRAN 
   INSERT ТОВАР (ID_Товара, Наименование_товара, Описание, Цена, Количество_на_складе)
   VALUES (7, 'Полка', 'Сосна', 110, 60)
   BEGIN TRAN 
	 INSERT ТОВАР (ID_Товара, Наименование_товара, Описание, Цена, Количество_на_складе)
     VALUES (8, 'Шкафчик', 'Кедр', 130, 80)
ROLLBACK TRAN