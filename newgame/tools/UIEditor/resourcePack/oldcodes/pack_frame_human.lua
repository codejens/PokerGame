require 'pack'
fMinAlpha = 0
-- 打包序列帧
ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/human",
								 "./../resource/frame",
								 "frame",
								 "human",
								 ".png",
								 512, 512, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)

ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/weapon",
								 "./../resource/frame",
								 "frame",
								 "weapon",
								 ".png",
								 512, 512, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)


ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/wing",
								 "./../resource/frame",
								 "frame",
								 "wing",
								 ".png",
								 512, 512, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)