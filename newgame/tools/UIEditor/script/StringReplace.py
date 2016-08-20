# -*- coding: UTF-8 -*-
import os
def zip_path(f, path, zippath):
    
    if os.path.isdir(path):    
        for d in os.listdir(path):
            
            fullpath = path + os.sep + d
            if d == '.svn':
                continue
            
            elif d == 'language':
                continue
            else:
                zipfullpath = zippath + os.sep + d
                zip_path(f, fullpath, zipfullpath)
    else:
        (path,filename) =  os.path.split(path)
        (fileonly, ext) = os.path.splitext(filename)
        print(filename)
    pass
zip_path('','../script/UI/achieve','')
