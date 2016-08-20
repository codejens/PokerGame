-- DouFaTaiResult.lua
-- create by hcl on 2013-4-7
-- 斗法台胜利或失败后的对话框

super_class.DouFaTaiResult(Window)

function DouFaTaiResult:show( is_win ,money,sw ) 
	print(" DouFaTaiResult:show( is_win ,money,sw ) ",is_win,money,sw);
	local win = UIManager:show_window("doufatai_result");
	if ( win ) then
		-- 关闭倒计时
		UIManager:destroy_window("count_down_view");
		win:create_result_dialog( is_win ,money,sw);
		if ( money and sw ) then
			win.is_jjc = true;
		else
			win.is_jjc = false;
		end
	end
end

function DouFaTaiResult:__init(  )
 	panel = self.view;

 	-- 两层基本背景
    -- local bg = CCBasePanel:panelWithFile(1,1,414,329, UILH_COMMON.bg_03, 500, 500)
    -- self.view:addChild(bg,-1)
    local bg_1 = CCBasePanel:panelWithFile(13, 62, 390, 221,UILH_COMMON.bottom_bg, 500, 500)
    panel:addChild(bg_1)

    -- 标题背景
    local bg_size = self.view:getSize()
    self.title_bg = ZImage:create( self.view, UILH_COMMON.title_bg, 0, 0, -1, -1 )
    local title_bg_size = self.title_bg:getSize()
    self.title_bg:setPosition( ( bg_size.width - title_bg_size.width ) / 2, 294 )
    self.title = ZImage:create( self.title_bg, UILH_DOUFATAI.zhandoushengli, 0, 0, -1, -1 )
    local title_size = self.title.view:getSize()
    self.title.view:setPosition(title_bg_size.width/2-title_size.width/2,title_bg_size.height/2-title_size.height/2 )

    local left_x = 153

    self.update_dialog = {};
    -- MUtils:create_zximg(self.view,UIPIC_ConfirmWin_010, left_x+49,183,160,35,500,500,2);
    self.update_dialog[1] = MUtils:create_zxfont(self.view,"",left_x+60,192,1,18,2); -- [855]="#c66ff66仙币:#c35c3f73333"
    MUtils:create_zxfont(self.view, Lang.doufatai[28], left_x, 192,1,18,2)		-- [28]=铜币

    -- MUtils:create_zximg(self.view,UIPIC_ConfirmWin_010, left_x+49 ,131,160,35,500,500,2);
    MUtils:create_zxfont(self.view, Lang.doufatai[29], left_x, 140,1,18,2)		-- [29]=声望
    self.update_dialog[2] = MUtils:create_zxfont(self.view,"",left_x+60,140,1,18,2); -- [856]="#c66ff66声望:#c35c3f74444"

    local function func( eventType,args,msg_id)
		-- if eventType == TOUCH_BEGAN then
		-- 	return true; 
		-- elseif eventType == TOUCH_CLICK then
			-- 退出副本，然后打开斗法台界面
			require "control/OthersCC"
            OthersCC:req_exit_fuben();
            UIManager:hide_window("doufatai_result");
            if ( self.is_jjc ) then 
            	DouFaTaiWin:show();
			else
				UIManager:show_window("hld_main_win");
			end
			return true
		-- end
		-- return true
	end

	-- 确定按钮
	local btn =ZTextButton:create(panel,Lang.common.confirm[0],{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s},func,157,7,-1,-1, 1)
end

local update_dialog = {};
function DouFaTaiResult:create_result_dialog( is_win ,money,sw)

	if ( is_win == 1 ) then
		self.title:setTexture(UILH_DOUFATAI.zhandoushengli);
	else
		self.title:setTexture(UILH_DOUFATAI.zhandoushibai);
	end
	if ( money ) then
		self.update_dialog[1]:setText("#cffff00" .. money); -- [857]="#c66ff66仙币:#c35c3f7"
	else
		self.update_dialog[1]:setText("");
	end
	if ( sw ) then
		self.update_dialog[2]:setText("#cffff00" .. sw); -- [858]="#c66ff66声望:#c35c3f7"
	else
		self.update_dialog[2]:setText("");
	end
end

function DouFaTaiResult:active(show)
    if self.exit_btn then
        -- self.exit_btn:setPosition(363,287)
        self.exit_btn.view:setIsVisible(false)
    end 
end