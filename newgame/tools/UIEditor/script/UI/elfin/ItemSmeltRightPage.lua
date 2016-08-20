-- ItemSmeltRightPage.lua
-- created by yongrui.liang on 2014-8-25
-- 式神熔炼右页面

require "UI/component/Window"
require "utils/MUtils"
require "utils/UI/UIButton"
super_class.ItemSmeltRightPage( )

function ItemSmeltRightPage:__init( )

    self.select_btn = { }
    --保存物品信息
    self.item_info = { }
	-- 底板
    local panel = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	self.view = panel

    local scrollPanel = self:createScrollPanel(373, 545)
    scrollPanel:setPosition(10, 10)
    self.view:addChild(scrollPanel)
end

function ItemSmeltRightPage:createScrollItem( width, height )
    local parent = ZBasePanel.new(nil, width, height)
    ZImage:create(parent.view, "ui/common/jgt_line.png", 5, 0, width-10, 2)

    parent.item = ElfinEquipItem()
    parent.item.view:setPosition(20, 13)
    parent.item:setOpenStatus(true)
    parent.view:addChild(parent.item.view)

    local name = ZLabel:create(parent.view, "", 100, 60, 18)
    local smelt = ZLabel:create(parent.view, "", 100, 37, 16)
    local attr = ZLabel:create(parent.view, "", 100, 14, 16)

    --是否选择
    local function select_fun( if_selected )
        if if_selected == true then 
            local if_full = ElfinModel:if_smelt_full()
            if if_full == false then
                if parent.data then
                    parent.data.if_select = true
                    ElfinModel:set_equip_item_series(parent.data)
                end
            else
                parent.select_btn.set_state( false )
                GlobalFunc:create_screen_notic( "熔炼槽已满" )
            end
        else
            if parent.data then
                parent.data.if_select = false
                ElfinModel:set_equip_item_series(parent.data)
            end
        end
    end
    parent.select_btn = UIButton:create_switch_button(320, 20, 100, 44, 
    UIPIC_FORGE_031, 
    UIPIC_FORGE_032, 
    "", 50, 16, nil, nil, nil, nil, 
    select_fun )
    parent.view:addChild(parent.select_btn.view)

    parent.update = function( data )
        parent.data = data
        if data and data.equip.itemCDKey ~= 0 then
            parent.item:setIcon( data.equip.itemType )
            parent.item:setQuality( data.equip.itemQlty )

            parent.select_btn.set_state(data.if_select)

            local color = ItemConfig:get_item_color(data.equip.itemQlty)
            local nameTxt = ElfinConfig:getEquipNameByType(data.equip.itemType)
            name:setText(string.format("#c%s%s #ce519cb+%d", color, nameTxt, data.equip.itemLevel))

            local isEquip = ElfinConfig:getEquipmentCanEquipByType(data.equip.itemType)
            if not isEquip then
                if data.equip.itemType == 9 then
                    local smeltVal = ElfinConfig:get_bnxj_equip_smelt()
                    smelt:setText(string.format("熔炼值：#cfff000%d", smeltVal))
                    attr:setText("")
                end
            else
                local smeltVal = ElfinConfig:getEquipSmeltByLevel(data.equip.itemType, data.equip.itemQlty, data.equip.itemLevel)
                smelt:setText(string.format("熔炼值：#cfff000%d", smeltVal))

                local attrName = ElfinConfig:getEquipAttrName(data.equip.itemType)
                local attrVal = data.equip.itemBaseVal
                attr:setText(string.format("效  果：#cfff000%s #ce519cb+%d", attrName, attrVal))
            end
        end
    end

    return parent
end

function ItemSmeltRightPage:createScrollPanel( width, height )
    local parent = ZBasePanel.new(nil, width, height).view
    ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

    local itemsData = ElfinModel:get_right_equip()
    local createItem = function( data, newComp )
        if not newComp then
            newComp = self:createScrollItem(width, 90)
            newComp.update(data)
        else
            newComp.update(data)
        end
        return newComp
    end
    self.itemScroll = TouchListVertical(0, 0, width, height, 90, 8)
    self.itemScroll:BuildList(90, 0, 7, itemsData, createItem)
    parent:addChild(self.itemScroll.view)

    if itemsData and #itemsData > 0 then
        if self.notice then
            self.notice:setText("")
        else
            self.notice = ZLabel:create(parent, "", width/2, height/2, 18, 2)
        end
    else
        if self.notice then
            self.notice:setText("#c00ff00您当前没有可用于熔炼的道具")
        else
            self.notice = ZLabel:create(parent, "#c00ff00您当前没有可用于熔炼的道具", width/2, height/2, 18, 2)
        end
    end

    return parent
end

function ItemSmeltRightPage:updateScrollPanel( )
    if self.itemScroll then
        local itemsData = ElfinModel:get_right_equip()
        self.itemScroll:refresh(itemsData)
    end
end

--[[ 
-- 创建一行队伍成员。 参数：坐标 宽高 背景图名称 该行的数据
function ItemSmeltRightPage:create_scroll_item( one_row, index )
    local one_equip = self.bag_data[index]

    if one_equip ~= nil and one_equip.equip.itemCDKey ~= 0 then
        local slotItem =  ElfinEquipItem()
        slotItem.view:setPosition(20,13)

        slotItem:setOpenStatus(true)
        slotItem:setIcon( one_equip.equip.itemType )
        slotItem:setQuality( one_equip.equip.itemQlty )
        one_row:addChild( slotItem.view ) 

        local name = ElfinConfig:getEquipNameByType(one_equip.equip.itemType)
        local equip_name = UILabel:create_lable_2( "#c00ff00"..name, 100, 60, 18, ALIGN_LEFT )
        one_row:addChild(equip_name)

        --熔炼值
        --
        local if_is_equip = ElfinConfig:getEquipmentCanEquipByType( one_equip.equip.itemType )
        local smelt_num
        if if_is_equip == false then 
            --特殊处理 当type值为9时 目前为 百年玄晶 道具
            if one_equip.equip.itemType == 9 then
              smelt_num =  ElfinConfig:get_bnxj_equip_smelt(  ) 
            end
        else
            smelt_num = ElfinConfig:getEquipSmeltByLevel(one_equip.equip.itemType,
                                one_equip.equip.itemQlty,one_equip.equip.itemLevel)
        end 
        
        local smelt = UILabel:create_lable_2( "#c00ff00熔炼值：".."#cffffff"..smelt_num, 100, 37, 16, ALIGN_LEFT )
        one_row:addChild(smelt)

        --效果
        local show_name =ElfinConfig:getEquipAttrName( one_equip.equip.itemType )
        local show = UILabel:create_lable_2( "#c00ff00效  果：".."#cffffff"..show_name, 100, 14, 16, ALIGN_LEFT )
        one_row:addChild(show)

         --是否选择
        local function select_fun( if_selected )
            if if_selected == true then 
               
                local if_full = ElfinModel:if_smelt_full(  )
                if if_full == false then 
                    one_equip.if_select = true
                    ElfinModel:set_equip_item_series( one_equip)
                else 
                    self.select_btn[index].set_state( false )
                    GlobalFunc:create_screen_notic( "熔炼槽已满" );
                end 
            else 
                one_equip.if_select = false
                ElfinModel:set_equip_item_series( one_equip)
            end
        end

        local select_btn = UIButton:create_switch_button(320,20, 100, 44, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        "", 50, 16, nil, nil, nil, nil, 
        select_fun )
        local select_eq =  one_equip.if_select
        select_btn.set_state( select_eq )
        self.select_btn[index] = select_btn
        one_row:addChild(select_btn.view, 2);
    end 
end

function ItemSmeltRightPage:updata_equip( )
    self.bag_data = ElfinModel:get_right_equip() --存放连续道具信息
    local max = #self.bag_data
    if max == 0 then 
         if self.scroll then 
            self.view:removeChild( self.scroll, true );
            self.scroll = nil
        end
        self.notice = UILabel:create_lable_2("#c00ff00您当前没有可用于熔炼的道具", 58, 293, 18, ALIGN_LEFT )
        self.view:addChild(self.notice)
    else 
        if self.notice then
            self.view:removeChild( self.notice, true ); 
            self.notice = nil
        end 
        local _scroll_info = { x = 7 , y = 5 , width = 380, height = 554, maxnum = max, stype = TYPE_HORIZONTAL }
        
         if self.scroll then 
            self.view:removeChild( self.scroll, true );
            self.scroll = nil
        end

        self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
        self.view:addChild(self.scroll);

        local function scrollfun(eventType, args, msg_id)
            if eventType == nil or args == nil or msg_id == nil then 
                return
            end
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_MOVED then
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            elseif eventType == SCROLL_CREATE_ITEM then

                local temparg = Utils:Split(args,":")
                local row = temparg[1] +1             -- 行

                -- 每行的背景panel
                local new_panel = CCBasePanel:panelWithFile(0,0 ,380,90,"", 600, 600);
                self.scroll:addItem(new_panel);
                self:create_scroll_item( new_panel ,row )
                self.scroll:refresh();
                return false
            end
        end
        self.scroll:registerScriptHandler(scrollfun);
        self.scroll:refresh() 
    end 
end
-- ]]

function ItemSmeltRightPage:update( updateType, param )
    print('--- ItemSmeltRightPage:update: ', updateType)
	if updateType == "refresh" then 
        -- self:updata_equip()
        self:updateScrollPanel()
    elseif updateType == "all"then 
        -- self:updata_equip()
        self:updateScrollPanel()
    elseif updateType == "selectSmeltItem" then
        self:updateScrollPanel()
    elseif updateType == "addBagItem" then
    elseif updateType == "removeBagItem" then
    end 
end
function ItemSmeltRightPage:active(show)
    if show then
    else
    end
end

function ItemSmeltRightPage:destroy( )
end