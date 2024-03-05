<#
���� PowerShell ������������ ��������� �������
��������� PowerShell �� ����� ��������������
����� � ������ ��������� �����
Set-ExecutionPolicy RemoteSigned
�������� Enter
������ ���� "A"
�������� Enter
��������� ������
������ ������������ ��� ���������� �������� ������ � �����, 
������������� �� ��������� ������, 
���������� ��������� �� ���� ����,
����������� ��������������� ��� ���� ����� ��������� gs ������ �� �������� ��������� ������
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$path = "g:\����� �����\automation\prod\rt_data.backup\"
cd $path 
$promt = @(
    '������� ��������� ����� ������ ��� ����������� � ������� "2023-01"'
    )
$name = read-host $promt
ls -filter "admin_$name*.csv*" #����������� ����� 
New-Item -Path "d:\$name" -ItemType Directory #������ ����� �� ��������� ������
#����������� ������ �� ����� � ������������� �����
Write-Host ���������� ������� �����������, �� ����� ������ ��������������� �����...
copy-item -path "$path\admin_$name*.csv*" -destination "d:\$name" -recurse -force -include "*.csv"
#�������� ������ � ���������� ��������� ������
Write-Host ������ �����...
compress-archive -path "d:\$name\" -destinationpath d:\"$name.zip" -compressionlevel optimal -Force
Write-Host ����� ������ �� ��������� ������ �� ������ d:\"$name.zip" 
Write-Host ��� ����������� ������� Enter
Read-Host
$promt = @(
    '���� �� ������ ��������� ������ ����� �� ���� ����'
    '������� ��� � ������� "2023"'
    ) -join ' '
$year = read-host $promt
copy-item -path d:\"$name.zip" -destination "$path\$year\"
Write-Host ����� �������� �� ���� ���� �� ������ "$path\$year\"
Write-Host ���� �� ������ ������ ��������� ��������������� �������� �������������� ������ � �����
Write-Host ������� Enter
Read-Host
get-childItem -path "$path\" -filter "admin_$name*.csv*" -recurse | % {$i=1} {rename-Item $_ -newname ("{0:0000000000#}.csv" -f $i++)}
Write-Host ����� ������������� � ����� ������� � ������� �����
Write-Host ��� �������� ������� Enter
Read-Host