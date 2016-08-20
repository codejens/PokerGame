-- TaskDialog.lua
-- create by hcl on 2013-1-23
-- 任务对话框

require "UI/component/Window"
super_class.TaskDialog(Window)
require "utils/MUtils"

-- 左边距
local l_m = 11;
-- 下边距
local b_m = 51;

local basePanel = nil;

-- UIManager使用来创建
-- function TaskDialog:create( texture_name )
-- 	--local view = PetWin("ui/common/bg02.png",20,30,760,424);
--     local view = TaskDialog(nil,l_m,b_m,389,429);
-- 	return view;
-- end

function TaskDialog:__init(texture_name)
	-- 空面板
    basePanel = self.view;
    -- 背景，标题，关闭按钮
	local bg = MUtils:create_sprite(basePanel,UIResourcePath.FileLocate.common .. "bg01.png",0,0);
    bg:setAnchorPoint(CCPoint(0,0));

    local function btn_close_fun(eventType,x,y)
	    if eventType == TOUCH_CLICK then
	        UIManager:hide_window("task_dialog");
	    end
        return true
    end
    local exit_btn = MUtils:create_btn(basePanel,UIResourcePath.FileLocate.common .. "close_btn_z.png",UIResourcePath.FileLocate.common .. "close_btn_z.png",btn_close_fun,380,400,-1,-1);
    local exit_btn_size = exit_btn:getSize()
    local spr_bg_size = basePanel:getSize()
    exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- 
    MUtils:create_zximg(basePanel,UIResourcePath.FileLocate.common .. "coner2.png",31-l_m,480-147-b_m,328,2,15,0);
    MUtils:create_zximg(basePanel,UIResourcePath.FileLocate.common .. "coner2.png",31-l_m,480-257-b_m,328,2,15,0);

    -- npc头像
    MUtils:create_sprite(basePanel,UIResourcePath.FileLocate.task .. "test_npc.png",52-l_m,480-59-b_m);
    -- npc名字
    MUtils:create_zxfont(basePanel,LangGameString[1939],82-l_m,480-93-b_m,1,14); -- [1939]="#cfff000npc名字"
    -- 任务名
    MUtils:create_zxfont(basePanel,LangGameString[1940],35-l_m,480-134-b_m,1,14); -- [1940]="#cfff000任务名称:#c66ff66兴师问罪"
    -- 任务描述
    local chat_dialog = CCDialog:dialogWithFile(33.7-l_m,480-180-b_m, 316, 63, 15, nil, TYPE_VERTICAL);
    chat_dialog:setAnchorPoint(0,1.0);
    basePanel:addChild(chat_dialog);
    chat_dialog:setText(LangGameString[1941]); -- [1941]="sfkjdsklfjsdi力的的的的是 到付款了三季度房价放到空间费斯柯达飞水电费飞水电费水电费地方"
    chat_dialog:setEnableScroll(false);
    -- 任务奖励标题
    MUtils:create_zxfont(basePanel,LangGameString[1931],35-l_m,480-280-b_m,1,14); -- [1931]="#cfff000任务奖励:"

    for i=0,2 do
        local x = 46-l_m + i*160;
        local y = 480-303-b_m;
        MUtils:create_zxfont(basePanel,LangGameString[1942],x,y,1,14); -- [1942]="#c66ff66经验:#cffffff20000"
        local bg = MUtils:create_sprite(basePanel,UIResourcePath.FileLocate.common .. "pet_c_b.png",x+75,y-44);
        MUtils:create_sprite(bg,UIPIC_ITEMSLOT,33,33.5);
        MUtils:create_ccdialog(basePanel,"",x+60,y-59,100,40,2,false);
    end
end
