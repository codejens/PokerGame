require 'pack'
fMinAlpha = 0.02
bCreateNewTableOnCall = true
first_pack = true
final_pack = false
-- 打包序列帧
ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/NPC",
								 "./../resource/frame",
								 "frame",
								 "common",
								 ".png",
								 1024, 1024, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)

first_pack = false
final_pack = true
ImagePackProccess:ResizeAndPack( "./../resourceTree/frame/Monster",
								 "./../resource/frame",
								 "frame",
								 "common",
								 ".png",
								 1024, 1024, 32,
								 FreeImage.FIT_BITMAP,
								 orginal_center)

