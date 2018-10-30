# 服务器使用docker + jenkins + gitlab实现自动编译部署 #

# docker #
## docker 常用命令 ##
1. docker run -it xxx 第一次运行一个容器
2. docker ps   当前是正在运行的容器
3. docker ps -a  所有的容器
4. docker restart xxx  重启一个已经运行过的容器
5. docker rm xx 移除一个未运行的容器
5. docker exec -it jenkins /bin/bash 进入容器内部

## 1.安装docker ##

shell 命令

1. apt install docker.io
2. sudo service docker start 
3. vi /etc/docker/daemon.json
4. sudo docker run hello-world


说明

1. 安装ubuntu官方维护的docker
2. docker启动需要root权限
3. 配置docker配置文件,使用镜像网站用来更新镜像,在文件里面添加 {"registry-mirrors": ["http://hub-mirror.c.163.com"]}
4. 测试docker demo

安装完成

## 2.docker上安装jenkins容器 ##

shell

1. docker pull jenkinsci/blueocean
2. vim Dockerfile
3. docker build -t myjenkins:v1 .

说明

1. jenkins的镜像,这里用的镜像是jenkins官网上的demo使用的,相对原始的镜像多了一个皮肤,多了部分汉化翻译
2. 编写dockerfile
3. docker run -itd -u root -p 8088:8080 -p 50000:50000 --name jenkins  -v /var/run/docker.sock:/var/run/docker.sock  myjenkins:v1
4. cat /home/xzs/dockerhome/jenkins/secrets/inital~~
5. 登录192.168.2.26:8088 按照提示一路初始化自己的jenkins就可以了


### 附 ###
note/Dockerfile

## 使用jenkins ##

1. 安装public on ssh插件
2. 配置jenkins服务器和gitLab的ssh连接..确认连接成功
2. 配置指定的服务器和jenkins容器的ssh连接..确认连接成功
3. 新建一个自由风格项目获取项目来编译
 4. general 内容自定义
 5. 源码管理选择git,使用配置好的gitLab服务器
 6. 构建触发器可以忽略,如果要提交就自动更新的话就选择`GitHub hook trigger for GITScm polling`
 7. 构建环境可以忽略
 8. 构建操作,如果用maven的话就用maven构建,可以选择pipeline script来执行这个操作
 9. 构建后push文件到目标服务器对应的文件夹(步骤一的作用)
10. 可以另外建一个项目调用目标服务器shell执行服务器的启动,具体配置略

### 附 ###
note/serverUtil.sh