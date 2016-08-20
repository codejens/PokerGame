-- HelpPanel.lua
-- created by hcl on 2013/2/1
-- 通用的提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.HelpPanel(Window)

function HelpPanel:show(type,title_path,str)
    -- 创建通用购买面板
    local win = UIManager:show_window("help_panel",true);
    win:init_with_arg(type,title_path,str);
end

function HelpPanel:__init()	
	self.view:setAnchorPoint(0.5,0.5);
end

local table_wx_num = {42,30,20,10};
local table_wx_value = {"50%","30%","15%","5%"};
local table_cz_value = {"500","300","150","50"};

-- 340,200
function HelpPanel:init_with_arg(create_type,title_path,str)
	MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "tishi_bg.png", 0,0,340,230,500,500);
	
	-- 九宫格背景
	MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "ng_gradient.png", 20,185,300,22,500,500);
    MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "coner2.png", 20,184,300,2,10,0);
    MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "coner2.png", 20,15,300,2,10,0);
	-- 创建悟性提升说明界面
	if ( create_type == 1 ) then
	    MUtils:create_sprite(self.view,UIResourcePath.FileLocate.pet .. "pet_t_wxtssm.png",170,197);
	    local base_path = UIResourcePath.FileLocate.pet .. "pet_t_jie";
	    for i=1,4 do
	    	MUtils:create_sprite(self.view,base_path..i..".png",50,200-i*35);
	    	MUtils:create_zxfont(self.view,LangGameString[816]..table_wx_num[i]..LangGameString[817] .. table_wx_value[i],80,192-i*35,1,14); -- [816]="#cfff000需要悟性" -- [817]="以上所有属性+"
	    end
	    MUtils:create_zxfont(self.view,LangGameString[818],170,20,2,14); -- [818]="#c35C3F7悟性等级到12、24增加额外的技能槽"
    -- 创建成长提升说明界面
    elseif ( create_type == 2 ) then
    	-- 九宫格背景
	    MUtils:create_sprite(self.view,UIResourcePath.FileLocate.pet .. "pet_t_cztssm.png",170,197);
	    local base_path = "ui/pet/pet_t_shou";
	    for i=1,4 do
	    	MUtils:create_sprite(self.view,base_path..i..".png",50,200-i*30);
	    	MUtils:create_zxfont(self.view,LangGameString[819]..table_wx_num[i]..LangGameString[817] .. table_wx_value[i],80,192-i*30,1,14); -- [819]="#cfff000需要成长" -- [817]="以上所有属性+"
	    end
	    MUtils:create_zxfont(self.view,LangGameString[820],170,20,2,14); -- [820]="#c35C3F7成长等级到13、26增加额外的技能槽"
	elseif ( create_type == 3 ) then
		MUtils:create_sprite(self.view,title_path,170,197);
		local ccdialogEx = MUtils:create_ccdialogEx(self.view,str,163,125,270,100,10,14);
		ccdialogEx:setAnchorPoint(0.5,1.0);
    end
end

function HelpPanel:active(show)
	if ( show == false) then
		self.view:removeAllChildrenWithCleanup(true);
	end
end
