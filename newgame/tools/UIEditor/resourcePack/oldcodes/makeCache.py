import os
import md5_file

dirindex = 0
def makeDownload(path,index):
    global xml
    for lua_file in os.listdir(path):
        name = path + os.sep + lua_file
        if os.path.isdir(name):
            name = name.replace('\\','/')
            xml += '<dir>' + name + '</dir>\n'
            #index += 1
            makeDownload(name,index)
            
        else:
            if name.find('.jd') == -1 :
                continue
            strindex = str(index)
            md5Value = md5_file.MD5File(name)
            #name = 'resource/' + name
            name = name.replace('\\','/')
            #+ ' dir=\"' + strindex + '\"'
            xml += '<file '+ 'md5=\"' + md5Value + '\"' + '>'+ name + '</file>\n'

xml = '<root>\n'
xml += '<dir>cache</dir>\n'
makeDownload('cache',dirindex)
xml += '</root>\n'
f = open('cache.xml','w+')
f.write(xml)
f.close()
