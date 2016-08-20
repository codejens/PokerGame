-- pack.lua
-- created by aXing on 2012-11-21
-- Í¼Æ¬´ò°üÎÄ¼þ

require 'lfs'
require 'FreeImageToolBox'
require 'ZXBinaryLua'
require 'strbuf'
require 'xml'
require 'io'
require 'math'


print (lfs._VERSION)


fMinAlpha = 0.02
final_pack = true
first_pack = true
sort_type = 1
-- ¸ù¾ÝÓÎÏ·Ä¬ÈÏµÄÃ¿Ö¡ÌùÍ¼´óÐ¡ ÒÔ¼°Ä¬ÈÏÃªµã
orginal_size		= { 630, 473 }
orginal_center 	= { 316, 236 }

--[[

	FreeImageToolBox.CygonRectanglePacker
		-- Éú³ÉÒ»¸ö´ò°üÅÅÐòÆ÷£¬ÓÃÓÚ·µ»Ø¿ÕÏÐÎ»ÖÃ
		-- ¹¹Ôìº¯ÊýÐèÒª´óÍ¼µÄ³¤¿í

		CygonRectanglePacker:TryPack
			-- ³¢ÊÔ´ò°ü²ÎÊýÎªÐ¡Í¼³¤¿í
			-- Ê§°Ü·µ»Ønil£¬·ñÔò·µ»Ø{ x, y }

	FreeImageToolBox.fipImage
		-- Éú³ÉÒ»¸öfreeimage¶ÔÏó£¬¿ÉÓÃ²ÎÊý(fmt,width,height,BPP)
		fmt =
			FIT_UNKNOWN = 0,	// unknown type
			FIT_BITMAP  = 1,	// standard image			: 1-, 4-, 8-, 16-, 24-, 32-bit
			FIT_UINT16	= 2,	// array of unsigned short	: unsigned 16-bit
			FIT_INT16	= 3,	// array of short			: signed 16-bit
			FIT_UINT32	= 4,	// array of unsigned long	: unsigned 32-bit
			FIT_INT32	= 5,	// array of long			: signed 32-bit
			FIT_FLOAT	= 6,	// array of float			: 32-bit IEEE floating point
			FIT_DOUBLE	= 7,	// array of double			: 64-bit IEEE floating point
			FIT_COMPLEX	= 8,	// array of FICOMPLEX		: 2 x 64-bit IEEE floating point
			FIT_RGB16	= 9,	// 48-bit RGB image			: 3 x 16-bit
			FIT_RGBA16	= 10,	// 64-bit RGBA image		: 4 x 16-bit
			FIT_RGBF	= 11,	// 96-bit RGB float image	: 3 x 32-bit IEEE floating point
			FIT_RGBAF	= 12	// 128-bit RGBA float image	: 4 x 32-bit IEEE floating point
		BPP = 8,16,32,64, Ã¿¸öÏñËØµÄ´óÐ¡

		fipImage:copySubImage(dst,left,top,right,bottom)    --°Ñµ±Ç°ÎÆÀíµÄÒ»²¿·Ö¸´ÖÆµ½dst
		fipImage:pasteSubImage(src,x,y) 					--°ÑsrcÕ³Ìùµ½µ±Ç°ÎÆÀíµÄ(x,yÎ»ÖÃ)
		fipImage:save
		fipImage:load


		FreeImageToolBox.GetRectFromAlpha
			--»ñÈ¡alpha boundingbox,
			--ÐèÒªÒ»¸öfipImage×÷ÎªÊäÈë
			--Ê§°Ü·µ»Ønil£¬³É¹¦·µ»Øtable = { left, top, right , bottom}

		FreeImageToolBox.ResizeToTransparent
			--»ñÈ¡alpha²Ã¼ôÒÔºóµÄflipImage
			--ÐèÒªÒ»¸öfipImage×÷ÎªÊäÈë
			--Ê§°Ü·µ»Ønil£¬³É¹¦·µ»ØÒ»¸öÐÂµÄfipImage¶ÔÏó


			--Õâ¸öº¯ÊýÆäÊµ¿ÉÒÔÓÃ½Å±¾Íê³É
				local dst = FreeImage.GetRectFromAlpha(self.src)
				if dst then
					src:copySubImage(dst,dst[1],dst[2],dst[3]+1,dst[4]+1)
				end
			local dst = FreeImage.ResizeToTransparent(self.src)

]]--
--redirect

FreeImage = FreeImageToolBox

--¶ÁÐ´¶þ½øÖÆÍ¼Æ¬
ZXBinary = ZXBinaryLua
ZXImageSet = ZXBinary.ZXImageSet
ZXImageUnit = ZXBinary.ZXImageUnit
--¶ÁÐ´¶þ½øÖÆ¶¯»­Ö¡
ZXFrameData = ZXBinary.ZXFrameData
ZXFrameArray = ZXBinary.ZXFrameArray
ZXFrameSet = ZXBinary.ZXFrameSet


local gImageSet = ZXImageSet()
local gImageUnit = ZXImageUnit()

local gFrameData = ZXFrameData()
local gFrameSet = ZXFrameSet()

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


function SaveImageSet(xmltable, fname)
	--print(xmltable.attr.file,#xmltable)
	xmltable.attr.file = string.gsub(xmltable.attr.file,'[/\\]','/')
	if tonumber(convertWebp) == 1 then
		converted = xmltable.attr.file
		local i = string.find(converted,'.jpg')
		if i then
			converted = string.sub(converted,1,i) .. 'wd'
		else
			i = string.find(converted,'.png')
			if i then
				converted = string.sub(converted,1,i) .. 'wd'
			end
		end
		xmltable.attr.file = converted
	else
		converted = xmltable.attr.file
		local i = string.find(converted,'.jpg')
		if i then
			converted = string.sub(converted,1,i) .. 'jd'
		else
			i = string.find(converted,'.png')
			if i then
				converted = string.sub(converted,1,i) .. 'pd'
			end
		end
		xmltable.attr.file = converted
	end
	gImageSet:Initialize(xmltable.attr.file, #xmltable)
	for i,v in ipairs(xmltable) do
		print('>>',v.attr.width,v.attr.height,v.attr.file)
		v.attr.file = string.gsub(v.attr.file,'[/\\]','/')
		if not gImageUnit:Set( v.attr.x,v.attr.y,
								  v.attr.width,
								  v.attr.height,
								  v.attr.file ) then
			error('failed to set ImageUnit',  xmltable.attr.file);
		end

		if not gImageSet:Set(gImageUnit, i - 1) then
			error('failed to set ImageUnit',  v.attr.file);
		end
	end
	local new_fname = string.gsub(fname,'.xml$','.imageset')

	gImageSet:Save(new_fname)
end

function SaveFrameSet(xmltable,fname)
	xmltable.attr.file = string.gsub(xmltable.attr.file,'[/\\]','/')

	if tonumber(convertWebp) == 1 then
		converted = xmltable.attr.file
		local i = string.find(converted,'.jpg')
		if i then
			converted = string.sub(converted,1,i) .. 'wd'
		else
			i = string.find(converted,'.png')
			if i then
				converted = string.sub(converted,1,i) .. 'wd'
			end
		end
		xmltable.attr.file = converted
	else
		converted = xmltable.attr.file
		local i = string.find(converted,'.jpg')
		if i then
			converted = string.sub(converted,1,i) .. 'jd'
		else
			i = string.find(converted,'.png')
			if i then
				converted = string.sub(converted,1,i) .. 'pd'
			end
		end
		xmltable.attr.file = converted
	end

	gFrameSet:Initialize(xmltable.attr.file, #xmltable)
	for i,v in ipairs(xmltable) do
		v.attr.file = string.gsub(v.attr.file,'[/\\]','/')
		if not gFrameData:Set( v.attr.x,v.attr.y,
							   v.attr.width,
							   v.attr.height,
							   v.attr.anchor_x,
							   v.attr.anchor_y,
							   v.attr.file ) then
			error('failed to set ImageUnit ' ..  xmltable.attr.file);
		end

		if not gFrameSet:Set(gFrameData, i - 1) then
			error('failed to set ImageUnit ' ..  v.attr.file);
		end
	end
	local new_fname = string.gsub(fname,'.xml$','.frame')
	gFrameSet:Save(new_fname)
end

ImagePacker = FreeImage.CygonRectanglePacker

--´ò°ü¿â
ImagePackProccess = { }
--×îÐ¡alpha£¬²ÃÇÐÍ¼Æ¬µÄÊ±ºòÐ¡ÓÚ¸Ãalpha½«»á±»ºöÂÔ




local sep = "/"
local upper = ".."
local imageset_ext = '.xml'


function del_path(_path)
	--_path = string.gsub(_path,'/','\\')
	--os.execute('del /s /q ' .. _path)
end

function renameFile(outputfile, s, d)
	local i = string.find(outputfile, s)
	cmd = 'copy ' .. outputfile .. ' ' .. string.sub(outputfile,1,i-1) .. d
	cmd = string.gsub(cmd,'[/\\]','\\')
	print(cmd)
	os.execute(cmd)
	del = string.gsub(outputfile,'[/\\]','\\')
	cmd = 'del ' .. del
	print(cmd)
	os.execute(cmd)
end

function convert_output( outputfile , width, height, opt, outformat)


	---------------------------------

	if tonumber(convertWebp) == 1 then
		converted = ''
		local i = string.find(outputfile,'.jpg')
		if i then
			converted = string.sub(outputfile,1,i) .. 'wd'
		else
			i = string.find(outputfile,'.png')
			if i then
				converted = string.sub(outputfile,1,i) .. 'wd'
			end
		end

		if converted ~= '' then
			local c = string.format('cwebp.exe %s -o %s', outputfile, converted)
			c = string.gsub(c,'[/\\]','\\')
			os.execute(c)
			c = string.gsub(c,'[/\\]','\\')
			outputfile = string.gsub(outputfile,'[/\\]','\\')
			c = string.format('del /S /Q %s',outputfile)
			print(c)
			os.execute(c)
		end
		return
	elseif g_renameFile then
		--renameFile(outputfile,'.png','.pd')
	end

	local opt = 2
	if g_RGBA8888 == 0 then
		outformat = 'RGBA4444'
		opt = 2
	else
		outformat = 'RGBA8888'
		opt = 5
	end
	local app = 'TexturePacker'
	local args ='%s --sheet %s --width %d --height %d --png-opt-level %d --opt %s'
	local otherargs = '--shape-padding 0 --border-padding 0 --disable-rotation --trim-mode None ' .. compress_type --premultiply-alpha'
	local args = string.format(args, outputfile, outputfile, width, height, opt, outformat)
	print('>>>' .. compress_type)
	print('converting to ' .. args)
	os.execute(app .. ' ' .. args .. ' ' .. otherargs)
	i = string.find(outputfile,'.png')

	cmd = 'copy ' .. outputfile .. ' ' .. string.sub(outputfile,1,i) .. 'pd'
	cmd = string.gsub(cmd,'[/\\]','\\')
	print(cmd)
	os.execute(cmd)
	del = string.gsub(outputfile,'[/\\]','\\')
	cmd = 'del ' .. del
	print(cmd)
	os.execute(cmd)
end

--±éÀúÎÄ¼þ¼Ð
function ImagePackProccess:TravelPath (path)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." and file ~= ".svn" then
			local f = path..sep..file
			local attr = lfs.attributes (f)
			assert (type(attr) == "table")
			if attr.mode == "directory" then
				self:TravelPath (f)
			else
				local s = self:GetImageData(f,file)
				if s then
					self.filelist[#self.filelist+1] = s
				end
				--self:PackSingleImage(f)
			end
		end
	end
end

-- Çå¿ÕÊä³öÎÄ¼þ¼ÐÄÚµÄÎÄ¼þ
function ImagePackProccess:ClearOutPath()
	--[[
	for file in lfs.dir(self.out_path) do
		if file ~= "." and file ~= ".." then
			local f = self.out_path..sep..file
			os.remove(f)
		end
	end
	]]--
end

--±£´æXML´ò°üÓÃ
function ImagePackProccess:SaveDst()
	local o = self:GetOutputFileName(self.out_file_ext)
	local xmlfilename = self:GetOutputFileName(imageset_ext)
	local w = self.dst:getWidth()
	local h = self.dst:getHeight()
	local xmltable = self.xmltable[self.count]

	packmkdir(self.out_path)

	self.dst:save(o)

	convert_output(o,w,h)

	-----------------------------------
	--local xmlstring = string.writeXML(xmltable,'  ', '  ')
	print("save",o,self.dst:getWidth(),self.dst:getHeight())
	--f = io.open(xmlfilename, 'wb+')
	--f:write(xmlstring)
	--io.close(f)

	SaveFrameSet(xmltable, xmlfilename)
	self.count = self.count + 1

end

-- ÓÃÓÚ´ò°üui×ÊÔ´£¬ÖØÐÂ´ò°üÈ«²¿×ÊÔ´
function ImagePackProccess:SaveAll(  )
	for i=1,self.count do
		local o = self:GetOutputFileName(self.out_file_ext, i)
		local xmlfilename = self:GetOutputFileName(imageset_ext, i)
		local dst = self.dsts[i]
		local w = dst:getWidth()
		local h = dst:getHeight()

		packmkdir(self.out_path)

		dst:save(o)
		convert_output(o,w,h)

		-- save xml
		print("save",o,dst:getWidth(),dst:getHeight())
		--local xmlstring = string.writeXML(self.xmltable[i],'  ', '  ')
		--f = io.open(xmlfilename, 'wb+')
		--f:write(xmlstring)
		--io.close(f)
		-- save binary
		SaveImageSet(self.xmltable[i], xmlfilename)
	end
end

--»ñÈ¡Êä³öÎÄ¼þÃû£¬´ò°üÓÃ
function ImagePackProccess:GetOutputFileName(out_file_ext, index)
	if index == nil then
		index = self.count
	end
	return self.out_path .. '/' ..
		   self.out_prefix ..
	       tostring(index) ..
	       out_file_ext
end

--»ñÈ¡Êä³öÎÄ¼þÃû£¬¶ÁÐ´ÓÃ
function ImagePackProccess:GetOutputPath( out_file_ext )
	--return string.lower(
	return self.out_path_prefix .. '/' ..
		   self.out_prefix ..
		   tostring(self.count) ..
		   out_file_ext
	--)
end

--ÐÂµÄÎÄ¼þ¸ù´ò°üÓÃ
function ImagePackProccess:NewDstAndTable()
	self.packer = ImagePacker(self.out_width,self.out_height)

	self.packers[self.count] = self.packer

	self.dst = FreeImage.fipImage( self.out_fmt,
								   self.out_width,
								   self.out_height,
								   self.out_BPP)

	self.dsts[self.count]	= self.dst

	self:NewIUXmlTable();

end

function ImagePackProccess:NewIUXmlTable()
	self.xmltable[self.count] = {
									tag = 'ImageSet',
									attr = { ['width'] = self.out_width,
									         ['height'] = self.out_height,
											 ['bbp'] = self.out_BPP,
											 ['file'] = self:GetOutputPath(self.out_file_ext),
											 ['center_x'] = self.out_center[1],
											 ['center_y'] = self.out_center[2],
										   }
								}
end


--¼ÇÂ¼Ô¤´¦ÀíÎÄ¼þÐÅÏ¢£¬ÓÃÓÚÅÅÐò
function ImagePackProccess:GetImageData(file,name)
	if not self.src:load(file) then
		print(string.format('ImagePackProccess: pack failed load %s \n ',file))
		return nil
	end

	return { ['f'] = file,
			 ['w'] = self.src:getWidth() + 1,
			 ['h'] = self.src:getHeight() + 1,
			 ['s'] = name}
end

-- ±éÀúÒÑÓÐµÄÌùÍ¼£¬¿´ÊÇ·ñ¿ÉÒÔ·ÅµÃÏÂ
function ImagePackProccess:TryToPack( width, height )

	for i, packer in ipairs(self.packers) do
		local result = packer:TryPack(width, height)
		if result then
			--print("TryToPack", i, result, packer, width, height)
			return i, result
		end
	end
	return nil, nil
end

-- ´ò°üÃ¿Ò»ÕÅÍ¼Æ¬µÄº¯Êý
function ImagePackProccess:PackSingleImage2( file_path, file_name, secondtry )

	-- ÏÈ¼ÆËãÒª²Ã¼ô¶àÉÙalphaºÍbb
	print('GetRectFromAlpha',file_name)
	local dst = FreeImage.GetRectFromAlpha(self.src,fMinAlpha)
	print('>>>',dst[1],dst[2],dst[3],dst[4],fMinAlpha)
	print('>>>',self.src[1],self.src[2],self.src[3],self.src[4])
	if dst == nil then
		local bb = self.src:getBitsPerPixel()
		-- png8²»²Ù×÷
		if self.src:isTransparent() and bb ~= 8 then
			--È«Í¸
			dst = {0,0,2,2}
		else
			dst = {0, 0, self.src:getWidth(), self.src:getHeight()}
		end
		-- print("can not cut", file_path, file_name)

	end
	-- print("self.src",self.src)
	-- print("dst",dst)
	--self:PackSingleImage(v, v.f,v.s,v.w,v.h)
	-- °ÑÃ¿Ò»ÕÅÍ¼¸´ÖÆ¹ýÈ¥
	local result = self.packer:TryPack(dst[3] - dst[1] + 2, dst[4] - dst[2] + 2)	-- Ñ¯ÎÊÊÇ·ñ¹»Î»ÖÃ

	if result then
		local tmp = FreeImage.fipImage()
		self.src:copySubImage(tmp, dst[1], dst[2], dst[3], dst[4])		-- ¸´ÖÆ

		self.needsaved = true

		local x 	 	= result[1];
		local y 	 	= result[2];
		local width  	= dst[3] - dst[1]
		local height 	= dst[4] - dst[2]
		local anchor_x	= self.out_center[1] - dst[1]
		local anchor_y	= self.out_center[2] - dst[4]
		local root 	 	= self.xmltable[self.count]
		local st, en 	= string.find(file_path, self.out_path_prefix)

		--print('>>',file_path,self.out_path_prefix)
		local file_key	= string.sub(file_path, st, -1)
		print("PackSingleImage2 " .. file_path .. ", " .. self.out_path_prefix .. ", " .. file_key)
		local iu   	 = { tag = 'ImageUnit',
					   attr = {
								['x'] 		= x,									-- ÆðÊ¼x
								['y']		= y,									-- ÆðÊ¼y
								['width'] 	= width,								-- ÇÐÆ¬width
								['height'] 	= height,								-- ÇÐÆ¬height
								['file'] 	= file_key, 							-- string.lower(file_key),								-- Ô­Ê¼Â·¾¶£¬ÓÃÓÚ×ökey
								['name'] 	= file_name,							-- ÎÄ¼þÃû Ä¿Ç°²»ÐèÒª
--								['u0'] 		= x / self.out_width,					-- uv cocos2dx²»ÐèÒª
--								['v0'] 		= y / self.out_height,
--								['u1'] 		= (x + width) / self.out_width,
--								['v1'] 		= (y + height) / self.out_height,
								['anchor_x']= anchor_x,								-- ÃªµãÎ»ÖÃ ÓÃÓÚÐòÁÐÖ¡¶¯»­¶Ô½¹
								['anchor_y']= anchor_y,
							  }
						}
--		iu[1] = { tag = 'boundingbox',
--				  attr= {
--							['left'] 	= dst[1],
--							['top'] 	= dst[2],
--							['right'] 	= dst[3],
--							['bottom'] 	= dst[4],
--						}
--				}
		--print('>>>>>>>>>>>>>',root,self.xmltable,self.count])
		root[#root+1] = iu
		self.dst:pasteSubImage(tmp,x,y)
	else
		--µÚ¶þ´Î½øÀ´¾Í³ö´íÁË£¬¿ÉÄÜÊÇÔ´±ÈÄ¿±ê»¹´ó
		if secondtry then
			error(string.format('ImagePackProccess failed pack %s\n ¶¨ÒåµÄÄ¿±êÍ¼Æ¬´óÐ¡Ì«Ð¡',file_path))
		end
		--±£´æ
		self:SaveDst()
		--ÐÂµÄpacker
		self:NewDstAndTable()
		ImagePackProccess:PackSingleImage2( file_path, file_name, true )
	end
end

-- ÇÐ³ý¿Õ°×µÄalpha²¢´ò°ü£¬
function ImagePackProccess:__ResizeAndPack( in_path,				-- ÐèÒª´ò°üµÄÎÄ¼þ¼Ð
										  out_path,				-- Êä³öÂ·¾¶
										  out_path_prefix,		-- Ð´ÈëÎÄ¼þÂ·¾¶
										  out_prefix,			-- Êä³öÎÄ¼þÃûÇ°×º
										  out_file_ext,			-- Êä³öÎÄ¼þÃûºó×º
										  out_width,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¿í¶È
										  out_height,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¸ß¶È
										  out_BPP,				-- Ã¿¸öÏñËØµÄÍ¨µÀ
										  out_fmt,				-- Í¼Æ¬¸ñÊ½
										  out_center)			-- Ãªµã



	self.in_path 		= in_path
	self.out_path 		= out_path
	self.out_path_prefix= out_path_prefix
	self.out_prefix 	= out_prefix
	self.out_file_ext 	= out_file_ext
	self.out_width 		= out_width
	self.out_height 	= out_height
	self.out_BPP 		= out_BPP
	self.out_fmt 		= out_fmt
	self.out_center 	= out_center
	-----------------------------
	self.src = FreeImage.fipImage()
	-----------------------------
	if first_pack then
		self.packers		= {}
		self.dsts			= {}
		self.xmltable 		= {}
		self.count 			= 1
		self:NewDstAndTable()
	else
		--self:NewIUXmlTable();
	end
	-----------------------------
	-- ±éÀúÎÄ¼þÖÐµÄÎÄ¼þ
	if in_path then
		self.filelist = {}
		self:TravelPath(in_path)
		if sort_type == 1 then
			table.sort(self.filelist, function(v1,v2) return v1.h > v2.h end)
		elseif sort_type == 2 then
			table.sort(self.filelist, function(v1,v2) return v1.h < v2.h end)
		end
	elseif #self.filelist == 0 then
		error('PackImages in_path empty')
	end

	-- Çå¿ÕÄ¿±êÎÄ¼þ¼Ð
	-- self:ClearOutPath()

	-- °ÑÃ¿Ò»ÕÅÍ¼Ìù¹ýÈ¥
	--print('>>>',self.xmltable)

	self.needsaved = false
	for i,v in ipairs(self.filelist) do
		if self.src:load(v.f) then
			ImagePackProccess:PackSingleImage2(v.f, v.s, false)
		end
	end

	if final_pack then
		if self.needsaved then
			local t = self.packer:CurrentSizePow2()
			if t[1] < self.out_width or t[2] < self.out_height then
				self.xmltable[self.count].attr.width = t[1]
				self.xmltable[self.count].attr.height = t[2]

				local newdst = FreeImage.fipImage()
				self.dst:copySubImage(newdst,0,0,t[1],t[2])
				self.dst = newdst
			end
			self:SaveDst()
			--print('ImagePackProccess',self.packer:CurrentSize())
		end
	end

	print("frame pack done!!")
end

--´ò°üµ¥¸öÎÄ¼þµÄ²Ù×÷(²»×öalphaÇÐ¸î)
function ImagePackProccess:PackSingleImage(filedata, file, name, width, height, secondtry, saveImage)

	if saveImage == nil then
		saveImage = true
	end
	if not self.src:load(file) then
		error(string.format('ImagePackProccess failed load %s',file))
	end

	-- local result = self.packer:TryPack(width, height)

	local index, result = self:TryToPack(width, height)
	print('TryToPack',file,result)
	if result then
		--[[
		print('PackSingleImage', file,'\n', "Index", index, "\n",
			  'pos', result[1], result[2], '\n',
			  'width', width, 'height', height, '\n',
			  '-----------------------------------\n')
		]]--
		local x = result[1];
		local y = result[2];
		-- self.dst:pasteSubImage(self.src,x,y)
		self.dsts[index]:pasteSubImage(self.src,x,y)

		self.needsaved = true

		local st, en 	= string.find(file, self.out_path_prefix)
		local file_key	= string.sub(file, st, -1)
		-- local root 		= self.xmltable[self.count]
		local root 		= self.xmltable[index]
		local iu      	= { tag = 'ImageUnit',
						  attr = {
									['x'] = x,
									['y'] = y,
									['width'] = width - 1,
									['height'] = height - 1,
									['file'] = file_key,
--									['name'] = name,
--									['u0'] = x / self.out_width,
--									['v0'] = y / self.out_height,
--									['u1'] = (x + width) / self.out_width,
--									['v1'] = (y + height) / self.out_height
								  }
						}

		root[#root+1] = iu

	else
		--µÚ¶þ´Î½øÀ´¾Í³ö´íÁË£¬¿ÉÄÜÊÇÔ´±ÈÄ¿±ê»¹´ó
		if secondtry then
			error(string.format('ImagePackProccess failed pack %s\n ¶¨ÒåµÄÄ¿±êÍ¼Æ¬´óÐ¡Ì«Ð¡',file))
		end
		--±£´æ
		if saveImage then
			self:SaveDst()
		else
			self.count = self.count + 1
		end
		--ÐÂµÄpacker
		self:NewDstAndTable()
		index = ImagePackProccess : PackSingleImage(filedata,file,name,width,height,true, saveImage)
	end

	return index
end

-- µ¥´¿´ò°üÃÀÊõ×ÊÔ´(²»×öalphaÇÐ¸î)
function ImagePackProccess:__OnlyPack( in_path,				-- ÐèÒª´ò°üµÄÎÄ¼þ¼Ð
									 out_path,				-- Êä³öÂ·¾¶
									 out_path_prefix,		-- Ð´ÈëÎÄ¼þÂ·¾¶
									 out_prefix,			-- Êä³öÎÄ¼þÃûÇ°×º
									 out_file_ext,			-- Êä³öÎÄ¼þÃûºó×º
									 out_width,				-- Ã¿Ò»ÕÅÎÆÀíµÄ¿í¶È
									 out_height,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¸ß¶È
									 out_BPP,				-- Ã¿¸öÏñËØµÄÍ¨µÀ
									 out_fmt)				-- Í¼Æ¬¸ñÊ½

	self.in_path 		= in_path
	self.out_path 		= out_path
	self.out_path_prefix= out_path_prefix
	self.out_prefix 	= out_prefix
	self.out_file_ext 	= out_file_ext
	self.out_width 		= out_width
	self.out_height 	= out_height
	self.out_BPP 		= out_BPP
	self.out_fmt 		= out_fmt
	self.out_center 	= {0,0}				-- Ä¬ÈÏÃªµãÊÇ×óÉÏ½Ç
	-----------------------------
	self.src = FreeImage.fipImage()
	-----------------------------
	if first_pack then
		self.packers		= {}
		self.dsts			= {}
		self.xmltable 		= {}
		self.count 			= 1
		self:NewDstAndTable()
	else
		--self:NewIUXmlTable();
	end
	-----------------------------
	-- ±éÀúÎÄ¼þÖÐµÄÎÄ¼þ
	if in_path then
		self.filelist = {}
		self:TravelPath(in_path)
		if sort_type == 1 then
			table.sort(self.filelist, function(v1,v2) return v1.h > v2.h end)
		elseif sort_type == 2 then
			table.sort(self.filelist, function(v1,v2) return v1.h < v2.h end)
		end
	elseif #self.filelist == 0 then
		error('PackImages in_path empty')
	end

	-- Çå¿ÕÄ¿±êÎÄ¼þ¼Ð
	self:ClearOutPath()

	-- °ÑÃ¿Ò»ÕÅÍ¼Ìù¹ýÈ¥
	self.needsaved = false
	for i,v in ipairs(self.filelist) do
		if self.src:load(v.f) then
			local i = self:PackSingleImage(v, v.f, v.s, v.w, v.h,false,false)
			--[[
			local t = self.packers[i]:CurrentSizePow2()
			if t[1] < self.out_width or t[2] < self.out_height then
				local newdst = FreeImage.fipImage()
				self.dsts[i]:copySubImage(newdst,0,0,t[1],t[2])
				self.dsts[i] = newdst
			end
			]]--
		end
	end

	if final_pack then
		if self.needsaved then
			local i = self.count
			local dst = self.dsts[i]
			local packer = self.packers[i]

			local t = packer:CurrentSizePow2()
			if t[1] < self.out_width or t[2] < self.out_height then
				self.xmltable[i].attr.width = t[1]
				self.xmltable[i].attr.height = t[2]

				local newdst = FreeImage.fipImage()
				dst:copySubImage(newdst,0,0,t[1],t[2])
				self.dsts[i] = newdst
			end
		end
		self:SaveAll()
	end



	print("ui pack done!!")
end



-- ´ò°ü³¡¾°×ÊÔ´ÐòÁÐÖ¡
function ImagePackProccess:Resize_Pack_Scene( in_path, out_path )

	-- ÓÅÏÈ±éÀúÂ·¾¶ÏÂÃæµÚÒ»²ãµÄ³¡¾°ÎÄ¼þ¼Ð
	del_path(out_path);

	print('start pack',in_path)

	for file in lfs.dir(in_path) do
		if file ~= "." and file ~= ".." and file ~= ".svn" then
			local f = in_path..sep..file
			local attr = lfs.attributes (f)
			assert (type(attr) == "table")
			if attr.mode == "directory" then
				ImagePackProccess:__ResizeAndPack( f, out_path, "scene", file,
								 ".png",
								 512, 512, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)
			end
		end
	end
	print("scene pack done!!")
end

function ImagePackProccess:ResizeAndPack( in_path,				-- ÐèÒª´ò°üµÄÎÄ¼þ¼Ð
										  out_path,				-- Êä³öÂ·¾¶
										  out_path_prefix,		-- Ð´ÈëÎÄ¼þÂ·¾¶
										  out_prefix,			-- Êä³öÎÄ¼þÃûÇ°×º
										  out_file_ext,			-- Êä³öÎÄ¼þÃûºó×º
										  out_width,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¿í¶È
										  out_height,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¸ß¶È
										  out_BPP,				-- Ã¿¸öÏñËØµÄÍ¨µÀ
										  out_fmt,				-- Í¼Æ¬¸ñÊ½
										  out_center)			-- Ãªµã


	del_path(out_path);
	print('start pack',in_path)
	self:__ResizeAndPack( in_path,				-- ÐèÒª´ò°üµÄÎÄ¼þ¼Ð
						  out_path,				-- Êä³öÂ·¾¶
						  out_path_prefix,		-- Ð´ÈëÎÄ¼þÂ·¾¶
						  out_prefix,			-- Êä³öÎÄ¼þÃûÇ°×º
						  out_file_ext,			-- Êä³öÎÄ¼þÃûºó×º
						  out_width,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¿í¶È
						  out_height,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¸ß¶È
						  out_BPP,				-- Ã¿¸öÏñËØµÄÍ¨µÀ
						  out_fmt,				-- Í¼Æ¬¸ñÊ½
						  out_center )			-- Ãªµã
end


function ImagePackProccess:OnlyPack( in_path,				-- ÐèÒª´ò°üµÄÎÄ¼þ¼Ð
									 out_path,				-- Êä³öÂ·¾¶
									 out_path_prefix,		-- Ð´ÈëÎÄ¼þÂ·¾¶
									 out_prefix,			-- Êä³öÎÄ¼þÃûÇ°×º
									 out_file_ext,			-- Êä³öÎÄ¼þÃûºó×º
									 out_width,				-- Ã¿Ò»ÕÅÎÆÀíµÄ¿í¶È
									 out_height,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¸ß¶È
									 out_BPP,				-- Ã¿¸öÏñËØµÄÍ¨µÀ
									 out_fmt)				-- Í¼Æ¬¸ñÊ½

	--del_path(out_path);
	print('start pack',in_path)
	self:__OnlyPack( in_path,				-- ÐèÒª´ò°üµÄÎÄ¼þ¼Ð
					 out_path,				-- Êä³öÂ·¾¶
					 out_path_prefix,		-- Ð´ÈëÎÄ¼þÂ·¾¶
					 out_prefix,			-- Êä³öÎÄ¼þÃûÇ°×º
					 out_file_ext,			-- Êä³öÎÄ¼þÃûºó×º
					 out_width,				-- Ã¿Ò»ÕÅÎÆÀíµÄ¿í¶È
					 out_height,			-- Ã¿Ò»ÕÅÎÆÀíµÄ¸ß¶È
					 out_BPP,				-- Ã¿¸öÏñËØµÄÍ¨µÀ
					 out_fmt)				-- Í¼Æ¬¸ñÊ½
end
