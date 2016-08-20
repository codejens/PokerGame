-- TransformDevelopWin.lua
-- created by aXing on 2014-5-21
-- 变身培养界面

super_class.TransformDevelopWin(Window)


local _dark_img_path = UIResourcePath.FileLocate.linggen .. "ling_p1.png"
local _light_img_path = UIResourcePath.FileLocate.linggen .. "ling_p2.png"

    -- 字路径（从上面左开始，顺时针）
_font_path_t = {
    { UIResourcePath.FileLocate.linggen .. "jing-1.png", UIResourcePath.FileLocate.linggen .. "jing-2.png" },
    { UIResourcePath.FileLocate.linggen .. "yin-1.png", UIResourcePath.FileLocate.linggen .. "yin-2.png" },
    { UIResourcePath.FileLocate.linggen .. "ren-1.png", UIResourcePath.FileLocate.linggen .. "ren-2.png" },
    { UIResourcePath.FileLocate.linggen .. "ti-1.png", UIResourcePath.FileLocate.linggen .. "ti-2.png" },
    { UIResourcePath.FileLocate.linggen .. "huan-1.png", UIResourcePath.FileLocate.linggen .. "huan-2.png" },
    { UIResourcePath.FileLocate.linggen .. "xian-1.png", UIResourcePath.FileLocate.linggen .. "xian-2.png" },
    { UIResourcePath.FileLocate.linggen .. "su-1.png", UIResourcePath.FileLocate.linggen .. "su-2.png" },
    { UIResourcePath.FileLocate.linggen .. "li-1.png", UIResourcePath.FileLocate.linggen .. "li-2.png" },
}

local _stage_lv = TransformConfig.stage_lv_t
local _stage = TransformConfig.stage_book_t
local _cheng_hao = TransformConfig.title_t
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

-- 先写窗口的初始化方法
function TransformDevelopWin:__init( window_name, texture_name )
	-- 主要是创建控件
	local bg = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 660, 530)
    bg:setPosition(30, 20)
    self:addChild(bg)

	self:create_left_panel()
	self:create_right_top_panel()
	self:create_right_bottom_panel()
	self:create_bottom_panel()
end

function TransformDevelopWin:set_transform_info(model_id)
    ZXLog('---------------set_transform_info-----------',model_id)
    self.model_id = model_id
    self.stage_level = TransformModel:get_transform_stage_level_by_id(model_id)
    self.stage = TransformModel:get_transform_stage_by_id(model_id)
    -- ZXLog('======stage=stage_level: ', self.stage, self.stage_level)
    self:update()
end

-- 创建左边面板
function TransformDevelopWin:create_left_panel(  )
	local bg = ZBasePanel.new("", 424, 445) 
    bg:setPosition(41, 95)
    self:addChild(bg)
    self.left_panel = bg

    -- 轮回底图
    local fuck_img = ZImage.new(UIResourcePath.FileLocate.transform .. "11.png")
    fuck_img.view:setAnchorPoint(0.5, 0.5)
    fuck_img:setPosition(424/2, 445/2)
    bg:addChild(fuck_img)

    -- 不发光图、发光图
    _dark_img_path = UIResourcePath.FileLocate.linggen .. "ling_p1.png"
    _light_img_path = UIResourcePath.FileLocate.linggen .. "ling_p2.png"

    -- 字底图坐标（从上面左（"力"字）开始，顺时针）
    local pos_t = {
        {251, 365},
        {328, 315},
        {345, 108},
        {263, 13},
        {72, 36},
        {0, 126},
        {21, 287},
        {89, 365},
    }

    -- 保存字，方便切换发光和不发光状态（用setTexture方法）（从上面左（"力"字）开始，顺时针）
    self.font_t = {}
    -- 保存字底图， 方便切换发光和不发光状态（用setTexture方法）（从上面左（"力"字）开始，顺时针）
    self.font_bg_t = {}
    local font_x, font_y = 23, 22

    for i,v in ipairs(pos_t) do
        local shit_img = ZImage.new(_dark_img_path)
        shit_img:setPosition(v[1], v[2])
        bg:addChild(shit_img)
        self.font_bg_t[i] = shit_img

        local font = ZImage.new(_font_path_t[i][1])
        font:setPosition(font_x, font_y)
        shit_img:addChild(font)
        self.font_t[i] = font
    end

    -- 培养称号
    local name_bg = ZImage.new(UIResourcePath.FileLocate.transform .. "py.png")
    name_bg:setPosition(155, 135)
    bg:addChild(name_bg)
    self.cheng_hao = ZLabel.new("真·六道仙人")    -- 用setText方法改变文本
    self.cheng_hao.view:setAnchorPoint(CCPointMake(0.5, 0))
    self.cheng_hao:setFontSize(15)
    self.cheng_hao:setPosition(116/2, 14)
    name_bg:addChild(self.cheng_hao)

    -- 创建人物模型
    local action = UI_TRANSFORM_ACTION;
    self.ninja_model = MUtils:create_animation(212, 190, "frame/human/0/01000", action)
    bg:addChild(self.ninja_model)
end

-- 创建右边上面的面板
function TransformDevelopWin:create_right_top_panel(  )
	local bg = ZBasePanel.new("", 210, 230) 
    bg:setPosition(470, 309)
    self:addChild(bg)

    -- 背景size
    local size = bg:getSize()

    -- 标题
    local title_bg = CCZXImage:imageWithFile(0, size.height-33, -1, -1, UIResourcePath.FileLocate.common .. "wzd-1.png", 500, 500)
    bg:addChild(title_bg)
    local title = CCZXImage:imageWithFile(23, 3, -1, -1, UIResourcePath.FileLocate.renwu .. "attr.png", 500, 500)
    title_bg:addChild(title)

    -- 属性
    local attr_t = {
        "精（生    命）：",
        "印（暴    击）：",
        "忍（物理防御）：",
        "体（抗 暴 击）：",
        "幻（精神防御）：",
        "贤（命    中）：",
        "速（闪    避）：",
        "力（攻    击）："
    }
    local font_size = 15
    local offset_y = 22
    local start_x = 3
    local start_x2 = 140
    local start_y = 170

    -- 保存属性值label
    self.attr_val_t = {}

    for i,v in ipairs(attr_t) do
        local attr_name = ZLabel.new(v)
        attr_name:setFontSize(font_size)
        attr_name:setPosition(start_x, start_y - offset_y*(i-1))
        bg:addChild(attr_name)

        local attr_val = ZLabel.new("#c00ff00500000")
        attr_val:setFontSize(font_size)
        attr_val:setPosition(start_x2, start_y - offset_y*(i-1))
        bg:addChild(attr_val)
        self.attr_val_t[i] = attr_val
    end
end

-- 创建右边下面的面板
function TransformDevelopWin:create_right_bottom_panel(  )
	local bg = ZBasePanel.new("", 210, 210) 
    bg:setPosition(470, 95)
    self:addChild(bg)

    -- 背景size
    local size = bg:getSize()

    -- 标题
    local title_bg = CCZXImage:imageWithFile(0, size.height-33, -1, -1, UIResourcePath.FileLocate.common .. "wzd-1.png", 500, 500)
    bg:addChild(title_bg)
    local title = CCZXImage:imageWithFile(23, 3, -1, -1, UIResourcePath.FileLocate.renwu .. "tips.png", 500, 500)
    title_bg:addChild(title)

    local tips_t = {
        "1.培养需要消耗查克拉和忍币",
        "2.每次培养有一定成功率",
        "3.培养成功后会在角色名字前增加特殊标识",
        "4.培养属性会直接附加给角色"
    }
    local font_size = 15
    local offset_y = 44
    local x, y = 5, 138
    local w, h = 202, 40
    local num = 50

    for i,v in ipairs(tips_t) do
        local text = ZDialog.new(v, w, h, num, font_size)
        text:setPosition(x, y - offset_y*(i-1))
        bg:addChild(text)
    end
end

-- 创建底下面板
function TransformDevelopWin:create_bottom_panel(  )
	local bg = ZBasePanel.new("", 640, 60) 
    bg:setPosition(41, 30)
    self:addChild(bg)

    local y = 10
    local y2 = 35

    -- 令之书
    self.fuck_name = ZLabel.new("#cffff00令の书·力")
    self.fuck_name:setPosition(10, y2)
    bg:addChild(self.fuck_name)

    -- 属性
    self.attr = ZLabel.new("#cffffff攻击：#c00ff0059000")
    self.attr:setPosition(10, y)
    bg:addChild(self.attr)

    -- 消耗忍者币
    -- local name = ZLabel.new("#cffff00消耗忍者币：")
    -- name:setPosition(225, y2)
    -- bg:addChild(name)
    -- self.cost_renbi = ZLabel.new("#cffff0059000")
    -- self.cost_renbi:setPosition(335, y2)
    -- bg:addChild(self.cost_renbi)

    -- 消耗查克拉
    local name = ZLabel.new("#cffffff消耗查克拉：")
    name:setPosition(225, y)
    bg:addChild(name)
    self.cost_chakela = ZLabel.new("#cffffff59000")
    self.cost_chakela:setPosition(335, y)
    bg:addChild(self.cost_chakela)

    -- 培养按钮
    local dev_func = function(  )
       TransformModel:request_develop( self.model_id )
    end
     --xiehande 通用按钮  btn_hong.png ->button3  btn_lv ->button3
    self.dev_btn = ZButton.new( UIResourcePath.FileLocate.common .. "button3.png" )

    --btn_hui2
    self.dev_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "button3_d.png")
    self.dev_btn:setPosition(500, 8)
    self.dev_btn:setTouchClickFun(dev_func)
    bg:addChild(self.dev_btn)
    local dev_name = ZLabel.new("培  养")
    dev_name:setPosition(126/2, 15)
    dev_name.view:setAnchorPoint(CCPointMake(0.5, 0))
    self.dev_btn:addChild(dev_name)
end

function TransformDevelopWin:update(  )
    self:update_ninja(self.model_id)

    local curr_stage_info = TransformConfig:get_dev_info_by_stage( self.stage )

    local next_stage_info = TransformConfig:get_dev_info_by_stage( self.stage+1 )

    for i=self.stage_level+1,#self.attr_val_t do
        self.attr_val_t[i]:setText("#c00ff00" .. (curr_stage_info and curr_stage_info[i].value or "0"))
    end

    if next_stage_info then
        
        self:update_stage_lv(self.stage_level)

        for i=1,self.stage_level do
            self.attr_val_t[i]:setText("#c00ff00" .. next_stage_info[i].value)
        end

        self.fuck_name:setText("#cffff00" .. _stage[self.stage+1] .. "·" .. _stage_lv[self.stage_level+1])
        self.attr:setText("#cffffff" .. _attr_t[self.stage_level+1] .. "#c00ff00" .. next_stage_info[self.stage_level+1].value)
        -- self.cost_renbi:setText("#cffff00" .. next_stage_info[self.stage_level+1].coin)
        self.cost_chakela:setText("#cffffff" .. next_stage_info[self.stage_level+1].expr)
    else
        
        self:update_stage_lv(#_stage_lv)

        self.fuck_name:setText("#cffff00" .. _stage[self.stage] .. "." .. _stage_lv[#_stage_lv])
        self.attr:setText("#cffffff" .. _attr_t[#_stage_lv] .. "#c00ff00" .. curr_stage_info[#_stage_lv].value)
        -- self.cost_renbi:setText("#cffff00" .. curr_stage_info[#_stage_lv].coin)
        self.cost_chakela:setText("#cffffff" .. curr_stage_info[#_stage_lv].expr)
        self.dev_btn:setCurState(CLICK_STATE_DISABLE)
    end

    self.cheng_hao:setText(_cheng_hao[self.stage+1])

end

-- 更新阶段等级(发光的字)
function TransformDevelopWin:update_stage_lv( stage_lv )
    for i,v in ipairs(self.font_t) do
        self.font_bg_t[i]:setTexture(_dark_img_path)
        self.font_t[i]:setTexture(_font_path_t[i][1])
    end

    for i=1,stage_lv do
        self.font_bg_t[i]:setTexture(_light_img_path)
        self.font_t[i]:setTexture(_font_path_t[i][2])
    end
end

-- 更新当前法宝形象
function TransformDevelopWin:update_ninja( model_id )
    if self.ninja_model then
        self.ninja_model:removeFromParentAndCleanup(true);
    end
    -- 获取模型ID
    local _model_id = TransformConfig:get_ninja_modelid_by_id( model_id )

    local frame_str='frame/human/0/'.._model_id

    local action = UI_TRANSFORM_ACTION;
    self.ninja_model = MUtils:create_animation( 212, 190, frame_str, action );
    self.left_panel:addChild( self.ninja_model );
end

