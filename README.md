# Keepalived

针对 [Keepalived](https://keepalived.org) 应用的 Docker 镜像，用于提供 Keepalived 服务。

使用说明可参照：[官方说明](https://keepalived.org/manpage.html) 及 [配置参数说明](https://www.keepalived.org/doc/index.html)

<img src="img/keepalived-logo.png" alt="keepalived-logo" style="zoom:50%;" />

**版本信息：**

- 2.0、latest

**镜像信息**

* 镜像地址：registry.cn-shenzhen.aliyuncs.com/colovu/keepalived:2.0



## TL;DR

Docker 快速启动命令：

```shell
$ docker run -d --privileged=true registry.cn-shenzhen.aliyuncs.com/colovu/keepalived:2.0
```

Docker-Compose 快速启动命令：

```shell
$ curl -sSL https://raw.githubusercontent.com/colovu/docker-keepalived/master/docker-compose.yml > docker-compose.yml

$ docker-compose up -d
```

Docker 使用其他容器网络（`www`容器），并指定 VIP:

```shell
$ docker run -d --name keepalived  --privileged=true -e KEEPALIVED_VIPS=172.17.0.100 --net container:www registry.cn-shenzhen.aliyuncs.com/colovu/keepalived:2.0
```

- 使用其他容器（如命令行）的网络："container:www"
- 使用其他服务（如Docker-compose）的网络："service:www"



---



## 默认对外声明

### 端口

- xx：端口用途

### 数据卷

镜像默认提供以下数据卷定义，默认数据分别存储在自动生成的应用名对应`Keepalived`子目录中：

```shell
/srv/conf     # 配置文件
/var/log      # 日志输出

```

如果需要持久化存储相应数据，需要**在宿主机建立本地目录**，并在使用镜像初始化容器时进行映射。宿主机相关的目录中如果不存在对应应用`Keepalived`的子目录或相应数据文件，则容器会在初始化时创建相应目录及文件。



## 容器配置

在初始化 `Keepalived` 容器时，如果没有预置配置文件，可以在命令行中设置相应环境变量对默认参数进行修改。类似命令如下：

```shell
$ docker run -d -e "KEEPALIVED_ROUTE_ID=51" --name keepalived colovu/keepalived:latest
```



### 常规配置参数

常规配置参数用来配置容器基本属性，一般情况下需要设置，主要包括：

- KEEPALIVED_STATE：默认值：**BACKUP**。Keepalvied 角色，取值范围：`MASTER`、`BACKUP`
- KEEPALIVED_INTERFACE：默认值：**eth0**。指定网络接口
- KEEPALIVED_VIPS：默认值：**192.168.0.240**。设置 VIP 地址，多个地址以','或' '分隔
- KEEPALIVED_PRIORITY：默认值：**50**。节点优先级,数字越大表示节点的优先级越高
- KEEPALIVED_ADVERT_TIME：默认值：**1**。MASTER与BACKUP主机之间同步检查的时间间隔

### 常规可选参数

如果没有必要，可选配置参数可以不用定义，直接使用对应的默认值，主要包括：

- **ENV_DEBUG**：默认值：**false**。设置是否输出容器调试信息。可选值：1、true、yes
- **KEEPALIVED_AUTH_PASS**：默认值：**colovu**。节点间通信密码
- **KEEPALIVED_ID**：默认值：**$HOSTNAME**。服务器标识，邮件发送时在主题中显示的信息

### 集群配置参数

配置服务为集群工作模式时，通过以下参数进行配置：

- **KEEPALIVED_ROUTE_ID**：默认值：**51**。虚拟路由标识，取值范围：1-255；同1个 VRRP 实例使用一致的标识





## 注意事项

- 容器中启动参数必须包含`--privileged`，否则会报`Netlink: error: Operation not permitted`错误
- 如果未使用`--privileged`参数，也可以使用`cap_add`指定具体的权限，如：ALL、NET_ADMIN、NET_RAW等
- 如果 VIP 使用宿主机网段，需要使用`host`方式配置网络，如：`--net host`；使用宿主机网络时，不能声明端口映射



## 更新记录

- 2.0、latest



----

本文原始来源 [Endial Fang](https://github.com/colovu) @ [Github.com](https://github.com)
