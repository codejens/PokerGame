require 'lfs'
require 'FreeImageToolBox'
require 'ZXBinaryLua'
require 'strbuf'
require 'xml'
require 'io'
require 'math'
require 'os'

sep = '\\'
FreeImage = FreeImageToolBox

--读写二进制图�?
ZXBinary = ZXBinaryLua
ZXImageSet = ZXBinary.ZXImageSet
ZXImageUnit = ZXBinary.ZXImageUnit
--读写二进制动画帧
ZXFrameData = ZXBinary.ZXFrameData
ZXFrameArray = ZXBinary.ZXFrameArray
ZXFrameSet = ZXBinary.ZXFrameSet


local gImageSet = ZXImageSet()
local gImageUnit = ZXImageUnit()

local gFrameData = ZXFrameData()
local gFrameSet = ZXFrameSet()

mapTileProcessor = {}

ImagePacker = FreeImage.CygonRectanglePacker

function mapTileProcessor : init()
	self.src = FreeImage.fipImage()
	self.filelist = {}
	self.dpi = 0
	self.quality = 0
	self.filter = ''
end


--遍历文件�?
function mapTileProcessor:TravelPath (path)
	for file in lfs.dir(path) do
		print("file",file)
		if file ~= "." and file ~= ".." and file ~= '.svn' then
			local f = path..sep..file
			local attr = lfs.attributes (f)
			assert (type(attr) == "table")
			if attr.mode == "directory" then
				self:TravelPath (f)
			else
				local k = string.find(file, ".pd")
				fn = string.sub(file, 0, k - 1)
				print("fn",fn)
				print("f",f)
				print("path",path)
				print("sep",sep)
				print("file",file)
				--os.execute('convert ' .. f .. ' -set colorspace RGB -colorspace gray -posterize 16 ' .. path .. sep .. fn .. "_d" .. ".png")
				--os.execute('convert ' .. f .. ' -posterize 8 ' .. path .. sep  .. file)
				--if k then
				--	fn = string.sub(file,0,5)
				--	if tonumber(fn) then
				--		print("fn",fn)
				--		print("f",f);
				--		print("path",path)
				--		print("sep",sep)
				--		print("file",file)
						--print("command",'convert ' .. f .. ' -set colorspace RGB -colorspace gray -posterize 16 ' .. path .. sep .. fn .. "_d" .. ".png")
				--		os.execute('convert ' .. f .. ' -set colorspace RGB -colorspace gray -posterize 16 ' .. path .. sep .. fn .. "_d" .. ".png")
						os.execute('convert ' .. f .. ' -posterize 8 ' .. path .. sep  .. file)
						--return
				--	else
				--		local fileLen = string.len(file)
				--		fn = string.sub(file, 0, k - 1)
				--		print("!!fn",fn)
				--	end
				--end
			end
		end
	end
end

--mapTileProcessor:TravelPath('../resource/icon/item/')
--mapTileProcessor:TravelPath('../resource/icon/interface/others')
mapTileProcessor:TravelPath('../resource/icon/tt/')
--mapTileProcessor:TravelPath('../resource/icon/skill/')
