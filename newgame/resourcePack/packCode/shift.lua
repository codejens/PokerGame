
require 'FreeImageToolBox'
require 'lfs'

local sep = '/'
FreeImage = FreeImageToolBox

function convert(dstfile,srcfile,yShift)
	local f = FreeImage.fipImage()
	f:load(srcfile)
	local out = FreeImage.fipImage(FreeImage.FIT_BITMAP,1024,1024,32)

	local w = f:getWidth()
	local h = f:getHeight()
	if w < 1024 and h < 1024 then
		local centerX = (1024 - w) * 0.5
		local centerY = (1024 - h) * 0.5
		out:pasteSubImage(f,centerX,centerY + tonumber(yShift))
		out:save(dstfile)
	end
end


function convertSpineAvatarAnchor(path, yShift)
	local outdir = path..sep..'converted'
	lfs.mkdir(outdir)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = path..sep..file
			local attr = lfs.attributes (f)
			assert (type(attr) == "table")
			if attr.mode == "directory" then
				--self:convertSpineAvatarAnchor (f)
			else
				convert(outdir..sep..file,f,yShift)
			end
		end
	end
end

convertSpineAvatarAnchor('.')
