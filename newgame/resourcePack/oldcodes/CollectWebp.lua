require 'lfs'
--require 'FreeImageToolBox'
require 'strbuf'
require 'xml'
require 'io'
require 'math'
require 'framePacker'
require 'ZXBinaryLua'

FreeImage = FreeImageToolBox

--¬∂√Å√ê¬¥¬∂√æ¬Ω√∏√ñ√Ü√ç¬º√Ü¬¨
ZXBinary = ZXBinaryLua
ZXImageSet = ZXBinary.ZXImageSet
ZXImageUnit = ZXBinary.ZXImageUnit

local sep = '\\'

function splitfilename(strfilename)
	-- Returns the Path, Filename, and Extension as 3 values
	return string.match(strfilename, "(.-)([^\\/]-([^\\/%.]+))$")
end

local processList = {}
--±È¿˙Œƒº˛º–
function travel_path( in_path )
	for file in lfs.dir(in_path) do
		if file ~= "." and file ~= ".." then
			local f = in_path..sep..file
			if file ~= output_file then
				local attr = lfs.attributes(f)
				assert(type(attr) == "table")
				if attr.mode == "directory" then
					travel_path(f)
					--frameTable[#frameTable+1] = {file,f}
				elseif string.find(file, "%.webp") or string.find(file, "%.wd") then
					processList[#processList+1] = f
				end
			end
		end
	end
end

travel_path('.\\..\\resource')

for k,fullfile in ipairs(processList) do
	local p,fonly,e = splitfilename(fullfile)
	local outfile = string.gsub(fullfile,e,'pd')
	local imagesetfile = string.gsub(fullfile,e,'imageset')

	local cmd = string.format('dwebp %s -o %s',fullfile,outfile)
	os.execute(cmd)

	local f = io.open(imagesetfile,'r')
	if f then
		f:close()
		--print(imagesetfile)
		local gImageSet = ZXImageSet()
		gImageSet:Load(imagesetfile)
		local tn = gImageSet:TextureName()
		print(tn)
		if string.find(tn, "%.webp") then
			tn = string.gsub(tn,"%.webp","%.pd")
		elseif string.find(tn, "%.wd") then
			tn = string.gsub(tn,"%.wd","%.pd")
		end
		gImageSet:SetTextureName(tn)
		gImageSet:Save(imagesetfile)
	end
	os.execute("del /q " .. fullfile)
end

for k,f in ipairs(processList) do
	--print(f)
end
