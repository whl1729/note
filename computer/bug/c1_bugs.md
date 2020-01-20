# Minieye C1项目写过的bug

## 4 由于flash容量不足导致固件升级失败

[redmine issue #5459](https://redmine.minieye.tech/issues/5459)

- 原因：没注意一键升级脚本的工作目录，没细想整个升级流程，导致没发现执行自升级脚本时会将临时文件写到flash中。
- 教训：开发功能前，先分析清楚该功能的工作原理和执行流程，提取出约束条件，再进行编码。

## 3 APP进行画面调校时设备自动重启

[redmine issue #5560](https://redmine.minieye.tech/issues/5560)

- 原因：修改自动调节亮度功能时，异常分支没做sleep处理，导致疯狂创建进程和打印日志，进一步导致上传错误日志容量过大，耗尽系统内存。
- 教训：修改代码要小心谨慎，要充分自验。在嵌入式设备开发功能，需要考虑内存问题，严禁使用局部变量存储大量数据。

## 2 headway延时6秒才显示

[redmine issue #5320](https://redmine.minieye.tech/issues/5320)

- 原因：发送GPS速度给显示器时没检查发送频率，沿用了之前的频率。
- 教训：编码前先写文档，记录约束条件。

## 1 设备启动后插入新存储卡升级会失败

[redmine issue #5519](https://redmine.minieye.tech/issues/5519)

- 原因：保存文件时忘记检查目录是否存在
- 教训：同样的错误犯了两次。编码时要确认前提条件。
