# 网络使用笔记

1. 一个有线网络无法上网的问题：在"ipv4 settings"的"routes..."中勾选了"Use this connection only for resource on this network"

2. `/proc/sys/net/ipv4/ip_forward`由0改为1后，笔记本可以转发报文。

3. Q：为什么netstat看不到8080和8081端口？ 
    - A：8080和8081端口按照惯例分别用于webchache和tproxy服务（见/etc/services），因此grep时要使用对应的服务名。

4. Q: 如何在Windows系统下过滤指定IP？
    - 参考[Win10 修改 IP 安全策略过滤某个IP的访问](https://blog.csdn.net/zhbpd/article/details/49839499).
    - 步骤简述：管理工具 - 本地安全策略 - IP 筛选器属性 - IP 筛选器操作
