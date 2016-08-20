-- HelpPanel.lua
-- created by hcl on 2013/2/1
-- 通用的提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.HelpPanel(Window)

function HelpPanel:show(type,title_path,str,font_size)
    -- 创建通用购买面板
    local win = UIManager:show_window("help_panel",true);
    if font_size == nil then
    	font_size = 16;
    end
    win:init_with_arg(type,title_path,str,font_size);
    -- win:setPosition(420, 240)
    return win
end

function HelpPanel:__init()	
	self.view:setAnchorPoint(0.5,0.5);
end

local table_wx_num = {42,30,20,10};
local table_wx_value = {"50%","30%","15%","5%"};
local table_cz_value = {"500","300","150","50"};

function HelpPanel:set_bk_img(texture_path)
	self.bk_img:setTexture( texture_path );
end
-- 340,200
function HelpPanel:init_with_arg(create_type,title_path,str,font_size)
	-- self.bk_img = MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "liebiao_bg.png", 0,0,340,230,500,500);
	-- 临时改变帮助框的背景图片 by HWL
	-- local bg_1 = CCBasePanel:panelWithFile(0,0,416,331, UILH_COMMON.style_bg, 500, 500)
	-- self.view:addChild(bg_1)
	self.bk_img = MUtils:create_zximg(self.view,UILH_COMMON.dialog_bg, 0,0,416,331,500,500);
	local bg_2 = CCBasePanel:panelWithFile(20, 26, 380, 265, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild(bg_2)
	local bg_1_size = self.bk_img:getSize()
	-- local bg_2 = CCBasePanel:panelWithFile(28, 34, 364, 224, "", 500, 500)
	-- self.view:addChild(bg_2)

	-- local btn_close_fun = function(  )
	-- 	UIManager:hide_window("help_panel")
	-- end
	-- local close_btn = ZButton:create(self.view, UIResourcePath.FileLocate.common .. "close_btn_z.png", btn_close_fun,0,0,-1,-1,999)
	-- local bg_size = self.bk_img:getSize()
	-- local close_size = close_btn:getSize()
	-- print( bg_size.width, bg_size.height)
	-- close_btn:setPosition( bg_size.width - close_size.width - 9, bg_size.height - close_size.height - 5 )
	
	-- 九宫格背景
	-- MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "liebiao_xuan.png", 20,185,300,25,500,500);
    --MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "coner2.png", 20,184,300,2,10,0);
    --MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "coner2.png", 20,15,300,2,10,0);
	-- 创建悟性提升说明界面
	if ( create_type == 1 ) then
	    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.pet .. "pet_t_wxtssm.png",210,300);
	    MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "title_tips.png",210,300);
	    local base_path = UIResourcePath.FileLocate.pet .. "tt_wx";
	    for i=1,4 do
	    	MUtils:create_sprite(self.view,base_path..(4-i+1)..".png",50+15,248-i*35);
	    	MUtils:create_zxfont(self.view,LangGameString[816]..table_wx_num[i]..LangGameString[817] .. table_wx_value[i],80+15,240-i*35,1,16); -- [816]="#cfff000需要悟性" -- [817]="以上所有属性+"
	    end
	    MUtils:create_zxfont(self.view,LangGameString[818],210,20+40,2,16); -- [818]="#c35C3F7悟性等级到12、24增加额外的技能槽"
    -- 创建成长提升说明界面
    elseif ( create_type == 2 ) then
    	-- 九宫格背景
	    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.pet .. "pet_t_cztssm.png",210,300);
	    MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "title_tips.png",210,300);
	    local base_path = "ui/pet/tt_cz";
	    for i=1,4 do
	    	MUtils:create_sprite(self.view,base_path..(4-i+1)..".png",50+15,248-i*35);
	    	MUtils:create_zxfont(self.view,LangGameString[819]..table_wx_num[i].."以上所有资质+" .. table_cz_value[i],80+15,240-i*35,1,16); -- [819]="#cfff000需要成长" -- [817]="以上所有属性+"
	    end
	    MUtils:create_zxfont(self.view,LangGameString[820],210,20+40,2,16); -- [820]="#c35C3F7成长等级到13、26增加额外的技能槽"
	elseif ( create_type == 3 ) then
		-- MUtils:create_sprite(self.view,title_path,170,197);
		local title_bg = ZImage:create( self.bk_img, UILH_COMMON.title_bg, 0, 0, -1, -1 )
		local title_bg_size = title_bg:getSize()
		title_bg:setPosition( ( bg_1_size.width - title_bg_size.width ) / 2, 295 )
		local title = ZImage:create( title_bg, title_path, 210 - 60, 300 + 16, -1, -1 )
		local title_size = title.view:getSize()
		title.view:setPosition(title_bg_size.width/2-title_size.width/2,title_bg_size.height/2-title_size.height/2 )
		--MUtils:create_sprite(self.view, title_path, 210, 300)
		local ccdialogEx = MUtils:create_ccdialogEx(self.view,str,35,273,350,100,99,font_size);
		ccdialogEx:setAnchorPoint(0,1.0);
	elseif ( create_type == 4 ) then

		MUtils:create_sprite(self.view,title_path,210, 300);
		local ccdialogEx = MUtils:create_ccdialogEx(self.view,str,42,248,335,100,99,font_size);
		ccdialogEx:setAnchorPoint(0,1.0);		
	elseif ( create_type == 5 ) then  --程序字标题

		ZLabel:create(self.view,title_path,153,293,17)
		local ccdialogEx = MUtils:create_ccdialogEx(self.view,str,42,248,335,120,99,font_size);
		ccdialogEx:setAnchorPoint(0,1.0);		
    end
end

function HelpPanel:active(show)
	print("help_panel active",show)
	if ( show == false) then
		self.view:removeAllChildrenWithCleanup(true);
	end
	if self.exit_btn then
       self.exit_btn:setPosition(355,292)
    end 
end
