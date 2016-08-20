-- ExchangeWin.lua  
-- created by lyl on 2013-2.19
-- 兑换主窗口  exchange_win

super_class.ExchangeWin(NormalStyleWindow);


-- 数字与 类型名称 的映射
local _index_to_category_name = { [1] = "equipment", [2] = "material", [3] = "glory" }

function ExchangeWin:__init( window_name, texture_name )
    local bgPanel = self.view

    --来点福利
    ZImage:create(self.view,"nopack/girl.png",-183,-16,-1,-1)
    --self.but_name_t = {} -- RadioButton有选中与未选中两种状态,此处保存分别对应于两种状态的按钮名称图片
    
    -- 侧面所有按钮
    local but_beg_x = 151            -- 按钮起始x坐标
    local but_beg_y = 522           -- 按钮起始y坐标
    local but_int_x = 100           -- 按钮x坐标间隔
    local but_width = 100
    local but_height = 45
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , but_int_x * 3, but_height,nil)
    bgPanel:addChild(self.raido_btn_group)
    self:create_text_button(self.raido_btn_group, 0, 1, but_width, but_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light,Lang.exchange.tag_text1, 18,1 )
    self:create_text_button(self.raido_btn_group, 100, 1, but_width, but_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light,Lang.exchange.tag_text2,18, 2 )
    self:create_text_button(self.raido_btn_group, 200, 1, but_width, but_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light,Lang.exchange.tag_text3,18 ,3 )

    -- 默认第一项被选中
   -- self.but_name_t[1].change_to_selected()

        --modified by zyz,增加以下几行新代码
    --------------------------------------------------------------------------------------------
    local panel_width = 742
    local panel = CCBasePanel:panelWithFile( 130,8, panel_width+20, 520, UILH_COMMON.normal_bg_v2,500, 500);
    bgPanel:addChild(panel)
    --第二层底图
    local bgPanel_1 = CCBasePanel:panelWithFile( 0,0, panel_width, 452, UILH_COMMON.bottom_bg,500, 500);
    local bgPanel_h = bgPanel_1:getSize().height
    bgPanel_1:setPosition(but_beg_x-12,but_beg_y-bgPanel_h+5-10)
    bgPanel:addChild( bgPanel_1 )

    --滑块上 
    local scrollbar_up = ZImage:create(bgPanel_1,UIPIC_DREAMLAND.scrollbar_up,724,434,-1,-1)
    -- 出售列表
    self.exchange_list = ExchangeList:create(  )
    self.exchange_list.view:setPosition( 0, 5 )

    bgPanel_1:addChild( self.exchange_list.view )
    local scrollbar_down = ZImage:create(bgPanel_1,UIPIC_DREAMLAND.scrollbar_down,724,6,-1,-1)

    --文字底图
    local text_panel  = CCBasePanel:panelWithFile(but_beg_x-8,15,panel_width,60,"",500,500)
    bgPanel:addChild(text_panel)
    local suochililian = UILabel:create_lable_2(LH_COLOR[13]..Lang.exchange.liliang, 39, 20, 16, ALIGN_LEFT )
    text_panel:addChild( suochililian )

    -- 历练值的底图标签
    --local lilianBg = CCBasePanel:panelWithFile( 113, 10, 120, 31, UI_EXCHANGE_010, 500, 500 )
    --CCZXImage:imageWithFile( 110, 10, 120, 31, UI_EXCHANGE_010 )
  --  bgPanel_1:addChild( lilianBg )

    self.lilian = UILabel:create_lable_2( LH_COLOR[2].."0", 90, 20, 14, ALIGN_LEFT )
    text_panel:addChild( self.lilian )   
--    self:update_lilian(  )

    -- 荣誉
   -- local suochirongyu = CCZXImage:imageWithFile( 260+65, 15, -1, -1, UIResourcePath.FileLocate.other .. "suochirongyu.png");  --头部
     -- local suochirongyu = ZTextButton:create(nil,Lang.exchange.rongyu,nil,nil,335, 20, 150, 30)
     -- suochirongyu:setFontSize(13)
 local suochirongyu = UILabel:create_lable_2(LH_COLOR[13]..Lang.exchange.rongyu, 356, 36, 16, ALIGN_LEFT )
    bgPanel:addChild( suochirongyu )
    self.honor = UILabel:create_lable_2( LH_COLOR[2].."0", 280, 20, 16, ALIGN_CENTER )
    text_panel:addChild( self.honor )
    self:update_honor(  )  

    -- 获取说明
    local function explain_but_fun( eventType,x,y )
    	if eventType == TOUCH_CLICK then 
            ExchangeModel:chow_get_explain(  )
        end
        return true
    end
   --问题图片
   local wenhao = MUtils:create_btn(bgPanel,LH_UI_EXCHANGE_003,LH_UI_EXCHANGE_003,explain_but_fun,691,24,-1,-1)
   --获取说明
   local explain_but = UIButton:create_button( 596, 16, -1, -1, LH_UI_EXCHANGE_004, LH_UI_EXCHANGE_004, LH_UI_EXCHANGE_004)
   explain_but:registerScriptHandler( explain_but_fun )
   text_panel:addChild( explain_but )
end

-- 提供外部静态调用的更新窗口方法
function ExchangeWin:update_win( update_type )
    local win = UIManager:find_visible_window("exchange_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

-- 更新数据
function ExchangeWin:update( update_type )
    if update_type == "lilian" then
        self:update_lilian(  )
    elseif update_type == "honor" then 
        self:update_honor( )      -- -- 新界面布局中，去掉了显示荣誉值(所持荣誉)
    elseif update_type == "all" then
        self:update_all(  )
    else
        
    end
end

-- 更新历练值
function ExchangeWin:update_lilian(  )
	local lilian = ExchangeModel:get_player_lilian(  )
	self.lilian:setString( LH_COLOR[2]..lilian )
end

-- 更新荣誉值
function ExchangeWin:update_honor(  )
    local honor = ExchangeModel:get_player_honor()
    self.honor:setString( LH_COLOR[2]..honor )
end

-- 所有数据更新
function ExchangeWin:update_all( )
	self:update_lilian(  )
    self:update_honor();      -- 新界面布局中，去掉了显示荣誉值(所持荣誉)
end

-- 激活时更新数据
function ExchangeWin:active( show )
    self:update("all")
    -- 新手指引代码
    --[[if ( XSZYManager:get_state() == XSZYConfig.DUI_HUAN_ZY ) then 
        if ( show ) then 
            
            -- 指向武器兑换按钮 215,345,60, 31
            local function cb ()
                local equip_table = ExchangeModel:get_category_items( "equipment" );
                local item_id = equip_table[1];
                local level = ExchangeModel:get_item_need_level( item_id ) or "";
                local price_name, price_value = ExchangeModel:get_item_need_money( item_id );
                ExchangeModel:show_buy_keyboard( item_id, level, price_value);
                -- XSZYManager:unlock_screen( );
            end
            --XSZYManager:lock_screen( 213,346,60,32 ,cb,3 )
            XSZYManager:lock_screen_by_id( XSZYConfig.DUI_HUAN_ZY, 2, cb );
        else
            local help_win = UIManager:find_visible_window("help_panel")
            if help_win ~= nil then
                UIManager:hide_window("help_panel")
            end
            -- 继续执行任务
            AIManager:do_quest(XSZYManager:get_data(),1);
            XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );
        end
    end--]]
end

function ExchangeWin:destroy()
    Window.destroy(self)
    self.exchange_list:destroy()
end

function ExchangeWin:change_page( page_index )
    self.exchange_list:Choose_panel( _index_to_category_name[page_index] )
    self.raido_btn_group:selectItem(page_index-1);
end

-- 父panel,相对于panel的x坐标,相对于panel的y坐标,按钮宽,按钮高,未被选中时的贴图,选中情况下的贴图
-- 按钮未被选中的状态下嵌入的文字贴图,按钮被选中时嵌入的文字贴图,文字贴图的相对坐标x,文字贴图的相对坐标y,按钮编号

-- function ExchangeWin:create_a_button( panel, pos_x, pos_y, size_w, size_h, image_n, image_s, but_name_n,but_name_s, name_x, name_y, but_index )
--     -- 创建按钮,添加被点击时,切换贴图
--     local radio_button = CCRadioButton:radioButtonWithFile( pos_x, pos_y, size_w, size_h, image_n )
--     radio_button:addTexWithFile( CLICK_STATE_DOWN, image_s )

--     -- 创建按钮名称贴图,按钮有选中和未选中两种状态,两种状态下,使用不同的文字贴图
--     self.but_name_t[but_index] = ExchangeWin:create_but_name( but_name_n, but_name_s, name_x, name_y )
--     -- 将按钮文字添加进radio_button的孩子列表
--     radio_button:addChild( self.but_name_t[but_index].view )
--     -- RadioButton被点击后的回调函数
--     local function radio_button_callback( eventType, x, y )
--         if eventType == TOUCH_BEGAN or eventType == TOUCH_ENDED then
--             return true
--         elseif eventType == TOUCH_CLICK then
--             print("选中")
--             self:change_page( but_index )
--             -- 切换所有RadioButton文字贴图至未选中
--             for k,v in pairs( self.but_name_t ) do
--                 v.change_to_no_selected()
--             end
--             -- 切换当前被选中的RadioButton文字贴图至选中
--             self.but_name_t[but_index].change_to_selected()
--             return true
--         end
--     end
--     -- 注册
--     radio_button:registerScriptHandler( radio_button_callback )

--     -- 加入group
--     panel:addGroup( radio_button )
-- end

 function ExchangeWin:create_text_button( panel, pos_x, pos_y, size_w, size_h, image_n, image_s, text , fontsize,but_index )
     -- 创建按钮,添加被点击时,切换贴图
    local radio_button = CCRadioButton:radioButtonWithFile( pos_x, pos_y, size_w, size_h, image_n )
    radio_button:addTexWithFile( CLICK_STATE_DOWN, image_s )

    -- 创建按钮名称贴图,按钮有选中和未选中两种状态,两种状态下,使用不同的文字贴图
    --self.but_name_t[but_index] = ExchangeWin:create_but_name( but_name_n, but_name_s, name_x, name_y )
    local text =  UILabel:create_lable_2( text, 0, 0, fontsize)
    radio_button:addChild(text)
    text:setPosition(radio_button:getSize().width/2 - text:getSize().width/2,radio_button:getSize().height/2 - text:getSize().height/2)
    -- 将按钮文字添加进radio_button的孩子列表
   -- radio_button:addChild( self.but_name_t[but_index].view )
    -- RadioButton被点击后的回调函数
    local function radio_button_callback( eventType, x, y )
        if eventType == TOUCH_BEGAN or eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( but_index )
            return true
        end
    end
    -- 注册
    radio_button:registerScriptHandler( radio_button_callback )

    -- 加入group
    panel:addGroup( radio_button )
end


-- function ExchangeWin:create_but_name( but_name_n, but_name_s, name_x, name_y )
--     -- body
--     local button_name = CCZXImage:imageWithFile( name_x, name_y, -1, -1, but_name_n )
    
--     local _script_object = {}
--     -- 按钮被选中时,调用函数切换贴图至but_name_s
--     _script_object.change_to_selected = function ()
--         button_name:setTexture( but_name_s )
--     end

--     -- 按钮由被选中切换至未选中时,调用函数切换贴图至but_name_n
--     _script_object.change_to_no_selected = function ()
--         button_name:setTexture( but_name_n )
--     end

--     _script_object.view = button_name

--     return _script_object
--end