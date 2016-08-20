require 'pack'
fMinAlpha = 0
-- 打包序列帧
ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/pet",
								 "./../resource/frame",
								 "frame",
								 "pet",
								 ".png",
								 512, 512, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)