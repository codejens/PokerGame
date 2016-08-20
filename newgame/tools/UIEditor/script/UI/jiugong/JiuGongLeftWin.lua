-- JiuGongLeftWin.lua
-- created by lxm on 2014-7-17
-- 九宫神藏 左边窗口

require "UI/component/Window"
require "../data/activity_config/jiugongshenzang_config"
super_class.JiuGongLeftWin(NormalStyleWindow)

--构造函数
function JiuGongLeftWin:__init( window_name, window_info )
	-- self.exit_btn.view:setIsVisible(false)
	self.slot_table = {}  -- 9个格子\
	self.select_slot_table = {}  -- 选中9个格子
	self.cur_slot ={}  --当前选中格子
  self.shuaxin_table ={}  --3个刷新格子
  self.cur_status = false  --抽奖状态 true 为抽奖中
  self.cur_choujiang_yuanbao = 0 -- 抽奖元宝
end

--当界面通过UILoader读取时会回调的函数,只会在布局文件读取完成时调用一次
function JiuGongLeftWin:onLoad(  )
    print("---------------sdfsdfsdfsdfsf onLoad")
	self:onBound()
end


--当界面被UIManager:destory_window的时候调用
--销毁的时候必须调用，清理比如retain分页，要在这里通知分页release
function JiuGongLeftWin:destroy()
	if self.time then 
        self.time:destroy();
        self.time = nil;
    end
	Window.destroy(self);
end

--当界面被UIManager:show_window, hide_window的时候调用
function JiuGongLeftWin:active(show)
    if show then
    	OnlineAwardCC:req_jiugong_info(0)
      self.cur_status = false
      self:update_btn_status(  )
    else
        if self.turn_timer then
            self.turn_timer:stop()
            self.turn_timer = nil
            self.time_index = 0
        end
    end
end

--在onload的时候调用,主要是绑定事件
function JiuGongLeftWin:onBound()
   local children = self.children
   self:create_all_slot(children[5] )
   self.shua_xin_label = children[10]
   self.top_bg = children[5]            --物品背景
   self.reflesh_cost_label = children[12] --刷新需消费的元宝
   self.reflesh_cost_label:setText( string.format("消费%d元宝",_jiugong_shuaxin_yuanbao) )
   self.choujiang_yuanbao = children[13]  --抽奖元宝
   --self:create_shuaxin_slot( children)
   self.tiao_donghua = children[18]
   --self.tiao_donghua:set_label_position(-20,-15)
   --self.dazi = children[19]   --谢谢您的参与！祝您好运！

   self:update_remain_time(  )
   self:clear_shuaxin_item()
   self.shua_xin_btn = children[14] 
   function shua_xin_fun( )
   	    self:shua_xin( )
   end
   self.shua_xin_btn:setTouchClickFun(shua_xin_fun)

   local function chou_jiang_click()
      self.chou_jiang_btn:setCurState(CLICK_STATE_DISABLE)
    	self:chou_jiang( )
   end

   self.chou_jiang_btn = children[15]  --抽奖按钮
   self.chou_jiang_btn:setTouchClickFun(chou_jiang_click)

   local close_btn = children[4] 
   function close_btn_fun( )
		UIManager:hide_window("jiu_gong_left_win");
		UIManager:hide_window("jiu_gong_right_win");
   end
   close_btn:setTouchClickFun(close_btn_fun)

   
 
end
-- 抽奖
function JiuGongLeftWin:chou_jiang( )
    local avatar = EntityManager:get_player_avatar();--角色拥有元宝
    if avatar.yuanbao < self.cur_choujiang_yuanbao then --如果元宝不足
        local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
        end
        ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
    else
        OnlineAwardCC:req_chou_jiang()
    end
end
-- 刷新
function JiuGongLeftWin:shua_xin( )
    local avatar = EntityManager:get_player_avatar();--角色拥有元宝
    if avatar.yuanbao < _jiugong_shuaxin_yuanbao then --如果元宝不足
        local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
        end
        ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
    else
        OnlineAwardCC:req_jiugong_info(1)
    end
end

-- 创建刷新物品
function JiuGongLeftWin:create_shuaxin_slot( children)
  local po_x = 6
  local po_y =2
  for i=1,3 do
    self:create_one_shuaxin_slot(  po_x , po_y ,i ,children[6])
    po_x =po_x +140
    
  end
  
end

function JiuGongLeftWin:update_shuaxin_item(  )
    local shuaxin_count = JiuGongModel:get_shuaxin_count( )
    for i=1,#_shuaxin_item do
      if shuaxin_count< _shuaxin_item[i].shuaxin_count then
          self:set_shuaxin_item(i ,shuaxin_count)
          return 
      end

      if shuaxin_count>= _shuaxin_item[#_shuaxin_item].shuaxin_count then
          self:set_shuaxin_item(#_shuaxin_item+1 ,shuaxin_count)
          self:clear_shuaxin_item(  )
      end
    end
end

function JiuGongLeftWin:set_shuaxin_item(index ,shuaxin_count)
    local children = self.children
    for i=1,3 do
      local from_index = (i-1)+index
      local label = children[6+i]
      if from_index<=#_shuaxin_item then
        local shuaxin_item = _shuaxin_item[from_index]
        local item_id  = shuaxin_item.item_id
        local function item_click_fun ()
          ActivityModel:show_mall_tips(item_id )
        end
        self.shuaxin_table[i]:set_click_event(item_click_fun)
        self.shuaxin_table[i]:set_icon_ex(item_id)

        
        local count = shuaxin_item.shuaxin_count-shuaxin_count
        local str = string.format("#cd5c241再刷新%d次",count)
        label.view:setString(str)
      else
        self.shuaxin_table[i]:set_icon_ex(nil)
        label.view:setString("")
      end
    end
    
    
end

-- 创建一个刷新道具slot. 参数：类型(作为索引用)， 坐标
function JiuGongLeftWin:create_one_shuaxin_slot(  po_x , po_y ,index ,panel)
    local width  = 50
    local height = 50
    local slotItem = SlotItem(width, height)
    slotItem:setPosition( po_x , po_y )    
    --slotItem.view:setSize( 10,10 )                                              -- 位置
    slotItem:set_icon_bg_texture( UILH_COMMON.bg_07, -10 ,  -12, width+20, height+24 )   -- 背框, 15是真龙之魂，没有背景框
    self.shuaxin_table[ index ] = slotItem

    -- local temp = ZImage:create(panel, UIResourcePath.FileLocate.jiugong .. "select_bg.png", po_x-13, po_y-17, width+26, height+32, 20)
    -- temp.view:setIsVisible( false ) 
    -- self.select_slot_table[ index ] = temp
    panel.view:addChild( slotItem.view, 999 )
  
end

function JiuGongLeftWin:create_all_slot(panel )
	local pos_x_start = 85   	--x 坐标起点
	local pos_y_start = 100   	--x 坐标起点
	local x_jian_ge = 65          --x间隔
	local y_jian_ge = 67          --y间隔
	-- 创建 三列格子
	for i=1,3 do
        for b=1,3 do
        	local cur_index = (i-1)*3+b
        	self:create_one_slot(  pos_x_start, pos_y_start ,cur_index ,panel)	
        	pos_x_start = pos_x_start+x_jian_ge
        	if b==3 then
            	pos_y_start = pos_y_start +y_jian_ge
            	pos_x_start = 85
        	end
        end
	 	
	end
end

-- 创建一个道具slot. 参数：类型(作为索引用)， 坐标
function JiuGongLeftWin:create_one_slot(  po_x , po_y ,index ,panel)
    local width  = 48
    local height = 48
    local slotItem = SlotItem(width, height)
    slotItem:setPosition( po_x , po_y )    
    --slotItem.view:setSize( 10,10 )                                              -- 位置
    slotItem:set_icon_bg_texture( UILH_COMMON.bg_07, -10 ,  -12, width+20, height+24 )   -- 背框, 15是真龙之魂，没有背景框
    self.slot_table[ index ] = slotItem

    local temp = ZImage:create(panel, UILH_COMMON.bg_07, po_x-13, po_y-17, width+26, height+32, 20)
    temp.view:setIsVisible( false ) 
    self.select_slot_table[ index ] = temp
    panel.view:addChild( slotItem.view, 999 )
  
end

-- 更新物品
function JiuGongLeftWin:update_slot_info(  )
	local gezi_info = JiuGongModel:get_gezi_info( )
	for i=1,9 do
		local n_bg = ItemConfig:get_item_icon( gezi_info[i].item_id )
    if gezi_info[i].status==1 then
        local d_bg = MUtils.CCSpriteSetGrayscale(nil, n_bg)
        self.slot_table[i]:set_icon_texture(d_bg)

    else
    	self.slot_table[i]:set_icon_texture(n_bg)
    end

    local function item_click_fun ()
      	ActivityModel:show_mall_tips( gezi_info[i].item_id )
  	end
  	self.slot_table[i]:set_click_event(item_click_fun)
		
	end
  
	local shuaxin_count = JiuGongModel:get_shuaxin_count()
	local str = string.format("目前已经刷新：%d次",shuaxin_count)
	self.shua_xin_label.view:setString(str)
  --self:show_shuaxin_item(  )

  --self:update_shuaxin_item(  )
  self:update_xiaofei_yuanbao(  )
end

local function has_value(Value)
    if Value > 63 then 
        return true
    end
    local zhuandong_speed = {1,5,9,12,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32,34,36,39,42,45,49,53,58,63}--20   23+8
    for i=1,#zhuandong_speed do
        if zhuandong_speed[i] == Value  then 
            return true
        end
    end
    return false
end

-- 抽奖
function JiuGongLeftWin:chou_jiang_fun( index ,item_id)
	if self.turn_timer == nil then
      self.cur_status =true
      self:update_btn_status( )
	    self.time_index = 0
      local speed_control = 1--控制快慢
      local  has_chou_item = JiuGongModel:get_has_chou_item( )
      if self.tiao_donghua:getCheck() or #has_chou_item==8 then
        self.time_index = 29
        speed_control = 1
      end
	    
	    function turn_fun( )
	        local flag = has_value(speed_control)
	        if flag then
	            if  self.time_index <= 28 then --正在抽奖            	  
	                --local r = math.random(1,9)
                  local x = JiuGongLeftWin:find_random( )
                  self:clear_select_slot()
	                self.select_slot_table[x].view:setIsVisible( true ) 
                  --end
	            end
	            if  self.time_index == 29 then       --过阵子 让圈圈消失
	            	  print("停下来了",speed_control)
	                self.turn_timer:stop() 
	                self.turn_timer = nil 
	                self.time_index = 0
	                self:clear_select_slot()
	                self.select_slot_table[index].view:setIsVisible( true ) 
	                local n_bg = ItemConfig:get_item_icon( item_id )
	                local d_bg = MUtils.CCSpriteSetGrayscale(nil, n_bg)
	        		    self.slot_table[index]:set_icon_texture(d_bg)
	        		    OnlineAwardCC:req_chou_item( index)
                  self.cur_status =false
                  self:update_btn_status(  )

                  JiuGongModel:set_gezi_status( index)
                  self:update_xiaofei_yuanbao(  )
	                return true
	            end

	            self.time_index = self.time_index + 1 
	        end
	        speed_control = speed_control + 1
	    end
	    self.turn_timer = timer()
	    self.turn_timer:start(0.1,turn_fun)
	end
end

function JiuGongLeftWin:clear_select_slot( ... )
	for i=1,9 do
		self.select_slot_table[i].view:setIsVisible( false ) 
	end
end

-- 更新剩余时间
function JiuGongLeftWin:update_remain_time(  )
	  if self.time then 
        self.time:destroy();
        self.time = nil;
    end
    local time = SmallOperationModel:get_act_time( 74 ); 
   -- print("更新剩余时间time=",time);
    local function finish_call(  )
        if self.time then
          self.time:setString("0秒")
        end
    end
    -- 
	  self.time = TimerLabel:create_label( self.top_bg, 16,300 , 16, time,"#cd5c241本活动总结束倒计时：" , finish_call, false,ALIGN_LEFT);   -- lyl ms

    if time == nil or time <= 0 then
        finish_call();
    end 
end

-- 更新按钮状态
function JiuGongLeftWin:update_btn_status(  )
    if self.cur_status then
      self.shua_xin_btn:setCurState(CLICK_STATE_DISABLE)
      self.chou_jiang_btn:setCurState(CLICK_STATE_DISABLE)
    else
      self.shua_xin_btn:setCurState(CLICK_STATE_UP)
      self.chou_jiang_btn:setCurState(CLICK_STATE_UP)
    end
end

-- 更新抽奖消费元宝
function JiuGongLeftWin:update_xiaofei_yuanbao( ... )
    local  has_chou_item = JiuGongModel:get_has_chou_item( )
    self.cur_choujiang_yuanbao = _choujiang_yuanbao[#has_chou_item+1]
    local str = string.format("消费%d元宝",self.cur_choujiang_yuanbao)
    self.choujiang_yuanbao.view:setString(str)
end

-- 查找抽奖闪过的格子 
-- function JiuGongLeftWin:find_choujiang_index( r )
--     local  has_chou_item = JiuGongModel:get_has_chou_item( )
--     for i=1,#has_chou_item do
--       if has_chou_item[i] == r then
--          return true
--       end
--     end
--     return false
-- end

function JiuGongLeftWin:show_shuaxin_item( ... )
    local children = self.children
    children[11].view:setIsVisible(true)
    children[16].view:setIsVisible(true)
    --self.dazi.view:setIsVisible(false)
    for i=1,3 do
      self.shuaxin_table[i].view:setIsVisible(true)
    end
end

-- 清除刷新物品 显示 谢谢您的参与！祝您好运！
function JiuGongLeftWin:clear_shuaxin_item( ... )
    local children = self.children
    children[11].view:setIsVisible(false)
    children[16].view:setIsVisible(false)
    --self.dazi.view:setIsVisible(false)
    -- for i=1,3 do
    --   self.shuaxin_table[i].view:setIsVisible(false)
    -- end
end

function JiuGongLeftWin:find_random( )
    local  no_chou_item = JiuGongModel:get_no_chou_item( )
    local r = math.random(1,#no_chou_item)
    return no_chou_item[r]
end





