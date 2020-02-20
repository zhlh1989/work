脚本功能：
自动将DHCP获取的网络配置信息更改成static手动的网络配置。

脚本执行需要先设置Powershell脚本运行策略：
以管理员身份运行Powershell命令提示符：
Set-ExecutionPolicy -ExecutionPolicy Unrestricted  -Force


脚本执行：
cd D:\code\work\dhcp2static
& .\DHCP2STATIC_new.ps1