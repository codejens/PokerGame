--CommonWin.lua
--created by liubo on 2015-04-27
--常用窗口

require "gamecore.ui.window.common.user.UserPage"

CommonWin = simple_class(GUIWindow)

local _PAGE = {
    user = UserPage,
}

---对外接口---
local function bag_btn_cb()
    CommonCC:open_user_person()
end

local function horse_btn_cb()
    CommonCC:open_user_horse()
end

local function change_title_btn_cb()

end

local function quit_btn_cb()
    CommonCC:colse_win()
end

--点击菜单回调
local function menu_cb(index)
    CommonCC:menu_cb(index)
end


--------------

--构造方法
function CommonWin:__init( view )
    self.page = {}
    self.menu_list = self:findWidgetByName("LV_Menu") --菜单背景
    self.page_bg = self:findWidgetByName("P_Page_Bg") --页背景
    self.current_page = nil -- 记录当前的页
end

--初始化窗口
function CommonWin:viewCreateCompleted() 
    GUIWindow.viewCreateCompleted(self)
    self:register_listener()
end

--显示页
function CommonWin:show_page(page_name)
    --隐藏当前页
    if self.current_page then
        self.current_page:setVisible(false)
    end

    --如果要显示的页不存在，则先创建
    local page = _PAGE[page_name]
    if not self.page[page_name] then
        if page then
            self.page[page_name] = page:create()
            self.page_bg:addChild(self.page[page_name].view)
            self.current_page = self.page[page_name]
        else
            --找不到要创建的页
            return
        end
    end

    --显示页
    self.page[page_name]:setVisible(true)

    if self.current_page and self.current_page.active then 
        self.current_page:active(  )
    end
end

--创建菜单
--data= {name=xx,title=xx}
function CommonWin:create_menu(data)
    self.menu_list:removeAllItems()
    self.menu_btn = {}
    for i,v in ipairs(data) do
        self.menu_btn[i] = GUIButton:create(_PATH_COMMON_TAB_BTN_NORMAL)
        self.menu_btn[i]:setTitleText(v.title,FONT_SIZE_24)
        self.menu_btn[i]:setTitleColor(160, 182, 183)
        local function touchfunc( sender,eventType )
            if eventType == ccui.TouchEventType.ended then
                menu_cb(i)
            end
        end 
        self.menu_btn[i]:addTouchEventListener(touchfunc)
        self.menu_list:insertCustomItem(self.menu_btn[i].view,i-1)
    end
end

--选中菜单
function CommonWin:slelcted_menu(index)
    for i,v in ipairs(self.menu_btn) do
        if i == index then
            v:setTextureNormal(_PATH_COMMON_TAB_BTN_SELECTED)
            v:setTitleColor(205, 252, 255)
        else
            v:setTextureNormal(_PATH_COMMON_TAB_BTN_NORMAL)
            v:setTitleColor(160, 182, 183)
        end
    end
end

--设置监听
function CommonWin:register_listener( ... )
    --退出按钮
    local function _cb_func_4(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            quit_btn_cb()
        end
    end    
    self:addTouchEventListener('B_Quit',_cb_func_4)
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function CommonWin:update( update_type, data )
    if update_type == "" then 
        
    else
        if self.current_page and self.current_page.update then
            self.current_page:update( update_type, data )
        end
    end
end

--- 变成激活（显示）情况调用
function CommonWin:active(  )
    if self.current_page and self.current_page.active then 
        self.current_page:active(  )
    end
end

-- 变成 非激活
function CommonWin:unActive(  )
    if self.current_page and self.current_page.unActive then 
        self.current_page:unActive(  )
    end
end