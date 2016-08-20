require 'pack'
fMinAlpha = 0.025
-- 打包序列帧
ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/mount",
								 "./../resource/frame",
								 "frame",
								 "mount",
								 ".png",
								 1024, 512, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)