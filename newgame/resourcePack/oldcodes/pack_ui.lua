require 'pack'

-- 打包UI资源(不需要锚点，不需要切alpha)
ImagePackProccess:OnlyPack( "./../resourceTree/ui",
							"./../resource/ui",
							"ui",
							"ui",
							".png",
							1024, 1024, 32,
							FreeImage.FIT_BITMAP)


--登陆
ImagePackProccess:OnlyPack( "./../resourceTree/ui2/login",
							"./../resource/ui2/login",
							"ui2/login",
							"login",
							".png",
							1024, 1024, 32,
							FreeImage.FIT_BITMAP)

-- MiniMap，不常用打包
ImagePackProccess:OnlyPack( "./../resourceTree/ui2/minimap",
							"./../resource/ui2/minimap",
							"ui2/minimap",
							"minimap",
							".png",
							1024, 1024, 32,
							FreeImage.FIT_BITMAP)

-- 角色界面
ImagePackProccess:OnlyPack( "./../resourceTree/ui2/role",
							"./../resource/ui2/role",
							"ui2/role",
							"role",
							".png",
							1024, 1024, 32,
							FreeImage.FIT_BITMAP)

-- 登录欢迎
ImagePackProccess:OnlyPack( "./../resourceTree/ui2/welcome",
							"./../resource/ui2/welcome",
							"ui2/welcome",
							"welcome",
							".png",
							1024, 1024, 32,
							FreeImage.FIT_BITMAP)
--打包表情
local chat_face_anchorpoint = {0,60}
ImagePackProccess:ResizeAndPack( "./../resourceTree/chat_face",
								"./../resource/chat_face",
								"chat_face",
								"chat_face",
								".png",
								512,512,32,
								FreeImage.FIT_BITMAP,
								chat_face_anchorpoint)

-- 灵根，不常用打包
ImagePackProccess:OnlyPack( "./../resourceTree/ui2/linggen",
							"./../resource/ui2/linggen",
							"ui2/linggen",
							"linggen",
							".png",
							1024, 1024, 32,
							FreeImage.FIT_BITMAP)
