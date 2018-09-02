--№1
CREATE DATABASE E_MyBaseLab3;

--№2
CREATE TABLE Prepoda(
[Фамилия] nvarchar(50),
[Имя] nvarchar(50),
[Отчество] nvarchar(50),
[Телефон] varchar(50),
[Стаж] int,
[Код преподавателя] int
);
SELECT * FROM Prepoda;

--№3
ALTER TABLE Prepoda ADD [Дата отпуска] date;
SELECT * FROM Prepoda;
ALTER TABLE Prepoda DROP COLUMN [Дата отпуска];

--№4
INSERT Prepoda([Фамилия],[Имя],[Отчество],[Телефон],[Стаж],[Код преподавателя]) VALUES
('Мороз',	'Елена',	'Станиславовна'	,'380-12-90',	15	,1),
('Бракович'	,'Андрей', 	'Викторович',	'380-12-92',	12,	3),
('Дятко',	'Александдр',	'Аркадьевич',	'381-12-91',	17,	5),
('Кобайло',	'Александр',	'Серафимович',	'382-12-91',	14	,7),
('Пацей'	,'Наталья'	,'Владимировна',	'382-12-90',	15,	6),
('Романенко',	'Дмиртрий',	'Михайлович',	'381-12-90'	,13,	4),
('Смелов',	'Владимир'	,'Владиславович',	'380-12-91'	,16	,2);

--№5
SELECT * FROM Prepoda;
SELECT [Фамилия] FROM Prepoda;
SELECT [Имя],[Отчество],[Телефон],[Стаж],[Код преподавателя] FROM Prepoda;
SELECT COUNT(*) FROM Prepoda;

--№6
UPDATE Prepoda SET [Код преподавателя]=5;

--№7
DROP TABLE Prepoda;

CREATE TABLE Prepoda(
[Фамилия] nvarchar(50) CONSTRAINT PK_Prepod PRIMARY KEY,
[Имя] nvarchar(50)NOT NULL,
[Отчество] nvarchar(50)NOT NULL,
[Телефон] varchar(50)NOT NULL,
[Стаж] int,
[Код преподавателя] int
);

INSERT Prepoda([Фамилия],[Имя],[Отчество],[Телефон],[Стаж],[Код преподавателя]) VALUES
('Ермаков', 'Кирилл',' Александрович', '180-26-23', 1, 11);

CREATE TABLE Prepoda(
NFAMIL nvarchar(50) CONSTRAINT PK_Prepod PRIMARY KEY,
NIMYA nvarchar(50)NOT NULL,
NOTCHESTVO nvarchar(50)NOT NULL,
NTELEFON varchar(50)NOT NULL,
NSTAZH int,
NKODPREPOD int,
POL nchar(1) CHECK(POL IN ('м','ж'))
);


--№10
CREATE TABLE Prepod1(
[Фамилия] nvarchar(50) CONSTRAINT PK_Prepod PRIMARY KEY,
[Имя] nvarchar(50)NOT NULL,
[Отчество] nvarchar(50)NOT NULL,
[Телефон] varchar(50)NOT NULL,
[Стаж] int,
[Код преподавателя] int,
[Пол] nchar(1) CHECK([Пол] IN ('м','ж')),
[Дата отпуска] date
);

INSERT Prepod1([Фамилия],[Имя],[Отчество],[Телефон],[Стаж],[Код преподавателя], [Пол], [Дата отпуска]) VALUES
('Макаров','Инван',' Владимирович','195-78-74',2,12,'м','20150101'),
('Загнетова','Анна',' Владимировна','199-61-05',3,13,'ж','20150101'),
('Якубейко','Виктория',' Владимировна','199-07-12',1,13,'ж','20150101');

SELECT [Фамилия]
FROM Prepod1
WHERE [ПОЛ]='ж' AND ([Стаж])>=2;