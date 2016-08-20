-- UserExchangePanelPanel.lua  
-- created by lyl on 2013-2.19
-- 兑换主窗口  exchange_win

super_class.UserExchangePanel();

-- 数字与 类型名称 的映射
local _index_to_category_name = { [1] = "equipment", [2] = "material", [3] = "glory" }

function UserExchangePanel:__init(father_Panel )
    local bgPanel = self.view

--new code
    -- 侧面所有按钮
    local but_beg_x = 17           -- 按钮起始x坐标
    local but_beg_y = 112          -- 按钮起始y坐标
    local but_int_y = 94          -- 按钮y坐标间隔
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , 50, but_int_y * 3,nil)
    bgPanel:addChild(self.raido_btn_group)
    self:create_a_button(self.raido_btn_group, 1, 1 + but_int_y * (3 - 1), 35, 93, UIResourcePath.FileLocate.common .. "xxk-1.png", UIResourcePath.FileLocate.common .. "xxk-2.png", UIResourcePath.FileLocate.shop .. "zhuangbei.png",-1, -1, 1, 5, -2)
    self:create_a_button(self.raido_btn_group, 1, 1 + but_int_y * (2 - 1), 35, 93, UIResourcePath.FileLocate.common .. "xxk-1.png", UIResourcePath.FileLocate.common .. "xxk-2.png", UIResourcePath.FileLocate.normal .. "material.png",-1, -1, 2, 5, -2)
    self:create_a_button(self.raido_btn_group, 1, 1 + but_int_y * (1 - 1), 35, 93, UIResourcePath.FileLocate.common .. "xxk-1.png", UIResourcePath.FileLocate.common .. "xxk-2.png", UIResourcePath.FileLocate.normal .. "rongyuduihuan.png",-1, -1, 3, 5, -2)

        --modified by zyz,增加以下几行新代码
    --------------------------------------------------------------------------------------------
    local bgPanel_1 = CCBasePanel:panelWithFile( 48, 10, 700, 386, UIPIC_GRID_nine_grid_bg3,500, 500);  --第二层底图
    bgPanel:addChild( bgPanel_1 )

    --历练文字后面的背景条
    local font_bg = CCZXImage:imageWithFile( 2, 1, 696, 30, UIResourcePath.FileLocate.common .. "quan_bg.png",500,500);  --头部
    bgPanel_1:addChild( font_bg )

    -- 关闭按钮
    -- local function close_but_CB( )
    --     UIManager:hide_window( "exchange_win" )
    -- end
    -- local close_but = UIButton:create_button_with_name( 0, 0, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = bgPanel:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )  
    -- bgPanel:addChild( close_but )

    -- 出售列表
    self.exchange_list = ExchangeList:create(  )
    --modified by zyz,old code
    -- bgPanel:addChild( self.exchange_list.view )
    --new code
        bgPanel_1:addChild( self.exchange_list.view )


    -- 所持有历练
    local suochililian = CCZXImage:imageWithFile( 46, 12, 94, 28, UIResourcePath.FileLocate.other .. "own_practice.png");  --头部
    bgPanel:addChild( suochililian )
    self.lilian = UILabel:create_lable_2( "#cffffff".."0", 170, 18, 16, ALIGN_CENTER )
    bgPanel:addChild( self.lilian )
    self:update_lilian(  )

    -- 荣誉
    local suochililian = CCZXImage:imageWithFile( 260+65, 15, -1, -1, UIResourcePath.FileLocate.other .. "suochirongyu.png");  --头部
    -- local suochirongyu = ZTextButton:create(nil,"#cffff00所持荣誉:",nil,nil,335, 20, 150, 30)
    -- suochirongyu:setFontSize(13)

    bgPanel:addChild( suochililian )
    self.honor = UILabel:create_lable_2( "#cffff00".."0", 450, 18, 16, ALIGN_CENTER )
    bgPanel:addChild( self.honor )
    self:update_honor(  )  

    -- 获取说明
    local function explain_but_fun( eventType,x,y )
    	-- if eventType == TOUCH_CLICK then 
            ExchangeModel:chow_get_explain(  )
        -- end
        return true
    end
    -- local explain_but = MUtils:creat_mutable_btn( 610, 15, {x=0, y=0, w=25, h=25}, UIResourcePath.FileLocate.normal .. "common_question_mark.png",{x=35, y=2, w=63, h=18}, UIResourcePath.FileLocate.other .. "get_explain.png", explain_but_fun )
   -- local explain_but = CCTextButton:textButtonWithFile(610, 15, 150, 30, "获取说明", "");
   --  explain_but:setFontSize(17)

    local explain_but = ZTextButton:create(nil,"     获取说明",nil,explain_but_fun,635, 20, 150, 30)
    explain_but:setFontSize(13)

    local question_mark = CCZXImage:imageWithFile( 1,-7, -1, -1, UIResourcePath.FileLocate.normal .. "common_question_mark.png");  --头部
    explain_but:addChild(question_mark)

    bgPanel:addChild( explain_but.view )



    -- bgPanel:addChild( explain_but )
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function UserExchangePanel:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index, word_x, word_y)
     local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then 
            --根据序列号来调用方法
            
            --print(but_index)
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( but_index )
            
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)
    panel:addGroup(radio_button)

    --按钮显示的名称
    local word_x_temp = word_x or 17
    local word_y_temp = word_y + 5 or 29 + 10
    print("  ::: ", word_x_temp, word_y_temp)
    local name_image = CCZXImage:imageWithFile( pos_x + word_x_temp, pos_y + word_y_temp, but_name_siz_w, but_name_siz_h, but_name ); 
    panel:addChild( name_image )
end

-- 提供外部静态调用的更新窗口方法
function UserExchangePanel:update_win( update_type )
    local win = UIManager:find_visible_window("exchange_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

-- 更新数据
function UserExchangePanel:update( update_type )
    if update_type == "lilian" then
        self:update_lilian(  )
    elseif update_type == "honor" then 
        self:update_honor( )
    elseif update_type == "all" then
        self:update_all(  )
    else
        
    end
end

-- 更新历练值
function UserExchangePanel:update_lilian(  )
	local lilian = ExchangeModel:get_player_lilian(  )
	self.lilian:setString( "#cffffff"..lilian )
end

-- 更新荣誉值
function UserExchangePanel:update_honor(  )
    local honor = ExchangeModel:get_player_honor()
    self.honor:setString( "#cffff00"..honor )
end

-- 所有数据更新
function UserExchangePanel:update_all(  )
	self:update_lilian(  )
    self:update_honor();
end

-- 激活时更新数据
function UserExchangePanel:active( show )
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

function UserExchangePanel:destroy()
    Window.destroy(self)
    self.exchange_list:destroy()
end

function UserExchangePanel:change_page( page_index )
    self.exchange_list:Choose_panel( _index_to_category_name[page_index] )
    self.raido_btn_group:selectItem(page_index-1);
end