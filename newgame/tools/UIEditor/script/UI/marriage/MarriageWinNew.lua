-- MarriageWinNew.lua
-- create by guozhinan on 2015-2-2
-- 结婚系统(改为大面板了)

super_class.MarriageWinNew(Window)

function MarriageWinNew:__init( window_name, texture_name, is_grid, width, height,title_text )
    -- 大背景
    local bg = ZImage:create( self.view, UILH_MARRIAGE.bg1, 0, 0, width, height - 25, -1,500,500 )
    
    --标题背景
    local title_bg = ZImage:create( self.view,nil, 0, 0, -1, -1 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
    -- 标题
    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    self.window_title = ZImage:create(title_bg, title_text , t_width/2,  t_height-27, -1,-1,999 );
    self.window_title.view:setAnchorPoint(0.5,0.5)
       
    -- 花纹装饰
    local left_decoration = CCZXImage:imageWithFile( -19, 91, -1, -1, UILH_MARRIAGE.decoration1 );
    self.view:addChild(left_decoration)
    local right_decoration = CCZXImage:imageWithFile( 574, 91, -1, -1, UILH_MARRIAGE.decoration1 );
    right_decoration:setFlipX(true);
    self.view:addChild(right_decoration)

    -- 顶部标签栏
    self.text_title = {Lang.marriage[7],Lang.marriage[8],Lang.marriage[9],}
    self.label_title = {}
    self.radio_btn_tab   = {}

    local win_size = self.view:getSize();
    local but_beg_x  = 22            -- 按钮起始x坐标
    local but_beg_y  = win_size.height - 65 - 45            -- 按钮起始y坐标
    local but_int_x  = 100           -- 按钮x坐标间隔
    local btn_with   = 100 
    local btn_height = 44
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , btn_with*5, btn_height,nil)
    self.view:addChild(self.raido_btn_group,100)
    -- 创建标签栏三个tab按钮
    for i=1,3 do
        self.radio_btn_tab[i] = self:create_a_button(self.raido_btn_group, 0 + but_int_x*(i-1), 0, btn_with, btn_height, UILH_MARRIAGE.tab_gray, UILH_MARRIAGE.tab_light, i)
    end
    -- 内部小背景
    ZImage:create( self.view, UILH_MARRIAGE.bg2, 15, 15, width-30, 508, -1,500,500 )
    -- 创建三个分页（一次性创建，如果打开结婚系统时会卡顿的话，可以考虑选中分页时再创建，这样的话，每个地方用self.page_panel[?]要做判空处理）
    self.page_panel = {}
    self.page_panel[1] = MarriagePageQingMi(20,20,860,500);
    self.view:addChild(self.page_panel[1].view);
    self.page_panel[2] = MarriagePageHunYan(20,20,860,500);
    self.view:addChild(self.page_panel[2].view);
    self.page_panel[3] = MarriagePageHunChe(20,20,860,500);
    self.view:addChild(self.page_panel[3].view);

    -- 选中第一个分页
    self.current_page_index = 1;
    self:change_page(1)

    --关闭按钮
    local function _close_btn_fun()
        Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
        UIManager:hide_window(window_name)
    end
    local _exit_btn_info = { img = UILH_MARRIAGE.close_btn_big, z = 1000, width = 80, height = 80 }
    self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    local exit_btn_size = self._exit_btn:getSize()
    self._exit_btn:setPosition( width - exit_btn_size.width , height - exit_btn_size.height-20)
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，序列号（用于触发事件判断调用的方法）
function MarriageWinNew:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,index)
     local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)
    panel:addGroup(radio_button)

    --按钮显示的名称
    self.label_title[index] = MUtils:create_zxfont(radio_button,LH_COLOR[2]..self.text_title[index],size_w/2,12,2,17);
    return radio_button;
end

--切页
function MarriageWinNew:change_page( page_index )
    self.current_page_index = page_index;
    for i,v in ipairs(self.label_title) do
        v:setText(LH_COLOR[2]..self.text_title[i])
    end
    self.label_title[page_index]:setText(LH_COLOR[15]..self.text_title[page_index])

    self:Choose_panel(page_index)
    self.raido_btn_group:selectItem(page_index-1)
end

-- 选择显示的面板
function MarriageWinNew:Choose_panel( page_index)
    for key, panel in pairs(self.page_panel) do
        panel.view:setIsVisible( false )
    end

    if page_index == 1 then
        self.page_panel[1].view:setIsVisible( true )
        if self.page_panel[1].active ~= nil then
            self.page_panel[1]:active(true)
        end
    elseif page_index == 2 then
        self.page_panel[2].view:setIsVisible( true )
        if self.page_panel[2].active ~= nil then
            self.page_panel[2]:active(true)
        end
    elseif page_index == 3 then
        self.page_panel[3].view:setIsVisible( true )
        if self.page_panel[3].active ~= nil then
            self.page_panel[3]:active(true)
        end
    end
end

-----界面更新（destroy方式的窗口，根据active方法没必要写）
function MarriageWinNew:active( show )
    if show then

    else

    end
end

-- 播放升级特效
function MarriageWinNew:play_uplevel_effect( type )
    if self.current_page_index ~= 1 then
        return;
    end
    if 1 == type then 
        --类型1是小红心特效
        local data = MarriageModel:get_marriage_data();
        self.page_panel[1]:play_heart_effect( data.count )
    elseif 2 == type then
        --类型2是大红心特效
        self.page_panel[1]:play_xy_uplevel_effect(  )
    end
end

-- 更新仙缘等级
function MarriageWinNew:update_xianyuan_level( )

    local data = MarriageModel:get_marriage_data();
    print("MarriageWin更新仙缘等级", data.count, data.level);
    if data.count ~= nil  and data.level ~= nil then
       -- print("MarriageWin更新仙缘等级", data.count, data.level);
        self.page_panel[1]:update_xianyuan_level( data.count, data.level );
    end

    -- 同时更新亲密度
    self:update_sweet_value()

end

-- 更新婚宴列表
function MarriageWinNew:update_wedding_list(  )
    if self.page_panel[2] then
        self.page_panel[2]:update_wedding_list(  )
    end
end

-- 选择婚宴列表
function MarriageWinNew:selected_wedding_list( index )
    if self.page_panel[2] then
        self.page_panel[2]:selected_tab( index );
    end
end

-- 更新结婚记录列表
function MarriageWinNew:update_marriage_record_list(  )
    if self.page_panel[3] then
        self.page_panel[3]:update_marriage_record(  );
    end
end

-- 更新亲密度
function MarriageWinNew:update_sweet_value(  )
    if self.page_panel[1] then
        self.page_panel[1]:update_sweet_value();
    end
end

-- 更新情意值
function MarriageWinNew:update_curr_qingyi_value(  )
    local data = MarriageModel:get_marriage_data( );
    if data.qingyi ~= nil and self.page_panel[1] then
        self.page_panel[1]:update_curr_qingyi_value( data.qingyi )
    end
end


-- 销毁窗体
function MarriageWinNew:destroy()
    for i=1,#self.page_panel do
        if self.page_panel[i] ~= nil and self.page_panel[i].destroy ~= nil then
            self.page_panel[i]:destroy();
        end
    end

    Window.destroy(self)
end