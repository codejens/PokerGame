-- 微信活动暗号输入框窗口
super_class.WeiXinInputDialog( Window )

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

function WeiXinInputDialog:__init( window_name, texture_name, is_grid, width, height )
	-- 窗口标题
	self.window_title = ZImage:create( self.view, UI_WeiXinInputDialog_008, width/2,  height-29, -1,-1,999 );
	self.window_title.view:setAnchorPoint(0.5,0.5)

	-- 添加外框
	local frame1 = CCBasePanel:panelWithFile( 18, 71, 380, 200, UI_WeiXinInputDialog_007, 500, 500 )
	self.view:addChild( frame1 );

	-- 添加背景框
	local frame2 = CCBasePanel:panelWithFile( 28, 82, 360, 180, UI_WeiXinInputDialog_006, 500, 500 )
	self.view:addChild( frame2 );

	-- "输入暗号"标题
	local anhao_bg = ZImage:create( self.view, UI_WeiXinInputDialog_001, width/2, 210, -1, -1 )
	anhao_bg.view:setAnchorPoint( 0.5, 0.5 );
	local anhao_img = ZImage:create( self.view, UI_WeiXinInputDialog_009, width/2, 210, -1, -1 )
	anhao_img.view:setAnchorPoint( 0.5, 0.5 );

	local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)


	-- 暗号输入框
	local function edit_box_function(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return true
		end
		if eventType == KEYBOARD_CONTENT_TEXT then
			
		elseif eventType == KEYBOARD_FINISH_INSERT then
			self:hide_keyboard()
		elseif eventType == TOUCH_BEGAN then
			-- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
		elseif eventType == KEYBOARD_WILL_SHOW then
			local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_show( keyboard_width, keyboard_height );	
		elseif eventType == KEYBOARD_WILL_HIDE then
			local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height );
		end
		return true
	end
	self.input_edit_box = CCZXAnalyzeEditBox:editWithFile( width/2 - 124, 150, 248, 31, UI_WeiXinInputDialog_002,  13 , 16, EDITBOX_TYPE_NORMAL, 500, 500 )
	self:addChild( self.input_edit_box );
	self.input_edit_box:registerScriptHandler(edit_box_function)

	-- 分割线
	local fenge_line = ZImage:create( self.view, UIResourcePath.FileLocate.common .. "jgt_line.png", 204, 120
		, 320, 2 );
	fenge_line.view:setAnchorPoint( 0.5, 0.5 )

	-- 确定按钮
	local function on_queding_btn_clicked()
		if ItemModel:check_bag_if_full() then
			-- [11]="背包已满,不能领取奖励"
			GlobalFunc:create_screen_notic( LangModelString[11] )
			return
		end
		-- 获取玩家输入的cdkey
		local cd_key = self.input_edit_box:getText()
		if cd_key == "" then
			GlobalFunc:create_screen_notic( "CDKEY不能为空")
			return
		end
        OnlineAwardCC:req_get_weixin_libao(cd_key)
        self.input_edit_box:setText("");
        UIManager:destroy_window( "weixin_input_dialog" );

        self:hide_keyboard()
	end
	--UI_WeiXinInputDialog_005 ->UIPIC_COMMOM_002
	local queding_btn = ZButton:create( self.view, UIPIC_COMMOM_002, on_queding_btn_clicked, width/2, 44, -1, -1 );
	queding_btn:setAnchorPoint( 0.5, 0.5 )
	local queding_lab = ZLabel:create( queding_btn.view, "确 定", 63, 20, 18, ALIGN_CENTER );
end

function WeiXinInputDialog:destroy()
	self:hide_keyboard()
	Window.destroy(self)
end

------------------
------------------弹出/关闭 键盘时将整个chatWin的y坐标的调整
function WeiXinInputDialog:keyboard_will_show( keyboard_w, keyboard_h )
	self.keyboard_visible = true;
	local win = UIManager:find_visible_window("weixin_input_dialog");
	-- local win_info = UIManager:get_win_info("chat_win")
	if win then
		if keyboard_h == 162 then--ip eg
			win:setPosition(_refWidth(0.5),500);
		elseif keyboard_h == 198 then---ip cn
			win:setPosition(_refWidth(0.5),500);
		elseif keyboard_h == 352 then --ipad eg
        	win:setPosition(_refWidth(0.5),500);
	    elseif keyboard_h == 406 then --ipad cn
        	win:setPosition(_refWidth(0.5),500);
		end
	end
end

function WeiXinInputDialog:keyboard_will_hide(  )
	self.keyboard_visible = false;
	local win = UIManager:find_visible_window("weixin_input_dialog");
	-- local win_info = UIManager:get_win_info("chat_win")
	if win then
		win:setPosition(_refWidth(0.5),_refHeight(0.5));
	end
end
--------------------
-------------------- 手动关闭键盘
function WeiXinInputDialog:hide_keyboard(  )

	-- if self.edit_box and self.keyboard_visible then
		self.input_edit_box:detachWithIME();
	-- end
end

function WeiXinInputDialog:active(show)
    if self.exit_btn then
        self.exit_btn:setPosition(363,278)
    end 
end