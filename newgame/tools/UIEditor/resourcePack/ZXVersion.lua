require 'io'
require('LuaXml')

deleteCode = { debug = false }

--最终输出使用,删除脚本信息
local outPath = arg[1]


local tappfile = '../resource/AppConfig.xml'


local appfile = xml.load(tappfile)
local appEntry = appfile:find("entryScript")




if arg[2] == 'shipping' then
	deleteCode = { debug = true }
	print('开始发布版本设置')
else
	print('开始开发版本设置')
end

function GetSvnRevision(input, output)
   local files = {}
   local tmpfile = output
   cmd = 'svn info --xml ' .. input .. ' > ' .. tmpfile
   os.execute(cmd)
   local xfile = xml.load(output)
   local xscene = xfile:find("commit")
   local revision = xscene['revision']

   os.execute('del ' .. output)
   return revision
end

print('获取svn信息')
local res_v = GetSvnRevision('..\\resource', 'svn.xml')
local script_v = GetSvnRevision('..\\script',   'svn.xml')
local src_v = 0 --GetSvnRevision('..\\src', 	   'svn.xml')
local exec_v = GetSvnRevision('..\\engine',   'svn.xml')


local tt = os.date('*t')
local sfn = 'version.txt'
local svnfile = io.open(outPath .. '\\' .. sfn,'w+')

print('资源版本',res_v)
print('脚本版本',script_v)
print('代码版本',src_v)
print('执行文件版本',exec_v)

svnfile:write('r:' .. res_v .. '\n' ..
			  's:' .. script_v .. '\n' ..
			  'e:' .. src_v .. '\n' ..
		       'd:' .. os.date() .. '\n' )
svnfile:close()

local versionScriptBody = [[  ZXLog('res:<%d>');ZXLog('script:<%d>');ZXLog('src:<%d>'); ]]

versionScriptBody = string.format(versionScriptBody,res_v,script_v,src_v,exec_v)
--print(versionScriptBody)
local outscriptfile = appEntry[1] .. '.lua'
local mfn = outPath .. '\\' .. outscriptfile
print(mfn)
local mainfile = io.open(mfn,'r')

local inVersion = false
local finish = false
local sourcetable = {}
for line in mainfile:lines() do

	if deleteCode.debug then
		local luaUtil = string.find(line,'ZXLuaUtils:')
		local profile = string.find(line,'profiler.start()')
		local test = string.find(line,'require \"Test\"')
		if not (luaUtil or profile or test)  then
			sourcetable[#sourcetable+1] = line .. '\n'
		else
			sourcetable[#sourcetable+1] = '--' .. line .. '\n'
		end
	else
		sourcetable[#sourcetable+1] = line .. '\n'
	end

	if not finish then
		local f = string.find(line,'local function version()')
		if f then
			inVersion = true
			sourcetable[#sourcetable+1] = versionScriptBody
		end

		if inVersion then
			local f = string.find(line,'end')
			finish = true
		end
	end
end

local f = io.open(outPath .. '\\' .. outscriptfile, 'w+')

f:write(table.concat(sourcetable))
f:close()
