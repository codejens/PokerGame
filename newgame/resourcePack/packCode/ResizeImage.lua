
require 'FreeImageToolBox'
require 'lfs'

local sep = '/'
FreeImage = FreeImageToolBox

function convert(dstfile,srcfile,xShift,yShift, tWidth, tHeight)
	local f = FreeImage.fipImage()
	f:load(srcfile)

	local w = f:getWidth()
	local h = f:getHeight()

	if w < tWidth and h < tHeight then
		local out = FreeImage.fipImage(FreeImage.FIT_BITMAP,tWidth,tHeight,32)
		local centerX = (tWidth - w) * 0.5
		local centerY = (tHeight - h) * 0.5
		out:pasteSubImage(f,centerX + tonumber(xShift),centerY + tonumber(yShift))
		out:save(dstfile)
	else 
		local centerX = w * 0.5
		local centerY = h * 0.5
		local dis_x = (w - tWidth) * 0.5
		local dis_y = (h - tHeight) * 0.5
		print("dis_x,dis_y,tWidth,tHeight",dis_x,dis_y,tWidth,tHeight)
		f:crop(dis_x, dis_y, dis_x + tWidth, dis_y + tHeight)
		--out:pasteSubImage(f,0, 0)
		f:save(dstfile)
	end
end
ResizeImage = {}

function ResizeImage.convertSpineAvatarAnchor(path, xShift, yShift, width, height)
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
				convert(outdir..sep..file,f,xShift,yShift, width, height)
			end
		end
	end
	return true,'×ª»»' .. path .. ' ±£´æµ½ ' .. outdir
end
