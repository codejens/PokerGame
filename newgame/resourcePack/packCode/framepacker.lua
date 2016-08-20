require( "iuplua" )
require( "iupluacontrols" )
require 'os'
require 'lfs'
local sep = "/"

OUTFORMAT = nil
COMPRESS_TYPE = nil

function splitfilename(strfilename)
	-- Returns the Path, Filename, and Extension as 3 values
	return string.match(strfilename, "(.-)([^\\/]-([^\\/%.]+))$")
end

function packmkdir(path, flp)
	flp = flp or ''

	local i = string.find(path,'[\\/]')

	if not i then
		local dot = string.find(path,'%.')
		if not dot then
			local mp = flp .. path

			lfs.mkdir(mp)
		end
		return
	end
	local lp = string.sub(path,0,i)
	local rp = string.sub(path,i+1,string.len(path))
	local mp = flp .. lp
	if lfs.attributes (mp) == nil then
		lfs.mkdir(mp)
	end
	packmkdir(rp, flp .. lp )
end


function doConvert(outfile, outPath, inPath ,width, height, outformat, compress_type, messageBox)

	local outputfile = outPath .. '\\out.png'
	local f = io.open('r.txt','w+')
	f:write('')
	f:close()

	local opt = opt or 2
	local outformat = outformat or 'RGBA4444'
	local compress_type = compress_type or '--dither-none-nn'

	local app = 'TexturePacker'
	local args =' --sheet %s --data %s --max-width %d --max-height %d --png-opt-level %d --opt %s'
	local otherargs = '--shape-padding 0 --border-padding 0 ' .. compress_type
	local outPng = outPath .. outfile ..  '.png'
	local outData = outPath .. outfile .. '.plist'
	local args = string.format(args,outPng,outData, width, height, opt, outformat)
	--print('>>>' .. compress_type)
	local cmd = app .. ' ' .. args .. ' ' .. otherargs .. ' ' .. inPath .. ' 2> r.txt'
	print(cmd)
	os.execute(cmd)

	local f = io.open('r.txt','r')
	local content = f:read()

	f:close()

	if content and content ~= ''  then
		if messageBox then
			if string.find(content,'TexturePacker:: error: Not all sprites could be packed into the texture!') then
				iup.Message('出错了', string.format("设置的图元太小了，(%d,%d)不能把所有图片打进大图片",width,height));
			else
				iup.Message('出错了', content)
			end
		end
		--print('>>', outfile, content)
		return false, { outPath, content }
	end
	return true
end

orginal_center = {}
if #arg > 0 then
	orginal_center[1] = tonumber(arg[1])
	orginal_center[2] = tonumber(arg[2])
	fMinAlpha = tonumber(arg[3]) / 10000.0;

	_filetype = arg[4]
	_width = tonumber(arg[5])
	_height = tonumber(arg[6])
	_srcpath = arg[7]
	_dstpath = arg[8]
	_refdst = arg[9]
	_output = arg[10]

	sort_type = tonumber(arg[11])
	convertWebp = tonumber(arg[12])
	rgba8888 = tonumber(arg[13])
	COMPRESS_TYPE = arg[14]
end
print('convertWebp','rgba8888', convertWebp,rgba8888)


if rgba8888 == 1 then
	OUTFORMAT = 'RGBA8888'
	iup.Message('提示', '你选择了RGBA8888，文件将比较大，请自行判断')
end

function os_execute(cmd)
	print(cmd)
	return os.execute(cmd)
end

function framePacker(_dstpath, _srcpath, _width, _height, outformat, compress_type, messageBox)
	local p,f,e = splitfilename(_dstpath .. '.png')
	local s = '%.'..e
	outfile = string.gsub(f,s,'') .. '1'
	--//print(_dstpath,_srcpath)
	packmkdir(_dstpath)
	local ok,err = doConvert( '/' .. outfile, _dstpath ,_srcpath, _width, _height, outformat, compress_type, messageBox)
	if ok then
		require 'packCode/ConvertPlist'

		
		if tonumber(convertWebp) == 1 then
			plistTool.convert( _dstpath .. '/' ..  outfile .. '.plist',
							   _dstpath .. '/' ..  outfile ..  '.frame',
							   '.wd', '.frame')
			local pathForCommand = string.gsub(_dstpath,'[/]','\\') .. '\\'
			local fullFileOnly = pathForCommand .. outfile
			
			local toWebp = string.format('cwebp.exe %s -o %s', fullFileOnly .. '.png', fullFileOnly .. '.wd')
			os_execute(toWebp)
			
			os_execute('del /q ' .. pathForCommand  .. '*.plist')
			os_execute('del /q ' .. pathForCommand  .. '*.png')
		else
			plistTool.convert( _dstpath .. '/' ..  outfile .. '.plist',
							   _dstpath .. '/' ..  outfile ..  '.frame',
							   '.pd', '.frame')
			local pathForCommand = string.gsub(_dstpath,'[/]','\\') .. '\\'
			local fullFileOnly = pathForCommand .. outfile
			renamefile(fullFileOnly .. '.png', fullFileOnly..'.pd')
			os.execute(cmd)
			os.execute('del /q ' .. pathForCommand .. outfile .. '.plist')
		end
	end
end

if #arg > 0 then
	
	framePacker(_dstpath,_srcpath,_width,_height,OUTFORMAT,COMPRESS_TYPE,true)
end
--[[
local TreePath = './../resourceTree/scene/npc'
for file in lfs.dir(TreePath) do
	if file ~= "." and file ~= ".." then
		local f = TreePath..sep..file
		local df = string.gsub(f,'resourceTree','resource')
		local attr = lfs.attributes (f)
		if attr.mode == "directory" then
			local hasFile = false
			for file in lfs.dir(f) do
				if file ~= "." and file ~= ".." then
					hasFile = true
					break;
				end
			end
			if hasFile then
				framePacker(df,f,512,512)
			end
		end

	end
end
]]--
