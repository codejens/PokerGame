-- SmallOperationActivityWin.lua
-- 小型运营活动面板 -- 多活动通用

super_class.SmallOperationActivityWin(NormalStyleWindow)

function SmallOperationActivityWin:__init(  )

	-- hcl 
	-- self.window_title_bg.view:removeFromParentAndCleanup(true);

	-- 标题
	local title_sp = CCZXImage:imageWithFile(794/2-244/2,448-135+25,244,135,UILH_COMMON.title_bg);
	self:addChild( title_sp );
	self.title = CCZXImage:imageWithFile(244/2-219/2+10, 135/2-64/2+34, 219, 64, "");
	title_sp:addChild( self.title );

	-- 美女图片
	--local lady_img = MUtils:create_zximg( self.view, "nopack/girl.png", 0, 0, 268, 460 );
    local base_panel = CCBasePanel:panelWithFile( 10, 10, 880, 550, UILH_COMMON.normal_bg_v2, 500,500 );	
	self:addChild(base_panel);
	--小背景
	local small_panel = CCBasePanel:panelWithFile( 25, 25, 850, 415, UILH_COMMON.bottom_bg, 500,500 );	
	self:addChild(small_panel);

		
	-- 充值按钮
	-- local function recharge_event( eventType )
	-- 	if TOUCH_CLICK == eventType then
	-- 		-- print("立即充值");
 --        	GlobalFunc:chong_zhi_enter_fun()
	-- 		--UIManager:show_window( "chong_zhi_win" );
	-- 	end
	-- end
	-- self.recharge_btn = MUtils:create_btn( small_panel, UIResourcePath.FileLocate.operationAct.."chongzhi_btn.png", UIResourcePath.FileLocate.operationAct.."chongzhi_btn.png",
	-- 					 recharge_event, 444, 13, 134, 45 );
    
    local title_panel = CCBasePanel:panelWithFile( 25, 444, 850, 100, UILH_COMMON.bottom_bg, 500,500 );	
	self:addChild(title_panel);

	-- 活动提示描述
	local tip_lab = UILabel:create_lable_2( "#cC3C09D"..Lang.activity[1], 28, 69, 18, ALIGN_LEFT ); -- [1104]="#c753113温馨提示:"
	title_panel:addChild(tip_lab);

	local str = "#cC3C09D"..Lang.activity[4]; -- [1105]="#cd40404玩家在活动期间内，强化全身装备到达指定的等级，即可领取价值超额的礼包。"
	self.tip_dialog = MUtils:create_ccdialogEx( title_panel, str, 130, 90, 700, 25,2,18 );
	self.tip_dialog:setAnchorPoint(0,1);

	-- 活动剩余时间
	local tip_lab = UILabel:create_lable_2( LH_COLOR[10]..Lang.activity[2], 27, 17, 18, ALIGN_LEFT ); -- [1106]="#c753113剩余时间:"
	title_panel:addChild(tip_lab);

	self.timer_lab = TimerLabel:create_label( title_panel, 170, 17, 18, 0,LH_COLOR[10], nil, false, ALIGN_LEFT );

	-- 当前xx
	self.tip_lab = UILabel:create_lable_2( Lang.activity[5], 435, 17, 18, ALIGN_LEFT ); -- [1107]="#c753113全身强化:"
	title_panel:addChild(self.tip_lab);

	self.ativity_content = UILabel:create_lable_2( LH_COLOR[1], 554, 17, 18, ALIGN_LEFT );
	title_panel:addChild(self.ativity_content);
	-- 获取该活动有多少个奖励项
	local count = OperationActivityConfig:get_award_cell_count( SmallOperationModel:get_operation_act_type() );
	self.activity_scroll = CCScroll:scrollWithFile( 10, 10, 835, 390, count, "", TYPE_HORIZONTAL, 600, 600 )   -- lyl ms
	self.activity_scroll:setEnableScroll(false)
    -- self.activity_scroll:setScrollLump("ui/common/common_progress.png", 10, 40, 35)
    
    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        local temparg = Utils:Split(arg,":")
        local row = temparg[1]  --列数
        if row == nil then 
            return false;
        end
        row = tonumber(row);
        if eventType == SCROLL_CREATE_ITEM then
  			
  			local cell = SmallOperationActivityCell( SmallOperationActivityCell.STYLE_DEFAULT, 0, 0, row+1);
      		local data = SmallOperationModel:get_current_act_data( );
      		local sub_activity_id =  SmallOperationModel:get_operation_act_sub_type();
      		cell:update_btn_status( data,sub_activity_id );
      		self.activity_scroll:addItem( cell.view );
	        self.activity_scroll:refresh(  );
        end
        return true
    end
    
    self.activity_scroll:registerScriptHandler(scrollfun)
    self.activity_scroll:refresh()
    small_panel:addChild(self.activity_scroll);

end

-------------------------- 界面更新

-- 设置活动类型面板
function SmallOperationActivityWin:set_activity_type_panel( type )
	
	local config = OperationActivityConfig:get_config_by_type( type );

	--self.title:setTexture(config.title);
	self.tip_dialog:setText("#cC3C09D"..config.desc);
	self.tip_lab:setText(LH_COLOR[1]..config.target);

end


function SmallOperationActivityWin:active( show )
	if show then

		self:set_activity_type_panel( SmallOperationModel:get_operation_act_type() );
		
		SmallOperationModel:req_get_current_act_data(  )

	end
end

-- 刷新
function SmallOperationActivityWin:update( data )
	
	self.activity_scroll:clear();
	local count = OperationActivityConfig:get_award_cell_count( SmallOperationModel:get_operation_act_type() );
	self.activity_scroll:setMaxNum( count );
	self.activity_scroll:refresh();
	--活动时间
	local time = SmallOperationModel:get_act_time( SmallOperationModel:get_operation_act_type() );
    print("活动时间",time)
	if ( time ~= 0 ) then 
		self.timer_lab:setText(time);
	else
		self.timer_lab:setText("0")
		self.timer_lab:setIsVisible(true)
		local txt_jiesu = UILabel:create_lable_2( LH_COLOR[10].."活动已结束", 189, 462, 18, ALIGN_LEFT ); -- [1107]="#c753113全身强化:"
		self.view:addChild(txt_jiesu)
	end
	--
	if time == 0 then
		-- self.ativity_content:setIsVisible(false);
		self.ativity_content:setText(LH_COLOR[1].."0元宝");
	else
		print("data.arg",data.arg)
		if data.arg == 0 then
			local sub_activity_id = SmallOperationModel:get_operation_act_sub_type();
			if sub_activity_id == 4 or sub_activity_id == 5 or sub_activity_id == 7 or sub_activity_id == 8 then
				self.ativity_content:setText(LH_COLOR[1]..data.had_get_record.."元宝");
			else
				self.ativity_content:setText(LH_COLOR[1].."0".."元宝");
			end
		else
			self.ativity_content:setText(LH_COLOR[1]..data.arg);
		end
		
	end
	
end

function SmallOperationActivityWin:destroy()
	self.timer_lab:destroy()
	Window.destroy(self);
end