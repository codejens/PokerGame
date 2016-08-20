-- DevelopBtnPage.lua 
-- createed by yongrui.liang on 2014-7-22
-- 培养按钮页

super_class.DevelopBtnPage(  )

-- 不发光图、发光图
    _dark_img_path = UIResourcePath.FileLocate.linggen .. "ling_p1.png"
    _light_img_path = UIResourcePath.FileLocate.linggen .. "ling_p2.png"

    local _attr_t = {
        "生    命：",
        "暴    击：",
        "物理防御：",
        "抗 暴 击：",
        "精神防御：",
        "命    中：",
        "闪    避：",
        "攻    击："
    }

function DevelopBtnPage:__init( )
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

function DevelopBtnPage:create_up_panel( parent )
    local size = parent:getSize()
    local model_bg = ZImage.new("ui/transform/new19.png").view
    model_bg:setAnchorPoint(0.5, 0.5)
    model_bg:setPosition(size.width/2, size.height/2)
    -- model_bg:setScale(0.7)
    parent:addChild(model_bg)

    -- 保存字，方便切换发光和不发光状态（用setTexture方法）（从上面左（"力"字）开始，顺时针）
    self.font_t = {}
    -- 保存字底图， 方便切换发光和不发光状态（用setTexture方法）（从上面左（"力"字）开始，顺时针）
    self.font_bg_t = {}
    local font_x, font_y = 23, 22

    for i,v in ipairs(UI_TRANS_DEV_FONT_POS) do
        local shit_img = ZImage.new(_dark_img_path)
        shit_img:setPosition(v.x, v.y)
        parent:addChild(shit_img.view)
        self.font_bg_t[i] = shit_img

        local font = ZImage.new(_font_path_t[i][1])
        font:setPosition(font_x, font_y)
        shit_img:addChild(font)
        self.font_t[i] = font
    end

    local model_title_bg = ZImage.new(UIResourcePath.FileLocate.transform .. "py.png").view
    model_title_bg:setAnchorPoint(0.5, 0.5)
    model_title_bg:setPosition(size.width/2, 103)
    parent:addChild(model_title_bg)
    self.model_title = ZLabel.new("真·六道仙人")
    self.model_title.view:setAnchorPoint(CCPointMake(0.5, 0))
    self.model_title:setFontSize(16)
    self.model_title:setPosition(116/2, 15)
    model_title_bg:addChild(self.model_title.view)

    -- self.level_img = ZImage.new(string.format("ui/transform/lv%d.png", 1)).view
    -- self.level_img:setAnchorPoint(0, 1.0)
    -- self.level_img:setPosition(0, size.height)
    -- parent:addChild(self.level_img)
end

function DevelopBtnPage:create_dwn_panel( parent )
    local size = parent:getSize()

    -- 属性
    self.attr = ZLabel.new("#cffffff攻击：#c00ff00+59000")
    self.attr:setFontSize(15)
    self.attr:setPosition(10, 165)
    parent:addChild(self.attr.view)

    -- 消耗查克拉
    -- local name = ZLabel.new("#cffffff消耗查克拉：")
    -- name:setFontSize(15)
    -- name:setPosition(140, 165)
    -- parent:addChild(name.view)
    self.cost_chakela = ZLabel.new("#cffffff消耗查克拉：#c00ff0059000")
    self.cost_chakela:setFontSize(15)
    self.cost_chakela:setPosition(150, 165)
    parent:addChild(self.cost_chakela.view)

    self.chakela = ZLabel.new("#cffffff查克拉：#cfff00055555554")
    self.chakela:setPosition(10, 30)
    parent:addChild(self.chakela.view)

    self.max_lv_tips = ZLabel.new("#cffffff已满级")
    self.max_lv_tips.view:setAnchorPoint(CCPointMake(0.5, 0))
    self.max_lv_tips:setPosition(size.width/2, 165)
    self.max_lv_tips.view:setIsVisible(false)
    parent:addChild(self.max_lv_tips.view)
 --xiehande 通用按钮  btn_hong.png ->button3  btn_lv ->button3
    self.dev_btn = ZTextButton.new("ui/common/button3.png", nil, nil, "培  养")
    --btn_hui2->button3_d
    self.dev_btn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button3_d.png")
    self.dev_btn.view:setAnchorPoint(0.5, 0.5)
    self.dev_btn.view:setPosition(size.width/2, 100)
    parent:addChild(self.dev_btn.view)
    -- 培养按钮
    local dev_func = function(  )
    	local model_id = TransformModel:get_current_selected_ninja( )
        print(model_id)
    	if model_id then
	    	TransformModel:request_develop( model_id )
	    end
    end
    self.dev_btn:setTouchClickFun(dev_func)
    local function btn_up_fun1( )
 
       ForgeDialog:show( 6 )
    end
    --xiehande  通用按钮修改  --btn_lang2.png ->button2.png
    local get_btn = ZTextButton.new("ui/common/button2.png", nil, nil, "获得")
    get_btn.view:setAnchorPoint(1, 0)
    get_btn.view:setPosition(size.width-25, 8)
    get_btn:setTouchClickFun(btn_up_fun1)
    parent:addChild(get_btn.view)
end

function DevelopBtnPage:update_up_panel( )
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

    -- 更新阶段等级(发光的字)
    local stage_lv = TransformModel:get_transform_stage_level_by_id(model_id)
    for i,v in ipairs(self.font_t) do
        self.font_bg_t[i]:setTexture(_dark_img_path)
        self.font_t[i]:setTexture(_font_path_t[i][1])
    end

    for i=1,stage_lv do
        self.font_bg_t[i]:setTexture(_light_img_path)
        self.font_t[i]:setTexture(_font_path_t[i][2])
    end

    local stage = TransformModel:get_transform_stage_by_id(model_id)
    self.model_title:setText(TransformConfig.title_t[stage+1])

    if stage >= 10 then
    	stage = 10
    	for i=1,8 do
	        self.font_bg_t[i]:setTexture(_light_img_path)
	        self.font_t[i]:setTexture(_font_path_t[i][2])
	    end
	elseif stage < 1 then
		stage = 1
    end

    -- if self.level_img then
    -- 	self.level_img:removeFromParentAndCleanup(true)
    -- end
    -- local size = self.up_panel:getSize()
    -- self.level_img = ZImage.new(string.format("ui/transform/lv%d.png", stage)).view
    -- self.level_img:setAnchorPoint(0, 1.0)
    -- self.level_img:setPosition(0, size.height)
    -- self.up_panel:addChild(self.level_img)
end

function DevelopBtnPage:update_dwn_panel( )
    local model_id = TransformModel:get_current_selected_ninja( )
    if not model_id then
        return
    end

    local stage = TransformModel:get_transform_stage_by_id(model_id)
    local next_stage_info = TransformConfig:get_dev_info_by_stage( stage+1 )
    local stage_lv = TransformModel:get_transform_stage_level_by_id(model_id)
    if next_stage_info and next_stage_info[stage_lv+1] then
	    self.attr:setText("#cffffff" .. _attr_t[stage_lv+1] .. "#cfff000+" .. next_stage_info[stage_lv+1].value)
	    self.cost_chakela:setText("#cffffff消耗查克拉：#c00ff00" .. next_stage_info[stage_lv+1].expr)
	end
    
    local player = EntityManager:get_player_avatar()
    self.chakela:setText("#cffffff查克拉：#cfff000"..player.lingQi)

    if stage >= 10 then
    	self.attr.view:setIsVisible(false)
    	self.cost_chakela.view:setIsVisible(false)
    	self.max_lv_tips.view:setIsVisible(true)
    	self.dev_btn:setCurState(CLICK_STATE_DISABLE)
    else
    	self.attr.view:setIsVisible(true)
    	self.cost_chakela.view:setIsVisible(true)
    	self.max_lv_tips.view:setIsVisible(false)
    	self.dev_btn:setCurState(CLICK_STATE_UP)
    end
end



function DevelopBtnPage:update(  )
	self:update_up_panel()
	self:update_dwn_panel()
end


