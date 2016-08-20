require 'lfs'
--require 'FreeImageToolBox'
require 'strbuf'
require 'xml'
require 'io'
require 'math'
require 'framePacker'
require 'packCode/ConvertPlist'
--require 'ZXBinaryLua'
--ZXBinary = ZXBinaryLua
--ZXImageSet = ZXBinary.ZXImageSet
--ZXImageUnit = ZXBinary.ZXImageUnit

--ZXFrameData = ZXBinary.ZXImageSet
--ZXFrameSet = ZXBinary.ZXFrameSet


local sep = "/"
local output_file = "texture_path.lua"
local output_luac = "texture_path.luac"
local out_list = {}
local frame_directory = {"chat_face", "frame", "scene", }
local ui_directory = {"ui", "ui2", "particle"}

function splitfilename(strfilename)
	-- Returns the Path, Filename, and Extension as 3 values
	return string.match(strfilename, "(.-)([^\\/]-([^\\/%.]+))$")
end

--table 串行化

-- 字典串行化
function serialize(iotable, o, idt)
	if type(o) == "number" then
		iotable[#iotable+1] = tostring(o)
	elseif type(o) == "boolean" then
		iotable[#iotable+1] = tostring(o)
	elseif type(o) == "string" then
		o = string.gsub(o, "\n", "\\n")
		iotable[#iotable+1] = '"' .. o .. '"'
	elseif type(o) == "table" then
		iotable[#iotable+1] = "{"
		for k, v in pairs(o) do
			local is_serialize = true;
			-- 如果不是过滤字段则序列化
			if ( is_serialize ) then
				--print("k = ",k);
				iotable[#iotable+1] = idt
				if type(k) == "number" then
					iotable[#iotable+1] = "["
					iotable[#iotable+1] = k
					iotable[#iotable+1] = "]"
				else
					iotable[#iotable+1] = k
				end
				iotable[#iotable+1] = " = "
				serialize(iotable,v,idt .. idt)
				iotable[#iotable+1] = ","
			end
		end
		iotable[#iotable+1] = idt .. "}\n"
	else
		error("cannot serialize type: " .. type(o) )
	end
end


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

local frameTable = {}
local errorList = {}
function Process(file,full)
	--print(file,full)


	local p, f, e = splitfilename(full)
	local outPath = p
	local fnameOnly = string.gsub(f,'%.'..e,'')
	local inPath = string.gsub(p,'resource','resourceTree')
	local pathForCommand = string.gsub(outPath,'[/]','\\')
	os.execute('del /q ' .. pathForCommand .. '*.*')

	local ok,err = doConvert(fnameOnly,outPath,inPath,1024,1024,nil,nil,false)
	print(ok,err)
	if ok then
		plistTool.convert( outPath .. fnameOnly .. '.plist',
						   outPath .. fnameOnly ..  '.frame',
						   '.pd', '.frame')

		local fullFileOnly = pathForCommand .. fnameOnly
		renamefile(fullFileOnly .. '.png', fullFileOnly..'.pd')
		os.execute(cmd)
		os.execute('del /q ' .. pathForCommand .. fnameOnly .. '.plist')
	else
		errorList[#errorList+1] = err

	end
end
--遍历文件夹
function travel_path( in_path )
	for file in lfs.dir(in_path) do
		if file ~= "." and file ~= ".." then
			local f = in_path..sep..file
			if file ~= output_file then
				local attr = lfs.attributes(f)
				assert(type(attr) == "table")
				if attr.mode == "directory" then
					travel_path(f)
					frameTable[#frameTable+1] = {file,f}
				elseif string.find(file, ".frame") then
					--frameTable[#frameTable+1] = {file,f}
					--Process(file,f)

				elseif string.find(file, ".imageset") then
					local tag = nil
					local pp = in_path .. '/'
					--[[
					local gImageSet = ZXImageSet()
					local gImageUnit = ZXImageUnit()
					local gFrameData = ZXFrameData()
					local gFrameSet = ZXFrameSet()
					local gFrameSet2 = ZXFrameSet()
					if string.find(file, ".imageset") then
					  gImageSet:Load(f)
					  local tn = gImageSet:TextureName()
					  tn = string.gsub(tn,'[/\\]','/')
					  gImageSet:SetTextureName(tn)
					  local count = gImageSet:ImageUnitCount()
					  for i=0, count - 1 do
						local iu = gImageSet:Get(i)
						local s = iu:ImageName()
						s = string.gsub(s,'[/\\]','/')
						iu:SetImageName(s)
					  end
					  gImageSet:Save(f)
					end

					if string.find(file, ".frame") then

					    gFrameSet:Load(f)
						local tn = gFrameSet:TextureName()
					    tn = string.gsub(tn,'[/\\]','/')
						gFrameSet:SetTextureName(tn)
						local count = gFrameSet:FrameDataCount()
						for i=0, count - 1 do
							local fdata = gFrameSet:Get(i)
							local s = fdata:ImageName()
							s = string.gsub(s,'[/\\]','/')
							fdata:SetImageName(s)
						end
						print(gFrameSet:TextureName())

						assert(gFrameSet:Save(f))

					end
					]]--
					for i,directory in ipairs(frame_directory) do
						if string.find(pp, directory .. '/') then
							tag = directory
							break
						end
					end
					for i,directory in ipairs(ui_directory) do
						if string.find(pp, directory .. '/') then
							tag = directory
							break
						end

					end
					if tag ~= nil then
						if out_list[tag] == nil then
							out_list[tag] = {}
						end
						-- edited by aXing on 2013-3-12
						-- 由于android的文件结构，所以把file的文件路径改一下
						local i, j = string.find(f, "./../resource")
						f = string.sub(f, j + 2, -1)
						out_list[tag][#out_list[tag]+1] = { ['file'] = f }
					end
				elseif string.find(file, ".wav") or string.find(file, ".mp3") then
					if out_list['sound'] == nil then
						out_list['sound'] = {}
					end
					local i, j = string.find(f, "./../resource")
					f = string.sub(f, j + 2, -1)
					out_list['sound'][#out_list['sound']+1] = { ['file'] = f }
				end
			end
		end
	end
end

-- 打包xml表
function pack_xml( in_path, out_path )
	--out_list = {}
	travel_path(in_path)

	for i, v in ipairs(frameTable) do
		Process(v[1],v[2])
		--print(v[1],v[2])
	end

	for i, v in ipairs(errorList) do
		print('>>',v[1],v[2])
	end
	--local strtable = { 'texture_xml = '}
	--serialize(strtable,out_list,' ');
	--local output = table.concat(strtable)


	--local xmlstring = string.writeXML(out_list,'  ', '  ')
	--[[
	f = io.open(out_path, 'w+')
	f:write(output)
	io.close(f)

	local cmd = "luac -o ./../resource/data/" .. output_luac .. " ./../resource/data/" .. output_file
	os.execute(cmd)
	]]--
end

-- 开始打包xml表
pack_xml("./../resourceTree/scene/npc", "./../resource/data/" .. output_file)
