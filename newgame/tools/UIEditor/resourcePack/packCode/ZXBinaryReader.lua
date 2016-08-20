require"iuplua"
require 'ZXBinaryLua'
require 'os'
local inputfile = arg[1]
--è¯»å†™äºŒè¿›åˆ¶å›¾ç‰‡
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
	return false, 'Î´Öª´íÎó'
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
		return false, '[ImageSetReaderV1] ÎÞ·¨×ª»»Î´ÖªÎÄ¼þÀàÐÍ ' .. src
	end
end
