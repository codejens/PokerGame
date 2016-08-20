require 'pack'

orginal_center[1] = 316
orginal_center[2] = 236
fMinAlpha = 0.0

_filetype = '.png'
_width = 512
_height = 512
_srcpath = '.\\..\\resourceTree\\frame\\effect\\ui\\35'
_dstpath = '.\\..\\resource\\frame\\effect\\ui\\35'
_refdst = 'frame\\effect\\ui\\35'
_output = '35'

sort_type = 1
-- 打包序列帧
ImagePackProccess:ResizeAndPack( _srcpath,
								 _dstpath,
								 _refdst,
								 _output,
								 _filetype,
								 _width, _height, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)