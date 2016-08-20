-- pack.lua
-- created by aXing on 2012-11-21
-- 图片打包文件

require 'lfs'
require 'FreeImageToolBox'
require 'ZXBinaryLua'
require 'strbuf'
require 'xml'
require 'io'
require 'math'
sep = '/'
FreeImage = FreeImageToolBox

ImagePackProccess = { filelist = {}, src = FreeImage.fipImage() }

function convert_output( outputfile , width, height, outformat)
	local opt = opt or 2
	local outformat = outformat or 'RGB565' 
	local app = 'TexturePacker'
	local args ='%s --sheet %s --width %d --height %d --opt %s'--png-opt-level %d 
	local otherargs = '--shape-padding 0 --border-padding 0 --disable-rotation --trim-mode None --dither-fs ' --alpha  '
	local args = string.format(args, outputfile, outputfile, width, height, outformat)
	
	print('converting to ' .. outformat)
	os.execute(app .. ' ' .. args .. ' ' .. otherargs)
end

--记录预处理文件信息，用于排序
function ImagePackProccess:GetImageData(file,name)
	print(file)
	if not self.src:load(file) then
		error(string.format('ImagePackProccess: pack failed load %s',file))
	end

	return { ['f'] = file,
			 ['w'] = self.src:getWidth(),
			 ['h'] = self.src:getHeight(),
			 ['s'] = name}
end

--遍历文件夹
function ImagePackProccess:TravelPath (path)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = path..sep..file
			local attr = lfs.attributes (f)
			assert (type(attr) == "table")
			if attr.mode == "directory" then
				self:TravelPath (f)
			else
				self.filelist[#self.filelist+1] = self:GetImageData(f,file)
				--self:PackSingleImage(f)
			end
		end
	end
end

function ImagePackProccess : BatchConvert()
	for i,v in ipairs(self.filelist) do
		convert_output(v.f,v.w,v.h)
	end
end

ImagePackProccess:TravelPath('E:\\mobile_client\\develop\\resource\\map\\Objects')
ImagePackProccess : BatchConvert()