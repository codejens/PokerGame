require 'lfs'
require 'FreeImageToolBox'
require 'strbuf'
require 'xml'
require 'io'
require 'math'
require 'ZXBinaryLua'
require 'ZXBinaryV2Lua'

ZXBinary = ZXBinaryLua
ZXImageSet = ZXBinary.ZXImageSet
ZXImageUnit = ZXBinary.ZXImageUnit

ZXFrameData = ZXBinary.ZXImageSet
ZXFrameSet = ZXBinary.ZXFrameSet


ZXBinaryV2 = ZXBinaryV2Lua
ZXImageSetV2 = ZXBinaryV2.ZXImageSetV2
ZXImageUnitV2 = ZXBinaryV2.ZXImageUnitV2

--ZXFrameDataV2 = ZXBinaryV2.ZXImageSet
--ZXFrameSetV2 = ZXBinaryV2.ZXFrameSet

local sep = "/"
function travel_path( in_path )
	for file in lfs.dir(in_path) do
		if file ~= "." and file ~= ".." then
			local f = in_path..sep..file
			if file ~= output_file then
				local attr = lfs.attributes(f)
				assert(type(attr) == "table")
				if attr.mode == "directory" then
					travel_path(f)
				elseif string.find(file, ".imageset") or string.find(file, ".frame") then
					local tag = nil
					local pp = in_path .. '/'
					local gImageSet = ZXImageSet()
					local gImageUnit = ZXImageUnit()




					if string.find(file, ".imageset") then
					  gImageSet:Load(f)
					  local tn = gImageSet:TextureName()
					  tn = string.gsub(tn,'[/\\]','/')
					  gImageSet:SetTextureName(tn)
					  local count = gImageSet:ImageUnitCount()

					  local v2Set = ZXImageSetV2()
					  print(tn,f,count)
					  v2Set:Initialize(tn,count)
					  for i=0, count - 1 do
						local iu = gImageSet:Get(i)
						local s = iu:ImageName()
						s = string.gsub(s,'[/\\]','/')
						iu:SetImageName(s)

						local v2Unit = ZXImageUnitV2()
						v2Unit:Set(iu.x,iu.y,iu.width,iu.height,s);
						v2Set:Set(v2Unit,i)
					  end
					  v2Set:Save(f)
					  --gImageSet:Save(f)
					end

				end
			end
		end
	end
end

travel_path('../resource')

