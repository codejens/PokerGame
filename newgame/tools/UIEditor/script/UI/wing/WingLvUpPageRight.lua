-- WingLvUpPageRight.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统升级右页面

super_class.WingLvUpPageRight()

local autoBuyBtn = nil

function WingLvUpPageRight:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	local panel = self.view

    -- ZBasePanel:create(panel, "", 10, 10, 373, 545, 500, 500)

    local upPanel = self:createUpPanel(393, 565/2)
    upPanel:setPosition(0, 565/2)
    panel:addChild(upPanel)

    local dwnPanel = self:createDwnPanel(393, 565/2)
    dwnPanel:setPosition(0, 0)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function WingLvUpPageRight:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	ZImage:create(parent, "ui/wing/15.png", 5, size.height-90, -1, -1, 0, 0)

	-- 战斗力
	self.fightVal = ZXLabelAtlas:createWithString("99999", "ui/normal/numbig")
    self.fightVal:setPosition(CCPointMake(180, size.height-72))
    self.fightVal:setAnchorPoint(CCPointMake(0, 0))
    parent:addChild(self.fightVal)

	ZLabel:create(parent, LangGameString[2200], 20, 150, 16, 1, 1)     -- "祝福值："
	self.wishVal = ZLabel:create(parent, "", 100, 150, 16, 1, 1)

	ZLabel:create(parent, LangGameString[2202], 60, 100, 16, 1, 1)         -- "成功率："
	self.successRate = ZLabel:create(parent, "", 130, 100, 16, 1, 1)

	-- 羽翼晶石tips
  	local function needItemTipsFunc(  )
  		local needItemId = WingModel:get_cur_level_crystal_item_id()
  		if needItemId then
	   		TipsModel:show_shop_tip( 400, 240, needItemId, TipsModel.LAYOUT_LEFT )
	   	end
	end
	-- 羽翼晶石 slotItem
	local needItemId = WingModel:get_cur_level_crystal_item_id()
	self.needItem = MUtils:create_slot_item(parent, UIPIC_ITEMSLOT, 168, 122, 72, 72, needItemId, needItemTipsFunc)

    -- 购买按钮
    local buyBtn = ZTextButton.new("ui/common/button2.png", nil, nil, "购买")
    buyBtn:setPosition(260, 130)
    parent:addChild(buyBtn.view)
    local buyBtnCallback = function( )
        self:update("addItem")
    end
    local buyFunc = function( )
        local itemID = WingModel:get_cur_level_crystal_item_id()
        BuyKeyboardWin:show(itemID, buyBtnCallback)
    end
    buyBtn:setTouchClickFun(buyFunc)
	
	-- 提升等级按钮
	local lvUpBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	lvUpBtn:setPosition(134, 30)
	parent:addChild(lvUpBtn.view)
	local lvUpFunc = function( )
		print('-- lvUpBtn clicked --')
		WingModel:req_up_wing_level(autoBuyBtn.if_selected)
	end
	lvUpBtn:setTouchClickFun(lvUpFunc)
	local btnSize = lvUpBtn.view:getSize()
	local txtImg = ZImage:create(lvUpBtn.view, "ui/wing/16.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	ZLabel:create(parent, LangGameString[2162], 135, 8, 16, 1, 1)   -- "需要忍币："
	self.needBindYinlang = ZLabel:create(parent, "123456", 225, 8, 16, 1, 1)

	-- 是否自动购买材料
    autoBuyBtn = UIButton:create_switch_button(10, 15, 100, 44, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        "", 50, 16, nil, nil, nil, nil, 
        autoBuyFunc )
    parent:addChild(autoBuyBtn.view, 2);

    ZLabel:create(parent, "自动购", 55, 40, 16, 1, 1)
    ZLabel:create(parent, "买材料", 55, 20, 16, 1, 1)

	return parent
end

-- 更新上面板
function WingLvUpPageRight:updateUpPanel( )
	-- 更新材料item信息
	local count = WingModel:get_yuli_crystal_count()
    local needItemId = WingModel:get_cur_level_crystal_item_id()
    self.needItem:set_icon(needItemId)
    self.needItem:set_item_count(count)
    if count > 0 then
    	self.needItem:set_icon_light_color()
    else
    	self.needItem:set_icon_dead_color()
    end

    -- 更新需要忍币
    local needMoney = WingModel:need_xb_levelup_wing()
    self.needBindYinlang:setText(string.format("#cfff000%d", needMoney))

    -- 更新祝福值
    local wishVal = WingModel:get_curr_level_wishes()
    local maxWish = 10
    self.wishVal:setText(string.format("#c0edc09%d/%d", wishVal, maxWish))

    -- 更新成功率
    local sucRate = WingModel:get_curr_level_success_rate()
    local addRate = WingConfig:get_zhufu_add_rate( WingModel:get_curr_level_wishes() )
    self.successRate:setText(string.format("#c0edc09%d%%+%d%%（祝福值加成）", sucRate, addRate))

    -- 更新战斗力
	local fight = WingModel:get_curr_wing_score()
	self.fightVal:init(tostring(fight))

    -- local canBuy = MallModel:checkExistItemInShop(needItemId)
    -- if canBuy then
    --     autoBuyBtn.set_enable(true)
    -- else
    --     autoBuyBtn.set_state(false, true)
    --     autoBuyBtn.set_enable(false)
    -- end
end

function WingLvUpPageRight:playLvUpEffect( parent, x, y )
    LuaEffectManager:stop_view_effect(10014, parent)
    LuaEffectManager:play_view_effect(10014, x, y, parent, false, 10000):setPosition(CCPointMake(x, y))
end

-- 创建下面板
function WingLvUpPageRight:createDwnPanel(width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

    local rowBg = ZImage:create(nil, "ui/common/ht_bg.png", 2, size.height-40, size.width-4, 39, 0, 500, 500).view
    parent:addChild(rowBg)

    ZLabel:create(rowBg, LangGameString[2183], 51, 14, 17, 1, 1)    -- "等级："
    self.curLevel = ZLabel:create(rowBg, "", 110, 14, 17, 1, 1)

    ZLabel:create(rowBg, LangGameString[2183], 248, 14, 17, 1, 1)
    self.nexLevel = ZLabel:create(rowBg, "", 308, 14, 17, 1, 1)

    ZLabel:create(parent, LangGameString[2146], 10, 195, 15, 1, 1)          -- "生    命："
    ZLabel:create(parent, LangGameString[2143], 10, 195-55, 15, 1, 1)       -- "攻    击："
    ZLabel:create(parent, LangGameString[2144], 10, 195-55*2, 15, 1, 1)     -- "物理防御："
    ZLabel:create(parent, LangGameString[2145], 10, 195-55*3, 15, 1, 1)     -- "精神防御："

    self.hp = ZLabel:create(parent, "", 10+80, 195, 15, 1, 1)
    self.attack = ZLabel:create(parent, "", 10+80, 195-55, 15, 1, 1)
    self.phyDef = ZLabel:create(parent, "", 10+80, 195-55*2, 15, 1, 1)
    self.magDef = ZLabel:create(parent, "", 10+80, 195-55*3, 15, 1, 1)

    ZLabel:create(parent, LangGameString[2146], size.width/2+10, 195, 15, 1, 1)
    ZLabel:create(parent, LangGameString[2143], size.width/2+10, 195-55, 15, 1, 1)
    ZLabel:create(parent, LangGameString[2144], size.width/2+10, 195-55*2, 15, 1, 1)
    ZLabel:create(parent, LangGameString[2145], size.width/2+10, 195-55*3, 15, 1, 1)

    self.nexHp = ZLabel:create(parent, "", size.width/2+10+80, 195, 15, 1, 1)
    self.nexAttack = ZLabel:create(parent, "", size.width/2+10+80, 195-55, 15, 1, 1)
    self.nexPhyDef = ZLabel:create(parent, "", size.width/2+10+80, 195-55*2, 15, 1, 1)
    self.nexMagDef = ZLabel:create(parent, "", size.width/2+10+80, 195-55*3, 15, 1, 1)

    return parent
end

-- 更新下面板
function WingLvUpPageRight:updateDwnPanel( )
	-- 更新等级
	local curLv = WingModel:get_curr_wing_level()
	local maxLv = WingConfig:get_wing_max_level()
	self.curLevel:setText(curLv)
	self.nexLevel:setText((curLv>=maxLv) and maxLv or (curLv+1))

	-- 更新属性
	local curAttr = WingModel:get_curr_attr()
	local curAddAttr = WingModel:get_curr_attr_append()
	local nexAttr = WingModel:get_next_attr()
	local nexAddAttr = WingModel:get_next_attr_append()

	self.hp:setText(string.format("#cffffff%d+#cfe8300%d", curAttr[4], curAddAttr[4]))
	self.attack:setText(string.format("#cffffff%d+#cfe8300%d", curAttr[1], curAddAttr[1]))
	self.phyDef:setText(string.format("#cffffff%d+#cfe8300%d", curAttr[2], curAddAttr[2]))
	self.magDef:setText(string.format("#cffffff%d+#cfe8300%d", curAttr[3], curAddAttr[3]))

	self.nexHp:setText(string.format("#cffffff%d+#cfe8300%d", nexAttr[4], nexAddAttr[4]))
	self.nexAttack:setText(string.format("#cffffff%d+#cfe8300%d", nexAttr[1], nexAddAttr[1]))
	self.nexPhyDef:setText(string.format("#cffffff%d+#cfe8300%d", nexAttr[2], nexAddAttr[2]))
	self.nexMagDef:setText(string.format("#cffffff%d+#cfe8300%d", nexAttr[3], nexAddAttr[3]))
end

function WingLvUpPageRight:update( updateType )
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
    elseif updateType == "LvUpEffect" then
        self:playLvUpEffect(self.view, 190+15, 446-15)
    elseif updateType == "fight" then
        -- 更新战斗力
        local fight = WingModel:get_curr_wing_score()
        self.fightVal:init(tostring(fight))
    elseif updateType == "addItem" then
        local count = WingModel:get_yuli_crystal_count()
        self.needItem:set_item_count(count)
        if count > 0 then
            self.needItem:set_icon_light_color()
        else
            self.needItem:set_icon_dead_color()
        end
	end
end

function WingLvUpPageRight:destroy( )
	
end