require 'XBinaryLua'

local XBinary = XBinaryLua
local XImageSet = XBinary.XImageSet
local XImageUnit = XBinary.XImageUnit

local file_suffix = "frame"
local new_suffix = "pkm"
ImageSetReader = {}


function ImageSetReader.changeTextureName(textureEdit)
	if ImageSetReader.loadedfile then
		local filename = ImageSetReader.loadedfile
		local gImageSet = XImageSet()

		gImageSet:Load(filename)
		gImageSet:SetTextureName(textureEdit.value)
		gImageSet:Save(filename)

		return ImageSetReader.load(filename, textureEdit)
	end
	return false, '未知错误'
end

function ImageSetReader.load(filename, textureEdit)
	local s = string.find(filename,'.imageset$') or string.find(filename,'.frame$')
	if s then
		local gImageSet = XImageSet()
		local gImageUnit = XImageUnit()

		ImageSetReader.ImageSet = gImageSet

		gImageSet:Load(filename)
		local szTable = {}
		local count = gImageSet:ImageUnitCount()
		local ver = gImageSet:GetVersion()
		szTable[#szTable + 1] = string.format("file=\"%s\" count=%d ver =%d\n",gImageSet:TextureName(),count,ver);
		szTable[#szTable + 1] = '----------------------------------------------\n'
		for i=0, count - 1 do
			local iu = gImageSet:Get(i)
			--
			local rot = 0
			if iu.rotation then
				rot = 1
			end

			szTable[#szTable + 1] = string.format("[%d] file=\"%s\" x=%d y=%d width=%d height=%d rot=%d offset={%d,%d}, sourceSize={%d,%d}\n",
			i,iu:ImageName(),iu.x,iu.y,iu.width,iu.height,rot, iu.offsetX, iu.offsetY, iu.sourceSizeX, iu.sourceSizeY);
		end

		textureEdit.value = gImageSet:TextureName()
		ImageSetReader.loadedfile = filename
		return true, table.concat(szTable)
	else
		return false, '[plist打包器] 无法转换未知文件类型 ' .. src
	end
end


function getpathes(rootpath, pathes)
    pathes = pathes or {}

    ret, files, iter = pcall(lfs.dir, rootpath)
    if ret == false then
        return pathes
    end
    for entry in files, iter do
        local next = false
        if entry ~= '.' and entry ~= '..' then
            local path = rootpath .. '/' .. entry
            local attr = lfs.attributes(path)
            if attr == nil then
                next = true
            end

            if next == false then 
                if attr.mode == 'directory' then
                    getpathes(path, pathes)
                else
                	if file_suffix == path:match(".+%.(%w+)$") then
                    	table.insert(pathes, path)
                    end
                end
            end
        end
        next = false
    end
    return pathes
end


function ImageSetReader.patchLoad(filename,textureEdit)
	local pathes = {}
	getpathes(filename, pathes)
	local error_num = 0
	local ok_num = 0
	local all_message = ""
	for _, path in pairs(pathes) do

		local ok,message = ImageSetReader.load(path,  textureEdit)
		if ok then
			local old_path = textureEdit.value
			local suffix = old_path:match(".+%.(%w+)$")
			local s = "."..suffix
			local d = "." .. new_suffix
			local new_path = string.gsub(old_path,s,d)
			new_path = new_path or old_path
			textureEdit.value = new_path

			ImageSetReader.changeTextureName(textureEdit)
			ok_num = ok_num + 1
		else
			error_num = error_num + 1
			all_message = all_message .. "[" .. error_num .. "=" .. message .. "],"
		end
	end
	if error_num > 0 then --有错误,返回nil,所有错误信息
		return nil,all_message
	else
		return true,"success " .. ok_num .. "个"
	end
end

function ImageSetReader.patchLoad_pvr(filename,textureEdit)
	local pathes = {}
	getpathes(filename, pathes)
	local error_num = 0
	local ok_num = 0
	local all_message = ""
	for _, path in pairs(pathes) do

		local ok,message = ImageSetReader.load(path,  textureEdit)
		if ok then
			local old_path = textureEdit.value
			local suffix = old_path:match(".+%.(%w+)$")
			local s = "."..suffix
			local d = ".pvr.gz"
			local t = ".pd"
			local new_path = string.gsub(old_path,t,d)
			new_path = new_path or old_path
			textureEdit.value = new_path

			ImageSetReader.changeTextureName(textureEdit)
			ok_num = ok_num + 1
		else
			error_num = error_num + 1
			all_message = all_message .. "[" .. error_num .. "=" .. message .. "],"
		end
	end
	if error_num > 0 then --有错误,返回nil,所有错误信息
		return nil,all_message
	else
		return true,"success " .. ok_num .. "个"
	end
end