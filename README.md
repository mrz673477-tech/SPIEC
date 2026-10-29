# Windows 安装包

运行 `dist/透明SPICE-Setup.exe`，即可在当前 Windows 用户目录安装，无需管理员权限。安装程序会创建开始菜单和桌面快捷方式，并尝试以 Edge 应用窗口运行。所有分析都在本机离线完成。

重新构建安装包：在项目根目录运行 `powershell -ExecutionPolicy Bypass -File installer/build-installer.ps1`。

卸载入口位于开始菜单的“透明 SPICE”文件夹中，也会登记到当前用户的 Windows 已安装应用列表。
