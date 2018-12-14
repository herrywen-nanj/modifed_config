#!/bin/bash
git clone git@github.com:herrywen-nanj/webapp.git > /dev/null  2>&1
cd webapp
local_path=`pwd`
api_name="c.chinachelai.com"
master_name="cl.chinachelai.com"
local_port="80"
#定义gateway文件路径
gateway_directory=(c/admin/gateway.lua c/user/gateway.lua)
#定义变化c.chinachelai的配置文件
c_configfile=(che/app/index.html che/app/webapp/index.js che/script/services/appService.js conf/nginx.conf)
#定义变化cl.chinachelai.com的配置文件
cl_configfile=(conf/nginx.conf)
echo "---------------请按照提示依次输入你的api域名，主域名，服务端口，如果不需要修改服务端口，可以直接回车-------------------------"
read -p "please input your api_domain name: " api_domain_name
read -p "please input your master_domain name: " master_domain_name
read -p "please input your service_port: " service_port
function gateway()
{
      for j in ${gateway_directory[@]}
      do
         sed -i "s@/usr/nginx@${local_path}@g" $j
      done       
}
function modify_api_domain_name()
{
     for i in ${c_configfile[@]}
     do
	sed -i "s@${api_name}@${api_domain_name}@g" $i
     done
}             
function modify_master_domain_name()
{      
      for k in ${cl_configfile[@]}
      do
          sed -i "s@${master_name}@${master_domain_name}@g" $k
      done
      [ -n "${service_port}" ] &&  sed -i "s@${local_port}@${service_port}@g" conf/nginx.conf
}
echo "--------初始化本地配置文件中---------"
gateway
modify_api_domain_name
modify_master_domain_name
echo "--------你可以修改自己的代码了-----------"
[ -z "${service_port}" ] && echo  你的登陆方式: http://${master_domain_name} || echo 你的登陆方式: http://${master_domain_name}:${service_port} || exit 2
