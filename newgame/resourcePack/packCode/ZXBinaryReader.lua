require"iuplua"
require 'ZXBinaryLua'
require 'os'
local inputfile = arg[1]

ZXBinary = ZXBinaryLua
ZXImageSet = ZXBinary.ZXImageSet
ZXImageUnit = ZXBinary.ZXImageUnit

ZXFrameData = ZXBinary.ZXImageSet
ZXFrameSet = ZXBinary.ZXFrameSet

ImageSetReaderV1 = {}


function ImageSetReaderV1.changeTextureName(textureEdit)
	if ImageSetReaderV1.loadedfile then
		local filename = ImageSetReaderV1.loadedfile
		local gImageSet = ZXImageSet()

		gImageSet:Load(filename)
		gImageSet:SetTextureName(textureEdit.value)
		gImageSet:Save(filename)

		return ImageSetReaderV1.load(filename, textureEdit)
	end
	return false, '未知错误'
end



function ImageSetReaderV1.load(filename, textureEdit)
	local s = string.find(filename,'.imageset$') or string.find(filename,'.frame$')
	if s then
		local gImageSet = ZXImageSet()
		local gImageUnit = ZXImageUnit()

		ImageSetReaderV1.ImageSet = gImageSet

		gImageSet:Load(filename)
		local szTable = {}
		local count = gImageSet:ImageUnitCount()
		szTable[#szTable + 1] = string.format("file=\"%s\" count=%d\n",gImageSet:TextureName(),count);
		szTable[#szTable + 1] = '----------------------------------------------\n'
		notepad.textureChangeEdit.value = gImageSet:TextureName()
		for i=0, count - 1 do
			local iu = gImageSet:Get(i)
			szTable[#szTable + 1] = string.format("[%d] file=\"%s\" x=%d y=%d width=%d height=%d\n",i,iu:ImageName(),iu.x,iu.y,iu.width,iu.height);
		end
		textureEdit.value = gImageSet:TextureName()
		ImageSetReaderV1.loadedfile = filename
		return true, table.concat(szTable)
	else
		return false, '[ImageSetReaderV1] 无法转换未知文件类型 ' .. src
	end
end

local file_suffix = "imageset"

function _getpathes(rootpath, pathes)
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
                    _getpathes(path, pathes)
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

function ImageSetReaderV1.patchLoad(filename,textureEdit)
	local pathes = {}
	_getpathes(filename, pathes)
	local error_num = 0
	local ok_num = 0
	local all_message = ""
	local path_ = "num="..#pathes
	for _, path in pairs(pathes) do
		--return true,path--print("path========",path)
		
		local ok,message = ImageSetReaderV1.load(path,  textureEdit)
		if ok then
			local old_path = textureEdit.value
			local suffix = old_path:match(".+%.(%w+)$")
			local s = "."..suffix
			local d = "." .. "pvr.gz"
			local new_path = string.gsub(old_path,s,d)
			path_ = path_ .."old_path="..old_path.." s=="..s.."  d="..d.."new_path=="..new_path
			new_path = new_path or old_path
			textureEdit.value = new_path
			--path_ = path_ .. "  " ..textureEdit.value .. "new_path="..new_path.."old_path="..old_path
			ImageSetReaderV1.changeTextureName(textureEdit)
			ok_num = ok_num + 1

		else
			error_num = error_num + 1
			all_message = all_message .. "[" .. error_num .. "=" .. message .. "],"
		end
	end
	if error_num > 0 then --有错误,返回nil,所有错误信息
		return nil,all_message
	else
		return true,"success " .. ok_num .. " num"
	end
end