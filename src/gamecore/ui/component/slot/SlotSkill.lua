-- SlotSkill.lua
-- created by aXing on 2012-12-10
-- 继承自SlotMove
-- 实现技能图标放置的格子

require "UI/component/SlotMove"
require "config/SkillConfig"
super_class.SlotSkill(SlotMove)

function SlotSkill:__init( width, height )
    self.lock_icon = nil
    self.if_lock = false

    self.enable_drag = true;
    self.if_not_through  = true        -- slot是否不可穿透

    self.select_effect_state = false    -- 默认不播放选中特效

    local function on_drag_event(eventType,arg,msgid)
        if eventType == nil or arg == nil or msgid == nil then 
            return false;
        end
        -- print("SlotMove on_drag_event eventType",eventType)
        if eventType == TOUCH_BEGAN then
            if self.on_begin_event ~= nil then
                self.on_begin_event(self )
            end
            return self.if_not_through
        elseif eventType == DRAG_BEGIN then
            --开始拖拽
            if self.obj_data ~= nil and self.enable_drag then
                local temparg = Utils:Split(arg,":")
                local x = temparg[1]    --列数
                local y = temparg[2]    --行数
                
                NotificationCenter:registDragObject(self,tonumber(x),tonumber(y));
            end
            return true;
        elseif eventType == DRAG_OUT then               
            if self.on_drag_out ~= nil and self.enable_drag then
                self.on_drag_out(self);
            end
            return self.if_not_through

        elseif eventType == TOUCH_ENDED then
            if self.on_drag_in ~= nil then
                local dragObj = NotificationCenter:checkRegistDragObject();
                if dragObj ~= nil and dragObj ~= self then
                    NotificationCenter:click_slotItem(self.win);
                    self.on_drag_in(dragObj);
                end
            end
            return self.if_not_through;
        elseif eventType == TOUCH_MOVED then            
            return self.if_not_through;
        elseif eventType == TOUCH_CLICK then
            if self.on_click_event ~= nil then
                self.on_click_event(self,eventType, arg, msgid)
                print("SlotSkill:59: self.select_effect_state = ",self.select_effect_state);
                if ( self.select_effect_state ) then 
                    SlotEffectManager.play_effect_by_slot_item( self );
                end
            end
            return self.if_not_through
        elseif eventType == TOUCH_DOUBLE_CLICK then
            if self.on_double_click_event ~= nil then
                self.on_double_click_event(self)
            end
            return self.if_not_through
        elseif eventType == ITEM_DELETE then           
            if self.on_delete_view_event ~= nil then
                self.on_delete_view_event(self)
            end
        end
    end
    
    self.view:registerScriptHandler(on_drag_event);
end

-- 设置人物技能图标
function SlotSkill:set_icon( icon_id )
    if ( icon_id == nil  ) then
        self:set_icon_texture("");
    else
        local texture = SkillConfig:get_skill_icon(icon_id)
        self:set_icon_texture(texture)
    end
    
end
-- 设置宠物技能图标
function SlotSkill:set_pet_skill_icon( skill_id,skill_lv ) 
    if ( skill_id == nil or skill_lv == nil ) then
        self:set_icon_texture("");
    else
        local texture = SkillConfig:get_skill_icon_path( skill_id,skill_lv)
        self:set_icon_texture(texture)
    end
end

-- 设计技能等级
function SlotSkill:set_skill_level( level )
	self:set_count(level)
end


-- 设置格子的左上角 是否被动
function SlotSkill:set_skill_passive( skill_id )
	self:create_label_left_up()
	if skill_id == nil or skill_id == 0 then
        self._label_left_up:setIsVisible(false)
        return 
	end
    require "config/SkillConfig"
    local skill_base = SkillConfig:get_skill_by_id( skill_id )
    if skill_base == nil then
        self._label_left_up:setIsVisible(false)
        return 
    end
    if skill_base.skillType == 1 then
        self._label_left_up:setText(string.format("%s", "被动"))
        self._label_left_up:setIsVisible(true)
    else
    	self._label_left_up:setIsVisible(false)
    end
end

-- 创建格子左上角label
function SlotSkill:create_label_left_up(  )
	if self._label_left_up ~= nil then
		return
	end
	self._label_left_up = CCZXLabel:labelWithTextS(CCPointMake(0,0),"",12,ALIGN_CENTER);
	self._label_left_up:setAnchorPoint(CCPoint(1.0,0.0))
	self._label_left_up:setPosition(CCPoint(10, self.height - 18))
	self.view:addChild(self._label_left_up,99);
end

-- 播放技能cd动画
function SlotSkill:play_skill_cd_animation( cooltime ,skill_id,percentage )
    local progressTo_action  = CCProgressTo:actionWithDuration(cooltime, 0);
    self.progressTimer = CCProgressTimer:progressWithFile("nopack/skill_cd.png");
    self.progressTimer:setPercentage(percentage);
    self.progressTimer:setScaleX(53/60);
    self.progressTimer:setScaleY(53/60);
    self.progressTimer:setType( kCCProgressTimerTypeRadialCCW );
    self.view:addChild(self.progressTimer,5);
    self.progressTimer:setPosition(CCPointMake(22, 22));
    self.progressTimer:runAction( progressTo_action );

    self.progressTimer_callback = callback:new()

    local function dismiss( dt )
        if ( self.progressTimer ) then 
            self.progressTimer:removeFromParentAndCleanup(true);
            self.progressTimer = nil;
            -- 重置技能cd为0
            UserSkillModel:set_skill_cd_zero( skill_id );
            self.progressTimer_callback = nil;
        end
    end

    self.progressTimer_callback:start(cooltime,dismiss)
end

-- 停止播放技能cd动画
function SlotSkill:stop_cd_animation(  )
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

-- 设置是否需要选中特效
function SlotSkill:set_select_effect_state( is_open )
    self.select_effect_state = is_open;
end