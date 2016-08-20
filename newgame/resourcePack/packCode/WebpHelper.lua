WebpHelper = {}

function WebpHelper.convert(filename)
	local d,f,e = string.match(filename, "(.-)([^\\/]-%.?([^%.\\/]*))$")

	local converted = ''
	local i = string.find(filename,'.jpg')
	if i then
		converted = string.sub(filename,1,i) .. 'webp'
	else
		i = string.find(filename,'.png')
		if i then
			converted = string.sub(filename,1,i) .. 'webp'
		end
	end

	if converted ~= '' then
		local c = string.format('cwebp.exe %s -o %s', filename, converted)
		c = string.gsub(c,'[/\\]','\\')
		os.execute(c)
		return true, c
	else
		return false, '[webp转换器] : 未知文件类型 ' .. filename
	end
end
