-- ActiTemplateWin.lua  
-- created by chj on 2015.2.11
-- 各种活动的展示窗口  
super_class.ActiTemplateWin(NormalStyleWindow)

-- 初始化
function ActiTemplateWin:__init(  )

    -- 分页保存表 & 选中框
    self.page_table_sld = {}
    self.item_scroll = {}
    self.item_frame_sld = {}


	-- 创建主界面
    local temp = ActiTemplateModel:get_panelbase_conf( )
	self.panel_base = CCBasePanel:panelWithFile( temp.x, temp.y, temp.width, temp.height, temp.image, 500, 500)
	self.view:addChild(self.panel_base)

	self:create_panel_left()
	self:create_panel_right()
end

-- ==================================================
-- 创建分界线---------------------------------------
-- ==================================================
--- 左面板 ----
function ActiTemplateWin:create_panel_left( )
    local temp = ActiTemplateModel:get_panel_panelleft_conf()
	self.panel_left = CCBasePanel:panelWithFile( 22, 30, 235, 520, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild(self.panel_left)
    if ActiTemplateModel:get_acti_include_num() > 0 then
	   self:create_scroll_left(self.panel_left)
    end
end

-- 左面板 scrollview
function ActiTemplateWin:create_scroll_left( panel )
    local num_acti_inc = ActiTemplateModel:get_acti_include_num()

    -- 创建scrollview
    local scroll_info = ActiTemplateModel:get_scrollleft_conf( )
    local scroll_item = ActiTemplateModel:get_scrollitem_conf( )
    self.scroll_left = CCScroll:scrollWithFile( scroll_info.x, scroll_info.y, 
            scroll_info.width, scroll_info.height, scroll_info.maxnum, scroll_info.image, scroll_info.stype )

    local function scrollfun(eventType, args, msg_id)
        if (eventType or args or msg_id) == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args, ":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x + 1

            -- 创建scroll item
            local panel_scroll = CCBasePanel:panelWithFile( 0, 0, scroll_info.width, num_acti_inc*scroll_item.height, scroll_item.image)
            for i=1, num_acti_inc do
                self.item_scroll[i] = self:create_scroll_item(panel_scroll, i)
            end

            self.scroll_left:addItem(panel_scroll)
            self.scroll_left:refresh();
            return false
        end
    end
    self.scroll_left:registerScriptHandler(scrollfun)
    self.scroll_left:refresh();

    panel:addChild( self.scroll_left );
end

-- 创建scorll_item
function ActiTemplateWin:create_scroll_item( panel, index )
    -- 包含活动个数
    local num_acti_inc = ActiTemplateModel:get_acti_include_num()
    -- item的主面板 (由main_conf控制)
    local temp_item = ActiTemplateModel:get_scrollitem_conf( )
    local panel_item = CCBasePanel:panelWithFile( temp_item.x, temp_item.height*( num_acti_inc-index), 
                                        temp_item.width, temp_item.height, temp_item.image, 500, 500 )

    -- 添加item 图标 (由temp_pic控制) ----------------------------------------
    local temp_item_inc = ActiTemplateModel:get_acti_include_index( index )
    --
    local temp_pic = temp_item_inc.item_pic
    local temp_pic_y = temp_pic.y or (temp_item.height-temp_pic.height)*0.5
    local item_pic = MUtils:create_slot_item2( panel_item, temp_pic.image_bg, 
                                temp_pic.x, temp_pic_y, temp_pic.width, temp_pic.height, nil, nil, temp_pic.offset )
    item_pic:set_icon_texture( temp_pic.image, temp_pic.x, temp_pic_y, temp_pic.width, temp_pic.height )

    -- item 点击事件
    local function selected_change( eventType )
        self:select_page(index, self.panel_right)
        return true;
    end 
    item_pic:set_click_event(selected_change);


    -- item的美术描述字 --------------------------------
    local temp_title = temp_item_inc.item_title
    local temp_title_x = temp_title.x or temp_pic.x+temp_pic.offset+temp_pic.width
    local item_title = CCBasePanel:panelWithFile( temp_title_x, temp_title.y, 
                                temp_title.width, temp_title.height, temp_title.image )
    panel_item:addChild( item_title)

    panel:addChild( panel_item)
    return panel_item
end

-- 选择分页
function ActiTemplateWin:select_page( index, panel)
    print("--------index:", index)
    
    local temp_item_inc = ActiTemplateModel:get_acti_include_index( index )
    if not temp_item_inc then
        return 
    end

    -- 活动的标题背景 & 标题(先删除再创建)
    if self.title_page then
        self.title_page:removeFromParentAndCleanup(true)
        self.title_page = nil
    end
    for k,v in pairs(self.title_bg) do
        v:removeFromParentAndCleanup(true)
        v = nil
    end
    local temp_tb = temp_item_inc.title_bg
    if temp_tb then
        for i=1, #temp_tb do
            self.title_bg[i] = CCBasePanel:panelWithFile( temp_tb[i].x, temp_tb[i].y,
                                    temp_tb[i].width, temp_tb[i].height, temp_tb[i].image )
            panel:addChild( self.title_bg[i])
            if temp_tb[i].flipx then
                self.title_bg[i]:setFlipX(true)
            end
        end
    end

    local temp_title_page = temp_item_inc.title_page
    self.title_page = CCBasePanel:panelWithFile(temp_title_page.x, temp_title_page.y, 
        temp_title_page.width, temp_title_page.height, temp_title_page.image )
    panel:addChild( self.title_page)
    if temp_title_page.flipx then
        self.title_page:setFlipX(true)
    end

    -- 活动时间 & title ---------------------------
    local temp_title_1 = temp_item_inc.title_time_acti
    self.title_1:setPosition( temp_title_1.x, temp_title_1.y)
    self.title_1:setText( temp_title_1.text)
    self.title_1:setFontSize( temp_title_1.font_size)
    -- 时间
    local temp_time = temp_item_inc.time_acti
    self.time_acti:setPosition( temp_time.x, temp_time.y)
    self.time_acti:setFontSize( temp_time.font_size)
    self.time_acti:setText( temp_time.text)

    -- 活动说明 title-----------------------------------
    local temp_title_2 = temp_item_inc.title_desc_acti
    self.title_2:setPosition( temp_title_2.x, temp_title_2.y)
    self.title_2:setText( temp_title_2.text)
    self.title_2:setFontSize ( temp_title_2.font_size)
    -- 说明内容
    local temp_desc = temp_item_inc.desc_acti
    self.desc_acti:setLineEmptySpace( temp_desc.line_space)
    self.desc_acti:setPosition( temp_desc.x, temp_desc.y)
    self.desc_acti:setFontSize( temp_desc.font_size);
    self.desc_acti:setText( temp_desc.text); 
    self.desc_acti:setTag( 0)

    -- 剩余时间 & title -----------------------------
    local temp_title_3 = temp_item_inc.title_time_remain
    self.title_3:setPosition( temp_title_3.x, temp_title_3.y)
    self.title_3:setText( temp_title_3.text)
    self.title_3:setFontSize ( temp_title_3.font_size)
    if self.timerlable_remain then
        self.timerlable_remain:destroy()
        self.timerlable_remain = nil
    end
    -- "活动结束"
    if self.time_remain then
        self.time_remain:removeFromParentAndCleanup(true)
        self.time_remain = nil
    end
    local temp_time_remain = temp_item_inc.time_remain
    self.time_remain = UILabel:create_lable_2( temp_time_remain.text, 
        temp_time_remain.x, temp_time_remain.y, temp_time_remain.font_size, temp_time_remain.align) 
    panel:addChild( self.time_remain)

    -- 分页小贴士 ----------------------------------
    local temp_tip_page = temp_item_inc.tip_page
    if self.tip_page then
        self.tip_page:removeFromParentAndCleanup(true)
    end
    self.tip_page = CCBasePanel:panelWithFile(temp_tip_page.x, temp_tip_page.y, 
        temp_tip_page.width, temp_tip_page.height, temp_tip_page.image )
    panel:addChild( self.tip_page)

    -- 创建分页界面
    self:select_update_page( index, panel)
end

-- 选择的时更新分页
function ActiTemplateWin:select_update_page( index, panel)

    -- 选中框
    local temp_sld_frame = ActiTemplateModel:get_sld_frame_conf( )
    for k,v in pairs(self.item_frame_sld) do
        if v then
            v:setIsVisible(false)
        end
    end
    if self.item_frame_sld[index] then
        self.item_frame_sld[index]:setIsVisible(true)
    else
        local temp_frame_sld = ActiTemplateModel:get_sld_frame_conf( )
        self.item_frame_sld[index] = CCBasePanel:panelWithFile( temp_frame_sld.x, temp_frame_sld.y,
            temp_frame_sld.width, temp_frame_sld.height, temp_frame_sld.image )
        self.item_scroll[index]:addChild( self.item_frame_sld[index])
    end

    -- 分页处理 ---------------------------------------------
    local temp_item_inc = ActiTemplateModel:get_acti_include_index( index )
    if not temp_item_inc then
        return 
    end
    -- 设置以创建的隐藏
    for k,v in pairs(self.page_table_sld) do
        if v then
            v.view:setIsVisible(false)
        end
    end
    -- 创建或显示
    if self.page_table_sld[index] then
        self.page_table_sld[index].view:setIsVisible(true)
    else
        local page_class = ActiTemplateModel:get_page_group_index( index)
        if page_class then
            local temp_panel_page = temp_item_inc.panel_page
            self.page_table_sld[index] = page_class:create( panel, temp_panel_page.x, temp_panel_page.y, 
                temp_panel_page.width, temp_panel_page.height, temp_panel_page.image)
        end
    end
end

--- 右面板 ---
function ActiTemplateWin:create_panel_right()
    local temp = ActiTemplateModel:get_panel_panelright_conf()
	self.panel_right = CCBasePanel:panelWithFile( temp.x, temp.y, temp.width, temp.height, temp.image, 500, 500)
	self.view:addChild( self.panel_right)

    self:create_acti_intro( self.panel_right)
end

-- 创建活动说明(右面板)
function ActiTemplateWin:create_acti_intro( panel)

    -- 标题背景 & 标题
    self.title_bg = {}
    self.title_page = nil
    -- 活动时间 =======================
    self.title_1 = UILabel:create_lable_2( LH_COLOR[1] .. "活动时间:", 100, 430, 16, ALIGN_RIGHT) 
    panel:addChild(self.title_1)
    --
    self.time_acti = UILabel:create_lable_2( "2015.2.12-2015.2.12", 100, 430, 16, ALIGN_LEFT)
    panel:addChild(self.time_acti)

    -- 活动说明 ========================
    self.title_2 = UILabel:create_lable_2( LH_COLOR[1] .. "活动说明:", 100, 410, 16, ALIGN_RIGHT) 
    panel:addChild( self.title_2)
    --
    self.desc_acti = CCDialogEx:dialogWithFile(100, 430, 430, 80, 16, "", TYPE_VERTICAL, ADD_LIST_DIR_UP);
    self.desc_acti:setAnchorPoint(0,1);
    panel:addChild( self.desc_acti)

    -- 活动剩余时间 ====================
    self.title_3 = UILabel:create_lable_2( LH_COLOR[1] .. "剩余时间:", 100, 390, 16, ALIGN_RIGHT) 
    panel:addChild(self.title_3)
    self.time_remain = nil
    self.timerlable_remain = nil

    -- 分页标题
    self.tip_page = CCBasePanel:panelWithFile(0, 350, -1, -1, "ui/lh_openser/tips.png")
    panel:addChild( self.tip_page)
end


-- ==================================================
-- 更新分界线---------------------------------------
-- ==================================================

-- 显示(打开窗口触发)
function ActiTemplateWin:active( show )
	-- not using
    self:select_page(1, self.panel_right)
end

-- 更新
function ActiTemplateWin:update( activity_id )
	
end

-- ==================================================
-- 销毁分界线---------------------------------------
-- ==================================================
-- 销毁
function ActiTemplateWin:destroy( )
    Window.destroy(self)
end