# 学习RESTful架构

## 理解REST

1. 就是用URL定位资源，用HTTP描述操作。

## RESTful设计原则

1. 在RESTful架构中，每个网址代表一种资源（resource），所以网址中不能有动词，只能有名词，而且所用的名词往往与数据库的表格名对应。一般来说，数据库中的表都是同种记录的"集合"（collection），所以API中的名词也应该使用***复数***。

2. 将API的版本号放入URL。

3. 如果记录数量很多，服务器不可能都将它们返回给用户。API应该提供参数，过滤返回结果。

4. 如果状态码是4xx，就应该向用户返回出错信息。一般来说，返回的信息中将error作为键名，出错信息作为键值即可。

5. 针对不同操作，服务器向用户返回的结果应该符合以下规范。
```
GET /collection：返回资源对象的列表（数组）
GET /collection/resource：返回单个资源对象
POST /collection：返回新生成的资源对象
PUT /collection/resource：返回完整的资源对象
PATCH /collection/resource：返回完整的资源对象
DELETE /collection/resource：返回一个空文档
```

6. RESTful API最好做到Hypermedia，即返回结果中提供链接，连向其他API方法，使得用户不查文档，也知道下一步应该做什么。

7. 服务器返回的数据格式，应该尽量使用JSON，避免使用XML。

8. 保证 HEAD 和 GET 方法是安全的，不会对资源状态有所改变（污染）。比如严格杜绝如下情况：`GET /deleteProduct?id=1）`

9. 资源的地址推荐用嵌套结构。比如：`GET /friends/10375923/profile`

10. 警惕返回结果的大小。如果过大，及时进行分页（pagination）或者加入限制（limit）。HTTP协议支持分页（Pagination）操作，在Header中使用 Link 即可。

## 参考资料

1. [理解RESTful架构](http://www.ruanyifeng.com/blog/2011/09/restful.html)

2. [RESTful API 设计指南](https://www.kancloud.cn/amamatthew/api/427085)
