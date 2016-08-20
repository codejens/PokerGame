-- ConfirmWin.lua
-- created by lyl on 2013-1-16
-- 确认窗口

super_class.ConfirmWin()

local is_showing = false         -- 只能显示一个.暂时在这里控制只能显示一个。
local toolTipMgr = nil            -- 记录tips。当已经显示一个，有新的tips显示，就要删除。

local win_x = 0                 -- 坐标
local win_y = 0

-- 参数： 类型 ：select_confirm    notice_confirm    ( 可以填""， 然后获取对象后再加按钮 )
--               select_confirm_2(没有按钮，自己加)
-- 父pannel， 提示信息，  可以填 nil， 这样就是根结点上显示
-- 确认调用的函数， 提示框填nil，
-- 函数参数， 回调函数没有或者不用参数，可以填{}
-- 位置 ，填nil，默认是： 350  200 坐标
function ConfirmWin:__init( confirm_type, fath_panel, notice_content, fun, param, pos_x, pos_y)
    -- 提示框使用 HelpPanel
    if confirm_type == "notice_confirm" then
        -- HelpPanel:show( 3, "ui/common/tishi.png", notice_content )
        NormalDialog:show( notice_content, nil, 2 )
        return 
    elseif confirm_type == "select_confirm" then 
        ConfirmWin2:show( 4, nil, notice_content,  fun, nil, nil )
        return
    end


	-- 如果已经显示过，就把当前的内容给去掉。重建
    if is_showing then
    	UIManager:get_main_panel():removeChild(toolTipMgr.view, true) 
    end
    is_showing = true       -- 标记已经显示

    win_x = pos_x or 350
    win_y = pos_y or 200
    -- print( "###################", win_x, win_y  )
    -- self.fath_panel = fath_panel or UIManager:get_main_panel()


    local confirm_panel = CCBasePanel:panelWithFile( win_x, win_y, 280, 200, UIResourcePath.FileLocate.common .. "bg_blue.png", 500, 500 )
    -- self.fath_panel:addChild(confirm_panel, 500)
    require "UI/component/AlertWin"
    AlertWin:show_new_alert( confirm_panel )

    local confirm_title_bg = CCZXImage:imageWithFile(  20, 155, -1, -1, UIResourcePath.FileLocate.common .. "title_bg_b.png" )
    confirm_panel:addChild( confirm_title_bg )
    
    local confirm_title_name = CCZXImage:imageWithFile(  100, 160, -1, -1, UIResourcePath.FileLocate.normal .. "dialog_title_t.png" )
    confirm_panel:addChild( confirm_title_name )

    -- local confirm_content = notice_content
    -- local notice_dialog = CCDialog:dialogWithFile( 15, 65, 235, 100, 20000, NULL, TYPE_VERTICAL, ADD_LIST_DIR_UP )
    -- -- confirm_label = UILabel:create_label_1_old(confirm_content, CCSize(230,60), 140, 115, 15, CCTextAlignmentCenter, 255, 255, 0)
    -- notice_dialog:setText( notice_content )
    -- confirm_panel:addChild( notice_dialog )
    require "utils/MUtils"
    local temp_dialog = MUtils:create_ccdialogEx( confirm_panel, notice_content, 25, 65+85, 235 - 10, 100, 2000, 16)
    temp_dialog:setAnchorPoint(0, 1)

    local confirm_tail_line = CCZXImage:imageWithFile( 30, 20, 220, 1, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    confirm_panel:addChild( confirm_tail_line )

    -- 二次确认窗口
    if confirm_type == "select_confirm" then
        self:show_select_confirm_win( confirm_panel, fun, param )
    elseif confirm_type == "select_confirm_2" then
        
    elseif confirm_type == "notice_confirm" then
        self:show_notice_confirm_win( confirm_panel )
    end
    
    -- 设置不可击穿
    confirm_panel:setDefaultMessageReturn(true)

    self.view = confirm_panel
    toolTipMgr = self
end

-- 关闭窗口
function ConfirmWin:close_win(  )
    AlertWin:close_alert(  )
	-- self.fath_panel:removeChild( self.view, true )
end

-- 设置不会点击任何地方关闭
function ConfirmWin:no_close_click_anywhere(  )
    AlertWin:if_close_click_anywhere( false )
end

-- 二次确认窗口. 确认就执行传入的函数，否者关闭，不执行
function ConfirmWin:show_select_confirm_win( fath_panel, fun, param )
	-- "确认"按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_1 = CCNGBtnMulTex:buttonWithFile( 45, 30, 96, 43, UIResourcePath.FileLocate.common .. "button2.png", 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2.png")
    --but_1:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/btn_hong2.png")
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
        	if param then
                fun( nil, unpack(param)  )
            else
            	fun()
        	end
            
            self:close_win()
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)                  --注册
    fath_panel:addChild(but_1)
    --按钮显示的名称
    local label_but_1 = UILabel:create_label_1(LangGameString[793], CCSize(100,15), 96/2 , 15, 16, CCTextAlignmentCenter, 255, 255, 0) -- [793]="确定"
    but_1:addChild( label_but_1 ) 

    -- "取消"按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_2 = CCNGBtnMulTex:buttonWithFile( 165, 30, 96, 43, UIResourcePath.FileLocate.common .. "button2.png", 500, 500)
    but_2:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2.png")
    --but_2:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/btn_hong2.png")
    local function but_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            self:close_win()
        end
        return true
    end
    but_2:registerScriptHandler(but_2_fun)                  --注册
    fath_panel:addChild(but_2)
    --按钮显示的名称
    local label_but_2 = UILabel:create_label_1(LangGameString[794], CCSize(100,15), 96/2 , 15, 16, CCTextAlignmentCenter, 255, 255, 0) -- [794]="取消"
    but_2:addChild( label_but_2 ) 

end

-- 提示框
function ConfirmWin:show_notice_confirm_win( fath_panel )
	-- "确认"按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_1 = CCNGBtnMulTex:buttonWithFile( 120, 30, 96, 43, UIResourcePath.FileLocate.common .. "button2.png", 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2.png")
    --but_1:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/btn_hong2.png")
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
        	self:close_win()
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)                  --注册
    fath_panel:addChild(but_1)
    --按钮显示的名称
    local label_but_1 = UILabel:create_label_1(LangGameString[793], CCSize(100,15), 96/2 , 15, 16, CCTextAlignmentCenter, 255, 255, 0) -- [793]="确定"
    but_1:addChild( label_but_1 ) 
end
