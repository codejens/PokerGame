-- TransformWin.lua
-- created by aXing on 2014-5-4
-- 变身系统

-- 其实这里不需要 require window 的
super_class.TransformWin(Window)

local _index_to_category_name = { [1] = "picture", [2] = "skill", }

-- 先写窗口的初始化方法
function TransformWin:__init( window_name, texture_name )
	-- 主要是创建控件
	local bg = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 800, 530)
    bg:setPosition(81, 20)
    self:addChild(bg)

	-- self:create_left_panel()
	-- self:create_right_panel()

	-- 这里还可以对一些窗口类的成员变量初始化

    -- 创建分页button
    self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 28, 175, 58, 360, "" )
    self:addChild(self.radio_btn_group)

    -- 普通类
    self.normal_level_button = CCRadioButton:radioButtonWithFile(0, 240, -1, -1, 
        UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.normal_level_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")
    local normal_text = CCZXImage:imageWithFile( 23, 16, -1, -1, UI_TransformWin_004 )
    self.normal_level_button:addChild(normal_text)
    self.radio_btn_group:addGroup(self.normal_level_button)
    local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( 1 )
            return true;
        elseif eventType == TOUCH_ENDED then
            
            return true;
        end
    end
    self.normal_level_button:registerScriptHandler(but_1_fun)
    -- 影级类
    self.high_level_button = CCRadioButton:radioButtonWithFile(0, 120, -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.high_level_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")
    local high_text = CCZXImage:imageWithFile( 23, 16, -1, -1, UI_TransformWin_005 )
    self.high_level_button:addChild(high_text)
    self.radio_btn_group:addGroup(self.high_level_button)
    local function but_2_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( 2 )
            return true;
        elseif eventType == TOUCH_ENDED then
            
            return true;
        end
    end
    self.high_level_button:registerScriptHandler(but_2_fun)

    -- 记录每个列表，控制显示与隐藏
    self.list_scroll_t = {}        

    -- 信息页
    self.TransformCardPage =TransformCardPage()
    bg:addChild( self.TransformCardPage.view )
    table.insert( self.list_scroll_t, self.TransformCardPage )

    -- 进阶页
    self.transformSkillPage =TransformSkillPage()
    bg:addChild( self.transformSkillPage.view )
    table.insert( self.list_scroll_t, self.transformSkillPage )

     -- 初始化进入进阶页面
    self:Choose_panel( "picture" )

end
--切页
function TransformWin:change_page( page_index )
    self:Choose_panel( _index_to_category_name[page_index] )
end

-- 选择显示的面板   equipment,  material 
function TransformWin:Choose_panel( panel_type )
    for key, scroll_view in pairs(self.list_scroll_t) do
        scroll_view.view:setIsVisible( false )
    end

    if panel_type == "picture" then
        self.TransformCardPage.view:setIsVisible( true )
        self.TransformCardPage:update()
    elseif panel_type == "skill" then
        self.transformSkillPage.view:setIsVisible( true )
        self.transformSkillPage:update()
    end

end

-- 创建左边面板
function TransformWin:create_left_panel(  )
	
	-- 创建分页button
	self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 32, 175, 58, 360, "" )
    self:addChild(self.radio_btn_group)

    -- 普通类
    self.normal_level_button = CCRadioButton:radioButtonWithFile(0, 240, -1, -1, 
    	UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.normal_level_button:addTexWithFile( CLICK_STATE_DOWN,
    	UIResourcePath.FileLocate.common .. "xxk-2.png")
    local normal_text = CCZXImage:imageWithFile( 23, 16, -1, -1, UIResourcePath.FileLocate.transform .. "4.png" )
    self.normal_level_button:addChild(normal_text)
    self.radio_btn_group:addGroup(self.normal_level_button)

    -- 影级类
    self.high_level_button = CCRadioButton:radioButtonWithFile(0, 120, -1, -1, 
    	UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.high_level_button:addTexWithFile( CLICK_STATE_DOWN,
    	UIResourcePath.FileLocate.common .. "xxk-2.png")
    local high_text = CCZXImage:imageWithFile( 23, 16, -1, -1, UIResourcePath.FileLocate.transform .. "6.png" )
    self.high_level_button:addChild(high_text)
    self.radio_btn_group:addGroup(self.high_level_button)

    -- 特殊类
    self.special_level_button = CCRadioButton:radioButtonWithFile(0, 0, -1, -1, 
    	UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.special_level_button:addTexWithFile( CLICK_STATE_DOWN,
    	UIResourcePath.FileLocate.common .. "xxk-2.png")
    local special_text = CCZXImage:imageWithFile( 23, 16, -1, -1, UIResourcePath.FileLocate.transform .. "8.png" )
    self.special_level_button:addChild(special_text)
    self.radio_btn_group:addGroup(self.special_level_button)

    local bg = ZBasePanel.new("", 380, 510) 
    -- local bg = CCZXImage:imageWithFile( 95, 30, 380, 510, "", 500, 500)
    bg:setPosition(95, 30)
    self:addChild(bg)

    -- 创建头像列表
    -- self:create_heads()

    -- 忍者图鉴状况
    local ds = ZImage.new(UIResourcePath.FileLocate.common .. "wzd-1.png") -- CCZXImage:imageWithFile( 0, 5, -1, -1, UIResourcePath.FileLocate.common .. "wzd-1.png")
    ds:setPosition(0, 5)
    bg:addChild(ds)

    local title = ZImage.new(UIResourcePath.FileLocate.transform .. "23.png") -- CCZXImage:imageWithFile( 20, 5, -1, -1, UIResourcePath.FileLocate.transform .. "23.png")
    title:setPosition(20, 5)
    bg:addChild(title)

    -- 总战力
    self.total_fight_point = ZLabel.new("总战斗力：XXXXXXXX") -- ZLabel()
    self.total_fight_point:setPosition(150, 10)
    bg:addChild(self.total_fight_point.view)
end

-- 创建忍者头像列表
function TransformWin:create_heads(  )
	-- 创建12个忍者头像
    local start_x = 17
    local start_y = 220
    local width   = 120
    local height  = 120
    local gap   = 9
    local now_x = start_x
    local now_y = start_y

    local pos_x
	for j = 1, 4 do
		for i = 1, 3 do
			local ninja = NinjaHead(width, height)
            ninja:move( now_x, now_y )
            self:addChild(ninja)
            now_x = now_x + slot_width + gap
		end
        now_x = start_x
        now_y = now_y - slot_height - gap
	end

end

-- 创建右边面板
function TransformWin:create_right_panel(  )

    -- 人物简介面板
    self:create_desription_panel()

    -- 人物模型面板
    self:create_model_panel()

    -- 人物属性
    self:create_attr_panel()

    -- 三个按钮
    -- 进阶
    local btn_stage = ZTextButton.create_style_1( "进阶" )
    btn_stage:setPosition(500, 30)
    btn_stage:setTouchClickFun(self.stage_btn_event)
    self:addChild(btn_stage)

    -- 培养
    local btn_develop = ZTextButton.create_style_1( "培养" )
    btn_develop:setPosition(630, 30)
    btn_develop:setTouchClickFun(self.develop_btn_event)
    self:addChild(btn_develop)

    -- 仙化
    local btn_change = ZTextButton.create_style_1( "仙化" )
    btn_change:setPosition(760, 30)
    btn_change:setTouchClickFun(self.change_btn_event)
    self:addChild(btn_change)
end

-- 创建人物简介面板
function TransformWin:create_desription_panel(  )
    -- TODO:: 这里理论上应该是一个 XPanel(带背景的容器)
    -- 人物简介
    local bg1 = ZBasePanel.new("", 390, 120) 
    -- local bg1 = CCZXImage:imageWithFile( 480, 420, 390, 120, "", 500, 500)
    bg1:setPosition(480, 420)
    self:addChild(bg1)

    local title_bg = ZImage.new(UIResourcePath.FileLocate.common .. "wzd-1.png") -- CCZXImage:imageWithFile( 0, 90, -1, -1, UIResourcePath.FileLocate.common .. "wzd-1.png")
    title_bg:setPosition(0, 90)
    bg1:addChild(title_bg)

    local title = ZImage.new(UIResourcePath.FileLocate.transform .. "2.png") -- CCZXImage:imageWithFile( 25, 93, -1, -1, UIResourcePath.FileLocate.transform .. "2.png")
    title:setPosition(25, 93)
    bg1:addChild(title)
end

-- 创建人物模型面板
function TransformWin:create_model_panel(  )
    local bg = ZBasePanel.new("", 390, 225) 
    -- local bg = CCZXImage:imageWithFile( 480, 190, 390, 225, "", 500, 500)
    bg:setPosition(480, 190)
    self:addChild(bg)

    self.ninja_type = ZLabel.new("精英上忍")                      -- 考虑这里初始化参数是 "精英上忍"
    self.ninja_type:setPosition(20, 190)
    bg:addChild(self.ninja_type)              -- 这里尽量不要添加view

    self.fight_point = ZLabel.new("战斗力：XXXXXXXX")
    self.fight_point:setPosition(240, 190)
    bg:addChild(self.fight_point)              -- 这里尽量不要添加view

    -- 创建人物模型
    local action = UI_TRANSFORM_ACTION;
    self.ninja_model = MUtils:create_animation(200, 40, "frame/human/0/01000", action)
    bg:addChild(self.ninja_model)

    -- 4个技能
    self.skill_slots = {}
    local slot_width  = 72
    local slot_height = 72

    local slot1 = ZSlotSkill(slot_width, slot_height)
    slot1:setPosition(20, 20)
    bg:addChild(slot1)
    self.skill_slots[1] = slot1

    local slot2 = ZSlotSkill(slot_width, slot_height)
    slot2:setPosition(300, 20)
    bg:addChild(slot2)
    self.skill_slots[2] = slot2

    local slot3 = ZSlotSkill(slot_width, slot_height)
    slot3:setPosition(20, 100)
    bg:addChild(slot3)
    self.skill_slots[3] = slot3

    local slot4 = ZSlotSkill(slot_width, slot_height)
    slot4:setPosition(300, 100)
    bg:addChild(slot4)
    self.skill_slots[4] = slot4

    -- 变身按钮
    local button = ZTextButton.create_style_1( "变身" )
    button:setPosition(150, 5)
    button:setTouchClickFun(self.transform_btn_event)
    bg:addChild(button)

end

-- 创建人物属性面板
function TransformWin:create_attr_panel(  )
    local bg = ZBasePanel.new("", 390, 100) 
    -- local bg = CCZXImage:imageWithFile( 480, 190, 390, 225, "", 500, 500)
    bg:setPosition(480, 85)
    self:addChild(bg)

    -- 攻击
    self.label_attack = ZLabel.new("攻  击：xxxx + xxxx")
    self.label_attack:setPosition(10, 70)
    bg:addChild(self.label_attack)

    -- 抗暴击
    self.label_def_critical = ZLabel.new("抗暴击：xxxx + xxxx")
    self.label_def_critical:setPosition(200, 70)
    bg:addChild(self.label_def_critical)

    -- 生命
    self.label_hp = ZLabel.new("生  命：xxxx + xxxx")
    self.label_hp:setPosition(10, 40)
    bg:addChild(self.label_hp)

    -- 命中
    self.label_hit = ZLabel.new("命  中：xxxx + xxxx")
    self.label_hit:setPosition(200, 40)
    bg:addChild(self.label_hit)

    -- 暴击
    self.label_critical = ZLabel.new("暴  击：xxxx + xxxx")
    self.label_critical:setPosition(10, 10)
    bg:addChild(self.label_critical)

    -- 忍防
    self.label_def = ZLabel.new("忍  防：xxxx + xxxx")
    self.label_def:setPosition(200, 10)
    bg:addChild(self.label_def)
end

function TransformWin:active( show )
    if show then
        self:update()
    end
    self.transformSkillPage:active(show)
end

-- 设置总战力
function TransformWin:set_total_fight_point( point )
    if self.total_fight_point ~= nil then
        self.total_fight_point:setText(point)
    end
end

-- 设置模型
function TransformWin:set_model( model_id )
    -- body
end

-- 设置四个技能
function TransformWin:set_skill_slot( index, skill_data )
    local slot = self.skill_slots[index]
    slot:update(skill_data)
end

-- 设置攻击力
function TransformWin:set_attack_label( base, added )
    local text = nil
    if added == nil then
        text = "攻  击：" .. base
    else
        text = "攻  击：" .. base .. " + " .. added
    end
    self.label_attack:setText(text)
end

-- 设置抗暴击
function TransformWin:set_def_critical_label( base, added )
    local text = nil
    if added == nil then
        text = "抗暴击：" .. base
    else
        text = "抗暴击：" .. base .. " + " .. added
    end
    self.label_def_critical:setText(text)
end

-- 设置生命
function TransformWin:set_hp_label( base, added )
    local text = nil
    if added == nil then
        text = "生  命：" .. base
    else
        text = "生  命：" .. base .. " + " .. added
    end
    self.label_hp:setText(text)
end

-- 设置命中
function TransformWin:set_hit_label( base, added )
    local text = nil
    if added == nil then
        text = "命  中：" .. base
    else
        text = "命  中：" .. base .. " + " .. added
    end
    self.label_hit:setText(text)
end

-- 设置暴击
function TransformWin:set_critical_label( base, added )
    local text = nil
    if added == nil then
        text = "暴  击：" .. base
    else
        text = "暴  击：" .. base .. " + " .. added
    end
    self.label_critical:setText(text)
end

-- 设置忍防
function TransformWin:set_def_label( base, added )
    local text = nil
    if added == nil then
        text = "忍  防：" .. base
    else
        text = "忍  防：" .. base .. " + " .. added
    end
    self.label_def:setText(text)
end

-- 变身按钮点击事件
function TransformWin:transform_btn_event(  )
    print("变身！")
end

-- 进阶按钮点击事件
function TransformWin:stage_btn_event(  )
    print("进阶！")
end

-- 培养按钮点击事件
function TransformWin:develop_btn_event(  )
    print("培养！")
end

-- 仙化按钮点击事件
function TransformWin:change_btn_event(  )
    print("仙化！")
end

function TransformWin:update(  )
    -- body
    self.TransformCardPage:update()
    self.transformSkillPage:update()
end



function TransformWin:update_point(  )
    self.TransformCardPage:update_point()
end