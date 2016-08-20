-- KeFuWin.lua
-- create by hcl on 2013-10-9
-- 客服窗口

super_class.KeFuWin(NormalStyleWindow)

-- local KEFU_URL = "http://42.62.53.220:82/mobile_api/advice.php";

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local link_text = {}
function KeFuWin:__init( )
	self.is_sending = false;
	-- self:create_close_btn_and_title();

	-- 背景
	MUtils:create_zximg(self.view,UILH_COMMON.normal_bg_v2,12,12,875,550,500,500);
	MUtils:create_zximg(self.view,UILH_COMMON.bottom_bg,25,400,845,150,500,500);
	MUtils:create_zximg(self.view,UILH_COMMON.bottom_bg,25,25,845,370,500,500);
	-- MUtils:create_zximg(self.view,UI_KeFuWin_002,104,331,771,42,500,500);

	local is_test_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_test_version")
	if is_test_version then
		link_text = Lang.kefu.lianyun
	elseif GetPlatform() == CC_PLATFORM_IOS then
		link_text = Lang.kefu.ios
	elseif Target_Platform == Platform_Type.Platform_Hoolai or Target_Platform == Platform_Type.Platform_Hoolai2 then
		link_text = Lang.kefu.ljcq
	elseif Target_Platform == Platform_Type.Platform_MSDK then
		link_text = Lang.kefu.yyb
	else
		link_text = Lang.kefu.lianyun
	end

	-- 标题
	local offset_y = 30
	-- [1313]="客服电话:"
	MUtils:create_zxfont(self.view,Lang.kefu[1].."#cd0d0d0 "..link_text.kefu_tel,58,515)
	-- [1314]="官网地址:"
	MUtils:create_zxfont(self.view,Lang.kefu[2],514,515)
	local function guanwangdizhi_fun()
		print("run guanwangdizhi_fun")
		phoneGotoURL(link_text.guanwangdizhi)  
	end
	local guang_wang_address = TextButton:create( nil, 615, 514, 10, 10, string.format( "#u1#c08d53d%s#u0", link_text.guanwangdizhi ), "" )
	if Target_Platform ~= Platform_Type.Platform_UC then
		self.view:addChild(guang_wang_address.view)
	end

	guang_wang_address:setTouchClickFun(guanwangdizhi_fun)
	-- [1315]="客服QQ:"
	MUtils:create_zxfont(self.view,Lang.kefu[3].."#cd0d0d0 "..link_text.kefu_qq,58,470)
	-- [1316]="官方QQ群:"
	if Target_Platform ~= Platform_Type.Platform_UC then
		MUtils:create_zxfont(self.view,Lang.kefu[4].."#cd0d0d0 "..link_text.qq_qun,514,470)
	else
		MUtils:create_zxfont(self.view,Lang.kefu[4],514,470)
	end
	MUtils:create_zxfont(self.view,Lang.kefu[5],58,430) -- [1317]="论坛地址:"
	local luntan_address = TextButton:create( nil, 150, 430, 10, 10, string.format( "#u1#c08d53d%s#u0", link_text.luntan ), "" )
	self.view:addChild( luntan_address.view )
	local function luntan_address_fun()
		print("run luntan_address_fun", link_text.luntan)
		phoneGotoURL(link_text.luntan)
	end
	luntan_address:setTouchClickFun(luntan_address_fun)
	MUtils:create_zxfont(self.view,Lang.kefu[6],58,353) -- [1318]="类型:"
	MUtils:create_zxfont(self.view,Lang.kefu[7],58,300) -- [1319]="标题:"
	MUtils:create_zxfont(self.view,Lang.kefu[8],58,255) -- [1320]="内容:"

	-- 标题输入框
	self.editbox_title = CCZXEditBox:editWithFile(113,290,745,35,UILH_COMMON.bg_10 , 20, 16,  EDITBOX_TYPE_NORMAL ,500,500);
	self.view:addChild(self.editbox_title);
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
	self.editbox_title:registerScriptHandler( edit_box_function )

	MUtils:create_zximg(self.view,UILH_COMMON.bg_10,113,95,745,178,500,500);
	self.editbox_content =  CCZXEditBoxArea:editWithFile(113,95,745,178,"", 100, 16);
	self.view:addChild(self.editbox_content);
	self.editbox_content:registerScriptHandler( edit_box_function )

	-- 发送按钮
	local function send_btn_fun( event_type,args,msgid )
		if event_type == TOUCH_CLICK then
			self:send_msg()
		end
		return true;
	end
	--UI_KeFuWin_003 ->UIPIC_COMMOM_002
	local send_btn = MUtils:create_btn(self.view,UILH_COMMON.btn4_nor, UILH_COMMON.btn4_nor,send_btn_fun, 735, 30,-1,-1);
--	MUtils:create_common_btn( self.view,LangGameString[732],send_btn_fun,640,20 ); -- [732]="发送"
	local send_btn_lab = UILabel:create_lable_2( Lang.chat.send, 60, 20, 16, ALIGN_CENTER )
	send_btn:addChild( send_btn_lab )

	self:create_radio_group();

	MUtils:create_zxfont(self.view,Lang.kefu[9],306,50, 18) -- [1321]="#c66ff66注:标题最多输入20个字，内容最多输入100个字"

	self.last_send_time = 0;

	local function self_view_func( eventType )
		if eventType == TOUCH_BEGAN then
			self:hide_keyboard()
		end
		return true
	end
	self.view:registerScriptHandler(self_view_func)
end

local btn_text_tab = { Lang.kefu[10],Lang.kefu[11],Lang.kefu[12],Lang.kefu[13] }; -- [1322]="BUG提交" -- [1323]="投诉" -- [1324]="游戏建议" -- [1024]="其他"
local ui_btn_tab = {};

function KeFuWin:create_radio_group()

	for i=1,4 do
		local function btn_fun()
			self:do_btn_method( i )
		end
		local x = 132 +  190*(i-1);
		local y = 337;
		-- local btn = MUtils:create_radio_button(self.raido_btn_group,UIResourcePath.FileLocate.common .. "toggle_n.png",UIResourcePath.FileLocate.common .. "toggle_s.png",btn_fun,x,0,-1,-1,false);
		ui_btn_tab[i] = UIButton:create_switch_button(x,y,150,35, UILH_COMMON.dg_sel_1,UILH_COMMON.dg_sel_2,btn_text_tab[i] , 26, 17, nil, nil, nil, nil, btn_fun,{"nocolor"} )
		ui_btn_tab[i].words:setPosition(42,10)
		self.view:addChild(ui_btn_tab[i].view);
	end 
end

function KeFuWin:do_btn_method( index )
	
	-- 如果index = self.select_type的话，说明点的是同一个,会取消之前的选中状态
	if ( self.select_type == index ) then
		self.select_type = nil;
	else
		self.select_type = index;
	end
	
	for i,v in ipairs(ui_btn_tab) do
		if ( i ~= index ) then
			v.set_state(false);
		end
	end
end

function KeFuWin:send_msg(  )
	
	if ( self.is_sending ) then
		print("正在发送中。。。");
		return;
	end 

	local curr_time = GameStateManager:get_total_seconds(  );
	if ( self.last_send_time~=0 and curr_time - self.last_send_time < 300 ) then
		GlobalFunc:create_screen_notic(Lang.kefu[14]); -- [1325]="5分钟之后才能再次发送。"
		return;
	end
	self.is_sending = true;
	

	local param = "";
	if ( self.select_type ) then
		param = "type="..(self.select_type-1).."&";
	else
		GlobalFunc:create_screen_notic( Lang.kefu[15] ); -- [1326]="请选择发送类型。"
		self.is_sending = false;
		return;
	end

	local title_str = self.editbox_title:getText()
	if ( title_str ~= "" ) then
		local result_str = ZXLuaUtils:URLEncode(title_str);
		param = param .. "title="..result_str.."&";
	else
		GlobalFunc:create_screen_notic( Lang.kefu[16] ); -- [1327]="请填写标题。"
		self.is_sending = false;
		return;
	end

	local context_str = self.editbox_content:getText()
	if ( context_str ~= "" ) then
		local result_str = ZXLuaUtils:URLEncode(context_str);
		param = param .. "context="..result_str.."&";
	else
		GlobalFunc:create_screen_notic( Lang.kefu[17] ); -- [1328]="请填写内容。"
		self.is_sending = false;
		return;
	end

	local login_info = RoleModel:get_login_info(  );
	param = param .. "serverId="..login_info.server_id.."&";

	local player = EntityManager:get_player_avatar();
	param = param .. "actorId="..player.id.."&";
	local result_str = ZXLuaUtils:URLEncode(player.name);
	param = param .. "actorName="..result_str;

	local function cb_fun( result_code, message)
		print("ca_fun:::", result_code, message)
		if ( result_code == 0 ) then
			GlobalFunc:create_screen_notic( Lang.kefu[18] ); -- [1329]="您的宝贵意见已成功发送，祝您游戏愉快！"
			self.last_send_time = GameStateManager:get_total_seconds(  );
		else

		end
		self.is_sending = false;
	end
	print("param = ",param);
	local kefu_url = UpdateManager.customer_service_url;
	-- local kefu_url = "http://sjzxadmin.app1000000129.twsapp.com/mobile_api/advice.php";
	local req = HttpRequest:new( kefu_url , param, cb_fun , false )
	req:send()

	-- 清空
	self.editbox_title:setText("");
	self.editbox_content:setText("");
	ui_btn_tab[self.select_type].set_state(false);
	self.select_type = nil;
end

function KeFuWin:active(show)
	if show then
		self.editbox_title:setText("");
		self.editbox_content:setText("");       
	end
end 

------------------弹出/关闭 键盘时将整个KeFuWin的y坐标的调整
function KeFuWin:keyboard_will_show( keyboard_w, keyboard_h )
	self.keyboard_visible = true;
	local win = UIManager:find_visible_window("kefu_win");
	-- local win_info = UIManager:get_win_info("kefu_win")
	if win then
		if keyboard_h == 162 then--ip eg
			win:setPosition(_refWidth(0.5), 530);
		elseif keyboard_h == 198 then---ip cn
			win:setPosition(_refWidth(0.5),550);
		elseif keyboard_h == 352 then --ipad eg
			win:setPosition(_refWidth(0.5), 530);
		elseif keyboard_h == 406 then --ipad cn
			win:setPosition(_refWidth(0.5), 530);
		end
	end
end
function KeFuWin:keyboard_will_hide(  )
	self.keyboard_visible = false;
	local win = UIManager:find_visible_window("kefu_win");
	-- local win_info = UIManager:get_win_info("kefu_win")
	if win then
		win:setPosition(_refWidth(0.5),_refHeight(0.5));
	end
end
function KeFuWin:destroy(  )
	self:hide_keyboard()
	Window.destroy(self)
end


function KeFuWin:hide_keyboard(  )
	if self.editbox_title then
		self.editbox_title:detachWithIME();
	end
	if self.editbox_content then
		self.editbox_content:detachWithIME();
	end
	
end