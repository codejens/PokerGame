-- XiaoFeiReturnWin
-- create by lxm on 2014.5.14
-- 消费返回活动
super_class.XiaoFeiReturnWin(NormalStyleWindow);
require "UI/operateActivity/ServerActivityConfig"
require "../data/activity_config/xiaofei_return_config"
require "../data/activity_config/yuanbaofanli_config"
local xiafei_row = 4
local return_get_slot_id = {}
local return_get_title = {}
local activity_type = ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN
local parent_actId = 53
local  child_actId = 2
--构造函数
function XiaoFeiReturnWin:__init( window_name, window_info )
    self.btn_table = {}  --保存的按钮
    self.btn_txt_table = {}
    self.panel = ZBasePanel:create( self.view,UILH_COMMON.normal_bg_v2 , 10, 10, 882, 550, 600, 600)
    local panel_img = ZImage:create(self.panel, UILH_COMMON.bottom_bg, 16, 18, 850, 480, nil, 500, 500)
    self.scroll = nil



end


function XiaoFeiReturnWin:setActivity_type( type )
    activity_type = type
    if activity_type == ServerActivityConfig.ACT_TYPE_YUANBAOFANLI then
       parent_actId = 53
       child_actId = 2
    elseif activity_type ==ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN then
       parent_actId = 43
       child_actId = 3
    end
    self:change_info(activity_type)
    self:create_top_view(activity_type)
    OnlineAwardCC:req_activity_data_com( parent_actId, child_actId )

end

function XiaoFeiReturnWin:change_info( type )
    if type == ServerActivityConfig.ACT_TYPE_YUANBAOFANLI then
        self.window_title:setTexture(UILH_MAINACTIVITY.chongzhi_return)
        xiafei_row = #_yuanbao_return_get_slot_id
        return_get_slot_id = _yuanbao_return_get_slot_id
        return_get_title = _yuanbao_return_get_title
    elseif type == ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN then
        xiafei_row = #_xiaofei_return_get_slot_id
        return_get_slot_id = _xiaofei_return_get_slot_id
        return_get_title =  _xiaofei_return_get_title
    end
     self:create_scroll_view(self.panel)
end
--当界面被UIManager:show_window, hide_window的时候调用
function XiaoFeiReturnWin:active(show)
	if show then
	end
end

--当界面被UIManager:destory_window的时候调用
--销毁的时候必须调用，清理比如retain分页，要在这里通知分页release
function XiaoFeiReturnWin:destroy()
    if self.recharge_time_lab then 
        self.recharge_time_lab:destroy();
        self.recharge_time_lab = nil;
    end
    
    
	Window.destroy(self);
end


function XiaoFeiReturnWin:create_top_view( activity_type )
    self.top_panel = ZBasePanel:create( self.view, "", 160, 508, 600, 40, 600, 600)


	-- ZImage:create(self.top_panel, UIResourcePath.FileLocate.xiaofeireturn .. "daoji_time.png", 10, 2, 150, 20) 
        local label_txt = UILabel:create_label_1(LH_COLOR[15]..Lang.mainActivity.xiaofei_return[1], CCSize(100,15), 58 , 22, 16, CCTextAlignmentLeft, 255, 255, 0)
        self.top_panel:addChild( label_txt ) 

    self.txt_shuoming = UILabel:create_lable_2(LH_COLOR[2].."",  542 , 14, 16, ALIGN_CENTER)
    self.top_panel:addChild(self.txt_shuoming)

    local  tip_txt = ""
      if activity_type == ServerActivityConfig.ACT_TYPE_YUANBAOFANLI then
      tip_txt = Lang.mainActivity.xiaofei_return[2]
    elseif activity_type == ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN then
      tip_txt = Lang.mainActivity.xiaofei_return[3]
    end

    local function tip_but_fun1( eventType,x,y )
        if eventType == TOUCH_CLICK then
       -- self.current_page_index = 1
       -- local tip_data = WelfareModel:get_list_date_by_type(1) 
        NormalDialog:show(tip_txt, "", 2 )

    end
        return true
        
    end 
    local question_tip = MUtils:create_btn(self.top_panel,
    UILH_NORMAL.wenhao,
    UILH_NORMAL.wenhao,
    tip_but_fun1,
    381, 0, -1, -1) 
end

function XiaoFeiReturnWin:create_scroll_view(parent)

    --print("row_num")
    local function scrollfun( _self, row )
        row = row + 1;
        -- print("row = ",row)
        local heigth = 125
        local panel = CCBasePanel:panelWithFile(0,0,700,heigth,nil);
    	self:create_one_row( panel,row)    
        return panel;
    end

    self.scroll = ZScroll:create(parent, scrollfun, 34 , 35 , 825, 450, xiafei_row);
    self.scroll:setScrollCreatFunction(scrollfun)
    self.scroll:setMaxNum(xiafei_row)  
    self.scroll:setScrollLump(10, 30, 502)
    self.scroll:setScrollLumpPos(815)
    local arrow_up = CCZXImage:imageWithFile(860, 492, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(860, 35, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    self.view:addChild(arrow_up)
    self.view:addChild(arrow_down)

    self.scroll:refresh();

    return scroll;
end

function XiaoFeiReturnWin:create_one_row( panel,row)
	local pos_x = 10
	local pos_y = 10
    local len = string.len(return_get_title[row])
	local titleBg = ZImage:create(panel,UILH_NORMAL.title_bg4,5, pos_y+82, 800,31,1,500,500)
    ZLabel:create(titleBg, return_get_title[row], 5, 8, 14, ALIGN_LEFT, 0)

	for i=1,#return_get_slot_id[row] do
		self:create_one_slot(  pos_x , pos_y ,panel,return_get_slot_id[row][i] )
		pos_x = pos_x+85
	end


    local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then 
                OnlineAwardCC:req_get_activity_award_com( parent_actId, child_actId, row )
            end
     end

    local function panel_func(eventType,x,y)
        if  eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            OnlineAwardCC:req_get_activity_award_com( parent_actId, child_actId, row )
            return true;
        end
        return true
    end

    local btn_panel = ZBasePanel:create(panel,"" , 690, -5, 120, 100, 600, 600)
    btn_panel.view:registerScriptHandler(panel_func)

    self.btn_table[row] = CCNGBtnMulTex:buttonWithFile(690, pos_y+6, -1, -1,UILH_COMMON.lh_button_4_r,500,500)
    self.btn_table[row]:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.btn4_dis)
    self.btn_table[row]:registerScriptHandler(btn_fun) 
    panel:addChild(self.btn_table[row])

    self.btn_txt_table[row] = UILabel:create_lable_2(LH_COLOR[2].."", 38, 17, 14, ALIGN_CENTER )
    local btn_size =  self.btn_table[row]:getSize()
    local btn_txt_size  = self.btn_txt_table[row]:getSize()

    self.btn_table[row]:addChild( self.btn_txt_table[row] )
    self.btn_txt_table[row]:setText(LH_COLOR[2]..Lang.mainActivity.xiaofei_return[4]) -- [549]="领取"
    self.btn_txt_table[row]:setPosition(btn_size.width/2-btn_txt_size.width/2,btn_size.height/2- btn_txt_size.height/2+3)
    local activity_data = BigActivityModel:get_activity_data( parent_actId )
    if activity_data then
    	self:update_btn_status( activity_data[1],row )
    end

end

-- 创建一个道具slot.  
function XiaoFeiReturnWin:create_one_slot(  po_x , po_y ,panel,item_info)
    local width  = 84
    local height = 84
    local slotItem = SlotItem(64, 64)
    slotItem:setPosition( po_x , po_y )                                                         -- 位置
    slotItem:set_icon_bg_texture( UILH_COMMON.slot_bg,  -10 ,  -8, width, height )   -- 背框, 15是真龙之魂，没有背景框
    slotItem:set_icon_ex(item_info.id)
    slotItem:set_item_count(item_info.num)
    slotItem:set_select_effect_state( true )
    --slotItem:set_color_frame( item_info.item_id, -3, -4, 48, 48 )    -- 边框颜色
    slotItem.grid_had_open = true
    -- local item_base = ItemConfig:get_item_by_id(item_info.id );
    -- local pj = ItemModel:get_item_pj( item_base )
    -- print("设置物品的品质和品阶",pj)
    -- slotItem:set_item_quality( nil,pj );
    slotItem:set_gem_level( item_info.id ) 
    local function item_click_fun ()
        ActivityModel:show_mall_tips( item_info.id )
    end
    slotItem:set_click_event(item_click_fun)
    panel:addChild( slotItem.view, 999 )
end

function XiaoFeiReturnWin:update_xiaofei_data(activity_data )
    --self:init_btn()
    -- print("xiafei_row",xiafei_row)
    -- for i=1,xiafei_row do
    --     if self.btn_table[i] and self.btn_table[i].view then
    --         self:update_btn_status( activity_data,i )
    --     end
    -- end
    -- if self.xiaofei_yuanbao then
    --string.format("#cd5c241目前已消费:%s元宝",activity_data.arg )
       

    if activity_type == ServerActivityConfig.ACT_TYPE_YUANBAOFANLI then
      self.txt_shuoming:setText(string.format("#cd5c241目前已充值:%s元宝",activity_data.arg ))
    elseif activity_type == ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN then
      self.txt_shuoming:setText(string.format("#cd5c241目前已消费:%s元宝",activity_data.arg ))
    end


    -- end
    if self.scroll then
            self.scroll:clear()
            self.scroll:refresh()
    end
    self:update_time( )
end

function XiaoFeiReturnWin:update_btn_status( activity_data,i )
    -- print("Utils:get_bit_by_position( activity_data.can_get_record, i )",Utils:get_bit_by_position( activity_data.can_get_record, i ),Utils:get_bit_by_position( activity_data.had_get_record, i ))
    if Utils:get_bit_by_position( activity_data.can_get_record, i ) == 0 then
        self.btn_table[i]:setCurState(CLICK_STATE_DISABLE)
        self.btn_txt_table[i]:setText(LH_COLOR[2]..Lang.mainActivity.xiaofei_return[4]) 
    else
        self.btn_table[i]:setTexture(UILH_COMMON.lh_button_4_r)
        self.btn_txt_table[i]:setText(LH_COLOR[2]..Lang.mainActivity.xiaofei_return[4]) 
    end

    if Utils:get_bit_by_position( activity_data.had_get_record, i ) == 1 then 
        self.btn_table[i]:setCurState(CLICK_STATE_DISABLE)
        self.btn_txt_table[i]:setText(LH_COLOR[2]..Lang.mainActivity.xiaofei_return[5]) 
    end
end

function XiaoFeiReturnWin:update_time(  )
    if self.recharge_time_lab then 
        self.recharge_time_lab:destroy();
        self.recharge_time_lab = nil;
    end

    local function finish_call(  )
        if self.recharge_time_lab then
          self.recharge_time_lab:setString("0秒")
        end
    end
    -- 
    local time = SmallOperationModel:get_act_time( parent_actId ); --消费返还 活动id=43
    self.recharge_time_lab = TimerLabel:create_label( self.top_panel, 180,12 , 16, time,"" , finish_call, false,ALIGN_LEFT);  
    if time == nil or time <= 0 then
        finish_call();
    end 
end


