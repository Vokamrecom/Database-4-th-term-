SELECT        ������.[������������ ������], ������.[���� �������]
FROM            ��������� INNER JOIN
                         ������ ON ���������.[������������ �����] = ������.�������� INNER JOIN
                         ������ ON ������.[������������ ������] = ������.������������
WHERE        (������.[���� �������] > 300 AND ������.[���� �������] < 601)
