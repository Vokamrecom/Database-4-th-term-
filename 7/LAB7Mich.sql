use Zakaz

--1-- ������ �������, ���� �� ���� �� ��� ������� ���� (id 21111) //�������
SELECT  ������.������������, ������.ID_������ 
		FROM ������, ��������, ������
 Where ������.ID_������ = ��������.ID_������ and
��������.ID_������ = ������.ID_������ 
and ������.���������� In (Select ������.����������  FROM  ������  
        Where (������.���������� = '21111'))  

--2-- --3-- �� �� �����, �� ��� ���������� (� inner join'���)//�������
SELECT  ������.������������, ������.ID_������ 
		FROM �������� inner join ������
 on ������.ID_������ = ��������.ID_������ inner join ������
	on ��������.ID_������ = ������.ID_������ 
		where ������.���������� In (Select ������.����������  FROM  ������  
			Where (������.���������� = '21111')) 

--4-- ����� ����� ���������� ������ ������ �� ���� ����� (��� ������� ������)//�����
SELECT distinct ������.������������, ������.ID_������, ��������.���������� 
		FROM ��������, ������
	where  ��������.���������� = ( select  top(1) ��������.���������� from �������� 
		where ��������.ID_������ = ������.ID_������
		 order by ������.ID_������ desc)
					  
