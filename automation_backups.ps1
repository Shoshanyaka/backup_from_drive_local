<#
Если PowerShell отказывается запускать скрипты
Запускаем PowerShell от имени администратора
Пишем в строке следующий текст
Set-ExecutionPolicy RemoteSigned
Нажимаем Enter
Вводим ключ "A"
Нажимаем Enter
Запускаем скрипт
Скрипт предназначен для скачивания бекапных файлов с диска, 
архивированию на локальной машине, 
дальнейшей загрузкой на гугл диск,
последующем переименованием для того чтобы отработал gs скрипт на удаление отдельных файлов
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$path = "g:\общие диски\automation\prod\rt_data.backup\"
cd $path 
$promt = @(
    'Введите начальную маску файлов для копирования в формате "2023-01"'
    )
$name = read-host $promt
ls -filter "admin_$name*.csv*" #индексируем файлы 
New-Item -Path "d:\$name" -ItemType Directory #создаём папку на локальной машине
#копирование файлов по маске в свежесозданую папку
Write-Host Происходит процесс копирования, он может занять продолжительное время...
copy-item -path "$path\admin_$name*.csv*" -destination "d:\$name" -recurse -force -include "*.csv"
#создание архива с изначально указанным именем
Write-Host Создаём архив...
compress-archive -path "d:\$name\" -destinationpath d:\"$name.zip" -compressionlevel optimal -Force
Write-Host Архив создан на локальной машине по адресу d:\"$name.zip" 
Write-Host Для продолжения нажмите Enter
Read-Host
$promt = @(
    'Если вы хотите загрузить данный архив на гугл диск'
    'введите год в формате "2023"'
    ) -join ' '
$year = read-host $promt
copy-item -path d:\"$name.zip" -destination "$path\$year\"
Write-Host Архив загружен на гугл диск по адресу "$path\$year\"
Write-Host Если вы хотите начать процедуру автоматического удаления архивированных файлов с диска
Write-Host Нажмите Enter
Read-Host
get-childItem -path "$path\" -filter "admin_$name*.csv*" -recurse | % {$i=1} {rename-Item $_ -newname ("{0:0000000000#}.csv" -f $i++)}
Write-Host Файлы переименованы и будут удалены в течении суток
Write-Host Для закрытия нажмите Enter
Read-Host