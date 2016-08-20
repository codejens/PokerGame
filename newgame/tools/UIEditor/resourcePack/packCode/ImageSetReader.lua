require 'XBinaryLua'

local XBinary = XBinaryLua
local XImageSet = XBinary.XImageSet
local XImageUnit = XBinary.XImageUnit

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
