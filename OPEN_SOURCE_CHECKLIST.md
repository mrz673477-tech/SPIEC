# 开源发布检查清单

仓库公开前：

- [ ] 确认 GitHub 仓库名称、简介、Topics 和默认分支。
- [ ] 将仓库可见性设为 Public；检查 Git 提交历史，确保未包含密码、访问令牌、私人电路图或个人文件。
- [ ] 确认 `LICENSE`、`README.md`、`CONTRIBUTING.md`、`SECURITY.md` 和本清单已提交。
- [ ] 在仓库设置中启用 GitHub Actions、Pages（来源选 GitHub Actions）和 Private vulnerability reporting。
- [ ] 检查 Actions 权限；Windows Release 工作流需要创建 GitHub Release 的权限。
- [ ] 推送 `main` 后检查 Pages 部署结果；发布版本时推送形如 `v1.0.0` 的标签，Release 工作流会生成 Windows 文件和 SHA-256 校验值。

发布下载文件时：

- [ ] 下载 ZIP 并解压，确认 `index.html`、`app.js` 和 `favicon.svg` 都在同一目录。
- [ ] 核对 GitHub Release 上的 SHA-256 校验值。
- [ ] 在 Windows 上检查免安装版和安装/卸载流程；代码尚未签名时，向用户说明 Windows 可能显示安全提示。

公开仓库前请逐项检查提交历史，而不只是当前工作目录；删除当前文件并不能移除已经进入 Git 历史的敏感内容。
