-- ItemSmeltLeftPage.lua
-- created by yongrui.liang on 2014-8-25
-- 装备熔炼左页面

super_class.ItemSmeltLeftPage()

function ItemSmeltLeftPage:__init( )
	   --初始化道具table 
    ElfinModel:init_equip_data()
	-- --左侧装备信息，保存起来
	self.item_slot = {}
	self.award_lable = {}

	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	-- 上面板
    local upPanel = self:createUpPanel(320+10, 365)
    upPanel:setPosition(5, 195)
    panel:addChild(upPanel,1)

    -- 下面板
    local dwnPanel = self:createDwnPanel(324, 188)
    dwnPanel:setPosition(8, 8)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function ItemSmeltLeftPage:createUpPanel( width, height )

	self.up_parent = ZBasePanel.new(nil, width, height).view
	local size = self.up_parent:getSize()

	ZBasePanel:create(self.up_parent, "ui/elfin/10.png", 3, 3, size.width-6, size.height-6, 0, 0)


	local function smelt_fun(  )
		ElfinModel:equip_smelt() 
	end
	local smelt_btn = ZButton:create( self.up_parent,"ui/elfin/10.1.png",smelt_fun, 103, 144,-1,-1);

	-- 4个角标
	local LTCorner = ZBasePanel:create(self.up_parent, "ui/geniues/genius_bg5.png", 1, size.height-43)
	LTCorner.view:setFlipX(true)
	LTCorner.view:setFlipY(false)
	local LBCorner = ZBasePanel:create(self.up_parent, "ui/geniues/genius_bg5.png", 1, 1)
	LBCorner.view:setFlipX(true)
	LBCorner.view:setFlipY(true)
	local RTCorner = ZBasePanel:create(self.up_parent, "ui/geniues/genius_bg5.png", size.width-43, size.height-43)
	RTCorner.view:setFlipX(false)
	RTCorner.view:setFlipY(false)
	local RBCorner = ZBasePanel:create(self.up_parent, "ui/geniues/genius_bg5.png", size.width-43, 1)
	RBCorner.view:setFlipX(false)
	RBCorner.view:setFlipY(true)

	--八个增加按钮
	self:create_item_btn( self.up_parent )

	-- 自动筛选按钮
	local autoSelBtn = ZTextButton.new("ui/common/button3.png", nil, nil, "自动筛选")
	autoSelBtn:setPosition(size.width/2-68, 5)
	autoSelBtn.view:setAnchorPoint(0.5, 0)
	self.up_parent:addChild(autoSelBtn.view)
	local autoSelFunc = function( )
		ElfinModel:auto_select()
	end
	autoSelBtn:setTouchClickFun(autoSelFunc)

	--装备升级
	local equipUpgrade = ZTextButton.new("ui/common/button3.png", nil, nil, "装备升级")
	equipUpgrade:setPosition(size.width/2+68, 5)
	equipUpgrade.view:setAnchorPoint(0.5, 0)
	self.up_parent:addChild(equipUpgrade.view)
	local equipUpgradeFunc = function( )
		ElfinModel:setCurLeftPage( ElfinModel.ELFIN_ITEM_LEFT_PAGE )
		ElfinModel:changeLeftPage( ElfinModel.ELFIN_ITEM_LEFT_PAGE )
		ElfinModel:setCurElfinItemPage( ElfinModel.LV_UP_ITEM_PAGE)
		ElfinModel:changeRightPage(ElfinModel.LV_UP_ITEM_PAGE)
	end
	equipUpgrade:setTouchClickFun(equipUpgradeFunc)

	return self.up_parent
end

-- 8个有+号的item
function ItemSmeltLeftPage:create_item_btn( parent )
	local btnPos = {{131, 280}, {40, 260}, {25, 170}, {40, 81}, {131, 68}, {222, 81}, {240, 170}, {222, 260}}
	for i,v in ipairs(btnPos) do
		self.item_slot[i] = self:createItemSmelt(parent, v[1], v[2],i)
	end
end

-- 1个有+号的item
function ItemSmeltLeftPage:createItemSmelt(parent, x, y, index)
	local one_slow_info = { }

	local function f1( arg )
	end
	local slotItem =  ElfinEquipItem()
	slotItem.view:setPosition(x, y)
	slotItem:setDoubleClickFun( f1 )
	slotItem:setOpenStatus(true)
	parent:addChild( slotItem.view ) 

	local function btn_fun(  )
		ElfinModel:setCurRightPage(ElfinModel.ITEMSMELT_RIGHT_PAGE)
		ElfinModel:changeRightPage( ElfinModel.ITEMSMELT_RIGHT_PAGE )
	end
	local default_btn = ZButton:create( nil,"ui/elfin/11.png", btn_fun, 32, 32, -1, -1);
	default_btn.view:setAnchorPoint(0.5, 0.5)
	default_btn.view:setScale(1.4)
	slotItem.view:addChild(default_btn.view,99)
 
	one_slow_info.slotItem = slotItem
	one_slow_info.default_btn = default_btn 

	return one_slow_info
end

-- 更新上面板
function ItemSmeltLeftPage:updateUpPanel( )
	local all_equip_table = ElfinModel:get_equip_data(  )
	local num = #all_equip_table
	if num ~= 0 then
		for i=1,8 do
			local one_slot = all_equip_table[i]
			if one_slot.equip.itemCDKey ~= nil and one_slot.if_select == true then
				self.item_slot[i].slotItem:setIcon( one_slot.equip.itemType );
				self.item_slot[i].slotItem:setQuality( one_slot.equip.itemQlty )
				self.item_slot[i].default_btn.view:setIsVisible(false)
				self.item_slot[i].slotItem:setDoubleClickFun(function( )
					one_slot.if_select = false
					ElfinModel:set_equip_item_series(one_slot)
				end)
			else 
				self.item_slot[i].slotItem:setIcon( nil )
				self.item_slot[i].slotItem:setQuality( nil )
				self.item_slot[i].default_btn.view:setIsVisible(true)
				self.item_slot[i].slotItem:setDoubleClickFun(nil)
			end 
		end
	end 
end

-- 创建下面板
function ItemSmeltLeftPage:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	self.down_parent = parent

	ZBasePanel:create(parent, "", 0, 0, size.width, size.height, 500, 500)
	local title_bg = ZImage:create(parent, "ui/common/ht_bg.png", 0, size.height-38, size.width, 39, 0, 500, 500)
	
    local player_smelt  = ElfinModel:getSmeltVal( )
	self.title_lable = UILabel:create_lable_2( "#cffff00熔炼值："..player_smelt, size.width/2, 14, 18, ALIGN_CENTER )
	title_bg:addChild(self.title_lable ,99)
	-- 标题
	local titleBg = ZImage:create(parent, "ui/transform/new24.png", size.width/2, size.height-56, -1, -1, 0, 500, 500)
    titleBg.view:setAnchorPoint(0.5, 0.5)
    ZLabel:create(parent, "#cfff000熔炼信息", size.width/2, size.height-63, 16, 2)

    local x, y, oy = 10, 100, 30
    self.award_lable = {}
    self.award_lable[1] = ZLabel:create(parent, "", x, y, 15, 1, 1)
    self.award_lable[2] = ZLabel:create(parent, "", width/2+x, y, 15, 1, 1)
    self.award_lable[3] = ZLabel:create(parent, "", x, y-oy, 15, 1, 1)
    self.award_lable[4] = ZLabel:create(parent, "", width/2+x, y-oy, 15, 1, 1)
    self.award_lable[5] = ZLabel:create(parent, "", x, y-oy*2, 15, 1, 1)
    self.award_lable[6] = ZLabel:create(parent, "", width/2+x, y-oy*2, 15, 1, 1)
    self.award_lable[7] = ZLabel:create(parent, "", x, y-oy*3, 15, 1, 1)
    self.award_lable[8] = ZLabel:create(parent, "", width/2+x, y-oy*3, 15, 1, 1)

	return parent
end

-- 更新下面板
function ItemSmeltLeftPage:updateDwnPanel( )
	-- 更新属性
    local player_smelt  = ElfinModel:getSmeltVal()
	self.title_lable:setText("#cffff00熔炼值："..player_smelt)

	local award_list = ElfinModel:get_award_list()
	if award_list then 
		for i=1,#award_list do
			if award_list[i].if_new_equip == true then
				local name =  award_list[i].new_equip_name
				self.award_lable[i]:setText(string.format("#cf1e7d4获得装备:#cff0000%s", name))
			else
				local smelt_value =  award_list[i].smelt_value
				self.award_lable[i]:setText(string.format("#cf1e7d4熔 炼 值:%d", smelt_value))
			end 
		end
	end
end

function ItemSmeltLeftPage:update( updateType )
	print('--- ItemSmeltLeftPage:update: ', updateType)
	if updateType =="smeltItems" then
		self:player_smelt_effect()
		self:updateUpPanel()
		self:updateDwnPanel()
	elseif updateType == "all" then
		self:updateDwnPanel()
		self:updateUpPanel()
	elseif updateType == "selectSmeltItem" then
		self:updateUpPanel()
	end 
end

--播放熔炼特效
function ItemSmeltLeftPage:player_smelt_effect(  )
	LuaEffectManager:play_view_effect(411,160,201,self.up_parent,false,99,1)
	local Pic =  'ui/elfin/light.png'
	local light1 = CCZXImage:imageWithFile( 36,100, -1,-1, Pic);
	local light2 = CCZXImage:imageWithFile( 90,100, -1,-1, Pic);
	light1:setAnchorPoint(0,0)
	light2:setAnchorPoint(0,0)
	self.up_parent:addChild(light1)
	self.up_parent:addChild(light2)

	local array1 = CCArray:array();
	array1:addObject(CCMoveTo:actionWithDuration(0.5,CCPoint(-13,15)))
	array1:addObject(CCMoveTo:actionWithDuration(0.5,CCPoint(62,-116)))
	array1:addObject(CCRemove:action())
	local seq1 = CCSequence:actionsWithArray(array1);
	light1:runAction(seq1)

	local array2 = CCArray:array();
	array2:addObject(CCMoveTo:actionWithDuration(0.5,CCPoint(165,15)))
	array2:addObject(CCMoveTo:actionWithDuration(0.5,CCPoint(62,-116)))
	array2:addObject(CCRemove:action())
	local seq2 = CCSequence:actionsWithArray(array2);
	light2:runAction(seq2)

	local size = self.down_parent:getSize()
	LuaEffectManager:play_view_effect(412, 154, size.height-38+24,self.down_parent,false,99,2)
end

function ItemSmeltLeftPage:destroy( )
	self.item_slot = nil
	self.award_lable = nil
	LuaEffectManager:stop_view_effect( 411,self.up_parent )
	LuaEffectManager:stop_view_effect( 412,self.down_parent )
end