require 'packCode/pack_utils'
require( "iuplua" )

_filetype = arg[1]
_width = tonumber(arg[2])
_height = tonumber(arg[3])
_srcpath = arg[4]
_dstpath = arg[5]
_refdst = arg[6]
_output = arg[7]
sort_type = tonumber(arg[8])
g_RGBA8888 = tonumber(arg[9])
convertWebp = tonumber(arg[10])
compress_type = arg[11]
print("compress_type",compress_type)
g_renameFile = true

--[[
if switch == 0 then
	convert = false
elseif switch == 1 then
	convert = true
end
]]--

local s,e = pcall(function () ImagePackProccess:OnlyPack( _srcpath,
							_dstpath,
							_refdst,
							_output,
							_filetype,
							_width, _height, 32,
							FreeImage.FIT_BITMAP ) end)
if not s then
	iup.Message('´íÎó',e)
end
