-- VIPSysWin.lua 
-- created by fangjiehua on 2012-12-28
-- vip仙尊系统窗口
 
super_class.VIPSysWin(NormalStyleWindow)

local _base_size = CCSize(900, 605)
local _nowy=0

-- local has_vip_view 			= nil;		--是vip
-- local no_vip_view 			= nil;		--非vip
local vip_level_icon 		= nil;		--vip等级图标
local player_name			= nil;		--玩家的名字
local huiyuan_lab 			= nil;		--会员字样

local purchase_lab			= nil;		--
local vip_next_level_bg     = nil;
local vip_next_level_icon 	= nil;		--下级vip等级图标
local vip_up_needMoney 		= nil;		--升级到下级还需要的元宝数
local vip_progress			= nil;		--充值进度条
local vip_scroll 			= nil;		--vip列表

--local _base_size=nil
--local _nowy=0

-- local vipinfo_cell_base={
-- 	local base_size=nil, --整体尺寸
-- 	local title_bg=nil, --标题栏背景
-- 	local title_bg2=nil, --
-- 	local title_text=nil,
-- 	local title_size=nil,--标题栏尺寸
-- 	local text_region_size=nil,
-- 	local text_region_padding={left=10,top=10,bottom=10}, --文字区域间距
-- 	function setTitleText(text)
		
-- 	end

-- 	function new(obj)
-- 		obj=obj or {}
-- 		setmetatable(obj, self)
-- 		self.__index=self
-- 		return obj
		
-- 	end
-- }

--super_class.vipinfo_cell_panel(vipinfo_cell_base)




local _vipinfo_panel_1=nil
local _vipinfo_panel_2=nil
local _curvipindex=1
local _font_size = 16

local vipinfo_panel_size = CCSize(426, 300)
local vipinfo_panel_padding={left=20}

local _title_text_label1=nil
local _title_text_label2=nil
local _title_text_label_color="#cfff106"

local _vipinfo_content1=nil
local _vipinfo_content2=nil

local vipbtn_num = 10

local _vipinfo=nil
local _bg_panel=nil
local _bg_panel_padding={left=8, top=40, right=8, bottom=14}
local _bg_panel_size=CCSize(
	_base_size.width-_bg_panel_padding.left-_bg_panel_padding.right, 
	_base_size.height-_bg_panel_padding.top-_bg_panel_padding.bottom)
local _bg_panel_pos=CCPointMake(_bg_panel_padding.left, _bg_panel_padding.bottom)
-- --日免费元宝
-- local day_yuabao = {5,10,15,20,40,50,50,50,50,50};
-- --免费传送次数
-- local day_chuansong = {"10","20","无限","无限","无限","无限","无限","无限","无限","无限"};
-- --日常任务数量增加
-- local day_task = {1,2,3,4,5,6,7,8,9,10};
-- --蟠桃采摘数增加
-- local pantao_count = {1,2,3,4,5,6,7,8,9,10};
-- --打坐经验和灵气加成
-- local exp_exten = {"10%","20%","30%","40%","50%","60%","70%","80%","90%","100%",};
-- --每日招财数
-- local day_zhaocai = {3,5,7,9,30,40,50,60,70,100};
local _tiptop_label=nil
local _viplevel_progress=nil
local _viplevel_num=nil

function VIPSysWin:active( show )
	if show == true then
		self:update();
	end
end

function VIPSysWin:__init(window_name, texture_name, is_grid, width, height)
  -- 创建底面板
 --  	print("VIPSysWin call")
 --  	_base_size = self.view:getSize()
	_nowy=_bg_panel_size.height
	-- print("_base_size w h" .. _base_size.width .. " " .. _base_size.height)
 	_vipinfo = VIPModel:get_vip_info()
 	
 	self:initpanel(self.view)

  -- local main_bg = CCBasePanel:panelWithFile(229, 20, 650, 585, UIPIC_GRID_nine_grid_bg3, 500, 500)
  -- self.view:addChild(main_bg)

  -- -- 上、左下、右下分块
  -- local up_bg = ZImage:create(self.view, UI_VIPSysWin_013, 238, 473, 633, 122, 0, 500, 500)
  -- -- local ldown = ZImage:create(self.view, UI_VIPSysWin_001, 239, 102, 313, 367, 0, 500, 500)
  -- -- local rdown = ZImage:create(self.view, UI_VIPSysWin_001, 557, 102, 313, 367, 0, 500, 500)

  -- -- 充值描述
  -- self.recharge_desc = ZImage:create(self.view, UI_VIPSysWin_011, 250, 541, -1, -1)
  -- -- 玩家名字
  -- local name = EntityManager:get_player_avatar().name;
  -- self.player_name   = ZLabel:create(self.view, "#cfff000" .. name, 348, 570, 16)
  -- -- 玩家当前的vip等级
  -- self.curr_vip_img  = ZImage:create(self.view, UI_VIPSysWin_016, 297, 566, -1, -1)
  -- -- 升级到下一级vip需要的元宝数量
  -- self.next_yuanbao  = ZLabel:create(self.view, "#cff00ba100000", 351, 553, 14)
  -- self.next_yuanbao.view:setAnchorPoint(CCPointMake(0.5, 0.5))
  -- -- 展示下一级vip的图标
  -- self.next_vip_img  = ZImage:create(self.view, UI_VIPSysWin_016, 498, 540, -1, -1)

  -- -- 当前充值进度
  -- self.recharge_bar = MUtils:create_progress_bar( 274, 490, 410, 22, UI_PayWin_005, UI_PayWin_006, 0, {16,nil}, {4,4,4,4}, true )
  -- self.view:addChild(self.recharge_bar.view)

  -- -- 充值按钮
  -- local function recharge_func()
  -- 	GlobalFunc:chong_zhi_enter_fun()
  -- end
  -- local recharge_btn = ZButton:create(self.view, UI_VIPSysWin_002, recharge_func, 698, 503, 160,60)
  -- local recharge_btn_img = ZImage:create(recharge_btn.view, UI_VIPSysWin_003, 82, 30, -1, -1)
  -- recharge_btn_img.view:setAnchorPoint(0.5, 0.5)

  -- -- 创建滑动面板
  -- self:create_scroll();

  -- -- 滑动提示
  -- local huadong_tips = ZImage:create(self.view, UI_VIPSysWin_014, 405, 45, -1, -1)
  -- -- 两个箭头提示图
  -- local left_arrow = ZImage:create(self.view, UI_VIPSysWin_019, 375, 78, -1, -1)
  -- left_arrow.view:setRotation(180.0)
  -- local right_arrow = ZImage:create(self.view, UI_VIPSysWin_019, 759, 49, -1, -1)
  -- -- 泡泡
  -- local paopao = ZImage:create(self.view, UI_VIPSysWin_010, 160, 465, -1, -1, 2)
  -- -- 妹子
  -- -- local meizi = ZImage:create(self.view, UI_VIPSysWin_009, -21, 0, -1, -1)

  -- if Target_Platform == Platform_Type.Platform_ap then
  --       local beauty = CCZXImage:imageWithFile(20, 130, -1, -1, "nopack/body/31.png")
  --       self.view:addChild(beauty,999)
  -- else
  --       local meizi = ZImage:create(self.view, UI_VIPSysWin_009, -21, 0, -1, -1)
  -- end

end


function VIPSysWin:show_all_vip_info(  )
	if self.all_vip_panel == nil then
	
		-- self.all_vip_panel = CCScroll:scrollWithFile( 40, 13, 712 , 290, 1, "", TYPE_HORIZONTAL, 600, 600 )
		self.all_vip_panel = CCScroll:scrollWithFile(40, 30, 840 , 408, 1, "", TYPE_HORIZONTAL, 600, 600 )
		-- self.all_vip_panel:setScrollLump(UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 40, 290 )

		local function scrollfun(eventType, arg, msgid)
			if eventType == nil or arg == nil or msgid == nil then
				return false
			end
			local temparg = Utils:Split(arg,":")
			local row = temparg[1]	--

			if eventType == SCROLL_CREATE_ITEM then

				-- local base_panel = CCBasePanel:panelWithFile(0,0,712,290*5,"");
				local base_panel = CCBasePanel:panelWithFile(0,0,840, 408*5,"");
				
				for i=1,5 do

					local panel_1 = VipCellView( VipCellView.CELL_STYLE_ALL, 0, 408*5-i*408, 416, 408);
					base_panel:addChild(panel_1.view);
					local yb = VIPConfig:get_vip_level_yuanbao( (i-1)*2+1 )
					panel_1:update_cell({(i-1)*2+1, yb});

					local panel_2 = VipCellView( VipCellView.CELL_STYLE_ALL, 416+3, 408*5-i*408, 416, 408);
					base_panel:addChild(panel_2.view);
					local yb = VIPConfig:get_vip_level_yuanbao( (i-1)*2+2 );
					panel_2:update_cell({(i-1)*2+2, yb});
				end
		

				self.all_vip_panel:addItem(base_panel)
				self.all_vip_panel:refresh()
				
			end
			return true
		end
		self.all_vip_panel:registerScriptHandler(scrollfun)
		self.all_vip_panel:refresh()
		self:addChild(self.all_vip_panel);


	else
		self.all_vip_panel:setIsVisible(true);

	end

	self.meinv.view:setIsVisible(false)

	self.vip_bg:setIsVisible(true);

	self.no_vip_bg:setIsVisible(false);
	self.curren_vip_cell.view:setIsVisible(false);
	self.next_vip_cell.view:setIsVisible(false);
end

function VIPSysWin:update()
	local vipInfo = VIPModel:get_vip_info()
	if not vipInfo then
		return
	end
	_vipinfo = vipInfo
	-- 获取下一等级vip需要的元宝数
	local need_yuanbao=100;
	local max_yuanbao;
	if vipInfo.level >= 0 and vipInfo.level < 10 then
		-- if vipInfo.level == 0 then
		-- 	self.recharge_desc:setTexture(UI_VIPSysWin_011)
		-- 	--self.player_name.view:setPosition(348, 570)
		-- 	self.curr_vip_img.view:setIsVisible(false)
		-- else
		-- 	self.recharge_desc:setTexture(UI_VIPSysWin_012)
		-- 	--self.player_name.view:setPosition(400, 570)
		-- 	self.curr_vip_img:setTexture(string.format("ui/main/vip/vip%d.png",vipInfo.level))
		-- 	self.curr_vip_img.view:setIsVisible(true)
		-- end
		need_yuanbao = VIPConfig:get_vip_level_yuanbao(vipInfo.level+1) - vipInfo.all_yuanbao_value
		max_yuanbao  = VIPConfig:get_vip_level_yuanbao(vipInfo.level+1)
		-- self.next_yuanbao:setText("#cff00ba" .. need_yuanbao)
		-- self.next_yuanbao.view:setIsVisible(true)
		-- self.next_vip_img:setTexture(string.format("ui/main/vip/vip%d.png",vipInfo.level+1))
		-- self.next_vip_img.view:setIsVisible(true)

		local tiptext = string.format(Lang.vip.top_tip, need_yuanbao, vipInfo.level+1)
		_tiptop_label:setText(tiptext)
		_tiptop_label:setIsVisible(true)

		--print("has_yuanbao:" .. vipInfo.all_yuanbao_value)
		--print("max_yuanbao:" .. max_yuanbao)
		--print("need_yuanbao:" .. need_yuanbao)


	elseif vipInfo.level == 10 then
		max_yuanbao = VIPConfig:get_vip_level_yuanbao(vipInfo.level)
		--self.recharge_desc:setTexture(UI_VIPSysWin_017)
		--self.player_name.view:setPosition(400, 570)
		-- self.curr_vip_img:setTexture(string.format("ui/main/vip/vip%d.png",vipInfo.level))
		-- self.curr_vip_img.view:setIsVisible(true)
		-- self.next_yuanbao.view:setIsVisible(false)
		-- self.next_vip_img.view:setIsVisible(false)

		_tiptop_label:setIsVisible(false)
		--print("vipInfo.level==10###########")

	end
	if _viplevel_num then
		_viplevel_num:set_number(vipInfo.level)
		--print("_viplevel_num:set_number################")
	end
	-- 设置进度条的进度值
	_viplevel_progress.set_max_value(max_yuanbao)
	_viplevel_progress.set_current_value(vipInfo.all_yuanbao_value)

	--local level = clamp(vipInfo.level,1,9)
	--self.scroll:setIndex(level)
	if vipInfo.level>0 then
		self:onvipbtnClick(vipInfo.level)	
	else
		self:onvipbtnClick(1)
	end

	if vipInfo.level > 0 then
		self.vip_select.view:setIsVisible(true)
	else
		self.vip_select.view:setIsVisible(false)
	end
	-- (i-1)*(vip_btn_region_size.width+vip_btn_region_space), 
	-- 		viplist_region_size.height/2
	self.vip_select:setPosition( 18 + ( vipInfo.level - 1 ) * 85, 387 )
end

--显示体验vip的布局
function VIPSysWin:show_exp_vip_layout( vipModel )
	-- 如果vip体验时间大于0，则为vip体验阶段
	-- huiyuan_lab:setText("#cfff000体验");
	-- has_vip_view:setIsVisible(true);
	-- no_vip_view:setIsVisible(false);
	self.vip_level_icon:setTexture(string.format(UIResourcePath.FileLocate.vip .. "vip_3.png"));
	self.vip_level_icon:setPosition(128, 8)
	self.vip_level_icon:setSize(77, 20)

	self.curren_vip_cell.style = VipCellView.CELL_STYLE_DEFAULT;
	self.curren_vip_cell:update_cell( {3} );
	local level_yuanbao = VIPConfig:get_vip_level_yuanbao(3+1);
	self.next_vip_cell:update_cell( {4, level_yuanbao-vipModel.all_yuanbao_value} );

	-- vip_progress:setProgressValue(vipModel.all_yuanbao_value,level_yuanbao);
	vip_progress.set_current_value(vipModel.all_yuanbao_value)
	vip_progress.set_max_value(level_yuanbao)


end

--显示正常vip的布局
function VIPSysWin:show_normal_vip_layout( vipModel )
	-- has_vip_view:setIsVisible(true);
	-- no_vip_view:setIsVisible(false);
	-- huiyuan_lab:setText("");
	self.vip_level_icon:setTexture(string.format(UIResourcePath.FileLocate.vip .. "vip_%d.png",vipModel.level));
	self.vip_level_icon:setPosition(128, 6)
	self.vip_level_icon:setSize(77, 20)
	
	local level_yuanbao
	if vipModel.level <10 then
		level_yuanbao = VIPConfig:get_vip_level_yuanbao(vipModel.level+1);
	else
		level_yuanbao = VIPConfig:get_vip_level_yuanbao(vipModel.level);
	end
	vip_progress.set_current_value(vipModel.all_yuanbao_value)
	vip_progress.set_max_value(level_yuanbao)

	self.curren_vip_cell.style = VipCellView.CELL_STYLE_DEFAULT;
	self.curren_vip_cell:update_cell( {vipModel.level} );

	--充值进度条
	if vipModel.level <10 then
		local level_yuanbao = VIPConfig:get_vip_level_yuanbao(vipModel.level+1);
		self.next_vip_cell:update_cell( {vipModel.level+1, level_yuanbao-vipModel.all_yuanbao_value} );
	else
	-- 	level_yuanbao = VIPConfig:get_vip_level_yuanbao(vipModel.level);
	-- 	self.next_vip_cell.view:setIsVisible(false);
		self.next_vip_cell:update_cell( {vipModel.level+1} );
	end


end

function VIPSysWin:create_scroll()

	local function createVipCellView(index,newComp)
		if not newComp then
			newComp = VipCellView( VipCellView.CELL_STYLE_ALL, 0, 0, 313, 365);
			local yb = VIPConfig:get_vip_level_yuanbao( index )
			newComp:update_cell({ index, yb});
		else
			local yb = VIPConfig:get_vip_level_yuanbao( index )
			newComp:update_cell({ index, yb});
		end
		return newComp
	end
	self.scroll = TouchListHorizontal(238,100,635,365,313, 2)
	self.scroll:BuildList(320,2,2,{1,2,3,4,5,6,7,8,9,10},createVipCellView)

	self:addChild(self.scroll.view);
end

function VIPSysWin:destroy()
	--self.scroll:destroy()
	--Window.destroy(self)
end

function VIPSysWin:initpanel(parentpanel)

	_bg_panel = CCBasePanel:panelWithFile(
		_bg_panel_pos.x, _bg_panel_pos.y, _bg_panel_size.width, _bg_panel_size.height, UILH_COMMON.normal_bg_v2, 500, 500)
	parentpanel:addChild(_bg_panel)
	_bg_panel:setAnchorPoint(0, 0)	

	self:init_vipstate_panel(_bg_panel)
	self:init_vipiconlist_panel(_bg_panel)
	self:init_vipinfo_panel(_bg_panel, 1)
	self:init_buybtn(_bg_panel)

	self:onvipbtnClick(1)
end

function VIPSysWin:init_vipstate_panel(parentpanel)
	--大哥 你的代码太难维护 哥也是醉了
   
    local panel1 = CCZXImage:imageWithFile(13, 387, 854, 150, UILH_COMMON.bottom_bg,500,500)
    parentpanel:addChild(panel1)

	local parentpanelsize = parentpanel:getSize()	
	local vipstate_panel_padding={left=10, top=2, right=10}
	local vipstate_panel_size = CCSize(parentpanelsize.width-vipstate_panel_padding.left-vipstate_panel_padding.right, 88)
	local vipstate_panel_pos = CCPointMake(parentpanelsize.width/2, 540)
	local vipstate_panel = CCBasePanel:panelWithFile(
		vipstate_panel_pos.x, 
		vipstate_panel_pos.y, 
		vipstate_panel_size.width, 
		vipstate_panel_size.height, 
	    "", 500, 500)
	vipstate_panel:setAnchorPoint(0.5,1)
	parentpanel:addChild(vipstate_panel)

	local viplevel_label_padding={left=30}
	local viplevel_label_size=CCSize(-1,-1)
	local viplevel_label_pos = CCPointMake(viplevel_label_padding.left, vipstate_panel_size.height/2)	
	-- local viplevel_label = ZImage:create(vipstate_panel, UI_VIP.vip_big,
	--  	viplevel_label_pos.x, viplevel_label_pos.y, viplevel_label_size.width, viplevel_label_size.height)
	-- viplevel_label:setAnchorPoint(0, 0.5)	

	-- local viplevel_num_padding={left=5}
	-- local viplevel_num_size=CCSize(-1,-1)
	-- local viplevel_num_pos = CCPointMake(viplevel_label_padding.left+viplevel_label:getSize().width+viplevel_num_padding.left, vipstate_panel_size.height/2)
	-- local viplevel_num = ZImage:create(vipstate_panel, UI_VIP.vip_l_0,
	--  	viplevel_num_pos.x, viplevel_num_pos.y, viplevel_num_size.width, viplevel_num_size.height)
	-- viplevel_num:setAnchorPoint(0, 0.5)	

	local viplevel_label = self:create_viplevel_label(_vipinfo.level, false, true)		
	viplevel_label:setPosition(viplevel_label_pos)
	viplevel_label:setAnchorPoint(0, 0.5)

	vipstate_panel:addChild(viplevel_label)

	local tiptop_padding={top=20}
	local tiptop_pos = CCPointMake(vipstate_panel_size.width/2, vipstate_panel_size.height-tiptop_padding.top)
	_tiptop_label = CCZXLabel:labelWithTextS(tiptop_pos, "", _font_size, ALIGN_LEFT); -- [886]="#c38ff3310元宝"
	vipstate_panel:addChild(_tiptop_label);
	_tiptop_label:setAnchorPoint(CCPointMake(0.5, 1))

	local viplevel_progress_padding={bottom=20}
	-- local viplevel_progress = CCProgressTimer:progressWithFile("nopack/up.png");
 --    viplevel_progress:setAnchorPoint(CCPoint(0.5,0))
 --    viplevel_progress:setType( kCCProgressTimerTypeHorizontalBarLR)
 --   	viplevel_progress:setPosition(CCPointMake(vipstate_panel_size.width/2, viplevel_progress_padding.bottom))	
 --   	--viplevel_progress.view:setProgressValue(100)   
 --   	viplevel_progress:setPercentage(99)	
 	local viplevel_progress_size=CCSize(300, 23)
 	local viplevel_progress_pos=CCPointMake(vipstate_panel_size.width/2, viplevel_progress_padding.bottom)

  	_viplevel_progress = MUtils:create_progress_bar(
  		viplevel_progress_pos.x, viplevel_progress_pos.y, viplevel_progress_size.width, viplevel_progress_size.height, 
  		UILH_NORMAL.progress_bg, UI_VIP.progress_fr, 100, {14}, {11,11,5,5}, true)
  	vipstate_panel:addChild(_viplevel_progress.view)
  	_viplevel_progress.set_max_value(100)
  	_viplevel_progress.set_current_value(0)
  	_viplevel_progress.view:setAnchorPoint(0.5, 0)

   	--充值按钮
   	local function recharge_event( eventType, x, y)	   		
		--if eventType == TOUCH_CLICK then		
		Analyze:parse_click_main_menu_info(201)	
 			GlobalFunc:chong_zhi_enter_fun() 
 			--print("充值###########") 	
		--end
		return true
	end
   	local recharge_btn_size=CCSize(-1, -1)
   	local recharge_btn_padding={right=10}
   	local recharge_btn_pos = CCPointMake(vipstate_panel_size.width - recharge_btn_padding.right, vipstate_panel_size.height/2)
 --   	local recharge_btn = CCNGBtnMulTex:buttonWithFile(
 --   		recharge_btn_pos.x,recharge_btn_pos.y,recharge_btn_size.width,recharge_btn_size.height,UIPIC_CangKuWin_0003);
	-- recharge_btn:setAnchorPoint(1,0.5);
	-- recharge_btn:addTexWithFile(CLICK_STATE_DOWN, UIPIC_CangKuWin_0003);
	--recharge_btn:setText(Lang.vip.btn_recharge_text)

	local recharge_btn = ZTextButton:create(vipstate_panel, Lang.vip.btn_recharge_text, UILH_COMMON.lh_button_4_r, 
        recharge_event, recharge_btn_pos.x, recharge_btn_pos.y, recharge_btn_size.width, recharge_btn_size.height)
    recharge_btn:setFontSize(_font_size) --设置字体大小
	recharge_btn:setAnchorPoint(1,0.5);


	

	--recharge_btn:registerScriptHandler(recharge_event);
	--vipstate_panel:addChild(recharge_btn);

	_nowy = _nowy - vipstate_panel_padding.top - vipstate_panel_size.height
end


function VIPSysWin:onvipbtnClick(i)				
	_curvipindex=i
	if _title_text_label1 and _title_text_label2 then

		local title_texttext1 = string.format(_title_text_label_color .. "VIP%d", i)
		_title_text_label1:setText(title_texttext1)	


		local function get_vipinfo_content(vipindex)
			local labeltext = ""						
			-- for j=1, #Lang.vip.vipinfo_content[1] do
			-- 	labeltext = labeltext .. Lang.vip.vipinfo_content[1][j] .. "#r"
			-- end

			local vip_dict = FubenConfig:get_vip_detail_by_level(vipindex);
	 		for i,v in ipairs(vip_dict) do
		 		--local item = CCBasePanel:panelWithFile(0, 335-i*40, 310, 40, "", 500, 500)
		 		--self.vip_detail_panel:addChild(item)

		 		--local text = ZLabel.new(v)
		 		--text:setFontSize(16)
		 		--text:setPosition(10, 10)
		 		--item:addChild(text.view)

		 		--local line = ZImage:create(item, UI_VIPSysWin_020, 8, 0, 302, 2)

		 		-- vip_desc = vip_desc..v.."#r";
		 		labeltext = labeltext .. v .. "#r"
		 	end
		 	-- self.vip_detail:setText(vip_desc);
			--print("labeltext:#" .. labeltext .. "#")
			return labeltext
		end
		local infotext = get_vipinfo_content(i)
		--print("infotext:#" .. infotext .. "#")
		--print("_vipinfo_content1:#" .. _vipinfo_content1 .. "#")
		_vipinfo_content1:setText(infotext)

		if i<vipbtn_num then
			local title_texttext2 = string.format(_title_text_label_color .. "VIP%d", i+1)
			_title_text_label2:setText(title_texttext2)	
			_vipinfo_content2:setText(get_vipinfo_content(i+1))
		else
			local title_texttext2 = _title_text_label_color .. Lang.vip.last_tip_title
			_title_text_label2:setText(title_texttext2)	
			_vipinfo_content2:setText("")
		end
				
	end
end

--创建vip0 vip1 等等
function VIPSysWin:create_viplevel_label(viplevel, issmall, ismodify)
	local leftlabel_size=CCSize(-1, -1)
	local leftlabel_pos=CCPointMake(0, 0)
	local img1 = issmall and UI_VIP.vip_small or UI_VIP.vip_big
	local leftlabel = ZImage:create(
        nil, img1, leftlabel_pos.x, leftlabel_pos.y, 
        leftlabel_size.width, leftlabel_size.height)	





	--local rightlabel_size=CCSize(30, -1)
	local rightlabel_pos=CCPointMake(leftlabel:getSize().width + 8, leftlabel:getSize().height/2)	
	-- local img2 = issmall and UI_VIP.vip_s[viplevel+1] or UI_VIP.vip_l[viplevel+1]
	-- local rightlabel = ZImage:create(
 --        nil, img2, rightlabel_pos.x, rightlabel_pos.y, 
 --        rightlabel_size.width, rightlabel_size.height)
	-- rightlabel:setAnchorPoint(0, 0.5)

	-- local rightlabel2_size=CCSize(-1, -1)
	-- local rightlabel2_pos=CCPointMake(leftlabel:getSize().width, leftlabel:getSize().height/2)	
	-- local img3 = issmall and UI_VIP.vip_s[viplevel+1] or UI_VIP.vip_l[viplevel+1]
	-- local rightlabel2 = ZImage:create(
 --        nil, img3, rightlabel2_pos.x, rightlabel2_pos.y, 
 --        rightlabel2_size.width, rightlabel2_size.height)
	-- rightlabel2:setAnchorPoint(0, 0.5)


	local function get_num_ima( one_num )
        --return string.format("ui/lh_other/number1_%d.png",one_num);
        return issmall and UI_VIP.vip_s[one_num+1] or UI_VIP.vip_l[one_num+1]
    end
    local numwidth = issmall and 12 or 18
    local rightlabel = ImageNumberEx:create(viplevel, get_num_ima, numwidth)
    rightlabel.view:setPosition(rightlabel_pos)
    rightlabel.view:setAnchorPoint(CCPointMake(0, 0))

    local rightlabel_size = rightlabel.view:getContentSize()
    --print("rightlabel_size:" .. rightlabel_size.width .. " " .. rightlabel_size.height)
	local viplabel_pos=CCPointMake(0, 0)
	local viplabel_size=CCSize(
		leftlabel:getSize().width+rightlabel_size.width, 
		leftlabel:getSize().height)
	local viplabel = CCBasePanel:panelWithFile(viplabel_pos.x, viplabel_pos.y, viplabel_size.width, viplabel_size.height, "")
	--print("labelsize:" .. viplabel_size.width .. " " .. viplabel_size.height)
	viplabel:addChild(leftlabel.view)
	viplabel:addChild(rightlabel.view)
	--viplabel:addChild(rightlabel2.view)

	if ismodify then 
		_viplevel_num = rightlabel
		--_viplevel_num:set_number(_vipinfo.level)
		--print("_viplevel_num:set_number################")
	end
	return viplabel
end

function VIPSysWin:init_vipiconlist_panel(parentpanel)
	local parentpanelsize = parentpanel:getSize()
	
	local viplist_region_padding={left=15, top=10, right=15}
	local viplist_region_size = CCSize(parentpanelsize.width-viplist_region_padding.left-viplist_region_padding.right, 60)
	local viplist_region_pos = CCPointMake(parentpanelsize.width/2, 
		_nowy-viplist_region_padding.top)
	local viplist_region = CCBasePanel:panelWithFile(
		viplist_region_pos.x,
		viplist_region_pos.y,
		viplist_region_size.width,
		viplist_region_size.height,
		"")

	viplist_region:setAnchorPoint(0.5, 1)

	local vip_btn_region_size=CCSize(65, viplist_region_size.height)
	local vip_btn_region_space=(viplist_region_size.width-vip_btn_region_size.width*vipbtn_num)/(vipbtn_num-1)
	

	local vip_btn_size=CCSize(-1, -1)
	--local vip_btn_space=(viplist_region_size.width-vip_btn_size.width*vipbtn_num)/(vipbtn_num-1)
	
	self.vip_select = ZImage:create( parentpanel, UI_VIP.select_bg, 0, 0, 70, 70 )
	self.vip_select.view:setIsVisible(false)			
	parentpanel:addChild(viplist_region)

	local vip1btn=nil
	for i=1,vipbtn_num do
		--local imgstr = string.format("vip_%d.png", i)
		--local btnimg = UIResourcePath.FileLocate.lh_vip .. imgstr
		local vip_btn_region_pos=CCPointMake(
			(i-1)*85+5, 
			viplist_region_size.height/2)
		local vip_btn_region = CCBasePanel:panelWithFile(
			vip_btn_region_pos.x,
			vip_btn_region_pos.y,
			vip_btn_region_size.width,
			vip_btn_region_size.height,
			"")
		vip_btn_region:setAnchorPoint(0,0.5);
		viplist_region:addChild(vip_btn_region)	


		local vip_btn_pos=CCPointMake(0,vip_btn_region_size.height/2)
		local btnimg = UI_VIP.vip_bg
		local vip_btn = CCNGBtnMulTex:buttonWithFile(
			vip_btn_pos.x,
			vip_btn_pos.y,
			vip_btn_size.width,
			vip_btn_size.height,
			btnimg);
		vip_btn_region:addChild(vip_btn)		

		vip_btn:setAnchorPoint(0,0.5);
		vip_btn:addTexWithFile(CLICK_STATE_DOWN, btnimg)
		
		local function vip_btn_event( eventType, x, y)			
			if eventType == TOUCH_CLICK then
				self:onvipbtnClick(i)
				self.vip_select:setPosition( 18 + ( i - 1 ) * 85, 387 )
			end
		return true
		end

		vip_btn:registerScriptHandler(vip_btn_event)

		local btnsize = vip_btn:getSize()
		--print("btnsize:" .. btnsize.width .. " " .. btnsize.height)
		
		local viplabel = self:create_viplevel_label(i, true)
		vip_btn:addChild(viplabel)			
		viplabel:setAnchorPoint(0.5, 0.5)

		local labelsize = viplabel:getContentSize()
		local viplabel_pos = CCPointMake(btnsize.width/2, btnsize.height/2)
		viplabel:setPosition(viplabel_pos)
		-- print("btnsize:" .. btnsize.width .. " " .. btnsize.height)
		--print("labelsize:" .. labelsize.width .. " " .. labelsize.height)
		-- print("viplabel_pos:" .. viplabel_pos.x .. " " .. viplabel_pos.y)
		
	end
	
	_nowy = _nowy - viplist_region_padding.top - viplist_region_size.height

end

function VIPSysWin:init_vipinfo_panel(parentpanel, curvipindex)
	local parentpanelsize = parentpanel:getSize()
	local vipinfo_region_padding={left=10, top=10, right=10}
	local vipinfo_region_size = CCSize(
		parentpanelsize.width-vipinfo_region_padding.left-vipinfo_region_padding.right, 
		310)

	--print("parentpanelsize:" .. parentpanelsize.width .. " " .. parentpanelsize.height)
	--print("vipinfo_region_size:" .. vipinfo_region_size.width .. " " .. vipinfo_region_size.height)
	local vipinfo_region_pos = CCPointMake(parentpanelsize.width/2, 
		_nowy-vipinfo_region_padding.top-10)

	local vipinfo_region = CCBasePanel:panelWithFile(
		vipinfo_region_pos.x,
		vipinfo_region_pos.y,
		vipinfo_region_size.width,
		vipinfo_region_size.height,
		"")
	parentpanel:addChild(vipinfo_region)
	vipinfo_region:setAnchorPoint(0.5, 1)



	--_vipinfo_panel_1=vipinfo_cell_base:new()


	
	-- local vipinfo_panel_size = CCSize(300, 300)
	-- local vipinfo_panel_padding={left=20}
	local vipinfo_panel_pos1 = CCPointMake(5, vipinfo_region_size.height)
	
	-- local imgpath = UI_VIP.vip_show

	-- _vipinfo_panel_1=CCBasePanel:panelWithFile(
	-- 	vipinfo_panel_pos.x,
	-- 	vipinfo_panel_pos.y,
	-- 	vipinfo_panel_size.width,
	-- 	vipinfo_panel_size.height,
	-- 	imgpath)
	-- _vipinfo_panel_1:setAnchorPoint(0, 0.5)
	-- vipinfo_region:addChild(_vipinfo_panel_1)

	local vipinfo_panel_pos2= CCPointMake(vipinfo_region_size.width-5, vipinfo_region_size.height)
	-- _vipinfo_panel_2=CCBasePanel:panelWithFile(
	-- 	vipinfo_panel_pos.x,
	-- 	vipinfo_panel_pos.y,
	-- 	vipinfo_panel_size.width,
	-- 	vipinfo_panel_size.height,
	-- 	imgpath)
	-- _vipinfo_panel_2:setAnchorPoint(1, 0.5)
	-- vipinfo_region:addChild(_vipinfo_panel_2)

	_vipinfo_panel_1 = self:create_one_vipinfo_cell(curvipindex, vipinfo_panel_pos1)
	_vipinfo_panel_1:setAnchorPoint(0, 1)
	vipinfo_region:addChild(_vipinfo_panel_1)

	


	_vipinfo_panel_2 = self:create_one_vipinfo_cell(curvipindex+1, vipinfo_panel_pos2)
	_vipinfo_panel_2:setAnchorPoint(1, 1)
	vipinfo_region:addChild(_vipinfo_panel_2)

	local arrow_label_pos = CCPoint(vipinfo_region_size.width/2, vipinfo_region_size.height/2)
	local arrow_label_size=CCSize(-1, -1)
	local arrow_label = ZImage:create(
        vipinfo_region, UILH_COMMON.right_arrows, arrow_label_pos.x, arrow_label_pos.y, 
        arrow_label_size.width, arrow_label_size.height)	
    arrow_label:setAnchorPoint(0.5, 0.5)

	_nowy = _nowy - vipinfo_region_padding.top - vipinfo_region_size.height	
end

function VIPSysWin:init_buybtn(parentpanel)
	local parentpanelsize = parentpanel:getSize()
	local buy_btn_size=CCSize(-1, -1)
	local buy_btn_padding={bottom=18}
	local buy_btn_pos=CCPointMake(parentpanelsize.width/2, buy_btn_padding.bottom)
	
	local function buybtn_event( eventType, x, y)	
		--if eventType == TOUCH_CLICK then
		Analyze:parse_click_main_menu_info(201)
			GlobalFunc:chong_zhi_enter_fun() 	
		--end
		return true
	end	
	-- local buy_btn = CCNGBtnMulTex:buttonWithFile(buy_btn_pos.x,buy_btn_pos.y,buy_btn_size.width,buy_btn_size.height,UIPIC_CangKuWin_0003);
	-- buy_btn:setAnchorPoint(0.5,1);
	-- buy_btn:addTexWithFile(CLICK_STATE_DOWN, UIPIC_CangKuWin_0003)
	--buy_btn:registerScriptHandler(buybtn_event)
	--parentpanel:addChild(buy_btn)

	local buy_btn = ZTextButton:create(parentpanel, "", UILH_NORMAL.special_btn, 
        buybtn_event, buy_btn_pos.x, buy_btn_pos.y, buy_btn_size.width, buy_btn_size.height)
    --buy_btn:setFontSize(_font_size) --设置字体大小
	buy_btn:setAnchorPoint(0.5,0)	

	
	buy_btn_size = buy_btn:getSize()
	local buy_btn_label_pos = CCPointMake(buy_btn_size.width/2, buy_btn_size.height/2)
	local buy_btn_label = ZImage:create(buy_btn, UI_VIP.btn_buy,
	  	buy_btn_label_pos.x, buy_btn_label_pos.y, -1, -1)
	buy_btn_label:setAnchorPoint(0.5, 0.5)	


	-- local buy_btn = ZImageButton:create(parentpanel, UILH_NORMAL.special_btn, UI_VIP.btn_buy, recharge_event, 
	-- 	buy_btn_pos.y, buy_btn_pos.y, buy_btn_size.width, buy_btn_size.height)
	-- buy_btn:setAnchorPoint(1,0)	

	--print("buy_btn_pos:" .. buy_btn_pos.x .. " " .. buy_btn_pos.y)
	--print("buy_btn_label_pos:" .. buy_btn_label_pos.x .. " " .. buy_btn_label_pos.y)

end

--创建一个vip信息面板
function VIPSysWin:create_one_vipinfo_cell(vipindex, vipinfo_panel_pos)
	
	--local vipinfo_panel_pos = CCPointMake(vipinfo_panel_padding.left, vipinfo_region_size.height/2)
	
	local imgpath = UILH_COMMON.bottom_bg

	local vipinfo_panel=CCBasePanel:panelWithFile(
		vipinfo_panel_pos.x,
		vipinfo_panel_pos.y,
		vipinfo_panel_size.width,
		vipinfo_panel_size.height,
		imgpath,500,500)
	--_vipinfo_panel_1:setAnchorPoint(0, 0.5)

	local title_bg_padding={left=0,right=0}
	--local title_bg_size=CCSize(vipinfo_panel_size.width-title_bg_padding.left-title_bg_padding.right, 50)
	local title_bg_size=CCSize(-1, -1)
	local title_bg_pos = CCPointMake(vipinfo_panel_size.width/2, vipinfo_panel_size.height+20)
	local title_bg=CCBasePanel:panelWithFile(
		title_bg_pos.x, title_bg_pos.y, title_bg_size.width, title_bg_size.height, UILH_NORMAL.title_bg3)
	title_bg:setAnchorPoint(0.5, 1)
	vipinfo_panel:addChild(title_bg)

	-- local title_bg2_padding={left=50,top=-5, right=50, bottom=-5}
	-- local title_bg2_size=CCSize(title_bg_size.width-title_bg2_padding.left-title_bg2_padding.right, title_bg_size.height-title_bg2_padding.top-title_bg2_padding.bottom)
	-- local title_bg2_pos=CCPointMake(title_bg_size.width/2, title_bg_size.height/2)
	-- local title_bg2=CCBasePanel:panelWithFile(
	-- 	title_bg2_pos.x, title_bg2_pos.y, title_bg2_size.width, title_bg2_size.height, imgpath,500,500)
	-- title_bg2:setAnchorPoint(0.5, 0.5)
	-- title_bg:addChild(title_bg2)
	title_bg_size = title_bg:getSize()
	local title_text_pos = CCPointMake(title_bg_size.width/2, title_bg_size.height/2+2)
	local title_texttext = string.format(_title_text_label_color .. "VIP%d", vipindex)
	--title_texttext = "#cfff106VIP1"
	--print("title_texttext:" .. title_texttext)
	--ZLabel:create(fatherPanel, text, x, y, fontSize, aline, z)
	--local title_text_label=CCZXLabel:labelWithTextS(title_text_pos, title_texttext, _font_size, ALIGN_LEFT);
	local title_text_label=ZLabel:create(title_bg, title_texttext, title_text_pos.x, title_text_pos.y, _font_size, ALIGN_LEFT);
	--title_bg:addChild(title_text_label)
	title_text_label.view:setAnchorPoint(CCPointMake(0.5, 0.5))
	--title_text_label:setText("#cfff106aaaaaaa")

	local vipinfo_content_region_padding={left=24, top=0, right=10, bottom=10}
	local vipinfo_content_region_size=CCSize(
		vipinfo_panel_size.width-vipinfo_content_region_padding.left-vipinfo_content_region_padding.right,
		vipinfo_panel_size.height-title_bg_size.height-vipinfo_content_region_padding.top-vipinfo_content_region_padding.bottom)
	local vipinfo_content_region_pos=CCPointMake(vipinfo_content_region_padding.left, vipinfo_content_region_padding.bottom)

	
	
	local vipinfo_content_region = CCBasePanel:panelWithFile(
		vipinfo_content_region_pos.x, 
		vipinfo_content_region_pos.y, 
		vipinfo_content_region_size.width,
		vipinfo_content_region_size.height,
		"")
	vipinfo_panel:addChild(vipinfo_content_region)

	
	--local vipinfo_content_label = CCZXLabel:labelWithTextS(vipinfo_content_label_pos, "", _font_size, ALIGN_LEFT)
	--local vipinfo_content_label = UILabel:create_label_1(
	--	"", vipinfo_content_region_size, vipinfo_content_label_pos.x, vipinfo_content_label_pos.y, _font_size, CCTextAlignmentLeft)
	local vipinfo_content_label_padding={left=5, top=5, right=5, bottom=5}
	local vipinfo_content_label_size=CCSize(
		vipinfo_content_region_size.width-vipinfo_content_label_padding.left-vipinfo_content_label_padding.right,
		vipinfo_content_region_size.height-vipinfo_content_label_padding.top-vipinfo_content_label_padding.bottom)
	local vipinfo_content_label_pos=CCPointMake(vipinfo_content_label_padding.left, vipinfo_content_region_size.height-vipinfo_content_label_padding.top)


	-- local vipinfo_content_label = MUtils:create_ccdialogEx(
	-- 	vipinfo_content_region,"",vipinfo_content_label_pos.x,vipinfo_content_label_pos.y,
	-- 	vipinfo_content_label_size.width,vipinfo_content_label_size.height, 2000, _font_size)

	--vipinfo_content_region:addChild(vipinfo_content_label)
	--ZDialog:create(fatherPanel, text, x, y, width, height, fontsize, num, z)
	local vipinfo_content_label = ZDialog:create( vipinfo_content_region, "", 
		vipinfo_content_label_pos.x,vipinfo_content_label_pos.y,
	 	vipinfo_content_label_size.width,vipinfo_content_label_size.height, _font_size)
	vipinfo_content_label.view:setLineEmptySpace(5);
	vipinfo_content_label:setText(tips_words)
	vipinfo_content_label:setAnchorPoint(0, 1)
	

	if vipindex%2~=0 then
		_title_text_label1 = title_text_label
		_vipinfo_content1 = vipinfo_content_label
	else
		_title_text_label2 = title_text_label
		_vipinfo_content2 = vipinfo_content_label
	end

	return vipinfo_panel
end

