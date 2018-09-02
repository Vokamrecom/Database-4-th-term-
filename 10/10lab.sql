use  Mich_BSTU; 
DECLARE 
@a char = 'J', 
@b varchar = N'�', 
@c datetime = getdate(), 
@time time , 
@nomber int, 
@v smallint, 
@x tinyint, 
@z numeric(12,5); 
SET @nomber = (SELECT 2*2); 
SET @time = '00:00:00'; 
SELECT @v = 1,@x = 2,@z = 1.2; 
SELECT @a,@b,@c,@time; 
PRINT CAST(@nomber AS varchar(10)) + ' ' + CAST(@v AS varchar(10)) + ' ' + CAST(@x AS varchar(10)) + ' ' + CAST(@z AS varchar(10)); 
GO 

--2 
ALTER TABLE AUDITORIUM ADD ID int IDENTITY(1,1); 

DECLARE 
@i int = 1,-- �������� ��������� 
@sum int = 0,-- ������ ����������� ��������� 
@avg int = 0,-- �������� ����������� 
@k int = 0,-- ����������� ���������,� ������� ����������� ������ ������� 
@length int = (SELECT COUNT(*) FROM AUDITORIUM); --�16 ����� ���������� ��������� 

WHILE (@i <= @length) --1<=16
BEGIN 
SET @sum = @sum + (SELECT a.AUDITORIUM_CAPACITY FROM AUDITORIUM a WHERE a.ID = @i); 
SET @avg = @sum / @i; 
SET @k = (SELECT COUNT(*) FROM AUDITORIUM a WHERE a.AUDITORIUM_CAPACITY < @avg); 
IF (@sum > 200) 
BEGIN 
SELECT 
@i [���������� ���������], 
@avg [������� ����������� ���������], 
@k [���������� ���������,����������� ������� ������ �������],
CAST(CAST(@k AS float)/CAST(@length AS float)*100 AS int) [������� ���������] 
END; 
ELSE 
PRINT '����� ����������� : '+CAST(@sum AS varchar(10)); 
SET @i = @i + 1; 
END; 

--3 
PRINT '����� ������������ ����� : '+CAST(@@ROWCOUNT AS varchar(50)); 
PRINT '������ SQL : '+CAST(@@VERSION AS varchar(150)); 
PRINT '��������� ����������� �������� : '+CAST(@@SPID AS varchar(50)); 
PRINT '��������� ������ : '+CAST(@@ERROR AS varchar(50)); 

SELECT @@SERVERNAME [��� �������], 
@@TRANCOUNT [������� ����������� ����������], 
@@FETCH_STATUS [�������� ���������� ���������� �����], 
@@NESTLEVEL [������� ����������� ���������]; 

--4 
DECLARE @z int,@t int=2,@x int=3; 
IF (@t > @x) SET @z = POWER(SIN(@t),2) 
ELSE IF (@t < @x) SET @z = 4*(@t+@x) 
ELSE IF(@t = @x) SET @z = 1-EXP(@x - 2) 
PRINT 'z= : '+CAST(@z AS varchar(10)); 

--�������������� ������� ��� �������� � ����������� 
DECLARE 
@name nvarchar(100) = (SELECT stud.NAME FROM STUDENT stud WHERE stud.IDSTUDENT = 1010), 
@fist_name nvarchar(50), 
@midle_name nvarchar(50), 
@last_name nvarchar(50), 
@position_one int, 
@position_two int; 

SET @position_one = CHARINDEX(' ',@name); 
SET @position_two = LEN(@name) - CHARINDEX(' ',REVERSE(@name)); 
SET @fist_name = SUBSTRING(@name,0,@position_one) 
SET @midle_name = SUBSTRING(@name,@position_one + 1,1); 
SET @last_name = SUBSTRING(@name,@position_two + 2,1); 

PRINT @fist_name+' '+@midle_name+'.'+@last_name+'.'; 

--����� ���������, � ������� ���� ���-����� � ��������� ������
DECLARE 
@month int; 

SET @month = DATEPART(month,SYSDATETIME()) + 1; 

SELECT 
stud.NAME, 
stud.BDAY, 
DATEPART(year,SYSDATETIME()) - DATEPART(year,BDAY) [�������] 
FROM STUDENT stud 
WHERE DATEPART(month,stud.BDAY) = @month; 

SELECT 
s.IDSTUDENT, 
s.IDGROUP, 
s.NAME, 
p.[SUBJECT], 
p.PDATE 
FROM STUDENT s JOIN PROGRESS p 
ON s.IDSTUDENT = p.IDSTUDENT 

--����� ��� ������, � ������� �������� ��������� ������ ������� ������� �� ����.
DECLARE 
@group int = 3; 
SELECT 
s.NAME, 
CASE DATEPART(dd,p.PDATE) 
WHEN 1 THEN N'�����������' 
WHEN 1 THEN N'�������' 
WHEN 1 THEN N'�����' 
WHEN 1 THEN N'�������' 
WHEN 1 THEN N'�������' 
END [���� �����] 
FROM STUDENT s JOIN PROGRESS p 
ON s.IDSTUDENT = p.IDSTUDENT 
WHERE s.IDGROUP = @group AND p.[SUBJECT] = N'����'; 

--5 
use E_MyBase
DECLARE @even nvarchar(10); 
IF((SELECT p.[����� ������] FROM ������ p WHERE p.��������� = N'�����������') % 2 = 0 ) 
BEGIN 
SET @even = '������' 
PRINT @even; 
END 
ELSE 
BEGIN 
SET @even = '��������' 
PRINT @even; 
END 
--6 ����������� ��������, � ������� � ��-����� CASE ������������� ������, ���������� ���������� ���������� ��-�������� ��� ����� ���������
use  Mich_BSTU; 
SELECT 
x.NOTE [������], 
CASE 
WHEN x.NOTE < 6 THEN '������' 
WHEN x.NOTE = 6 OR x.NOTE = 7 THEN '������������������' 
WHEN x.NOTE >= 8 THEN '�������' 
END [������] 
FROM (SELECT pr.NOTE FROM PROGRESS pr) x; 

--7 ������� ��������� ��������� �������  ������� ����������. 
CREATE TABLE #TEMP( 
ID int, 
VALUE int); 

DECLARE @i int = 0; 
WHILE (@i <= 100) 
BEGIN 
INSERT #TEMP(ID,VALUE) VALUES (@i + 1,CAST(RAND()*10 AS int)); 
SET @i = @i + 1; 
END; 

SELECT 
t.ID [�������], 
t.VALUE [��������] 
FROM #TEMP t; 

DROP TABLE #TEMP; 

--9 ����������� ������, ��������������� ������������� ��������� RETURN. 
DECLARE @i int = 10; 

WHILE @i < 100 
BEGIN 
PRINT @i; 
SET @i = @i +1; 
IF (@i = 20) RETURN; 
ELSE CONTINUE; 
END; 

--10 ����������� �������� � ��������, � ��-����� ������������ ��� ��������� ������ ����� TRY � CATCH. 
BEGIN TRY 
INSERT
FACULTY(FACULTY,FACULTY_NAME) VALUES (NULL,NULL); 
END TRY 
BEGIN CATCH 
PRINT ERROR_NUMBER() 
PRINT ERROR_MESSAGE() 
PRINT ERROR_LINE() 
PRINT ERROR_PROCEDURE() 
PRINT ERROR_SEVERITY() 
PRINT ERROR_STATE() 
END CATCH 

--11 � ������� ���������� ����� T-SQL ������� ��������� ��������� �������. ������� �� ����������.
CREATE TABLE #TEMP( 
ID int, 
VALUE date); 

DECLARE @i int = 1; 
WHILE (@i <= 100) 
BEGIN 
INSERT #TEMP(ID,VALUE) VALUES (@i,SYSDATETIME()); 
SET @i = @i + 1; 
END; 

SELECT 
t.ID [�������], 
t.VALUE [��������] 
FROM #TEMP t; 

DROP TABLE #TEMP; 

--12 � ������� ���������� ����� T-SQL ������� ���������� ��������� �����-��. ������� �� ����������. 
CREATE TABLE ##GLOBAL_TEMP( 
ID int, 
VALUE int); 

DECLARE @i int = 0; 
WHILE (@i <= 100) 
BEGIN 
INSERT ##GLOBAL_TEMP(ID,VALUE) VALUES (@i + 1,DATEPART(mcs,SYSDATETIME())); 
SET @i = @i + 1; 
END; 

SELECT 
t.ID [�������], 
t.VALUE [��������] 
FROM ##GLOBAL_TEMP t; 

DROP TABLE ##GLOBAL_TEMP;