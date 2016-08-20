-- EntrustWin.lua  
-- created by lyl on 2013-5-16
-- 委托主窗口  entrust_Win

super_class.EntrustWin(NormalStyleWindow)

-- 页号对应的副本id
--历练副本
--心魔幻境
--天魔台
--幻天秘境
--玄天封印
--赏金副本
--诛仙阵
--魔界入口

--副本ＩＤ
local _fuben_id_to_page_index = {   
     EntrustModel.lilianfuben,
     EntrustModel.xinmohuanjing, 
     EntrustModel.tianmota,
     EntrustModel.huantianmijing,
     EntrustModel.xuantianfengyin, 
     EntrustModel.shangjinfuben,
     EntrustModel.zhuxianzhen, 
     EntrustModel.mojierukou,
     }

function EntrustWin:__init( window_name, texture_name )
	-- self.all_page_t = {}              -- 存储所有已经创建的页面
	-- self.current_panel = nil          -- 当前的面板。用于记录 界面。在切换的时候做操作
    self.entrust_page = nil              -- 显示委托信息的页

    local bgPanel = self.view
    
     self.slot_focus_array = {}
    --tab 背景
    self.tab_bg = CCZXImage:imageWithFile(17, 22, 220+5, 537, UILH_COMMON.bottom_bg, 500, 500 );
    self.view:addChild( self.tab_bg,99)


    -- tab按钮
    local but_beg_x = 20                     --按钮起始x坐标
    local but_int_y = 56                     --按钮x坐标间隔
    local but_beg_y = but_int_y * 8 + 28     --按钮起始y坐标

    local temp_button_item = {}
    local button_image_info = {
     { image = UILH_ENTRUST.lilianfuben, index = EntrustModel.lilianfuben },
     { image = UILH_ENTRUST.zhuxianzhen, index = EntrustModel.zhuxianzhen },
     { image = UILH_ENTRUST.shangjinfuben, index = EntrustModel.shangjinfuben },
     { image = UILH_ENTRUST.huantianmijing, index = EntrustModel.huantianmijing },
     { image = UILH_ENTRUST.xinmohuanjing, index = EntrustModel.xinmohuanjing },
     { image = UILH_ENTRUST.mojierukou, index = EntrustModel.mojierukou },
     { image = UILH_ENTRUST.xuantianfengying, index = EntrustModel.xuantianfengyin },
     { image = UILH_ENTRUST.tianmota, index = EntrustModel.tianmota },
    }
    local btn_height = 90
    local btn_width = 205
    local btn_gap_y = 2
    for i = 1, #button_image_info do
        local function btn_fun()
            local temp_index = button_image_info[i].index
            local entrust_win = UIManager:find_visible_window("entrust_Win")
            if entrust_win ~= nil then
                entrust_win:change_page( temp_index )
            end
        end

    local temp  =ZButton:create(nil, "ui2/login/lh_ser_bg.png" , btn_fun, 0, 0, btn_width, btn_height,nil,500,500)
    self.slot_focus_array[i] = MUtils:create_zximg(temp.view,UILH_COMMON.slot_focus,0,0,btn_width+2,btn_height+2)
    local text_img = MUtils:create_zximg(temp.view,button_image_info[i].image,55,33,-1,-1)
    table.insert( temp_button_item, temp )
    end

    local radiobutton = RadioButton:create( nil, 5, 0, btn_width, btn_height * #temp_button_item + btn_gap_y * #temp_button_item, 1)
    for i = 1, #temp_button_item do
        radiobutton:addItem( temp_button_item[i], btn_gap_y, 1 )
    end
    self.radio_buts = radiobutton.view
    self:change_page( 1 )

    local function create_scroll_item_func(  )
        -- local scroll_itme_bg = CCBasePanel:panelWithFile( 18, 22, 145,
        --     but_beg_y - but_int_y * (1 - 1) - ( but_beg_y - but_int_y * (8 -1) ) + 37, "ui/common/bg03.png", 500, 500 );
        --scroll_itme_bg:addChild( self.radio_buts )  -- 因为设置了只有一个项，所以这个面板是不会被干掉的
        return self.radio_buts--scroll_itme_bg
    end
    self.tab_scroll = MUtils:create_one_scroll( 20, 34, 215, 517, 1, "", TYPE_HORIZONTAL, create_scroll_item_func )

        --设置滚动条
    self.tab_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 208 )
    self.tab_scroll:setScrollLumpPos( 205 )
    local arrow_up = CCZXImage:imageWithFile(205 , 506, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(205, 1, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)

     self.tab_scroll:addChild(arrow_up)
     self.tab_scroll:addChild(arrow_down)
    bgPanel:addChild( self.tab_scroll,100 )
    
    --请求副本列表
    EntrustModel:request_depot_item_list()
end


--切换功能窗口:   
function EntrustWin:change_page( fuben_id )
    print( "EntrustWin:change_page~~~~~~", fuben_id )
    -- 测试 =====================================================================
    -- 调坐标动态生效用  =============================================
    -- dofile( "E:/mobile_client/develop/script/UI/entrust/enstrst_win_config.lua" )
    -- if self.entrust_page then
    --     self.view:removeChild( self.entrust_page.view, true )
    --     self.entrust_page = nil
    -- end
    -- =====================================================================
    if EntrustModel.fuben_id_to_page[ fuben_id ] == nil then    -- 如果不存在该id
        fuben_id = EntrustModel.lilianfuben 
    end

    self.radio_buts:selectItem( EntrustModel.fuben_id_to_page[ fuben_id ] - 1)

    for k,v in pairs(self.slot_focus_array) do
        self.slot_focus_array[k]:setIsVisible(false)
    end

    self.slot_focus_array[ EntrustModel.fuben_id_to_page[ fuben_id ]]:setIsVisible(true)
    
    if self.entrust_page == nil then
        self.entrust_page = EntrustPage:create(  )
        self.view:addChild( self.entrust_page.view )
        local parent_size = self.view:getSize()
        local child_size = self.entrust_page.view:getSize()
        self.entrust_page:setPosition(parent_size.width/2 - child_size.width/2,10)
    end
    self.entrust_page:change_page( fuben_id )
end

-- 更新窗口。 静态调用
function EntrustWin:update_win( update_type )
    local win = UIManager:find_visible_window("entrust_Win")
    if win then
        if win.entrust_page then
            win.entrust_page:update( update_type ) 
        end
    end
end

function EntrustWin:destroy()
    Window.destroy(self)
    if self.entrust_page then
        self.entrust_page:destroy()
    end
end
