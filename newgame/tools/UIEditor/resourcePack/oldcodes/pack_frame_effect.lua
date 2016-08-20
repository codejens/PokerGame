require 'pack'
fMinAlpha = 0.02
-- 打包序列帧
ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/effect",
								 "./../resource/frame",
								 "frame",
								 "effect",
								 ".png",
								 1024, 1024, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)