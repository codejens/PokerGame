-- FullScreenPanel.lua
-- created by mwy on 2014-6-10
-- 新手指引全屏遮盖层

super_class.FullScreenPanel(  )

function FullScreenPanel:fini()
    self.view=nil
end

--全屏遮盖层，中间镂空可以层穿透点击事件
--使用时注意，这里不考虑镂空层靠边的8种特殊情况,传参时注意
function FullScreenPanel:__init( x, y,w,h ,unlock_panel_func, debug, is_lock, click_lock_panel_func)
    local pos_x  = x or 10
    local pos_y  = y or 10
    local width  = w or 950
    local height = h or 470

    --不靠边
    if x== 0  then
        pos_x=1
        w=w-1
    end
    if y== 0  then
        pos_y=10
        h=h-1
    end

    local bg_width = GameScreenConfig.ui_screen_width
    local bg_height =GameScreenConfig.ui_screen_height

    --self.view = CCBasePanel:panelWithFile( 0, 0, _target_width, _target_height )
    self.view = CCBasePanel:panelWithFile( 0, 0, bg_width, bg_height, nil, 500, 500 )
    self.view:setDataInfo("full screen panel father")
    self.view:setAnchorPoint(0,0)
    self.view:setDefaultMessageReturn(false);
    local hollow_path = ''
    if debug then
        hollow_path = 'nopack/white.png'
    end


    --镂空层居中将遮盖层分成5块
    local bg_path=nil --""

    local _target_width = w - 1
    local _target_height = h - 1

    -- 保证在y>0时才创建该镂空层
    if y > 0 then
        local panel1 =  CCBasePanel:panelWithFile( 0, 0, x + w , y , hollow_path )
        self.view:addChild(panel1)
        panel1:setDefaultMessageReturn(is_lock or false);
        if is_lock then
            panel1:registerScriptHandler(click_lock_panel_func)
        end
    end

    local panel2 = CCBasePanel:panelWithFile( x + w , 0, bg_width, bg_height, hollow_path ) 
    self.view:addChild(panel2)
    panel2:setDefaultMessageReturn(is_lock or false);
    if is_lock then
        panel2:registerScriptHandler(click_lock_panel_func)
    end

    local panel3 = CCBasePanel:panelWithFile( x, y + h, bg_width, bg_height, hollow_path ) 
    self.view:addChild(panel3)
    panel3:setDefaultMessageReturn(is_lock or false);
    if is_lock then
        panel3:registerScriptHandler(click_lock_panel_func)
    end

    if x > 0 then
        local panel4 = CCBasePanel:panelWithFile( 0, y, x, bg_height, hollow_path ) 
        self.view:addChild(panel4)
        panel4:setDefaultMessageReturn(is_lock or false);
        if is_lock then
            panel4:registerScriptHandler(click_lock_panel_func)
        end
    end

    if debug then
        if panel1 then panel1:setColor(0x64000000) end
        panel2:setColor(0x64000000)
        panel3:setColor(0x64000000)
        if panel4 then panel4:setColor(0x64000000) end
    end

    if unlock_panel_func then
        local hollow_panel = nil

        hollow_panel = CCBasePanel:panelWithFile( x, y, w, h, hollow_path )
        --指引镂空层
       if debug then
            hollow_panel:setColor(0x64ff0000)
        end
        self.view:addChild(hollow_panel)
        hollow_panel:registerScriptHandler(unlock_panel_func)
        hollow_panel:setDefaultMessageReturn(false);
        hollow_panel:setEnableDoubleClick(true)
    end

    return self.view
end

