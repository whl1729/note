# 《TCP/IP 详解 卷1》阅读笔记

## 第1章 概述

### 1.2 分层

1. 应用程序通常是一个用户进程，而下三层则一般在（操作系统）内核中执行。（Question：为什么下三层要在内核中执行？）

2. TCP/IP 协议族 != TCP/IP
    - TCP/IP 协议族是一组不同的协议组合在一起构成的协议族。尽管通常称该协议族为 TCP/IP，但TCP和IP只是其中的两种协议而已。
    - TCP/IP 协议族的另一个名字是 Internet 协议族（Internet Protocol Suite）

3. 一个互连网（internet）就是一组通过**相同**协议族互连在一起的网络。

4. 为什么需要区分网络层和运输层？
    - 网络层和运输层分别负责不同的功能。网络层IP提供的是一种不可靠的服务，它只是尽可能快地把分组从源结点送到目的结点，但是并不提供任何可靠性保证。而TCP在不可靠的IP层上提供了一个可靠的运输层。
    - 补充：应用程序和运输层使用端到端（End-to-end）协议，只有端系统需要这两层协议。而网络层提供的却是逐跳（Hop-by-hop）协议，两个端系统和每个中间系统都要使用它。

5. 主机 vs 路由器
    - 一个路由器具有两个或多个网络接口层（因为它连接了两个或多个网络）。
    - 一个主机也可以有多个接口，但一般不称作路由器，除非它的功能只是单纯地把分组从一个接口传送到另一个接口。
    - 路由器并不一定指那种在互联网中用来转发分组的特殊硬件盒。大多数的 TCP/IP 实现也允许一个多接口主机来担当路由器的功能，但是主机为此必须进行特殊的配置。

6. 互联网的目的之一是在应用程序中隐藏所有的物理细节。物理细节的隐藏使得互联网功能非常强大，也非常有用。

### 1.3 TCP/IP 的分层

1. 一些使用 TCP 的应用：Telnet、FTP、SMTP

2. 一些使用 UDP 的应用：DNS、TFTP（简单文件传送协议）、BOOTP（引导程序协议）、SNMP

3. ICMP 是 IP 协议的附属协议。IP 层用它来与其他主机或路由器交换错误报文和其他重要信息。尽管 ICMP 主要被 IP 使用，但应用程序也有可能访问它，如 Ping 和 Traceroute 都使用了 ICMP。

4. IGMP 是 Internet 组管理协议。它用来把一个 UDP 数据报多播到多个主机。而广播是指把一个UDP数据报发送到某个指定网络上的所有主机。

### 1.4 互联网的地址

1. 各类 IP 地址的范围

类型 |             范围            |
---- | --------------------------- |
  A  |   0.0.0.0 ~ 127.255.255.255 |
  B  | 128.0.0.0 ~ 191.255.255.255 |
  C  | 192.0.0.0 ~ 223.255.255.255 |
  D  | 224.0.0.0 ~ 239.255.255.255 |
  E  | 240.0.0.0 ~ 255.255.255.255 |

2. InterNIC
    - 互联网络信息中心（Internet Network Information Center，InterNIC)：负责为接入互联网的网络分配IP地址。InterNIC只分配网络号。主机号的分配由系统管理员来负责。
    - InterNIC由三部分组成：注册服务（rs.internic.net）、目录和数据库服务（ds.internic.net）、信息服务（is.internic.net）。

3. The system of IP address classes was developed for the purpose of Internet IP addresses assignment. The classes created were based on the network size. For example, for the small number of networks with a very large number of hosts, the Class A was created. The Class C was created for numerous networks with small number of hosts.（伍注：不同组织机构的网络规模不同，需要申请的IP地址数目也不同，将IP地址进行分类，正是为了适应这一需求。）

### 1.5 域名系统

1. 任何应用程序都可以调用一个标准的库函数来查看给定名字的主机的IP地址。

### 1.6 封装

1. 各层数据单元
    - TCP层传给IP层的数据单元：TCP报文段（TCP segment）
    - IP层传给网络接口层的数据单元：IP数据报（IP datagram）。更准确地说，IP和网络接口层之间传送的数据单元应该是分组（packet）。分组既可以是一个IP数据报，也可以是IP数据报的一个片（fragment）。
    - 通过以太网传输的比特流：帧（Frame）

2. 以太网数据帧的物理特性是其长度必须在46～1500字节之间。

3. IP在首部中存入一个长度为8bit的数值，称为协议域。其数值对应的协议如下。
    - 1： ICMP协议
    - 2： IGMP协议
    - 6： TCP协议
    - 17： UDP协议

4. 网络接口分别要发送和接收IP、ARP和RARP数据，因此也必须在以太网的帧首部中加入某种形式的标识，以指明生成数据的网络层协议。为此，以太网的帧首部也有一个16 bit的帧类型域。

### 1.7 分用

1. 当目的主机收到一个以太网数据帧时，数据就开始从协议栈中由底向上升，同时去掉各层协议加上的报文首部。每层协议盒都要去检查报文首部中的协议标识，以确定接收数据的上层协议。这个过程称为**分用( Demultiplexing )**。

### 1.9 端口号

1. 到1992年为止，知名端口号介于1～255之间。256～1023之间的端口号通常都是由Unix系统占用，以提供一些特定的Unix服务。（也就是说，提供一些只有Unix系统才有的、而其他操作系统可能不提供的服务）现在IANA管理1～1023之间所有的端口号。

2. 大多数TCP/IP实现给临时端口分配1024～5000之间的端口号。大于5000的端口号是为其他服务器预留的（Internet上并不常用的服务）。

3. 大多数Unix系统的文件`/etc/services`都包含了人们熟知的端口号。

### 1.10 标准化过程

有四个小组在负责Internet技术：

- Internet协会（ISOC, Internet Society）
    - Internet体系结构委员会（IAB, Internet Architecture Board）：负责Internet标准的最后编辑和技术审核。
        - Internet工程专门小组（IETF, Internet Engineering Task Force）：开发成为Internet标准的规范。
        - Internet研究专门小组（IRIF, Internet Research Task Force）：研究长远的项目。
