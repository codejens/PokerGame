-- QihunIntroWin.lua
-- created by xiehande on 2014-10-29
-- 灵器系统器魂一览页面
super_class.QihunIntroWin(Window)
local font_size = 16
local color_type = LH_COLOR[2]
--创建方法
function  QihunIntroWin:create( )
	return QihunIntroWin( "QihunIntroWin", "", true, 880, 500)
end

--初始化
function  QihunIntroWin:__init(window_name, texture_name, is_grid, width, height)
	--背景低图
    local base_bg = CCBasePanel:panelWithFile(8,0,865,500,UILH_COMMON.bottom_bg,500,500);
    self:addChild(base_bg);

    self:create_panel(base_bg)
end

--创建面板
function QihunIntroWin:create_panel(base_bg)

  -- 器魂数据
    local xianhun_infos = FabaoConfig:get_xianhun_intro_info( );
    ---- 器魂列表 panel
    local xianhun_panel = CCBasePanel:panelWithFile(0,0,850,500,"",500,500)
    base_bg:addChild(xianhun_panel);
    
    --往上 往下点击按钮
    local arrow_up = CCZXImage:imageWithFile(851 , 485, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(851, 1, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    xianhun_panel:addChild(arrow_up,1)
    xianhun_panel:addChild(arrow_down,1)

    --总共需要的行数
    local panel_all_info = #xianhun_infos
    local colu_num = 3
    local total_row_num = math.ceil(panel_all_info / colu_num )

    -- scrollView  滑动条
    self.xianhun_scroll = CCScroll:scrollWithFile( 1, 12, 850 , 472, total_row_num, "", TYPE_HORIZONTAL, 600, 600 )
    self.xianhun_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 475/total_row_num )
    
    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then
            local temparg = Utils:Split(arg,":")
            local row = temparg[1]  --行
            local col = temparg[2]  --列
            local index = row * colu_num
            local cell = CCBasePanel:panelWithFile( 0, 0, 0, 0, "")
            local curx = 4
            local cury = 0
                
                --循环创建一列
            for i = 1 , colu_num do
                if xianhun_infos[index + i] then
                    local onecol = XianhunCell:create_for_intro_scroll(0, 0, 280, 114, xianhun_infos[index + i])
                    cell:addChild( onecol.view )
                    onecol.view:setPosition( curx, 4)
                    curx = curx + onecol.view:getSize().width+1    --有商品的列表间距
                    if cury < onecol.view:getSize().height+1   then
                        cury = onecol.view:getSize().height+1 
                    end
                end
            end
            cell:setSize(curx, cury)
            self.xianhun_scroll:addItem(cell)
            self.xianhun_scroll:refresh()
            return true

        end
    end
    
    self.xianhun_scroll:registerScriptHandler(scrollfun)
    self.xianhun_scroll:refresh()
    xianhun_panel:addChild(self.xianhun_scroll);
    return bg_panel
end