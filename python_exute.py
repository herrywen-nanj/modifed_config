#!/usr/bin/python
# - * - coding: utf-8 - * -
import os
def detectPort():
 a = [80,90,91]
 c = []
#print 'a数组是' , a
 for port in a:
     command = "lsof -i:{} > /dev/null  2>&1".format(port)
    #print '你的端口分别是' , command
     if os.system(command) != 0:
        c.append(port)
 print '您可用的端口还有' + ','.join(str(i) for i in c)
detectPort()

def excute_localshell():
 os.system("./local_initialization.sh")
excute_localshell()
print '该程序已经运行完毕'
