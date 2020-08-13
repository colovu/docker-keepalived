# Ver: 1.1 by Endial Fang (endial@126.com)
#
# 当前 Docker 镜像的编译脚本

app_name := colovu/keepalived

current_subversion:=$(shell if [[ -d .git ]]; then git rev-parse --short HEAD; else date +%Y%m%d-%H%M; fi)
current_tag:=$(shell if [[ -d .git ]]; then git rev-parse --abbrev-ref HEAD | sed -e 's/master/latest/'; else echo "latest"; fi)-$(current_subversion)

# Sources List: default / tencent / ustc / aliyun / huawei
build-arg:=--build-arg apt_source=tencent

# 设置本地下载服务器路径，加速调试时的本地编译速度
local_ip:=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $$2}'|tr -d "addr:"`
build-arg+=--build-arg local_url=http://$(local_ip)/dist-files/

.PHONY: build clean clearclean

build:
	docker build --force-rm $(build-arg) -t $(app_name):$(current_tag) .
	docker tag $(app_name):$(current_tag) $(app_name):latest

# 清理悬空的镜像（无TAG）及停止的容器 
clean:
	echo "Clean untaged images and stoped containers..."
	docker ps -a | grep "Exited" | awk '{print $$1}' | xargs docker rm
	docker images | grep '<none>' | awk '{print $$3}' | xargs docker rmi -f

clearclean: clean
	echo "Clean all images for current application..."
	docker images | grep "$(app_name)" | awk '{print $$3}' | xargs docker rmi -f