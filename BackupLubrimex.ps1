$BackLub = "F:\�����������"          #������������ �������� �����������
$BackRuk = "F:\�����������"          #������������ �������� �����������
$DirForBakFiles = "I:\EverydayBackup"   #������������ ��������, � ������� ������ ���� ����������� ������
$Log = "D:\log\backuplog.txt"          #������������ ����
$Date = Get-Date                       #������� ����

Set-ExecutionPolicy Bypass -Force      #��������� ���������� ����� ��������

Add-Content -Value "����������� ����������� ������ - $Date" -Path $Log

Copy-Item -Path $BackRuk -Destination $DirForBakFiles -Recurse -Force

If ($?){
    Add-Content -Value "����������� ����������� ��������� - $Date" -Path $Log
}



Add-Content -Value "����������� ����������� ������ - $Date" -Path $Log

Copy-Item -Path $BackLub -Destination $DirForBakFiles -Recurse -Force

If ($?){
    Add-Content -Value "����������� ����������� ��������� - $Date" -Path $Log
}