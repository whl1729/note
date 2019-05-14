# protobuf和gRPC使用笔记

## GPB基础

1. What are protocol buffers?
    - Protocol buffers are a flexible, efficient, automated mechanism for serializing structured data – think XML, but smaller, faster, and simpler. 
    - You define how you want your data to be structured once, then you can use special generated source code to easily write and read your structured data to and from a variety of data streams and using a variety of languages. 
    - You can even update your data structure without breaking deployed programs that are compiled against the "old" format.

2. How do they work?
    - You specify how you want the information you're serializing to be structured by defining protocol buffer message types in .proto files. Each protocol buffer message is a small logical record of information, containing a series of name-value pairs. 

3. Working with Protocol Buffers
    - The first step when working with protocol buffers is to define the structure for the data you want to serialize in a proto file.
    - Then you use the protocol buffer compiler protoc to generate data access classes in your preferred language(s) from your proto definition.
    - you define gRPC services in ordinary proto files, with RPC method parameters and return types specified as protocol buffer messages.

## gRPC基础

1. What is gRPC?
    - Google Remote Procedure Call, 一个开源的远程调用系统。
    - 它使用HTTP / 2进行传输，使用Protocol Buffers作为接口描述语言，并提供身份验证，双向流和流控制，阻塞或非阻塞绑定以及取消和超时等功能。

2. How do they work?
    - In gRPC a client application can directly call methods on a server application on a different machine as if it was a local object, making it easier for you to create distributed applications and services. 
    - As in many RPC systems, gRPC is based around the idea of defining a service, specifying the methods that can be called remotely with their parameters and return types. 
    - On the server side, the server implements this interface and runs a gRPC server to handle client calls. On the client side, the client has a stub (referred to as just a client in some languages) that provides the same methods as the server.

3. gRPC can use protocol buffers as both its Interface Definition Language (IDL) and as its underlying message interchange format.

## 参考资料

1. [Developer Guide For protobuf](https://developers.google.com/protocol-buffers/)

2. [grpc Documentation](https://www.grpc.io/docs/)
