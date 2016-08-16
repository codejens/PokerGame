-- SlotItem.lua
-- created by aXing on 2012-12-10
-- 继承自SlotMove
-- 用于放道具和装备的格子类


super_class.SlotItem(SlotMove)

-- 定义宝石等级图片显示资源路径
local GEM_PIC_PATH = {
	"ui/fonteffect/gem01.png",
	"ui/fonteffect/gem02.png",
	"ui/fonteffect/gem03.png",
	"ui/fonteffect/gem04.png",
	"ui/fonteffect/gem05.png",
	"ui/fonteffect/gem06.png",
	"ui/fonteffect/gem07.png",
	"ui/fonteffect/gem08.png",
	"ui/fonteffect/gem09.png",
	"ui/fonteffect/gem10.png",
}

local OriginalSize = 67

local _Width  = 75
local _Height = 75

local ACTIVITY_EFFECT_ID = 11007

--隐藏边框
function SlotItem:set_visible_frame(flags)
	self.visible = flags
	self.bg_frame:setIsVisible(flags)
end

function SlotItem:__init(width, height)
	-- self.scale = width / OriginalSize
 	-- self.icon:setScale(self.scale)
    
	self.lock_icon = nil
	self.if_lock = false
	self.visible = true
	self.show_time = false
	-- self.enable_drag = true
	-- self.if_not_through  = true        -- slot是否不可穿透

	self.select_effect_state = false	-- 默认不播放选中特效

	self.bg_frame = CCBasePanel:panelWithFile(0, 0, _Width, _Height, "")
	self.bg_frame:setAnchorPoint(0.5,0.5)
	self.bg_frame:setPosition(_Width/2,_Height/2)
	self.view:addChild(self.bg_frame,8)
end

--设置是否显示限时角标
function SlotItem:set_is_show_time(bool)
	self.show_time = bool
end

-- 设置道具图标
function SlotItem:set_icon(item_id)
	local texture = ItemConfig:get_item_icon(item_id)
	self:set_icon_texture(texture)
	self.item_id = item_id
	if self.show_time then
		local item_base = ItemConfig:get_item_by_id(item_id)
		if item_base and item_base.type == ItemConfig.ITEM_TYPE_FASHION_DRESS then
			local item_time = item_base.time
			local width = self.width
			if width < _Width then
				width = self.width/(self.width/_Width) + 1
			end
			MUtils:create_slot_day_time(self, item_time, width)
		end
	end
end

-- 设置非道具图标(例如经验，铜钱等) 1 = 铜钱， 4 = 经验
function SlotItem:set_special_icon(ttype)
	local texture = nil
	local size = self.bg_frame:getContentSize()
	if ttype == 1 then
		texture = SImage:create("icon/money/0.pd")
		texture.view:setAnchorPoint(0.5, 0.5)
		texture.view:setPosition(size.width / 2 , size.height / 2)
		self.view:addChild(texture.view, 5)
	elseif ttype == 4 then
		texture = SImage:create("icon/money/4.pd")
		texture.view:setAnchorPoint(0.5, 0.5)
		texture.view:setScale(0.85)
		texture.view:setPosition(size.width / 2 , size.height / 2)
		self.view:addChild(texture.view, 5)
	end

	self.color_frame = CCZXImage:imageWithFile(0, 0, -1, -1, "sui/other/f0.png")
	self.color_frame:setAnchorPoint(0.5,0.5)
	self.color_frame:setPosition(_Width/2,_Height/2)
    self.view:addChild(self.color_frame, 9)
	
	self.color_bg = CCZXImage:imageWithFile(0, 0, -1, -1, "sui/other/0.png")
	self.color_bg:setAnchorPoint(0.5,0.5)
	self.color_bg:setPosition(_Width/2,_Height/2)
    self.view:addChild(self.color_bg, 1)
end

function SlotItem:set_icon_ex(item_id)
	if item_id ~= nil then
		local texture = ItemConfig:get_item_icon(item_id)
		self:set_icon_texture(texture)
		self.item_id = item_id
	else
		self:set_icon_texture("")
		self.item_id = nil
	end
end

-- 此函数增加给坐骑化形图标设置使用
function SlotItem:set_icon_ex2(texture_path)
	if texture_path ~= nil then
		-- local texture = ItemConfig:get_item_icon(item_id)
		self:set_icon_texture(texture_path)
		-- self.item_id = item_id
	else
		self:set_icon_texture("")
		-- self.item_id = nil
	end
end

-- 设置货币类型图标 
function SlotItem:set_money_icon(money_type)
	-- local _money_image_path = {
	-- 					  -- [0] = "icon/money/0.png", 
	--        --                [1] = "icon/money/1.png", 
	--        --                [2] = "icon/money/2.png", 
	--        --                [3] = "icon/money/3.png",
	--        						  [0] = "icon/money/0.pd", 
	--                       [1] = "icon/money/1.pd", 
	--                       [2] = "icon/money/2.pd", 
	--                       [3] = "icon/money/3.pd", }
	require "../data/money_conf"
	if money_config[ money_type ] then
        self:set_icon_texture(money_config[money_type].icon)
        self:set_quality_color(money_config[money_type].quality)
	end
end

-- 设置道具数量
function SlotItem:set_item_count(count)
	self:set_count(count)
end

function SlotItem:set_Scale(Scale)
	self:set_setScale(Scale)
end

-- 设置锁的标识
function SlotItem:set_lock(if_lock)
	-- 屏蔽绑定标志 --
	if_lock = false
	------------------
	self.if_lock = if_lock
	if if_lock then
		if self.lock_icon == nil then
			-- 0,0 ->2,2
            self.lock_icon = CCZXImage:imageWithFile(2, 6, -1, -1, "sui/other/tianzhu_suo.png")
            self.view:addChild(self.lock_icon, 99)
		end
	else
        self.view:removeChild(self.lock_icon, true)
        self.lock_icon = nil
	end
end

-- 设置格子的右上角数字(装备强化等级，有加号)
function SlotItem:set_strong_level(strong_level)
	self.strong_level 	= strong_level
	self:create_label_right_up()
	-- self._label_right_up:setText("+"..string.format("%d", strong_level))
	self._label_right_up:set_number(string.format("+%d", strong_level), FLOW_COLOR_TYPE_YELLOW_ENHANCE)

	-- 如果数量是0或者1的话，则隐藏数字控件
	if strong_level == 0 then
		self._label_right_up.view:setIsVisible(false)
	else
		self._label_right_up.view:setIsVisible(true)
	end
end

-- 创建格子右上角label
function SlotItem:create_label_right_up()
	if self._label_right_up ~= nil then
		return
	end
	-- self._label_right_up = CCZXLabel:labelWithText(self.width-5, self.height - 18, "", 12 ,ALIGN_RIGHT)
	self._label_right_up = ImageNumber:create(0,nil,12)
	self._label_right_up.view:setScale(0.8)
	self._label_right_up.view:setAnchorPoint(CCPointMake(1, 0))
	self._label_right_up.view:setPosition(CCPointMake(self.width - 7, self.height - 7))
	self.view:addChild(self._label_right_up.view, 99)
end

-- 设置格子的左上角数字(宝石等级)
function SlotItem:set_gem_level(item_id)
	self:create_label_left_up()
	if item_id == nil or item_id == 0 then
        self._label_left_up:setIsVisible(false)
        return 
	end
    
    local item_base = ItemConfig:get_item_by_id(item_id)
    -- ----print("SlotItem:set_gem_level(item_id,item_base.type,item_base.suitId,item_base.name)",item_id,item_base.type,item_base.suitId,item_base.name)
    if item_base == nil or item_base.type ~= ItemConfig.ITEM_TYPE_GEM then
        self._label_left_up:setIsVisible(false)
        return
    end

	self.gem_level = item_base.suitId
	local pic_path = GEM_PIC_PATH[self.gem_level]
	if pic_path ~= nil then
		self._label_left_up:replaceTexture(pic_path)
    	self._label_left_up:setIsVisible(true)
    end
end

-- 创建格子左上角label
function SlotItem:create_label_left_up()
	if self._label_left_up ~= nil then
		return
	end
	self._label_left_up = CCSprite:spriteWithFile(GEM_PIC_PATH[1])
	self._label_left_up:setAnchorPoint(CCPointMake(0, 1))
	local size = self.view:getSize()
	self._label_left_up:setPosition(CCPointMake(15, size.height-15))
	self.view:addChild(self._label_left_up, 99)
end

-- 设置是否需要选中特效
function SlotItem:set_select_effect_state(is_open)
	self.select_effect_state = is_open
	if is_open == false then
		SlotEffectManager.delect_effect_by_slot_item(self)
	end
end

-- 更新功能
function SlotItem:update(item_id ,count,fun,x,y,width,height)
	local old_item_id = self.item_id
	-- -- 清除图片
	-- self:set_icon_texture("")
	-- 更新品质框
	self:set_item_count(count)
	self:set_icon_texture("")
	self:set_icon(item_id)
	-- 更新精华级别
	self:set_gem_level(item_id)

    if (self.count > 0) then
        self:set_icon_light_color()
		self:set_color_frame(item_id,x,y,width,height)
    else
        self:set_icon_dead_color()
    end
   local function f1(...)
   		local a, b, args = ...
   	    local click_pos = Utils:Split(args, ":")
        local world_pos = self.view:getParent():convertToWorldSpace(CCPointMake(tonumber(click_pos[1]),tonumber(click_pos[2])))
        if (item_id) then 
            TipsModel:show_shop_tip(world_pos.x, world_pos.y, item_id)
            if (fun) then
            	fun()
            end
        end
    end
    self:set_click_event(f1)
end

--播放技能cd动画
function SlotItem:play_cd_animation(cooltime, cd_percent ,cd_img)
	if not cd_img then
		cd_img = "nopack/item_cd.png"
	end
    local percentage = 99*(cd_percent or 1)
    if not self.progressTimer then
		self.progressTimer = CCProgressTimer:progressWithFile(cd_img)
		self.view:addChild(self.progressTimer, 999)
	    self.progressTimer:setType(kCCProgressTimerTypeRadialCCW)
	    local size = self.view:getSize()
	    self.progressTimer:setPosition(CCPointMake(size.width/2, size.height/2))
    end
    self.progressTimer:setPercentage(percentage)
    local progressTo_action = CCProgressTo:actionWithDuration(cooltime, 0)
    local hide  = CCHide:action()
    local array = CCArray:array()
	array:addObject(progressTo_action)
	array:addObject(hide)
	local seq = CCSequence:actionsWithArray(array)
	self.progressTimer:setIsVisible(true)
	self.progressTimer:stopAllActions()
    self.progressTimer:runAction(seq)
end

--停止播放cd动画
function SlotItem:stop_cd_animation()
    if self.progressTimer_callback then
        self.progressTimer_callback:cancel()
        self.progressTimer_callback = nil
    end
    if self.progressTimer then
        self.progressTimer:stopAllActions()
        self.progressTimer:removeFromParentAndCleanup(true)
        self.progressTimer = nil
    end
end

function SlotItem:setTouchBeginFunction(fun)
	self.touch_begin_function = fun
end

-- 设置物品的品质和品阶
function SlotItem:set_item_quality(quality,pj)
	if (self.quality) then
		if (self.pj and self.pj== 2) then
			-- 如果物品是完美品质
			if (self.quality == 4) then
				LuaEffectManager:stop_view_effect(91,self.view)
			elseif (self.quality == 5) then
				LuaEffectManager:stop_view_effect(81,self.view)
			end
			-- 去掉黄色框
			LuaEffectManager:stop_view_effect(92,self.view)
		else
			-- 如果物品是完美品质
			if (self.quality == 4) then
				LuaEffectManager:stop_view_effect(58,self.view)
			elseif (self.quality == 5) then
				LuaEffectManager:stop_view_effect(90,self.view)
			end
			if (self.pj and self.pj == 1) then
				-- 去掉紫色框
				LuaEffectManager:stop_view_effect(57,self.view)
			end
		end
	end
	self.quality = quality
	self.pj = pj

	if (self.pj and self.pj ==2) then
		-- 如果物品是完美品质
		if (self.quality == 4) then
			LuaEffectManager:play_view_effect(91,self.width/2,self.width/2,self.view,true,5)
		elseif (self.quality == 5) then
			LuaEffectManager:play_view_effect(81,self.width/2,self.width/2,self.view,true,5)
		end
		-- 黄色框
		LuaEffectManager:play_view_effect(92,self.width/2,self.width/2,self.view,true,5)
	else
		if (self.quality) then
			-- 增加品质特效
			-- 如果物品是完美品质
			if (self.quality == 4) then
				LuaEffectManager:play_view_effect(58,self.width/2,self.width/2,self.view,true,5)
			elseif (self.quality == 5) then
				LuaEffectManager:play_view_effect(90,self.width/2,self.width/2,self.view,true,5)
			end
		end
		if (self.pj and self.pj == 1) then
			-- 去掉紫色框
			LuaEffectManager:play_view_effect(57,self.width/2,self.width/2,self.view,true,5)
		end
	end
end

function SlotItem:play_activity_effect(effect_id)
	if self.effect_id then
		self:remove_activity_effect()
		self.effect_id = nil
	end
	if effect_id == nil then
		self.effect_id = ACTIVITY_EFFECT_ID
	else
		self.effect_id = effect_id
	end
	return LuaEffectManager:play_view_effect(self.effect_id,0,0,self.view,true,5)
end

function SlotItem:remove_activity_effect()
	if self.effect_id then
		LuaEffectManager:stop_view_effect(self.effect_id,self.view)
	end
end

function SlotItem:recovery_frame()
	self.bg_frame:setIsVisible(self.visible)
end

function SlotItem:set_color_frame(item_id)
	SlotBase.set_color_frame(self, item_id)
	self:set_gem_level(item_id)
end