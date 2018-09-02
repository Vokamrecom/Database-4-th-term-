use Mich_BSTU--������ 3�� �����!!!!!!!!!!!!!!!!
--1 �������� �������� ��������, ��������� � �������� ��������
exec sp_helpindex 'AUDITORIUM'; 
exec sp_helpindex 'AUDITORIUM_TYPE'; 
exec sp_helpindex 'FACULTY'; 
exec sp_helpindex 'GROUPS'; 
exec sp_helpindex 'PROFESSION'; 
exec sp_helpindex 'PROGRESS'; 
exec sp_helpindex 'PULPIT'; 
exec sp_helpindex 'STUDENT'; 
exec sp_helpindex 'SUBJECT'; 
exec sp_helpindex 'TEACHER'; 

--������������������ ������� �� ������ �� ���������� ������� ����� � �������
--2 
---� ������� ��������� ��������� ���-����. ��������� �� ������� (�� ��-��� 1000 �����). 
CREATE TABLE #TEMP( 
ID int IDENTITY(1,1), 
VALUE varchar(10)); 

DROP TABLE #TEMP; 

DECLARE @i int = 1, 
@j int = 0, 
@x char = '*', 
@str varchar(10) = ' ', 
@rand int; 

WHILE @i < 200
BEGIN 
SET @j = 0; 
SET @str = ' '; 
SET @rand = RAND()*10 
WHILE @j < @rand 
BEGIN 
SET @str = @str + @x; 
SET @j = @j + 1; 
END 
INSERT INTO #TEMP(VALUE) VALUES (@str); 
SET @i = @i + 1; 
END 

select * from #TEMP
---� 
CREATE CLUSTERED INDEX indx1 
ON #TEMP(VALUE ASC); 

DROP INDEX #TEMP.indx1; 
---� 
checkpoint; --�������� ��
DBCC DROPCLEANBUFFERS; --�������� �������� ���

SELECT 
t.ID, 
t.VALUE 
FROM #TEMP t 
WHERE t.VALUE LIKE '***'; 

SELECT * FROM #TEMP t WHERE t.ID BETWEEN 100 AND 200 ORDER BY t.VALUE; 

--3 ������� ��������� ��������� ���-����. ��������� �� ������� (�� ��-��� 10000 �����).
--������������������ ������� �� ������ �� ���������� ������� ����� � �������.
CREATE TABLE #TEMP( 
ID int IDENTITY(1,2), 
VALUE nvarchar(100)); 

drop table #TEMP

DECLARE @k int = 1; 
WHILE @k < 1000 
BEGIN 
INSERT #TEMP(VALUE) VALUES (REPLICATE(N'���',5*RAND())); 
SET @k = @k + 1; 
END; 
--������� ������������������ �����-������� ��������� ������ (������-��� �� ���� ��������). 
CREATE INDEX indx ON #TEMP(ID,VALUE); 
DROP INDEX #TEMP.indx; 
--����������� SELECT-������,  ����-���� ���� ������� � ���������� ��� ���������. 
SELECT * FROM #TEMP t WHERE t.VALUE = N'������' AND t.ID > 200; 

drop table #TEMP
--4 
--������� ��������� ��������� ���-����. ��������� �� ������� (�� ��-��� 10000 �����). 
--����������� SELECT-������. ��-������ ���� ������� � ���������� ��� ���������. 
--������� ������������������ ��-���� ��������, ����������� ���-������ SELECT-�������. 

CREATE TABLE #TEMP( 
ID int, 
VALUE1 nvarchar(100), 
VALUE2 nvarchar(100)); 
--������ �������� ������� ��������� �������� � ������ ��������� ������ �������� ������ ��� ���������� ��������������� ��������.
DECLARE @k int = 1; 
WHILE @k < 100 
BEGIN 
INSERT #TEMP(ID,VALUE1,VALUE2) VALUES (FLOOR(100*RAND()),N'����������� ������' + CAST(FLOOR(RAND()*10) AS nvarchar(2)),N'�������'); 
SET @k = @k + 1; 
END; 

CREATE INDEX indx ON #TEMP(ID) INCLUDE(VALUE1,VALUE2); 
DROP INDEX #TEMP.indx; 

SELECT t.VALUE1,t.VALUE2 FROM #TEMP t WHERE t.ID = 50; 

drop table #TEMP
--5 . ������� ��������� ��������� �������. ��������� �� ������� (�� ����� 10000 �����). ����������� SELECT-������, �������� ���� ��-����� � ���������� ��� ���������. ������� ������������������ ����-������� ������, ����������� ��������� SELECT-�������. 

CREATE TABLE #TEMP( 
ID int IDENTITY(1,1), 
NAME nvarchar(100), 
AGE int); 

DECLARE @k int = 1,@y int; 
WHILE @k < 100
BEGIN 
SET @y = @k%3; 
INSERT #TEMP(NAME,AGE) VALUES ( 
CASE @y 
WHEN 0 THEN N'����' 
WHEN 1 THEN N'����' 
WHEN 2 THEN N'����' 
END, 
FLOOR(RAND()*20)); 
SET @k = @k + 1; 
END; 

CREATE INDEX indx ON #TEMP(ID) WHERE(ID > 50 AND ID < 60); 
DROP INDEX #TEMP.indx; 

SELECT t.ID FROM #TEMP t WHERE t.ID > 50 AND t.ID < 60; 

drop table #TEMP
--6 ������� ��������� ��������� ���-����. ��������� �� ������� (�� ��-��� 1000 �����). ������� ��������-���������� ������. ������� ���-���� ������������ �������. 
--����������� �������� �� T-SQL, ���������� �������� �������� � ������ ������������ ������� ���� 90%.


CREATE TABLE TEMP( 
ID int IDENTITY(1,1), 
NAME nvarchar(100), 
AGE int); 

CREATE INDEX indx ON TEMP(ID); 

DECLARE @k int = 1,@y int; 
WHILE @k < 100
BEGIN 
SET @y = @k%3; 
INSERT TEMP(NAME,AGE) VALUES ( 
CASE @y 
WHEN 0 THEN N'����' 
WHEN 1 THEN N'����' 
WHEN 2 THEN N'����' 
END, 
FLOOR(RAND()*20)); 
SET @k = @k + 1; 
END; 
--������� ����������� �������������� ���������� ������ �������� �������������. 
SELECT tab2.name [������], tab1.avg_fragmentation_in_percent [������������ (%)] FROM 
sys.dm_db_index_physical_stats(DB_ID(N'Mich_BSTU'),OBJECT_ID(N'TEMP'),NULL,NULL,NULL) tab1 
JOIN 
sys.indexes tab2 
ON tab1.object_id = tab2.object_id AND tab1.index_id = tab2.index_id 
WHERE tab2.name IS NOT NULL; 
--������������� (REORGANIZE) ����������� ������, �� ����� ��� ������������ ��-��� ������ ������ �� ����� ������ ������.
ALTER INDEX indx ON TEMP REORGANIZE; 
--����������� (REBUILD) ����������� ��� ���� ������, �������  ����� �� ���������� ������� ������������ ����� ����
ALTER INDEX indx ON TEMP REBUILD WITH(ONLINE = OFF ); 

drop table TEMP
--7 
--����������� ������, �����������-���� ���������� ��������� FILL-FACTOR ��� �������� ����������-��������� �������
CREATE TABLE TEMP( 
ID int IDENTITY(1,1), 
NAME nvarchar(100), 
AGE int); 

DROP TABLE TEMP; 
--�������� FILLFACTOR ��������� ������� ���������� ��������� ������� ������� ������.
CREATE INDEX indx ON TEMP(ID) WITH(FILLFACTOR = 65); 

DROP INDEX TEMP.indx; 

DECLARE @k int = 1,@y int; 
WHILE @k < 10000 
BEGIN 
SET @y = @k%3; 
INSERT TEMP(NAME,AGE) VALUES ( 
CASE @y 
WHEN 0 THEN N'����' 
WHEN 1 THEN N'����' 
WHEN 2 THEN N'����' 
END, 
FLOOR(RAND()*20)); 
SET @k = @k + 1; 
END; 

SELECT tab2.name [������], tab1.avg_fragmentation_in_percent [������������ (%)] FROM 
sys.dm_db_index_physical_stats(DB_ID(N'Mich_BSTU'),OBJECT_ID(N'TEMP'),NULL,NULL,NULL) tab1 
JOIN 
sys.indexes tab2 
ON tab1.object_id = tab2.object_id AND tab1.index_id = tab2.index_id 
WHERE tab2.name IS NOT NULL; 

--8 
DELETE FROM TEMP; 
TRUNCATE TABLE TEMP; 

--9 //�������� ���������� ���� ������� ��� ������������� � ������ ����-������ ������. ������������� ��-������ �������: ��������� (FAC-ULTY. FACULTY_NAME), ����-������ ������ (����������� �� ��-���� ����� ������� PULPIT). ����-���� ��������, ����� ������� ����-��������� ������������ � ����� ��-�����.
use Mich_BSTU
CREATE VIEW [���������� ������] 
AS SELECT DISTINCT 
f.FACULTY_NAME [���������], 
(SELECT 
COUNT(p2.PULPIT) 
FROM PULPIT p2 
WHERE p2.FACULTY = p1.FACULTY) [���������� ������] 
FROM PULPIT p1 JOIN FACULTY f ON p1.FACULTY = f.FACULTY; 
GO 

DROP VIEW
[���������� ������]; 

SELECT * FROM [���������� ������]; 

--10 
use E_MyBase


exec sp_helpindex '[�������]'; 
exec sp_helpindex '[������]';

----------------------















CREATE INDEX indx ON [����������](ID) INCLUDE([����������],[�������],[�����]); 

CREATE CLUSTERED INDEX indx1 ON[������]([����� ������]);--��� ���� PK 

exec sp_helpindex '[����������]'; 
exec sp_helpindex '[������]';