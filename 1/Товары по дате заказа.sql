SELECT        ������.[������������ ������], ������.[���� ��������]
FROM            ��������� INNER JOIN
                         ������ ON ���������.[������������ �����] = ������.�������� INNER JOIN
                         ������ ON ������.[������������ ������] = ������.������������
WHERE        (������.[���� ��������] > CONVERT(DATETIME, '2018-01-01 00:00:00', 102)) AND
                         (������.[���� ��������] < CONVERT(DATETIME, '2018-05-31 00:00:00', 102))