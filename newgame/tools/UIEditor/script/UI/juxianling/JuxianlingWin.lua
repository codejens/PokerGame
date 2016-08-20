-- JuxianlingWin.lua 
-- created by zyb on 2014-4-10
-- 聚仙令主窗口  juxianling_win

super_class.JuxianlingWin(NormalStyleWindow)

function JuxianlingWin:__init( window_name, texture_name, is_grid, width, height,title_text )
	self.all_page_t = {}

	-- ZImage:create(self.view,UILH_COMMON.bottom_bg,10 ,12,760,355,0,500,500);
    -- 顶部所有按钮
    local win_size = self.view:getSize();
    local but_beg_x = 13          --按钮起始x坐标
    local but_beg_y = win_size.height - 65 - 45         --按钮起始y坐标
    local but_int_x = 107          --按钮x坐标间隔
    local btn_with   = 108 
    local btn_height = 45

    self.text_title = {Lang.juxianling[1],Lang.juxianling[2],}
    self.label_title = {}

    self.radio_buts = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , but_int_x * 7,37,nil)
    self.view:addChild(self.radio_buts)
    self:create_a_button(self.radio_buts, 1 + but_int_x * (1 - 1), 1, btn_with, btn_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, nil,70, 20, 1)
    self:create_a_button(self.radio_buts, 1 + but_int_x * (2 - 1), 1, btn_with, btn_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, nil,70, 20, 2)
	self:change_page(1)

end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function JuxianlingWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
	local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
        	print("切卷到分页",but_index)
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)

    --按钮显示的名称
    -- local name_image = CCZXImage:imageWithFile( size_w/2 , size_h/2 , but_name_siz_w, but_name_siz_h, but_name );
    -- name_image:setAnchorPoint(0.5,0.5);
    -- radio_button:addChild( name_image )
    self.label_title[but_index] = MUtils:create_zxfont(radio_button,LH_COLOR[2]..self.text_title[but_index],size_w/2,12,2,17);
    return radio_button
end

function JuxianlingWin:change_page( but_index )
    -- 改变标题文字颜色
    for i,v in ipairs(self.label_title) do
        v:setText(LH_COLOR[2]..self.text_title[i])
    end
    self.label_title[but_index]:setText(LH_COLOR[15]..self.text_title[but_index])

     -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] =  TeamFamPage:create()
            self.view:addChild( self.all_page_t[1].view )
        end
        self.current_panel = self.all_page_t[1]
        self.all_page_t[1]:update()
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] =  ScoreExchangePage:create(  )
            self.view:addChild( self.all_page_t[2].view )
        end
        self.current_panel = self.all_page_t[2]
        self.all_page_t[2]:update()
    end
    self.current_panel.view:setIsVisible(true)
end

-- 获取分页对象
function JuxianlingWin:get_page_by_index(index)
    if self.all_page_t[index] then 
        return self.all_page_t[index]
    end
end
function JuxianlingWin:update(  )
	
end

function JuxianlingWin:active( show )
    if show then
        TeamActivityCC:req_token_count( )
    else

    end
end

function JuxianlingWin:destroy()
    Window.destroy(self)
    if self.all_page_t ~= nil and type(self.all_page_t) == "table" then
        for key, page in pairs(self.all_page_t) do
            if page.destroy then
                page:destroy()
            end
        end 
    end
end