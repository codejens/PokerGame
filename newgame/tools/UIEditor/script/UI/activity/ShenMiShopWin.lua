-- ShenMiShopWin.lua
-- created by lxm on 2014.4.13
-- 神秘商店
super_class.ShenMiShopWin(NormalStyleWindow);
require "UI/activity/ShenMiSellPanel"
require "../data/activity_config/shenmishop_config"

--构造函数
function ShenMiShopWin:__init(window_name, texture,  grid,  width,  height,title_text )
	self.slot_table = {}                 -- 记录所有slot，以便根据实际数据来获取到slot改变
 	self.mallSellPanel = {}

    --第一层背景图
    local panel_bg = CCBasePanel:panelWithFile(10, 10,880 , 550, UILH_COMMON.normal_bg_v2,500,500)
     self.view:addChild(panel_bg)
    self:create_left_panel(self.view)
    self:create_right_panel(self.view)
    self:create_shuoming(self.view)
    
    self:update_remain_time(  )

end

--当界面通过UILoader读取时会回调的函数,只会在布局文件读取完成时调用一次
-- function ShenMiShopWin:onLoad(  )
-- 	self.panel = self.children.panel
-- 	self:create_left_panel(self.panel)
-- 	self:create_right_panel(self.panel)
-- 	self:create_shuoming( self.panel)
-- 	self:onBound()
-- end

--当界面被UIManager:show_window, hide_window的时候调用
function ShenMiShopWin:active(show)
	if show then

    	MiscCC:req_get_shenmi_info( )
	end
end

--当界面被UIManager:destory_window的时候调用
--销毁的时候必须调用，清理比如retain分页，要在这里通知分页release
function ShenMiShopWin:destroy()

    if self.time then 
        self.time:destroy();
        self.time = nil;
    end

    print(self.time)

    if self.shua_time then
        self.shua_time:destroy();
        self.shua_time  = nil;
    end
    print(self.shua_time)

	Window.destroy(self);
end

local function shua_fun( )
	local xiaofei_yuanbao = ShenMiShopModel:get_xiaohao_yuanbao() 
    local avatar = EntityManager:get_player_avatar();--角色拥有元宝
    if avatar.yuanbao < xiaofei_yuanbao then --如果元宝不足
        local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
        end
        ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
    else
        MiscCC:req_refresh_item( 0 ) --如果元宝足 ！
    end
end

local function chongzhi_fun( ... )
	--UIManager:show_window("chong_zhi_win");
	GlobalFunc:chong_zhi_enter_fun()
end

function ShenMiShopWin:create_left_panel( panel )
	self.left_panel = CCBasePanel:panelWithFile( 25, 25, 849, 520, UILH_COMMON.bottom_bg, 500, 500 )
    panel:addChild( self.left_panel )
    
    --剩余时间label
    local shengyu_lab = UILabel:create_lable_2(LH_COLOR[1].."剩余时间：", 40, 450, 16, ALIGN_LEFT)
    panel:addChild(shengyu_lab)

    --下次刷新时间label
    local next_shua_lab = UILabel:create_lable_2(LH_COLOR[1].."下次刷新时间：#c08d53d", 40, 72, 16, ALIGN_LEFT)
    panel:addChild(next_shua_lab)


	-- self:create_left_slot(self.left_panel )

	local player = EntityManager:get_player_avatar();
	-- self.yuan_bao = self.children.yuan_bao
     self.yuan_bao= UILabel:create_lable_2(LH_COLOR[1].."元宝", 41, 41, 16, ALIGN_LEFT ) -- [543]="#cffff00积分"
    panel:addChild( self.yuan_bao )

	self.yuan_bao:setString(player.yuanbao)

    local shua_btn =  ZButton:create(panel,UILH_NORMAL.special_btn,shua_fun,409,51,-1,-1)
    local btn_size = shua_btn:getSize()
    local shuaxin = ZImage:create(shua_btn,UILH_MAINACTIVITY.flash_now,0,0,-1,-1)
    local shua_size = shuaxin.view:getSize()
    shuaxin.view:setPosition(btn_size.width/2- shua_size.width/2 , btn_size.height/2- shua_size.height/2)


    -- local chongzhi_btn =  ZButton:create(panel,UILH_COMMON.button4,chongzhi_fun,1,330,35,35)
    -- chongzhi_btn:setTouchClickFun(shua_fun)


end


function ShenMiShopWin:create_right_panel( panel )
    
    local girl = ZImage:create(panel,"nopack/girl.png",449,-28,-1,-1)
    girl.view:setFlipX(true)

    self.shua_count= UILabel:create_lable_2("测试字符串", 350, 448, 16, ALIGN_LEFT ) -- [543]="#cffff00积分"
    panel:addChild( self.shua_count )

        self.xiaohao= UILabel:create_lable_2("测试字符串", 397, 35, 16, ALIGN_LEFT ) -- [543]="#cffff00积分"
    panel:addChild( self.xiaohao )

end

function ShenMiShopWin:create_left_slot(left_panel )
	local pos_x_start = 19   	--x 坐标起点
	local pos_y_start = 225   	--x 坐标起点
	local jian_ge = 70          --间隔
	-- 创建 两列格子
	for i=1,8 do
		local row = i/2 - 1
		if i%2 == 0 then
			self:create_one_slot(  pos_x_start , pos_y_start-row*jian_ge ,i ,left_panel,_shenmi_shop_get_slot_id[i].id)
		else
			row = (i+1)/2 - 1
			self:create_one_slot(  pos_x_start +jian_ge, pos_y_start-row*jian_ge ,i ,left_panel,_shenmi_shop_get_slot_id[i].id)
	 	end		
	end
end

-- 创建一个道具slot. 参数：类型(作为索引用)， 坐标
function ShenMiShopWin:create_one_slot(  po_x , po_y ,index ,panel,item_id)
    local width  = 48
    local height = 48
    local slotItem = SlotItem(width, height)
    slotItem:setPosition( po_x , po_y )                                                         -- 位置
    slotItem:set_icon_bg_texture( UILH_COMMON.slot_bg,  -6 ,  -6, width+12, height+12 )   -- 背框, 15是真龙之魂，没有背景框
    self.slot_table[ index ] = slotItem
    panel:addChild( slotItem.view, 999 )

    slotItem:set_icon_ex(item_id)
    --slotItem:set_select_effect_state( true )
    slotItem.grid_had_open = true
    slotItem:set_gem_level( item_id ) 

    local function item_click_fun ()
        ActivityModel:show_mall_tips( item_id )
    end
    slotItem:set_click_event(item_click_fun)
end

-- 创建右边销售商品
function ShenMiShopWin:create_right_sell( item_list )
	self:clear_right_sell(  )

	local curx = 40
	local cury = 275
	for i=1,4 do
        --根据策划要求  又做特殊处理   更改第一行，原价全改成元宝
		self.mallSellPanel[i] = ShenMiSellPanel( item_list[i],i)
    	self.view:addChild( self.mallSellPanel[i].view )
    	self.mallSellPanel[i].view:setPosition( curx, cury)
    	curx = curx + self.mallSellPanel[i].view:getSize().width+10    --有商品的列表间距
    	if i==2  then
        	curx = 40
        	cury = 105
		end
	end

    self.mallSellPanel[1].selected = true
    self:change_select()
	
end

-- 清除右边销售区域
function ShenMiShopWin:clear_right_sell(  )
	for i=1,4 do
		if self.mallSellPanel[i] then 
		print("清除第几行",i)
        self.mallSellPanel[i].view:removeFromParentAndCleanup(true)
        self.mallSellPanel[i] = nil;
    end
	end
end

-- 活动规则说明
function ShenMiShopWin:create_shuoming( panel )
    
    local shuoming = UILabel:create_lable_2(LH_COLOR[1].."活动说明：", 40, 510, 16, ALIGN_LEFT)
    panel:addChild(shuoming)
    self.dialog_info = ZDialog:create(nil, nil, 133, 485, 420, 85 ,14)
    self.dialog_info.view:setAnchorPoint(0, 0.5)
    self.dialog_info:setText(LH_COLOR[2]..Lang.shenmi_shop[2])  -- "活动期间，可进入神秘商店，购买到超值优惠的特价商品，300000真气丹、特级保护符、5级宝石、4级宝石等您来拿！",
    panel:addChild( self.dialog_info.view )

    --疑问按钮
    -- local function question_btn_fun(eventType,x,y)
    --     HelpPanel:show( 3, UILH_COMMON.button4, "这里是轰动规则")
    -- end
    -- ZButton:create(panel,UILH_COMMON.button4,question_btn_fun,700,330,35,35)
end

-- 刷新神秘商店界面
function ShenMiShopWin:update_shenmi_shop( )
	local remain_time = 0
	local next_shua_time = 0
	local remain_shua_count = 0
	local item_count = 0
	local xiaofei_yuanbao = 0
	remain_time,next_shua_time,remain_shua_count,item_count = ShenMiShopModel:get_shop_data()

    --消耗元宝直接写死 38元宝
	-- xiaofei_yuanbao = ShenMiShopModel:get_xiaohao_yuanbao()
	-- print("xiaofei_yuanbao",xiaofei_yuanbao)

	-- self:update_remain_time(  )
	self:update_next_time( next_shua_time )
	self.shua_count:setString(LH_COLOR[1].."今日剩余刷新次数：#c08d53d"..remain_shua_count)
	self.xiaohao:setString(Lang.shenmi_shop[1]) -- [1] = "#cd5c241每刷新一次消耗38#cd5c241元宝",

	local item_list = {}
	item_list = ShenMiShopModel:get_item_list(  )

    print("总共多少个数据",#item_list)
    if item_count > 0 then
		self:create_right_sell( item_list)
	end

	local player = EntityManager:get_player_avatar();
	print("player.yuanbao",player.yuanbao)
	self.yuan_bao:setString(LH_COLOR[1].."元宝："..LH_COLOR[15]..player.yuanbao)

end



-- 更新限时商店的刷新剩余时间
function ShenMiShopWin:update_remain_time(  )
	if self.time then 
        self.time:destroy();
        self.time = nil;
    end
    local the_time = SmallOperationModel:get_act_time( 29 ); 
    --print("time=",time);
    local function finish_call(  )
        if self.time then
          self.time:setString(LH_COLOR[10].."0秒")
        end
    end
    -- 
	self.time = TimerLabel:create_label( self.view, 135,451 , 16, the_time,LH_COLOR[10], finish_call, false,ALIGN_LEFT);   -- lyl ms

    if the_time == nil or the_time <= 0 then
        finish_call();
    end 
end

function ShenMiShopWin:update_next_time( time )
	if self.shua_time then 
        self.shua_time:destroy();
        self.shua_time = nil;
    end
    --local time = SmallOperationModel:get_act_time( 39 ); --翻牌 活动id=39
    --print("time=",time);
    local function finish_call(  )
        if self.shua_time then
          self.shua_time:setString(LH_COLOR[10].."0秒")
          MiscCC:req_refresh_item( 1 ) --如果元宝足 ！
        end
    end

	self.shua_time = TimerLabel:create_label( self.view, 170,73 , 13, time,LH_COLOR[10] , finish_call, false,ALIGN_LEFT);   -- lyl ms

    if time == nil or time <= 0 then
        finish_call();
    end 
end



function ShenMiShopWin:update_yuanbao( ... )
	local player = EntityManager:get_player_avatar();
	print("update_yuanbao",player.yuanbao)
	self.yuan_bao:setString(LH_COLOR[1].."元宝："..LH_COLOR[15]..player.yuanbao)   
end



function  ShenMiShopWin:change_select()
        --更新选中情况
    for i=1,#self.mallSellPanel do
        if self.mallSellPanel[i].selected then
            if self.mallSellPanel[i].select_img then
               self.mallSellPanel[i].select_img:setIsVisible(true)
            end
        else
             -- self.mallSellPanel[i].selected = false
             if self.mallSellPanel[i].select_img then
                self.mallSellPanel[i].select_img:setIsVisible(false)
             end
        end
        self.mallSellPanel[i].selected = false
    end
end


