#!/bin/bash
set -e
#/usr/local/openresty/nginx/code
git clone git@github.com:herrywen-nanj/webapp.git > /dev/null  2>&1
#git clone git@47.99.91.45:devops/webapp.git > /dev/null  2>&1
cd webapp
local_path=`pwd`
api_name="c.chinachelai.com"
master_name="cl.chinachelai.com"
local_port="80"
#定义gateway文件路径
gateway_directory=(c/admin/gateway.lua c/user/gateway.lua conf/nginx.conf)
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
      arr=$1
      for j in ${arr[*]}
      do
         sed -i "s@/usr/nginx@${local_path}@g" $j
      done       
}
function modify_api_domain_name()
{
     brr=$1
     for i in ${brr[*]}
     do
	sed -i "s@${api_name}@${api_domain_name}@g" $i
     done
}             
function modify_master_domain_name()
{      
      crr=$1
      for k in ${crr[*]}
      do
          sed -i "s@${master_name}@${master_domain_name}@g" $k
      done
      [ -n "${service_port}" ] &&  sed -i "s@${local_port}@${service_port}@g" conf/nginx.conf
}
#数组中"S[@]"是给对象传递数组中的每个元素，而"S[*]"是将所有元素作一次传递给对象，像下面只能只能使用"S[*]"，而无法使用"S[@]"，如果不带双引号的话，二者是等价
echo "--------初始化本地配置文件中---------"
gateway "${gateway_directory[*]}"
modify_api_domain_name "${c_configfile[*]}"
modify_master_domain_name "${cl_configfile[*]}"
echo "--------你可以修改自己的代码了-----------"
[ -z "${service_port}" ] && echo  你的登陆方式: http://${master_domain_name} || echo 你的登陆方式: http://${master_domain_name}:${service_port} || exit 2
set +e
