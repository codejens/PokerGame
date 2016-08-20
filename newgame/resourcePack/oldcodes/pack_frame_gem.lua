require 'pack'
fMinAlpha = 0.02
-- 打包序列帧
ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/gem",
								 "./../resource/frame",
								 "frame",
								 "gem",
								 ".png",
								 512, 512, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)