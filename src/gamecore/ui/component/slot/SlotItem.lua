-- SlotItem.lua
-- created by tjh on 2015-04-28
-- 继承自SlotMove
-- 用于放道具和装备的格子类

--!class SlotItem
SlotItem = simple_class(SlotMove)


local _COUNT_LAYER_NUM      = 20     -- 左下数字的层级
local _LOCK_ICION_LAYER_NUM = 20     -- 锁的显示层级

local _COUNT_LABEL_POS = { x = 55, y = 15 }    -- 左下数字的位置坐标
local _LOCK_ICON_POS   = { x = 15, y = 15 }    -- 锁的图标的位置坐标
-- local _COLOR_FRAME = { x = 5, y = 5 }       


function SlotItem:__init(  )
	self._lock_icon    = nil    -- 锁的图标。表示绑定
	self._if_lock      = false  -- 是否绑定
	self._color_frame  = nil    -- 颜色框。 代表品质 图
    self._count_label = nil    -- 右下角数字

	self.item_id = nil         -- 保存当前显示的itemid

	self.select_effect_state = false	-- 默认不播放选中特效

end

--- 创建完成，做些初始化工作
function SlotItem:viewCreateCompleted(  )
	SlotMove.viewCreateCompleted( self )
end




--- 使用item_id 来创建SlotItem . 
-- @param item_id 道具id
function SlotItem:create_by_item_id( item_id )
	local slot = self:create()
	-- 根据 item_id 设置显示
	if item_id then 
	    slot:set_icon_by_item_id( item_id )
	end
	-- lp todo
    return slot
end

-- 使用UserItem创建SlotItem
-- @param UserItem 数据
function SlotItem:create_by_item_data( userItem )
	local item_id = nil 
	if userItem then 
        item_id = userItem.item_id
	end
	local slot = self:create_by_item_id( item_id )
	-- 各数据显示
	if userItem then 
        slot:set_count( userItem.count )

        local if_lock = false    -- 是否邦定
        if userItem.flag == 1 then 
            if_lock = true
        end
        slot:set_lock( if_lock )
	end

    return slot
end

-- 把格子置空
function SlotItem:set_empty(  )
	SlotMove.set_empty( self )
	if self._count_label then 
	    self._count_label:setString( "" )
	end
	if self._lock_icon then 
        self._lock_icon:loadTexture( "" )
        self._lock_icon:setVisible(false)
	end
    
	-- note: 背景 是不会有这种置空需求的。 要隐藏直接把slot隐藏了。
end

function SlotItem:ended_event( pos )
	SlotMove.ended_event( self, pos )
	
    if ( self.select_effect_state ) then 
	   -- SlotEffectManager.play_effect_by_slot_item( self );
	end
end

-- 设置道具图标
function SlotItem:set_icon_by_item_id( item_id )
	self.item_id = item_id;
	if item_id == nil then 
        self:set_empty()
    else
        local texture = ItemConfig:get_item_icon(item_id)
	    self:set_icon_texture(texture)	
	end
end



-- 创建格子右下角label控件
function SlotItem:create_count_label(  )
	if self._count_label ~= nil then
		return
	end
	self._count_label = GUIText:create("",FONT_SIZE_MIN)
	self._count_label:setPosition( _COUNT_LABEL_POS.x , _COUNT_LABEL_POS.y )
	self:addChild( self._count_label, _COUNT_LAYER_NUM);
end

-- 设置格子的数量
function SlotItem:set_count( count )
	self.count 	= count
	self:create_count_label()
	self._count_label:setString(string.format("%d",count))

	-- 如果数量是0或者1的话，则隐藏数字控件
	if count == 0 or count == 1 then
		self._count_label:setVisible(false)
	else
		self._count_label:setVisible(true)
	end
end

-- 设置锁的标识
function SlotItem:set_lock( if_lock )
	if if_lock then
		-- 还没创建就要创建
		if self._lock_icon == nil then
	        self._lock_icon = GUIImg:create( PATH_ITEM_SLOT_LOCK )
	        self._lock_icon:setPosition( _LOCK_ICON_POS.x, _LOCK_ICON_POS.y )
	        self:addChild( self._lock_icon, _LOCK_ICION_LAYER_NUM )
		end
		self._lock_icon:setVisible( true )
	elseif self._lock_icon then 
        self._lock_icon:setVisible( false )
	end
end

-- 设置icom边框的颜色(例如武器分蓝，绿，紫三种颜色)  
function SlotItem:set_color_frame( item_id, po_x, po_y, width_para, height_para )
	-- lp todo
end
















-- 设置货币类型图标 
function SlotItem:set_money_icon( money_type )
	local _money_image_path = { [0] = "icon/money/0.pmt", 
	                      [1] = "icon/money/1.pmt", 
	                      [2] = "icon/money/2.pmt", 
	                      [3] = "icon/money_type/3.pmt", }
	if _money_image_path[ money_type ] then
        self:set_icon_texture( _money_image_path[ money_type ] )
	end
end

-- 设置格子的右上角数字(装备强化等级，有加号)
function SlotItem:set_strong_level( strong_level )
	self.strong_level 	= strong_level
	self:create_label_right_up()
	self._label_right_up:setText("+"..string.format("%d", strong_level))

	-- 如果数量是0或者1的话，则隐藏数字控件
	if strong_level == 0 then
		self._label_right_up:setIsVisible(false)
	else
		self._label_right_up:setIsVisible(true)
	end
end

-- 创建格子右上角label
function SlotItem:create_label_right_up(  )
	if self._label_right_up ~= nil then
		return
	end
	self._label_right_up = CCZXLabel:labelWithText( self.width-5, self.height - 18, "", 12 ,ALIGN_RIGHT );
	--self._label_right_up:setAnchorPoint(CCPoint(1.0,0.0))
	--self._label_right_up:setPosition(self.width, self.height - 18)--CCPoint(self.width - 15, self.height - 18))
	self.view:addChild(self._label_right_up,99);
end

-- 设置格子的左上角数字(宝石等级)
function SlotItem:set_gem_level( item_id )
	self:create_label_left_up()
	if item_id == nil or item_id == 0 then
        self._label_left_up:setIsVisible(false)
        return 
	end
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil or item_base.type ~= 85 then
        self._label_left_up:setIsVisible(false)
        return 
    end

	self.gem_level 	= item_base.suitId
	local level_t = {"一", "二", "三", "四", "五", "六", "七", "八", "九", "十",}
	self._label_left_up:setText(string.format("%s", level_t[self.gem_level]))
    self._label_left_up:setIsVisible(true)
end

-- 创建格子左上角label
function SlotItem:create_label_left_up(  )
	if self._label_left_up ~= nil then
		return
	end
	self._label_left_up = CCZXLabel:labelWithText(5, self.height - 18, "", 12, ALIGN_LEFT);
	-- self._label_left_up:setAnchorPoint(CCPoint(1.0,0.0))
	--self._label_left_up:setPosition(CCPoint(10, self.height - 18))
	self.view:addChild(self._label_left_up,99);
end

-- 设置是否需要选中特效
function SlotItem:set_select_effect_state( is_open )
	self.select_effect_state = is_open;
end

-- 更新功能
function SlotItem:update( item_id ,count,fun)
	local old_item_id = self.item_id;
	-- -- 清除图片
	-- self:set_icon_texture("");
	-- 更新品质框
	self:set_item_count(count);
	self:set_icon_texture("");
	self:set_icon( item_id );
    if ( self.count > 0 ) then
        self:set_icon_light_color(  );
		self:set_color_frame( item_id );
    else
        self:set_icon_dead_color();
    end
   local function f1( args)
   	    local click_pos = Utils:Split(args, ":")
        local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
        if ( item_id ) then 
            TipsModel:show_shop_tip( world_pos.x, world_pos.y, item_id );
            if ( fun ) then
            	fun();
            end
        end
    end
    self:set_click_event( f1 )
	
end

-- 播放技能cd动画
function SlotItem:play_cd_animation( cooltime, cd_percent ,cd_img)
	-- self:stop_cd_animation(  )
	if ( cd_img == nil ) then
		cd_img = "nopack/item_cd.png"
	end

    local percentage = 99 * ( cd_percent or 1 )

    
   
    if not self.progressTimer then
    	 self.progressTimer = CCProgressTimer:progressWithFile(cd_img);
    	 self.view:addChild(self.progressTimer,5);
    end

    local progressTo_action  = CCProgressTo:actionWithDuration(cooltime, 0);
    self.progressTimer:setPercentage(percentage);
    self.progressTimer:setType( kCCProgressTimerTypeRadialCCW );
    self.progressTimer:setPosition(CCPointMake(self.width / 2, self.height / 2));

    local hide = CCHide:action()
    local array = CCArray:array();

	array:addObject(progressTo_action);
	array:addObject(hide);
	local seq = CCSequence:actionsWithArray(array);
	self.progressTimer:setIsVisible(true)
	self.progressTimer:stopAllActions()
    self.progressTimer:runAction( seq );
end

-- 停止播放cd动画
function SlotItem:stop_cd_animation(  )
    if ( self.progressTimer_callback ) then
        self.progressTimer_callback:cancel();
        self.progressTimer_callback = nil;
    end
    if ( self.progressTimer ) then
        self.progressTimer:stopAllActions();
        self.progressTimer:removeFromParentAndCleanup(true);
        self.progressTimer = nil;
    end
    
end

function SlotItem:setTouchBeginFunction(fun)
	self.touch_begin_function = fun
end

-- 设置物品的品质和品阶
function SlotItem:set_item_quality( quality,pj,Distinguish )
	-- lp todo
end
