use Zakaz


--1-- ������ � ����� �� ������ � �����
SELECT MAX(����) [MAX], 
		MIN(����) [MIN], 
		AVG(����) [AVG], 
		SUM(����) [SUM],
		count(*) [COUNT]
from ������


--2-- ������ �� ���������� ������� ����
SELECT ������.������������, 
		  max(����������)  [����. ����������],
		  min(����������)  [���. ����������],
		  avg(����������)  [��. ����������],
		  sum(����������)  [���. ����������],  
          count(*)  [���-�� ������� ����� ������]
From  �������� inner join ������
	on  ��������.ID_������ = ������.ID_������  
		group by  ������.������������


--3-- ���������� ������ ��� ���������� ��� 
SELECT  *
 FROM (select Case 
   when ����  between 5 and  15  then '5-15'
   when ����  between 50 and  100  then '50-100'
   when ����  between 200 and  500  then '200-500'
   else '900'
   end  [����], COUNT (*) [���������� ������� �� ����� ��������� ���]    
FROM ������ Group by Case 
   when ����  between 5 and  15  then '5-15'
   when ����  between 50 and  100  then '50-100'
   when ����  between 200 and  500  then '200-500'
   else '900'
   end ) as T
ORDER BY  Case [����]
   when '5-15' then 4
   when '50-100' then 3
   when '200-500' then 2
   else 1
   end  


--4-- ������� ���� � ������ ������ � ������ ��������� ���� ����� �����������
SELECT  ������.ID_������, ���������.��������, round(avg(cast(������.���� as float(4))),2) [������� ���� � ������]
From ��������� inner join ������ 
            on ���������.ID_��������� = ������.����������
            inner join ��������  
            on ��������.ID_������ = ������.ID_������
			inner join ������
			on ��������.ID_������=������.ID_������                 
GROUP BY ������.ID_������, ���������.��������
ORDER BY ������.ID_������ asc

