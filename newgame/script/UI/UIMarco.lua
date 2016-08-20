--TAGS
UI_TAG_POPUPVIEW							= 100
UI_TAG_ACTION_SHOW_WIN						= 200

UI_TAG_ENTITY_DIALOG						= 998
UI_TAG_INSTRUCT_ENTITY_DIALOG				= 999

UI_TAG_INSTRUCTION_RECT 					= 1001
UI_TAG_INSTRUCTION_BLINK 					= 1002
UI_TAG_INSTRUCTION_POINTER 					= 1003

UI_TAG_GUIDE								= 1023 --新手指引

UI_TAG_TUXIAN								= 1050 --凸显界面遮罩
UI_TAG_SCREENMASK                           = 1051 --屏幕遮罩

Z_JOYSTICK				= 1				-- 摇杆深度低于ui层
Z_HYPERLINK				= 2 			-- 超连接
Z_DROP_ITEM_AREA 		= 100 			-- 丢弃道具深度
Z_NPC_DIALOG			= 150
Z_MINIBUTTON_AREA		= 200			-- 屏幕中间提示小按钮深度
Z_BUNIESS				= 299			-- 交易窗口
Z_ACTIVE_WINDOW 		= 300 			-- 活动窗口
Z_GAME					= 350			-- 小游戏层
Z_DIALOG_END 			= 400 			-- 对话框最低深度
Z_DIALOG_START			= 500 			-- 对话框开始深度
Z_DIALOG_HIGH			= 550 			-- 对话框最高深度(npc对话框使用)
Z_CHONGZHI				= 560			-- 充值弹在复活界面上面
Z_RIGHT_CLICK_MENU		= 600 			-- 右键菜单
Z_SCREEN_NOTIC			= 650			-- 跑马灯
Z_TOOLTIP				= 700 			-- Tooltips
Z_UI_TEXT_EFFECT		= 750			-- 必杀技名字
Z_FLOWER 				= 800			-- 界面的鲜花
Z_TOPMOST				= 60000			-- 最高的Z,用来放置摇杆定置的
Z_MOVIE					= 60001
Z_CINEMA_UI				= 60002
JT_ZORDER				= 60003
JT_ZORDER_NPC			= 60004
Z_ZORDER_GUIDE			= 61000         --新手指引
Z_LOADING				= 65536			-- Loading图的Z
Z_ABOVE_LOADING         = 65537

Z_SCREENMASK            = 99999			--最顶层的遮罩

Z_KEYBOARD              = 100000		--最顶层的遮罩 再高一层，键盘层


----------------------------------------------------
--道具Slot
UIPIC_ITEMSLOT 		   = 'ui/lh_normal/item_bg2.png'
--通用窗口底板
UIPIC_WINDOWS_BG       = "nopack/hall_function_bg.jpg"

