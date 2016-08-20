-- RenameDialog()
-- created by lyl on 2013-1-16
-- 角色改名窗口

require "UI/component/Window"
super_class.RenameDialog(Window)

function RenameDialog:__init(fath_panel, pos_x, pos_y)

end
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local  editbox =nil;

local panel = nil; 

local update_view = {};

local MAX_FONT_NUM = 6

local old_name = ""
local _if_check = false --是否已经校验名称
function RenameDialog:show()
	-- 创建通用购买面板
	local win = UIManager:show_window("rename_dialog",true);
	if win then
		win:set_title(UILH_RENAME.title)
	end

end

-- 关闭按钮
local function close_but_CB( )
	local win = UIManager:find_visible_window("rename_dialog")
	if win then
		win:hide_keyboard()
	end
	UIManager:hide_window( "rename_dialog" )
end

function RenameDialog:__init( window_name, texture_name, is_grid, width, height,title_text )
	panel = self.view;

	ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

	--标题背景
	local title_bg = ZImage:create( self.view,UILH_COMMON.title_bg, 0, 0, -1, -1 )
	local title_bg_size = title_bg:getSize()
	title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
	
	local bg = CCZXImage:imageWithFile( 12, 79, 416, 170, UILH_COMMON.normal_bg_v2,500,500);
	self.view:addChild(bg)

	ZImage:create(panel, UILH_RENAME.text, 40, 190, -1, -1)
	-- ZLabel:create(panel, LH_COLOR[13] .. Lang.rename[8], 40, 220, 20, 1)
	editbox = CCZXEditBox:editWithFile(40, 145, 246, 40, UILH_COMMON.bg_03, MAX_FONT_NUM, 16,  EDITBOX_TYPE_NORMAL ,500,500);
	panel:addChild(editbox);

	local function edit_box_function(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return true
		end
		if eventType == KEYBOARD_CONTENT_TEXT then
			
		elseif eventType == KEYBOARD_FINISH_INSERT then
			self:hide_keyboard()
			return true
		elseif eventType == TOUCH_BEGAN then
			-- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
		elseif eventType == KEYBOARD_WILL_SHOW then
			local temparg = Utils:Split(arg,":");
			local keyboard_width = tonumber(temparg[1])
			local keyboard_height = tonumber(temparg[2])
			self:keyboard_will_show( keyboard_width, keyboard_height ); 
			return true
		elseif eventType == KEYBOARD_WILL_HIDE then
			local temparg = Utils:Split(arg,":");
			local keyboard_width = tonumber(temparg[1])
			local keyboard_height = tonumber(temparg[2])
			self:keyboard_will_hide( keyboard_width, keyboard_height );
			return true
		end
		return true
	end

	editbox:registerScriptHandler(edit_box_function)

	self.check_timer = timer()
	-- 校验名称
	local function check_fun()
		self.check_btn.view:setCurState( CLICK_STATE_DISABLE )
		self.check_timer:start(5, function()
				self.check_btn.view:setCurState( CLICK_STATE_UP )
			end)
		local new_name = editbox:getText()
		old_name = new_name
		if new_name == "" then
			-- self.result_lab:setText(LH_COLOR[2] .. Lang.rename[7])
			GlobalFunc:create_screen_notic(Lang.rename[8])
			return
		end
		MiscCC:req_rename_check(new_name)
	end
	self.check_btn = ZButton:create(panel, UILH_COMMON.btn4_sel, check_fun, 290, 140, -1, -1)
	self.check_btn.view:addTexWithFile( CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
	ZLabel:create(self.check_btn.view, Lang.rename[6], 61, 20, 16, 2)

	-- 验证结果
	self.result_lab = ZLabel:create(panel, LH_COLOR[2] .. Lang.rename[7], 45, 120, 16, 1)
	local function btn_ok_fun(eventType,x,y)
		if eventType == TOUCH_CLICK then
			local new_name = editbox:getText()
			if new_name ~= old_name then
				_if_check = false
			end
			if new_name == "" or not _if_check then
				GlobalFunc:create_screen_notic(Lang.rename[7])
				return
			end
			MiscCC:req_rename(new_name)
			UIManager:hide_window("rename_dialog");
		end
		return true
	end

	self.btn1 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_ok_fun,85,18,-1,-1)
	MUtils:create_zxfont(self.btn1, Lang.common.confirm[0], 99/2, 20, 2, 18)   --[0]=确定

	local function btn_cancel_fun(eventType,x,y)
		if eventType == TOUCH_CLICK then
		   UIManager:hide_window("rename_dialog");
		end
		return true
	end
	self.btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_cancel_fun,260,18,-1,-1)
	MUtils:create_zxfont(self.btn2, Lang.common.confirm[9], 99/2, 20, 2, 18)   --[9]=取消

	local function self_view_func( eventType )
		if eventType == TOUCH_BEGAN then
			self:hide_keyboard()
		end
		return true
	end
	self.view:registerScriptHandler(self_view_func)

	--关闭按钮
	local function _close_btn_fun()
		if self.check_timer then
			self.check_timer:stop()
			self.check_timer = nil
		end
		UIManager:hide_window(window_name)
	end

	local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }
	self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
	local exit_btn_size = self._exit_btn:getSize()
	self._exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height-20)
end

function RenameDialog:active( show )
	if ( editbox) then 
		-- print("RenameDialog:64: 字符串置空")
		editbox:setText("");
	end
end

function RenameDialog:update( code )
	if code == 0 then
		_if_check = true
		self.result_lab:setText(LH_COLOR[10] .. Lang.rename[5])
	elseif code == -6 then
		self.result_lab:setText(LH_COLOR[9] .. Lang.rename[1])
	elseif code == -12 then
		self.result_lab:setText(LH_COLOR[9] .. Lang.rename[2])
	elseif code == -14 then
		self.result_lab:setText(LH_COLOR[9] .. Lang.rename[4])
	else
		self.result_lab:setText(LH_COLOR[9] .. Lang.rename[3])
	end
end

function RenameDialog:destroy(  )
	_if_check = false
	old_name = ""
	if self.check_timer then
		self.check_timer:stop()
		self.check_timer = nil
	end
	self:hide_keyboard()
	Window.destroy(self)
end

------------------弹出/关闭 键盘时将整个RenameDialog的y坐标的调整
function RenameDialog:keyboard_will_show( keyboard_w, keyboard_h )
	self.delay_cb = callback:new();
	local function cb()
		 self.keyboard_visible = true;
		local win = UIManager:find_visible_window("rename_dialog");
		if win then
			if keyboard_h == 162 then--ip eg
				win:setPosition(_refWidth(0.5),480);
			elseif keyboard_h == 198 then---ip cn
				win:setPosition(_refWidth(0.5),480);
			elseif keyboard_h == 352 then --ipad eg
				win:setPosition(_refWidth(0.5),520);
			elseif keyboard_h == 406 then --ipad cn
				win:setPosition(_refWidth(0.5),550);
			end

			-- local win_pos = win:getPosition()
			-- ZXLog('=====win_pos: ', win_pos.x, win_pos.y)
		end
		self.delay_cb = nil
	end
	self.delay_cb:start(0.2,cb);
end

function RenameDialog:keyboard_will_hide(  )
	 self.delay_cb = callback:new();
	local function cb()
		self.keyboard_visible = false;
		local win = UIManager:find_visible_window("rename_dialog");
		-- local win_info = UIManager:get_win_info("rename_dialog")
		if win then
			win:setPosition(_refWidth(0.5),_refHeight(0.5));
		end
	end
	self.delay_cb:start(0.1,cb);
	
end

-------------------- 手动关闭键盘
function RenameDialog:hide_keyboard(  )

	-- if self.edit_box and self.keyboard_visible then
		editbox:detachWithIME();
	-- end
end

-- 增加提示文本，如果位置、大小不合要求，可以再开几个参数去自定义设置。 note by guozhinan
function RenameDialog:add_tip_dialog(tip_text)
	if self.tip_dialog == nil then
		self.tip_dialog = ZDialog:create(self.view, "",65,180,350,50,16)
		self.tip_dialog.view:setLineEmptySpace(5)
		self.tip_dialog:setText(tip_text)
	else
		self.tip_dialog:setText(tip_text)
	end
end

function RenameDialog:set_title(title_img_path)
	if self.img_title == nil then
		self.img_title = ZImage:create(self.view, title_img_path , 220,  291, -1,-1,999 );
		self.img_title.view:setAnchorPoint(0.5,0.5)
	end
end
