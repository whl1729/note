# 网络使用笔记

1. 一个有线网络无法上网的问题：在"ipv4 settings"的"routes..."中勾选了"Use this connection only for resource on this network"

2. `/proc/sys/net/ipv4/ip_forward`由0改为1后，笔记本可以转发报文。

3. Q：为什么netstat看不到8080和8081端口？ 
    - A：8080和8081端口按照惯例分别用于webchache和tproxy服务（见/etc/services），因此grep时要使用对应的服务名。
