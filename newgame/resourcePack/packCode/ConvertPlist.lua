require 'XBinaryLua'

local inputfile = arg[1]

local XBinary = XBinaryLua
local XImageSet = XBinary.XImageSet
local XImageUnit = XBinary.XImageUnit

local lom = require "lxp.lom"

local frametable = {}

function renamefile(outputfile, copyFilename)
	cmd = 'copy ' .. outputfile .. ' ' .. copyFilename
	cmd = string.gsub(cmd,'[/\\]','\\')
	print(cmd)
	os.execute(cmd)
	del = string.gsub(outputfile,'[/\\]','\\')
	cmd = 'del ' .. del
	print(cmd)
	os.execute(cmd)
end

function getLastPath(path)
	local i = string.find(path,'[/\\]')
	if i == nil then
		return path
	elseif  i == string.len(path) then
		return string.sub(path,0,string.len(path)-1)
	end
	local subpath = string.sub(path,i+1,string.len(path))
	return getLastPath(subpath)
end

function parseframe(root)
	local framefound = false
	for k,v in ipairs(root) do
		if v.tag == 'key' and v[1] == 'frames' then
			framefound = true
		end
		if framefound then
			if v.tag == 'dict' then
				readframe(v)
				framefound = false
			end
		end
	end
end

function readframe(root)
	local file = nil
	for i,v in ipairs(root) do

		if v.tag == 'key' then
			file = v[1]
			frametable[file] = {}

		elseif v.tag == 'dict' then
			filltable(v,frametable[file])
			file = nil
		end
	end
end


function filltable(root,t)
	local key = nil
	for k,v in ipairs(root) do
		if v.tag == 'key' then
			key = v[1]

		elseif v.tag == 'true' then
			t[key] = 1
			key = nil

		elseif v.tag == 'false' then
			t[key] = 0
			key = nil

		elseif v.tag ~= nil and v.tag ~= '' then
			t[key] = v[1]
			key = nil
		end
	end
end

plistTool = {}

function plistTool.convert(src,dst, imageExt, dataExt)
	print("xxxxx=",src)

	imageExt = imageExt or '.pd'
	dataExt = dataExt or '.frame'
	local s = string.find(src,'.plist$')
	if not s then
		return false, '[plist打包器] 无法转换未知文件类型 ' .. src
	end
	frametable = {}
	f = io.open(src,'r')
	s = f:read('*all')
	f:close()

	local t = lom.parse(s)
	for k,v in ipairs(t) do
		--dict
		if v.tag == 'dict' then
			parseframe(v)
		end
	end
	print(frametable)

	src = string.gsub(src,'[/\\]','/')

	local i = string.find(src,'resource/')
	local j = string.find(src,'.plist')

	

	local out = string.sub(src,1,j-1) .. dataExt
	local tp =  string.sub(src,i+string.len('resource/'),j-1)
	local tn = tp .. imageExt
	print(tn)

	local fp = string.sub(src,i+string.len('resource/'),string.len(src))

	local lp = string.find(fp,getLastPath(src))


	local devPath = string.sub(src,1,i-1)

	local outpath = string.sub(fp,1,lp-1)

	local is = XImageSet()
	local count = 0
	for k, v in pairs(frametable) do
		--print(k)
		count = count + 1
	end


	is:Initialize(tn,count)

	count = 0;

	for k, v in pairs(frametable) do

		local iu = XImageUnit()
		local x,y,w,h = string.match(v['frame'],'{(%d+),(%d+)},{(%d+),(%d+)}')
		local offsetX,offsetY = string.match(v['offset'],'{(.+),(.+)}')
		local rotated = v['rotated']
		local sizeX,sizeY = string.match(v['sourceSize'],'{(.+),(.+)}')
		local iuname = outpath .. k
		if tonumber(rotated) == 0 then
			rotated = false
		else
			rotated = true
		end

		iu:Set( x,y,w,h,iuname,
				rotated,
				offsetX, offsetY,
				sizeX,sizeY);
		is:Set(iu,count)
		count = count + 1
	end

	is:Save(out)
	-- 	if true then
	-- 	return
	-- end--os.execute('lua buildResource/pack_xml.lua')
	return true, '[plist打包器] 打包完成\n    ' .. src .. ' --> ' .. out
end

local filename = ""
if #arg > 0 then
	print('filename =', filename)
	filename = arg[1]
	plistTool.convert(filename)
end

