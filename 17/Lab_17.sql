use Mich_BSTU;

--1каждый столбец конфигурируется независимо с помощью имени псевдонима этого столбца
go
select PULPIT.FACULTY[факультет/@код], TEACHER.PULPIT[факультет/кафедра/@код], 
    TEACHER.TEACHER_NAME[факультет/кафедра/преподаватель/@код]
	    from TEACHER inner join PULPIT
		    on TEACHER.PULPIT = PULPIT.PULPIT
			   where TEACHER.PULPIT = 'ИСиТ' for xml path, root('Список_преподавателей_кафедры_ИСиТ');


--2с применением вложенных элементов.
go
select AUDITORIUM.AUDITORIUM [Аудитория],
           AUDITORIUM.AUDITORIUM_TYPE [Наимменование_типа],
		   AUDITORIUM.AUDITORIUM_CAPACITY [Вместимость] 
		   from AUDITORIUM join AUDITORIUM_TYPE
		     on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК' for xml AUTO, root('Список_аудиторий'), elements;

--имена его атрибутов совпадают с именами столбцов результирующего набо-ра
--3
go
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины>
					     <дисциплина код="КГиГ" название="Компьютерная геометрия и графика" кафедра="ИСиТ" />
						 <дисциплина код="ОЗИ" название="Основы защиты информации" кафедра="ИСиТ" />
						 <дисциплина код="МПп" название="Математическое программирование п" кафедра="ИСиТ" />
					  </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select[код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
    with([код] char(10), [название] varchar(100), [кафедра] char(20));


--4
insert into STUDENT(IDGROUP, NAME, BDAY, INFO) values(22, 'Ермаков К.А.', '01.05.1999',
                                                          '<студент>
														     <паспорт серия="МС" номер="1234567" дата="01.05.2013" />
															 <телефон>+375291802623</телефон>
															 <адрес>
															    <страна>Беларусь</страна>
																<город>Минск</город>
																<улица>Полоцкой</улица>
																<дом>1</дом>
																<квартира>68</квартира>
															 </адрес>
														  </студент>');
select * from STUDENT where NAME = 'Ермаков К.А.';
update STUDENT set INFO = '<студент>
					           <паспорт серия="МС" номер="1234567" дата="01.05.2013" />
						       <телефон>+375291802623</телефон>
							   <адрес>
								  <страна>Беларусь</страна>
								  <город>Минск</город>
								  <улица>Полоцкой</улица>
	         					  <дом>1</дом>
								  <квартира>68</квартира>
								</адрес>
							 </студент>'
where NAME = 'Ермаков К.А.';
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
	INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта],
	INFO.query('/студент/адрес')[Адрес]
		from  STUDENT
			where NAME = 'Ермаков К.А.';       

--5
go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);

drop XML SCHEMA COLLECTION Student;

select Name, INFO from STUDENT where NAME='Ермаков К.А.'
	 

use Jod_MyBase_new

--1
select Наименование_фирмы, Адрес, Контактное_лицо 
  from ЗАКАЗЧИК
  where Наименование_фирмы like 'А%' 
  for xml auto, elements


--2
 DECLARE @xmlData XML =N'
     <Shops> 
         <Shop id="1">
             <device name="Sensation" vendor="HTC" id="1" />
             <device name="iPhone" vendor="Apple" id="2" />
         </Shop>
         <Shop id="2">
             <device name="Mozart" vendor="HTC" id="3" />
             <device name="Lumia" vendor="Nokia" id="4" />
        </Shop>
    </Shops>';
     SELECT @xmlData.query('/Shops/Shop/device')


--3
CREATE TABLE dbo.tArtist (
      artistId INT NOT NULL PRIMARY KEY
    , name VARCHAR(100) NOT NULL
    , xmlData XML NOT NULL
);
INSERT INTO dbo.tArtist (artistId, name, xmlData) VALUES
(1, 'Radiohead',
'<albums>
    <album title="The King of Limbs">
        <labels>
            <label>Self-released</label>
        </labels>
        <song title="Bloom" length="5:15"/>
        <song title="Morning Mr Magpie" length="4:41"/>
        <song title="Little by Little" length="4:27"/>
        <song title="Feral" length="3:13"/>
        <song title="Lotus Flower" length="5:01"/>
        <song title="Codex" length="4:47"/>
        <song title="Give Up the Ghost" length="4:50"/>
        <song title="Separator" length="5:20"/>
        <description link="http://en.wikipedia.org/wiki/The_King_of_Limbs">
        The King of Limbs is the eighth studio album by English rock band Radiohead,
        produced by Nigel Godrich. It was self-released on 18 February 2011 as a 
        download in MP3 and WAV formats, followed by physical CD and 12" vinyl 
        releases on 28 March, a wider digital release via AWAL, and a special 
        "newspaper" edition on 9 May 2011. The physical editions were released 
        through the band''s Ticker Tape imprint on XL in the United Kingdom, 
        TBD in the United States, and Hostess Entertainment in Japan.
        </description>
    </album>
    <album title="OK Computer">
        <labels>
            <label>Parlophone</label>
            <label>Capitol</label>
        </labels>
        <song title="Airbag" length="4:44"/>
        <song title="Paranoid Android" length="6:23"/>
        <song title="Subterranean Homesick Alien" length="4:27"/>
        <song title="Exit Music (For a Film)" length="4:24"/>
        <song title="Let Down" length="4:59"/>
        <song title="Karma Police" length="4:21"/>
        <song title="Fitter Happier" length="1:57"/>
        <song title="Electioneering" length="3:50"/>
        <song title="Climbing Up the Walls" length="4:45"/>
        <song title="No Surprises" length="3:48"/>
        <song title="Lucky" length="4:19"/>
        <song title="The Tourist" length="5:24"/>
        <description link="http://en.wikipedia.org/wiki/OK_Computer">
        OK Computer is the third studio album by the English alternative rock band 
        Radiohead, released on 16 June 1997 on Parlophone in the United Kingdom and 
        1 July 1997 by Capitol Records in the United States. It marks a deliberate 
        attempt by the band to move away from the introspective guitar-oriented 
        sound of their previous album The Bends. Its layered sound and wide range 
        of influences set it apart from many of the Britpop and alternative rock 
        bands popular at the time and laid the groundwork for Radiohead''s later, 
        more experimental work.
        </description>
    </album>
</albums>'),
(2, 'Guns N'' Roses',
'<albums>
    <album title="Use Your Illusion I">
        <labels>
            <label>Geffen Records</label>
        </labels>
        <song title="Right Next Door to Hell" length="3:02"/>
        <song title="Dust N'' Bones" length="4:58"/>
        <song title="Live and Let Die (Paul McCartney and Wings cover)" 
        length="3:04"/>
        <song title="Don''t Cry (original version)" length="4:44"/>
        <song title="Perfect Crime" length="2:24"/>
        <song title="You Ain''t the First" length="2:36"/>
        <song title="Bad Obsession" length="5:28"/>
        <song title="Back Off Bitch" length="5:04"/>
        <song title="Double Talkin'' Jive" length="3:24"/>
        <song title="November Rain" length="8:57"/>
        <song title="The Garden (featuring Alice Cooper and Shannon Hoon)" 
        length="5:22"/>
        <song title="Garden of Eden" length="2:42"/>
        <song title="Don''t Damn Me" length="5:19"/>
        <song title="Bad Apples" length="4:28"/>
        <song title="Dead Horse" length="4:18"/>
        <song title="Coma" length="10:13"/>
        <description link="http://ru.wikipedia.org/wiki/Use_Your_Illusion_I">
        Use Your Illusion I is the third studio album by GnR. It was the first of two 
        albums released in conjunction with the Use Your Illusion Tour, the other 
        being Use Your Illusion II. The two are thus sometimes considered a double album. 
        In fact, in the original vinyl releases, both Use Your Illusion albums are 
        double albums. Material for all two/four discs (depending on the medium) was 
        recorded at the same time and there was some discussion of releasing a 
        ''quadruple album''. The album debuted at No. 2 on the Billboard charts, selling 
        685,000 copies in its first week, behind Use Your Illusion II''s first week sales
        of 770,000. Use Your Illusion I has sold 5,502,000 units in the U.S. as of 2010, 
        according to Nielsen SoundScan. It was nominated for a Grammy Award in 1992.
        </description>
    </album>
    <album title="Use Your Illusion II">
        <labels>
            <label>Geffen Records</label>
        </labels>
        <song title="Civil War" length="7:42"/>
        <song title="14 Years" length="4:21"/>
        <song title="Yesterdays" length="3:16"/>
        <song title="Knockin'' on Heaven''s Door (Bob Dylan cover)" length="5:36"/>
        <song title="Get in the Ring" length="5:41"/>
        <song title="Shotgun Blues" length="3:23"/>
        <song title="Breakdown" length="7:05"/>
        <song title="Pretty Tied Up" length="4:48"/>
        <song title="Locomotive (Complicity)" length="8:42"/>
        <song title="So Fine" length="4:06"/>
        <song title="Estranged" length="9:24"/>
        <song title="You Could Be Mine" length="5:43"/>
        <song title="Don''t Cry (Alternate lyrics)" length="4:44"/>
        <song title="My World" length="1:24"/>
        <description link="http://ru.wikipedia.org/wiki/Use_Your_Illusion_II">
        Use Your Illusion II is the fourth studio album by GnR. It was one of two albums 
        released in conjunction with the Use Your Illusion Tour, and as a result the two 
        albums are sometimes considered a double album. Bolstered by lead single ''You 
        Could Be Mine'', Use Your Illusion II was the slightly more popular of the two 
        albums, selling 770,000 copies its first week and debuting at No. 1 on the U.S. 
        charts, ahead of Use Your Illusion I''s first week sales of 685,000.
        </description>
    </album>
</albums>');

