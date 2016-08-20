#!/usr/bin/python
#encoding=utf-8
import io
import sys
import hashlib
import string


def _MD5File(filename):
    m = hashlib.md5()
    file = io.FileIO(filename,'r')
    bytes = file.read(1024)
    while(bytes != b''):
        m.update(bytes)
        bytes = file.read(1024) 
    file.close()             
    md5value = m.hexdigest()
    return md5value

def MD5File(filename):
    m = hashlib.md5()
    a_file = io.open(filename, 'rb')    #需要使用二进制格式读取文件内容
    m.update(a_file.read())
    a_file.close()
    md5value = m.hexdigest()
    return md5value

#print(MD5File('zhanxian-update-1.0.1-package.zip'))
