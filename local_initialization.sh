#!/bin/bash
git clone git@47.99.91.45:devops/webapp.git > /dev/null  2>&1
cd webapp
a=`pwd`
b="c.chinachelai.com"
d="cl.chinachelai.com"
echo "---------------请按照提示依次输入你的api域名，主域名，服务端口，如果不需要修改服务端口，可以直接回车-------------------------"
read -p "please input your api_domain name: " c 
read -p "please input your master_domain name: " e
read -p "please input your service_port: " f
function modify_directory()
{
      sed -i "s@/usr/nginx@$a@g" c/admin/gateway.lua
      sed -i "s@/usr/nginx@$a@g" c/user/gateway.lua
}
function modify_domain_name()
{
      sed -i "s@$b@$c@g" che/app/index.html
      sed -i "s@$b@$c@g" che/app/webapp/index.js
      sed -i "s@$b@$c@g" che/script/services/appService.js
      sed -i "s@$b@$c@g" conf/nginx.conf
      sed -i "s@$d@$e@g" conf/nginx.conf
      if [ -n "$f" ]
      then
		sed -i "s@80@$f@g" conf/nginx.conf
      fi
}
echo "--------初始化本地配置文件中---------"
modify_directory
modify_domain_name
echo "--------你可以修改自己的代码了-----------"
if [ -z "$f" ]
then
	echo  你的登陆方式: http://$e
else
	echo 你的登陆方式:  http://$e:$f
fi
