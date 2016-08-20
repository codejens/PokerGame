-- TransformBtnPage.lua 
-- createed by yongrui.liang on 2014-7-22
-- 变身按钮页

super_class.TransformBtnPage(  )

function TransformBtnPage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

    local up_panel = ZBasePanel.new("", 320, 345).view
    up_panel:setPosition(10, 210)
    panel:addChild(up_panel)
    self.up_panel = up_panel

    local dwn_panel = ZBasePanel.new("", 320, 195).view
    dwn_panel:setPosition(10, 10)
    panel:addChild(dwn_panel)

    self:create_up_panel(up_panel)
    self:create_dwn_panel(dwn_panel)
end

function TransformBtnPage:create_up_panel( parent )
    local size = parent:getSize()
    local model_bg = ZImage.new("ui/transform/new18.png").view
    model_bg:setAnchorPoint(0.5, 0.5)
    model_bg:setPosition(size.width/2, size.height/2)
    parent:addChild(model_bg)

    local fight_bg = ZImage.new("ui/transform/new17.png").view
    fight_bg:setAnchorPoint(0, 1.0)
    fight_bg:setPosition(5, size.height-5)
    parent:addChild(fight_bg)

    -- self.max_fight = ZLabel.new("00000")
    -- self.max_fight:setFontSize(20)
    -- self.max_fight:setPosition(110, size.height-52)
    -- self.max_fight.view:setAnchorPoint(CCPointMake(1.0, 0))
    -- parent:addChild(self.max_fight.view)

    self.fight_val = ZXLabelAtlas:createWithString("99999", "ui/normal/number")
    self.fight_val:setPosition(CCPointMake(130, size.height-55))
    self.fight_val:setAnchorPoint(CCPointMake(1.0, 0))
    parent:addChild(self.fight_val)
end

function TransformBtnPage:create_dwn_panel( parent )
    local size = parent:getSize()
--xiehande 通用按钮  btn_hong.png ->button3
    self.trans_btn = ZTextButton.new("ui/common/button3.png", nil, nil, "变  身")
    self.trans_btn.view:setAnchorPoint(0.5, 0.5)
    self.trans_btn.view:setPosition(size.width/2, 40-4)
    parent:addChild(self.trans_btn.view)

    local trans_func = function( )
        Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
        local cur_trans_id = TransformModel:get_cur_transform_id()
        local cur_select_id = TransformModel:get_current_selected_ninja( )
        if cur_select_id == cur_trans_id then
            --还原变身
            TransformModel:request_recover_transform()
        else
            --请求变身
            TransformModel:request_transform(cur_select_id)
        end
    end
    self.trans_btn:setTouchClickFun(trans_func)

    local name_bg = ZImage:create(parent, "ui/transform/new24.png", size.width/2, 174, -1, -1, 0, 500, 500)
    name_bg.view:setAnchorPoint(0.5, 0.5)

    self.skill_item = SlotSkill(64, 64)
    self.skill_item:setPosition( 30, 77 )
    parent:addChild(self.skill_item.view)

    self.skill_item.icon_bg = ZImage.new("ui/guild/family_47.png").view
    self.skill_item.icon_bg:setAnchorPoint(0.5, 0.5)
    self.skill_item.icon_bg:setPosition(64/2, 64/2-1)
    self.skill_item.icon_bg:setScale(0.70)
    self.skill_item.view:addChild(self.skill_item.icon_bg, -1)

    self.skill_name = ZLabel.new("")
    self.skill_name.view:setAnchorPoint(CCPointMake(0.5, 0.5))
    self.skill_name:setFontSize(18)
    self.skill_name:setPosition(size.width/2, 176)
    parent:addChild(self.skill_name.view)

    self.skill_desc = ZDialog:create( parent, "", 110, 154, 204, 66, 15 )
    self.skill_desc:setAnchorPoint(0, 1)
    self.skill_desc.view:setLineEmptySpace(2)
    -- parent:addChild(self.skill_desc.view)
end

function TransformBtnPage:update_up_panel( )
    local model_id = TransformModel:get_current_selected_ninja( )
    if not model_id then
        return
    end

    if self.ninja_model then
        self.ninja_model:removeFromParentAndCleanup(true);
    end

    -- 获取模型ID
    local _model_id = TransformConfig:get_ninja_modelid_by_id( model_id )
    local frame_str='frame/human/0/'.._model_id
    local size = self.up_panel:getSize()

    local action = UI_TRANSFORM_ACTION
    self.ninja_model = MUtils:create_animation( size.width/2, size.height/2-50, frame_str, action )
    self.up_panel:addChild( self.ninja_model )

    local max_fight = TransformConfig:get_max_fight_by_id( model_id )
    -- self.max_fight:setText(max_fight)
    self.fight_val:init(tostring(max_fight))
end

function TransformBtnPage:update_dwn_panel( )
    local model_id = TransformModel:get_current_selected_ninja( )
    if not model_id then
        return
    end

    local cur_trans_id = TransformModel:get_cur_transform_id()
    if model_id == cur_trans_id then
        self.trans_btn:setText("还  原")
    else
        self.trans_btn:setText("变  身")
    end

    local skill_id = TransformConfig:get_ninja_skill_by_id(model_id)
    local model_level = TransformModel:get_transform_level_by_id(model_id )
    local skill_name, skill_desc = SkillConfig:get_skill_by_id_and_level(skill_id, (model_level < 1 and 1 or model_level))

    self.skill_name:setText(string.format("%s%s", "#cfff000", skill_name))
    self.skill_item:set_icon(skill_id)

    self.skill_desc:setText(skill_desc)
end

function TransformBtnPage:update( update_type )
    if update_type == "all" then
        self:update_up_panel()
        self:update_dwn_panel()
    end
end


