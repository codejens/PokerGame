-- SlotSkill.lua
-- created by aXing on 2012-12-10
-- 继承自SlotMove
-- 实现技能图标放置的格子

require "UI/component/SlotMove"
-- require "config/SkillConfig"
local SkillOriginalSize = 90
super_class.SlotSkill(SlotMove)
local _createScaleInOut = effectCreator.createScaleInOut

function SlotSkill:__init( width, height )
    local width = width or 100
    local height = height or 100

    -- 由于技能使用的技能图标是超出slot外的，以前的不可使用(统一更改会影响slotitem)
    -- 故添加此控件, 规格大小看资源处的多大
    self.skill_icon = CCBasePanel:panelWithFile( width*0.5, height*0.5, width, height, "")
    self.skill_icon:setAnchorPoint( 0.5, 0.5)
    self.view:addChild( self.skill_icon)
    -- 黑色透明遮罩层当然也跟着 skill_icon 变, 覆盖原来的 self.color_cover
    self.color_cover = CCBasePanel:panelWithFile( width*0.5, height*0.5, width, height, "")
    self.color_cover:setAnchorPoint( 0.5, 0.5)
    self.view:addChild( self.color_cover)

    self.scale = width / SkillOriginalSize

    -- cd 时间 add by chj @2014.11.20
    self._cd_time_remain = 0
    self._cd_timer = nil -- 定时器
    -- end

    self._size = { width, height }
    self.icon:setScale(self.scale)
    self.lock_icon = nil
    self.if_lock = false

    self.enable_drag = true;
    self.if_not_through  = true        -- slot是否不可穿透

    self.select_effect_state = false    -- 默认不播放选中特效

    local function on_drag_event(eventType,arg,msgid)
        if eventType == nil or arg == nil or msgid == nil then 
            return false;
        end
        -- ----print("SlotMove on_drag_event eventType",eventType)
        if eventType == TOUCH_BEGAN then
            if self.on_begin_event ~= nil then
                self.on_begin_event(self )
            end
            local act = _createScaleInOut(0.1,(width / SkillOriginalSize)*1.1,
                                          0.2,(width / SkillOriginalSize)*1.0)
            self.icon:runAction(act)
            return self.if_not_through
        elseif eventType == DRAG_BEGIN then
            --开始拖拽
            if self.obj_data ~= nil and self.enable_drag then
                local temparg = Utils:Split(arg,":")
                local x = temparg[1]    --列数
                local y = temparg[2]    --行数
                
                NotificationCenter:registDragObject(self,tonumber(x),tonumber(y));

                if self.begin_drag_event then
                    -- 增加一个开始拖拽的事件
                    self.begin_drag_event(self);
                end
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
-- x, y 位左右的偏移像素
function SlotSkill:set_icon( icon_id, x, y, width, height, scale)
    self._icon_id = icon_id
    if icon_id == nil then
        -- self:set_icon_texture("");
        self.skill_icon:setTexture( "")
    else
        local texture = SkillConfig:get_skill_icon(icon_id)
        -- self:set_icon_texture(texture)
        self.skill_icon:setTexture( texture)
        if x or y then
            local posX = self._size[1] * 0.5+2
            local posY = self._size[2] * 0.5-2
            if x then
                posX = posX + x
            end
            if y then
                posY = posY + y
            end
            self.skill_icon:setPosition( posX, posY)
            self.color_cover:setPosition( posX, posY) -- 保持位置一致
        end
        if width and height then
            self.skill_icon:setSize(width, height)
            self.color_cover:setSize(width, height)
        end
        if scale then
            self.skill_icon:setScale(scale)
            self.color_cover:setScale(scale)
        end
    end
    
end

-- 获取icon_id
function SlotSkill:get_icon_id( )
    return self._icon_id
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
    -- require "config/SkillConfig"
    local skill_base = SkillConfig:get_skill_by_id( skill_id )
    if skill_base == nil then
        self._label_left_up:setIsVisible(false)
        return 
    end
    if skill_base.skillType == 1 then
        self._label_left_up:setText(string.format("%s", LangGameString[854])) -- [854]="被动"
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
    -- add after tjxs
    if not self.progressTimer then
        self._cd_time_remain = cooltime
    end
    self:stop_cd_animation()
    -- add after tjxs
    local hf = self._size[1]/2
    local progressTo_action  = CCProgressTo:actionWithDuration(self._cd_time_remain, 0);
    -- local progressTo_action  = CCProgressTo:actionWithDuration(5, 0);
    self.progressTimer = CCProgressTimer:progressWithFile("nopack/skill_cd.png");
    local sprite = CCSprite:spriteWithFile(string.format("icon/skill/%05d.pd", self._icon_id))
    sprite:setColor( ccc3(1,1,1))
    sprite:setOpacity(192)
    self.progressTimer:setSprite(sprite)
    self.progressTimer:setPercentage(percentage);
    self.progressTimer:setType( kCCProgressTimerTypeRadialCCW );
    self.view:addChild(self.progressTimer,5);
    self.progressTimer:setPosition(CCPointMake(hf+1, hf-1));
    self.progressTimer:runAction( progressTo_action );

    -- cd 定时开始
    self.progressTimer_callback = callback:new()
    local function dismiss( dt )
        if ( self.progressTimer ) then 
            self.progressTimer:removeFromParentAndCleanup(true);
            self.progressTimer = nil
            -- 重置技能cd为0
            UserSkillModel:set_skill_cd_zero( skill_id );
            -- ----print("-1---------SlotSkill,技能需要优化:",skill_id, self)
            -- self:stop_cd_animation()
            -- local win = UIManager:find_visible_window("menus_panel")
            -- ----print("---win", win)
            -- if win then
            --     ----print("---win:clear_skill_cd")
            --     win:clear_skill_cd( skill_id )
            -- end
            self.progressTimer_callback = nil;

            -- 去除cd时间计时器
            if self._cd_timer then
                self._cd_timer:stop()
                self._cd_timer = nil
                self._cd_time_remain = 0
            end
        end
    end
    self.progressTimer_callback:start(self._cd_time_remain,dismiss)

    -- cd 统计时间
    local function cd_time_order_func( dt )
        self._cd_time_remain = self._cd_time_remain-dt
    end
    self._cd_timer = timer()
    self._cd_timer:start(1, cd_time_order_func)
end

-- 停止播放技能cd动画
function SlotSkill:stop_cd_animation( )
    if ( self.progressTimer ) then
        self.progressTimer:stopAllActions();
        self.progressTimer:removeFromParentAndCleanup(true);
        self.progressTimer = nil;
    else 

    end
    if ( self.progressTimer_callback ) then
        self.progressTimer_callback:cancel();
        self.progressTimer_callback = nil;
    end
    if self._cd_timer then
        self._cd_timer:stop()
        self._cd_timer = nil
    end
end

-- 设置是否需要选中特效
function SlotSkill:set_select_effect_state( is_open )
    self.select_effect_state = is_open;
end

-- 获取slotskill cd剩余时间 add by chj @2014.11.20
function SlotSkill:get_cd_remain_time( )
    return self._cd_time_remain
end

function SlotSkill:is_cd()
    if self.progressTimer then
        return true
    else
        return false
    end
end

-- 设置icon 变暗色（self.color_cover是skillitem自定义的，覆盖）
function SlotSkill:set_icon_dead_color( )
    self.color_cover:setTexture( string.format("icon/skill/%05d.pd", self._icon_id))
    self.color_cover:setColor( 0xc0010101)
    self.color_cover:setIsVisible( true)
end

function SlotSkill:set_lock_icon(icon_id, x, y, width, height, scale)
    local texture = string.format("icon/skill_lock/%05d_lock.pd", icon_id)
    self.skill_icon:setTexture( texture)
    if x or y then
        local posX = self._size[1] * 0.5+2
        local posY = self._size[2] * 0.5-2
        if x then
            posX = posX + x
        end
        if y then
            posY = posY + y
        end
        self.skill_icon:setPosition( posX, posY)
        self.color_cover:setPosition( posX, posY) -- 保持位置一致
        if width and height then
            self.skill_icon:setSize(width, height)
            self.color_cover:setSize(width, height)
        end
        if scale then
            self.skill_icon:setScale(scale)
            self.color_cover:setScale(scale)
        end
    end
end