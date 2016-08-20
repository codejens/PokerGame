-- ScoreExchangePage.lua  
-- created by zyb on 2014-4-10
-- 聚仙令——积分兑换 分页  

super_class.ScoreExchangePage()

local fuben_id = {81,82,83}

-- 每行的道具个数
local ITEMS_COUNT_PER_LINE = 3
-- 道具图标高宽
local ITEM_ICON_W = 200
local ITEM_ICON_H = 130
-- x间距，y间距
local ITEM_SP_X = 3
local ITEM_SP_Y = 5

function ScoreExchangePage:create(  )
    -- local temp_panel_info = { texture = "", x = 10, y = 12, width = 760, height = 355 }
	return ScoreExchangePage()
end

function ScoreExchangePage:__init()
    require "../data/teampoint_shop_config"

    self.view = CCBasePanel:panelWithFile( 5, 8, 890, 518, UILH_COMMON.normal_bg_v2, 500, 500 )

    self.items_cfg = teampoint_shop_config
	--当前分页道具的配置数据
	self.curr_page = 1

    -- 上侧背景
    ZImage:create(self.view, UILH_COMMON.bottom_bg,10,82,868,425, 0,500,500)

    -- 底部横条
    ZImage:create(self.view, UILH_NORMAL.title_bg_selected,15,13,858,65, 1,500,500)
    -- “当前拥有：”
    ZLabel:create(self.view, Lang.juxianling[11], 23, 40, 16, ALIGN_LEFT, 1)    -- [11] = "当前拥有：",
    -- 底部令牌的坐标和间距
    local sx2 = 205
    local sy2 = 40
    local spx2 = 200
    -- (玄令) (地令) (天令)
    ZLabel:create(self.view, Lang.juxianling[3], sx2,        sy2, 16, ALIGN_LEFT, 1)
    ZLabel:create(self.view, Lang.juxianling[4], sx2+spx2,   sy2, 16, ALIGN_LEFT, 1)
    ZLabel:create(self.view, Lang.juxianling[5], sx2+spx2*2, sy2, 16, ALIGN_LEFT, 1)
    -- 3令的剩余数量
    self.token_count_txt = {}
    self.token_count_txt[1] = ZLabel:create(self.view, string.format("%s%d","#cffff00",0), sx2+53,        sy2, 16, ALIGN_LEFT, 1)
    self.token_count_txt[2] = ZLabel:create(self.view, string.format("%s%d","#cffff00",0), sx2+53+spx2,   sy2, 16, ALIGN_LEFT, 1)
    self.token_count_txt[3] = ZLabel:create(self.view, string.format("%s%d","#cffff00",0), sx2+53+spx2*2, sy2, 16, ALIGN_LEFT, 1)
    -- 3令的图标
    ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.lh_juxianling,"token_img1.png"),sx2-70     ,10,63,66, 1)
    ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.lh_juxianling,"token_img2.png"),sx2-70+spx2  ,10,63,66, 1)
    ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.lh_juxianling,"token_img3.png"),sx2-70+spx2*2,10,63,66, 1)

	self:create_left_btns_panel()
	self:create_right_scroll_panel()

	
end

-- 创建左侧按钮列表
function ScoreExchangePage:create_left_btns_panel()
    -- 背景
    ZImage:create(self.view, UILH_COMMON.bg_10,15,90,245,410, 0,500,500)

	local sx = 5
	local sy = 290
	local spy = 140
	self.radio_group = CCRadioButtonGroup:buttonGroupWithFile(20,95, 235,400,nil);
	self.view:addChild(self.radio_group)
    -- 选中框
    self.selected_img = CCZXImage:imageWithFile( sx-7, sy-10, -1, -1, UILH_JUXIANLING.select_img )
    self.radio_group:addChild(self.selected_img,10)

    -- [18] = "玄.令",[19] = "地.令",[20] = "天.令",
    self.left_btn_title = {Lang.juxianling[18],Lang.juxianling[19],Lang.juxianling[20],}
	for i=1,3 do
		self:create_left_btns(self.radio_group, i, sx, sy-(i-1)*spy)
	end
end
-- 创建右侧道具列表
function ScoreExchangePage:create_right_scroll_panel()
	self.scroll_container = CCBasePanel:panelWithFile( 265, 95, 610, 405, "")
	self.view:addChild(self.scroll_container)
	self.items_scroll = self:create_scroll_area( self.items_cfg[self.curr_page],0,0, 610, 405, 3, 3, "")
	self.scroll_container:addChild(self.items_scroll)
    self:change_right_page(1)
end
-- 创建左边3个令对应的按钮
function ScoreExchangePage:create_left_btns(panel, btn_index, pos_x, pos_y)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, 219, 107, UILH_JUXIANLING.radio_button)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,UILH_JUXIANLING.radio_button)
	local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_right_page( btn_index )
            self.selected_img:setPosition(pos_x-7, pos_y-10)
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)
    --按钮显示的名称
    local icon_img = ZImage:create(radio_button, string.format("%s%s%d%s",UIResourcePath.FileLocate.lh_juxianling,"token_img",btn_index,".png"),10,-1,-1,-1, 1)
    local name_img = MUtils:create_zxfont(radio_button,self.left_btn_title[btn_index],127,46,1,18);  
    return radio_button
end

-- 切换各种令对应的兑换
function ScoreExchangePage:change_right_page( btn_index )
    self.curr_page = btn_index
    self.items_scroll:clear()
    -- self.items_scroll:autoAdjustItemPos(true)
    -- local maxLine = math.ceil(#self.items_cfg[self.curr_page]/ITEMS_COUNT_PER_LINE)
    local maxLine = math.ceil(#self.items_cfg[self.curr_page].secClasses[1].items/ITEMS_COUNT_PER_LINE)
    if maxLine <= 0 then 
        maxLine = 1
    end
    self.items_scroll:setMaxNum(maxLine)
    self.items_scroll:refresh()
end

--
function ScoreExchangePage:create_one_row2( pos_x, pos_y, width, height, texture_name, index, row_date )
    local panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name);
    for i=1,ITEMS_COUNT_PER_LINE do
        local data = self.items_cfg[self.curr_page]["secClasses"][1]["items"][(index-1)*ITEMS_COUNT_PER_LINE+i]
        if(data) then
            local per_t = {}
            per_t.view              = CCBasePanel:panelWithFile( (ITEM_ICON_W+ITEM_SP_X)*(i-1),ITEM_SP_Y, ITEM_ICON_W, ITEM_ICON_H, UILH_COMMON.bottom_bg,500,500 );
            panel:addChild(per_t.view)
            per_t.token_icon        = ZImage:create(per_t.view, string.format("%s%s%d%s",UIResourcePath.FileLocate.lh_juxianling,"token_img",TeamActivityMode:get_index_by_type(data["price"][1]["type"]),".png"),107,42,42,44, 1)
            local item_name_bg = ZImage:create(per_t.view, UILH_NORMAL.title_bg5,4,90,ITEM_ICON_W-8,36, 1,500,500)
            local item_name = ItemConfig:get_item_name_by_item_id( data.itemID )
            per_t.item_name_label   = ZLabel:create(item_name_bg, string.format("%s%s","#cffff00",item_name), (ITEM_ICON_W-8)/2, 10, 16, ALIGN_CENTER, 1)
            per_t.slot_item         = MUtils:create_slot_item2(per_t.view,UILH_COMMON.slot_bg,22,13,68,68,data.itemID,nil,6);
            per_t.slot_item:set_color_frame(data.itemID, 0, 0, 68, 68);
            per_t.cost_count        = ZLabel:create(per_t.view, string.format("%s%s","#cffff00",data["price"][1]["price"]), 151, 60, 14, ALIGN_LEFT,   1)
            local function btn_fun(eventType)
                -- if eventType == TOUCH_CLICK then
                    local info = {
                        [1] = data["price"][1]["price"],                     --单价
                        [2] = TeamActivityMode:get_tokens_name_by_type(data["price"][1]["type"]), --货币名字
                        [3] = TeamActivityMode:get_tokens_count_by_type(data["price"][1]["type"]), --拥有对应的货币数量
                        [4] = self.curr_page     --对应的道具分组
                    }
                    local function buy_callBack()
                        TeamActivityCC:req_token_count("token")
                    end 
                    BuyKeyboardWin:show(data.itemID,buy_callBack,200,99,info)
                -- end
            end 
            
            per_t.exchange_btn = ZButton:create(per_t.view, UILH_COMMON.button8, btn_fun, 110, 5, 77, 40 )
            per_t.exchange_btn:addImage(CLICK_STATE_DISABLE,UILH_COMMON.lh_button2_disable)
            per_t.exchange_btn.view:setCurState(CLICK_STATE_UP)
            MUtils:create_zxfont(per_t.exchange_btn,Lang.juxianling[12],77/2,13,2,16);  -- [12] = "兑换",

        end
    end
    return panel;
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function ScoreExchangePage:create_scroll_area( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #self.items_cfg[self.curr_page] / colu_num )
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
	-- scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 4, 40, size_h / 2)
    scroll:setEnableScroll(false)
    local had_add_t = {}
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
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x + 1
            local row = self:create_one_row2( 0, 0, size_w, ITEM_ICON_H+ITEM_SP_Y, "", index, self.items_cfg[self.curr_page] )
            scroll:addItem( row )
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

function ScoreExchangePage:update(update_type)

        self.token_count_txt[1]:setText(string.format("%s%d","#cffff00",TeamActivityMode:get_tokens_count()[1]))
        self.token_count_txt[2]:setText(string.format("%s%d","#cffff00",TeamActivityMode:get_tokens_count()[2]))
        self.token_count_txt[3]:setText(string.format("%s%d","#cffff00",TeamActivityMode:get_tokens_count()[3]))

end