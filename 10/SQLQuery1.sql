DECLARE @i  int = 1,
             @b varchar(4) = '����',
             @c datetime = getdate();       
SELECT @i  i, @b b, @c c
DECLARE  @h TABLE
    ( num int identity(1,1), 
      fil varchar(30) default 'XXX'
     );
  insert @h  default values;  -- ���������� ����� ������ � ��������� ����������  
      SELECT * from @h;


	  DECLARE @d  numeric(5,2) = 4.7, @a  char(2), @f float(4)=1;
SET @a = '��'; SET @f = 11.4+@f;
print 'd= ' +cast(@d as varchar(10)); 
print 'a= ' +cast(@a as varchar(10));
print 'f= ' +cast(@f as varchar(10));





DECLARE @���������� int = (select count(*) from ������)
    print '����������  : ' + cast (@���������� as varchar(10));
DECLARE @y1 numeric(8,3)= (select cast(sum(����_�������)
 as numeric(8,3)) from ������),  @y2 real, @y3 numeric(8,3), @y4 real
If @y1>1000 
begin
SELECT @y2 = (select cast( count(*) as numeric(8,3)) from ������),
              @y3 = (select cast(AVG(����_������� )  
                                                                               as numeric(8,3)) from ������)
SET @y4= (select cast(COUNT(*) as numeric(8,3)) from ������
                                                                                 where ����_������� > @y3)
SELECT @y1   '����� �����',  @y2   '����������',  @y3   '������� ����',
 @y4   '���������� ������� � ����� ���� �������'
End
else If @y1>500   print '����� ����� �� 500 �� 1000'
else If @y1>100   print '����� ����� �� 100 �� 500'
else   print '����� ����� < 100'
