-- filename: UIButton.lua
-- author: created by HardGame on 2012-12-18
-- function: this file contains lua UIButton control.

super_class.UIButton();

-- 创建一个button
-- x, y, w, h, 按钮坐标及尺寸
-- image_n: 正常状态下图片
-- image_d: 按钮按下后图片
-- image_m: 按钮被移动时图片
function UIButton:create_button (x, y, w, h, image_n, image_d, image_m)
	local button = CCNGBtnMulTex:buttonWithFile(x, y, w, h, image_n);

	if (image_d ~= nil) then
        button:addTexWithFile(CLICK_STATE_DOWN, image_d);
    end
    if (image_m ~= nil) then
        button:addTexWithFile(CLICK_STATE_MOVE, image_m);
    end

	return button;
end

-- =======================================
-- 创建一个带有自定义文字的按钮。 目前只支持中文  lyl
-- but_x, but_y, but_w, but_h: 按钮坐标和大小
-- image_n, image_s, image_d： 本别是常态、按下、无效状态下的图片路径,  image_s 和 image_d 可以是nil
-- but_name  字符串 按钮的名称  可以不填。如果不填，就显示 空字符串
-- callback_fun 回调函数        可以不填，不填就不回调
-- if_nine_grid： 是否使用九宫格创建
-- ========================================
function UIButton:create_button_with_name( but_x, but_y, but_w, but_h, image_n, image_s, image_d, but_name, callback_fun, if_nine_grid )
    local but_1
    but_name = but_name or ''
    if if_nine_grid then
	   but_1 = CCNGBtnMulTex:buttonWithFile( but_x, but_y, but_w, but_h, image_n, 500, 500 )
    else
       but_1 = CCNGBtnMulTex:buttonWithFile( but_x, but_y, but_w, but_h, image_n)
    end
    local but_1_script = {}
    but_1_script.double_click_func = nil     -- 双击事件
	if image_s then
        but_1:addTexWithFile( CLICK_STATE_DOWN, image_s )
    end
    if image_d then
        --but_1:addTexWithFile(CLICK_STATE_DISABLE, image_d )
    end
    local function but_1_fun(eventType, arg, msgid, selfItem)
        if eventType == nil or arg == nil or msgid == nil or selfItem == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return  true
        elseif eventType == TOUCH_CLICK then 
            if callback_fun then
                callback_fun()
            end
            return true
        elseif eventType == TOUCH_DOUBLE_CLICK then 
            if but_1_script.double_click_func then
                but_1_script.double_click_func()
            end
            return true
        end
    end
    but_1:registerScriptHandler(but_1_fun)                  --注册

    --按钮显示的名称
    local but_name_x = but_w / 2
    local but_name_y = 10
    -- --print("字的长度", string.len( but_name ) , but_w)
    local fontsize  = (but_w - 30) / string.len( but_name ) * 3  
    local but_name_lable = but_name or ""

    but_1_script.label_name = UILabel:create_lable_2( but_name, but_name_x, but_name_y, fontsize, ALIGN_CENTER )
    but_1:addChild( but_1_script.label_name, 5 )

    -- 提供外部调用的方法
    but_1_script.set_double_click_func = function ( double_click_func )
        but_1_script.double_click_func = double_click_func
    end

    but_1_script.view = but_1
    ----print('>>>>>', but_1)
    return but_1_script
end

-- ===================================================
-- create_button_with_name 的改进
-- 创建一个包含文字的按钮， 根据按钮字数来 定按钮大小 只支持 2 - 4 字  lyl
-- 
-- ===================================================
function UIButton:create_button_with_name2( father_panel, but_x, but_y, but_name, callback_fun )
    local but_1 = {}     -- 按钮对象
    
    -- 获取按钮名称长度 设置按钮图片
    local but_image_t = { [2] = UIPIC_COMMON_BUTTON_001, [3] = UIPIC_COMMON_BUTTON_001, [4] = UIPIC_COMMON_BUTTON_001 }
    local but_name_x_t = { [2] = 25, [3] = 32.5, [4] =42.5 }
    local name_length = string.len( but_name ) / 3
    -- --print("按钮文字长度, ", name_length)
    local but_bg = "ui/common/button2_bg.png"
    local but_name_x = 28
    local but_name_y = 6
    if but_image_t[name_length] then 
        but_bg = but_image_t[name_length]
        but_name_x = but_name_x_t[ name_length ]
    end

    but_1 = CCNGBtnMulTex:buttonWithFile( but_x, but_y, -1, -1, but_bg )
    but_1.label_name = UILabel:create_lable_2( but_name, but_name_x, but_name_y, 16, ALIGN_CENTER )
    but_1:addChild( but_1.label_name, 1 )

    local function but_1_fun(eventType, arg, msgid, selfItem)
        if eventType == nil or arg == nil or msgid == nil or selfItem == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return  true
        elseif eventType == TOUCH_CLICK then 
            if callback_fun then
                callback_fun(eventType, arg, msgid)
            end
            return true
        elseif eventType == TOUCH_DOUBLE_CLICK then 
            if but_1.double_click_func then
                but_1.double_click_func(eventType, arg, msgid)
            end
            return true
        end
    end
    but_1:registerScriptHandler(but_1_fun)                  --注册

    -- 提供外部调用的方法
    -- 设置双击事件
    but_1.set_double_click_func = function ( double_click_func )
        but_1.double_click_func = double_click_func
    end    

    -- 修改文字
    but_1.set_but_name = function( but_name )
        if but_name then 
            local name_length = string.len( but_name ) / 3
            if but_image_t[name_length] then 
                -- but_bg = but_image_t[name_length]
                -- but_name_x = but_name_x_t[ name_length ]
                -- but_1:setTexture( but_bg )
                -- but_1.label_name:setPosition( but_name_x, but_name_y )
                but_1.label_name:setString( but_name )
            else
                return
            end
        end
    end


    father_panel:addChild( but_1 )
    return but_1
end


-- ================================
-- 使用图片 设置一个按钮的 显示（名称）
-- button_obj  ： 要加入显示图片的按钮
-- ima_name_x, ima_name_y, ima_name_w, ima_name_h : 按钮坐标和大小
-- ima_name_path ， 按钮显示图片的路径
-- ================================
function UIButton:set_button_image_name( button_obj, ima_name_x, ima_name_y, ima_name_w, ima_name_h, ima_name_path  )
	if button_obj.label_name then
        button_obj.label_name:setIsVisible(false)
	end
	if ima_name_path then
		if button_obj.name_image then
			button_obj:removeChild( button_obj.name_image, true )
        end
        button_obj.name_image = CCZXImage:imageWithFile( ima_name_x, ima_name_y, ima_name_w, ima_name_h, ima_name_path )
        button_obj.view:addChild( button_obj.name_image, 10 )
    else
        if button_obj.name_image then
            button_obj.name_image:setIsVisible(false)
        end
    end
end

-- ================================
-- 创建包含文字的二态按钮  点击文字也会生效
-- x, y, w, h 坐标和整个点击响应区域大小
-- image_n: 为选中时的图片
-- image_s：选中时的图片
-- words：显示的文字
-- words_x: 文字的相对本控件的x坐标位置
-- fontsize： 文字大小
-- image_n_w, image_n_h  : 正常状态图片的大小，可以设置为nil，则为原图片大小
-- image_s_w, image_s_h  : 选中状态图片的大小，可以设置为nil，则为原图片大小
-- callback_fun： 每次点击时的回调函数。 可以为nil
-- select_colors： 颜色变化。table类型，例子：{ "#c66ff66", "#c4d2308" } 可以为nil，默认 选中绿色，不选中黄色.   如果第一个参数是“nocolor”字符串，只按玩家传入，不改变颜色
-- **********************
-- 提供的方法：
-- switch_but.setString    设置文字方法
-- switch_but.set_state    改变选中状态
-- ================================
function UIButton:create_switch_button( x, y, w, h, image_n, image_s, words, words_x, fontsize, image_n_w, image_n_h, image_s_w, image_s_h, callback_fun, select_colors, none_nine_grid)
    local switch_but = {}              -- 返回的二态按钮对象
    switch_but.callback_fun = callback_fun
    switch_but.if_selected = false     -- 是否选中
    switch_but.enable = true;          -- 是否可选
    
    local if_change_color = true       -- 是否改变颜色
    local current_color = "#c854c0f"--S_COLOR[5]

    local color_s = "#c854c0f"--S_COLOR[5]         -- 选中，天降雄师黄色"#cfff000"
    local color_n = "#c854c0f"--S_COLOR[5]         -- 不选中，天降雄师默认文本颜色"#cd0cda2"
    local color_d = "#c854c0f"--S_COLOR[5]         -- 不可选，灰色
    if select_colors  then
        color_s = select_colors[1] or "#ca27532"
        color_n = select_colors[2] or "#ca27532"
        if select_colors[1] == "nocolor" then
            if_change_color = false
        end
    end

    switch_but.view = CCBasePanel:panelWithFile( x, y, w, h, "", 500, 500 )

    -- 正常状态
    local image_n_w_temp = image_n_w or -1
    local image_n_h_temp = image_n_h or -1
    if none_nine_grid == true then
        switch_but.select_box_n = CCZXImage:imageWithFile( 0, 0, image_n_w_temp, image_n_h_temp, image_n )
    else
        switch_but.select_box_n = CCZXImage:imageWithFile( 0, 0, image_n_w_temp, image_n_h_temp, image_n, 500, 500 )
    end
    switch_but.view:addChild( switch_but.select_box_n )

    -- 选中状态
    local image_s_w_temp = image_s_w or -1
    local image_s_h_temp = image_s_h or -1
    if none_nine_grid == true then
        switch_but.select_box_s = CCZXImage:imageWithFile( 0, 0, image_s_w_temp, image_s_h_temp, image_s )
    else
        switch_but.select_box_s = CCZXImage:imageWithFile( 0, 0, image_s_w_temp, image_s_h_temp, image_s, 500, 500 )
    end
    switch_but.view:addChild( switch_but.select_box_s )
    switch_but.select_box_s:setIsVisible( false )

    -- 文字
    switch_but.words = UILabel:create_lable_2( words, words_x, 5, fontsize, ALIGN_LEFT )
    switch_but.view:addChild( switch_but.words )
    

    -- 设置状态图片
    local function set_start_image(  )
        if switch_but.if_selected then
            switch_but.select_box_n:setIsVisible( false )
            switch_but.select_box_s:setIsVisible( true )
        else
            switch_but.select_box_n:setIsVisible( true )
            switch_but.select_box_s:setIsVisible( false )
        end
    end

    -- 点击触发切换
    local function but_1_fun(eventType, arg, msgid ,selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then 
            if switch_but.enable then
                switch_but.set_state( not switch_but.if_selected )
                if switch_but.callback_fun then
                    switch_but.callback_fun( switch_but.if_selected )
                end
            end
        end
        return true;
    end
    switch_but.view:registerScriptHandler(but_1_fun)



    switch_but.set_callback_fun= function(func)
        switch_but.callback_fun = func
    end

    -- 提供的方法
    -- 设置文字方法
    switch_but.setString = function( str )
        if if_change_color then
            -- 做颜色切换： 如果以 #c开头，去掉颜色，这样才好做颜色控制
            str = str or ""        -- 防止传入nil
            -- 判断是否已颜色开头
            if string.len( str ) > 8 then
                local head_str = string.sub( str, 0, 2 )
                if head_str == "#c" then
                    str = string.sub( str, 9, -1 )
                end
            end
            
            -- 根据是否选中设置颜色
            words = str;
            if switch_but.if_selected then
                str = color_s..str
            else
                str = color_n..str
            end
        end
        -- words = str;
        switch_but.words:setString( str )
    end
    switch_but.setString( words )

    -- 改变选中状态  if_selected: 是否选中  if_callback：是否触发回调, 可以为nil
    switch_but.set_state = function ( if_selected, if_callback )
        switch_but.if_selected = if_selected
        set_start_image(  )
        switch_but.setString( words )

        if if_callback and callback_fun then
            callback_fun( switch_but.if_selected )
        end
    end
    -- 设置是否可点击
    switch_but.set_enable = function ( enable )
        switch_but.enable = enable;
        if enable then
            if switch_but.if_selected then
                switch_but.set_color(color_s)
            else
                switch_but.set_color(color_n)
            end
        else
            switch_but.set_color(color_d)
        end
    end
    
    -- 改变字体颜色
    switch_but.set_color = function ( color )
        switch_but.words:setText( color..words );
    end

    return switch_but
end

-- 原来的方法create_switch_button没有提供文字的y值，所以不得不另开一个方法。note by guozhinan
function UIButton:create_switch_button2( x, y, w, h, image_n, image_s, words, words_x, words_y, fontsize, image_n_w, image_n_h, image_s_w, image_s_h, callback_fun, select_colors, none_nine_grid)
    local switch_but = {}              -- 返回的二态按钮对象
    switch_but.if_selected = false     -- 是否选中
    switch_but.enable = true;          -- 是否可选
    
    local if_change_color = true       -- 是否改变颜色
    local current_color = "#c4d2308"

    local color_s = LH_COLOR[1]         -- 选中，天降雄师黄色"#cfff000"
    local color_n = LH_COLOR[2]         -- 不选中，天降雄师默认文本颜色"#cd0cda2"
    local color_d = "#caaaaaa"         -- 不可选，灰色
    if select_colors  then
        color_s = select_colors[1] or "#c66ff66"
        color_n = select_colors[2] or "#c4d2308"
        if select_colors[1] == "nocolor" then
            if_change_color = false
        end
    end

    switch_but.view = CCBasePanel:panelWithFile( x, y, w, h, "", 500, 500 )

    -- 正常状态
    local image_n_w_temp = image_n_w or -1
    local image_n_h_temp = image_n_h or -1
    if none_nine_grid == true then
        switch_but.select_box_n = CCZXImage:imageWithFile( 0, 0, image_n_w_temp, image_n_h_temp, image_n )
    else
        switch_but.select_box_n = CCZXImage:imageWithFile( 0, 0, image_n_w_temp, image_n_h_temp, image_n, 500, 500 )
    end
    switch_but.view:addChild( switch_but.select_box_n )

    -- 选中状态
    local image_s_w_temp = image_s_w or -1
    local image_s_h_temp = image_s_h or -1
    if none_nine_grid == true then
        switch_but.select_box_s = CCZXImage:imageWithFile( 0, 0, image_s_w_temp, image_s_h_temp, image_s )
    else
        switch_but.select_box_s = CCZXImage:imageWithFile( 0, 0, image_s_w_temp, image_s_h_temp, image_s, 500, 500 )
    end
    switch_but.view:addChild( switch_but.select_box_s )
    switch_but.select_box_s:setIsVisible( false )

    -- 文字
    switch_but.words = UILabel:create_lable_2( words, words_x, words_y, fontsize, ALIGN_LEFT )
    switch_but.view:addChild( switch_but.words )
    

    -- 设置状态图片
    local function set_start_image(  )
        if switch_but.if_selected then
            switch_but.select_box_n:setIsVisible( false )
            switch_but.select_box_s:setIsVisible( true )
        else
            switch_but.select_box_n:setIsVisible( true )
            switch_but.select_box_s:setIsVisible( false )
        end
    end

    -- 点击触发切换
    local function but_1_fun(eventType, arg, msgid ,selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then 
            if switch_but.enable then
                switch_but.set_state( not switch_but.if_selected )
                if callback_fun then
                    callback_fun( switch_but.if_selected )
                end
            end
        end
        return true;
    end
    switch_but.view:registerScriptHandler(but_1_fun)

    -- 提供的方法
    -- 设置文字方法
    switch_but.setString = function( str )
        if if_change_color then
            -- 做颜色切换： 如果以 #c开头，去掉颜色，这样才好做颜色控制
            str = str or ""        -- 防止传入nil
            -- 判断是否已颜色开头
            if string.len( str ) > 8 then
                local head_str = string.sub( str, 0, 2 )
                if head_str == "#c" then
                    str = string.sub( str, 9, -1 )
                end
            end
            
            -- 根据是否选中设置颜色
            words = str;
            if switch_but.if_selected then
                str = color_s..str
            else
                str = color_n..str
            end
        end
        -- words = str;
        switch_but.words:setString( str )
    end
    switch_but.setString( words )

    -- 改变选中状态  if_selected: 是否选中  if_callback：是否触发回调, 可以为nil
    switch_but.set_state = function ( if_selected, if_callback )
        switch_but.if_selected = if_selected
        set_start_image(  )
        switch_but.setString( words )

        if if_callback and callback_fun then
            callback_fun( switch_but.if_selected )
        end
    end
    -- 设置是否可点击
    switch_but.set_enable = function ( enable )
        switch_but.enable = enable;
        if enable then
            if switch_but.if_selected then
                switch_but.set_color(color_s)
            else
                switch_but.set_color(color_n)
            end
        else
            switch_but.set_color(color_d)
        end
    end
    
    -- 改变字体颜色
    switch_but.set_color = function ( color )
        switch_but.words:setText( color..words );
    end

    return switch_but
end


-- ================================
-- 创建包含文字的二态按钮  点击文字也会生效
-- x, y, w, h 坐标和整个点击响应区域大小
-- image_n: 为选中时的图片
-- image_s：选中时的图片
-- words：显示的文字
-- words_x: 文字的相对本控件的x坐标位置
-- fontsize： 文字大小
-- image_n_w, image_n_h  : 正常状态图片的大小，可以设置为nil，则为原图片大小
-- image_s_w, image_s_h  : 选中状态图片的大小，可以设置为nil，则为原图片大小
-- callback_fun： 每次点击时的回调函数。 可以为nil
-- select_colors： 颜色变化。table类型，例子：{ "#c66ff66", "#c4d2308" } 可以为nil，默认 选中绿色，不选中黄色.   如果第一个参数是“nocolor”字符串，只按玩家传入，不改变颜色
-- 提供的方法：
-- switch_but.setString    设置文字方法
-- switch_but.set_state    改变选中状态
-- ================================
function UIButton:create_switch_button_new(x, y, w, h, image_n, image_s, words, words_x, fontsize, image_n_w, image_n_h, image_s_w, image_s_h, callback_fun, select_colors, none_nine_grid)
    local switch_but        = {}             --返回的二态按钮对象
    switch_but.callback_fun = callback_fun   --按钮回调
    switch_but.if_selected  = false          --是否选中
    switch_but.enable       = true           --是否可选
    switch_but.view         = CCBasePanel:panelWithFile(x, y, w, h, "", 500, 500)
    fontsize                = fontsize or 20
    --正常状态
    local image_n_w_temp = image_n_w or -1
    local image_n_h_temp = image_n_h or -1
    if none_nine_grid == true then
        switch_but.select_box_n = CCZXImage:imageWithFile(0, 0, image_n_w_temp, image_n_h_temp, image_n)
    else
        switch_but.select_box_n = CCZXImage:imageWithFile(0, 0, image_n_w_temp, image_n_h_temp, image_n, 500, 500)
    end
    switch_but.view:addChild(switch_but.select_box_n)
    local size = switch_but.select_box_n:getSize()
    switch_but.select_box_n:setPosition(w-size.width-9, (h-size.height)/2)
    --选中状态
    local image_s_w_temp = image_s_w or -1
    local image_s_h_temp = image_s_h or -1
    if none_nine_grid == true then
        switch_but.select_box_s = CCZXImage:imageWithFile(0, 0, image_s_w_temp, image_s_h_temp, image_s)
    else
        switch_but.select_box_s = CCZXImage:imageWithFile(0, 0, image_s_w_temp, image_s_h_temp, image_s, 500, 500)
    end
    switch_but.view:addChild(switch_but.select_box_s)
    switch_but.select_box_s:setPosition(w-size.width-9, (h-size.height)/2)
    switch_but.select_box_s:setIsVisible(false)
    switch_but.png_x = w-size.width-9
    switch_but.png_y = (h-size.height)/2
    --设置状态图片
    local function set_start_image()
        if switch_but.if_selected then
            switch_but.select_box_n:setIsVisible(false)
            switch_but.select_box_s:setIsVisible(true)
        else
            switch_but.select_box_n:setIsVisible(true)
            switch_but.select_box_s:setIsVisible(false)
        end
    end
    local function btn_callback()
        if switch_but.enable then
            switch_but.set_state(not switch_but.if_selected)
            if switch_but.callback_fun then
                switch_but.callback_fun(switch_but.if_selected)
            end
        end
    end
    --点击触发切换
    local function but_1_fun(eventType, arg, msgid ,selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then 
            btn_callback()
        end
        return true
    end
    switch_but.view:registerScriptHandler(but_1_fun)
    switch_but.set_callback_fun= function(func)
        switch_but.callback_fun = func
    end
    --改变选中状态(if_selected:是否选中 if_callback:是否触发回调)
    switch_but.set_state = function (if_selected, if_callback)
        switch_but.if_selected = if_selected
        set_start_image()
        if switch_but.setString then
            switch_but.setString(words)
        end
        if switch_but.if_selected then
            switch_but.btn_n:setIsVisible(false)
            switch_but.btn_s:setIsVisible(true)
        else
            switch_but.btn_n:setIsVisible(true)
            switch_but.btn_s:setIsVisible(false)
        end
        if if_callback and callback_fun then
            callback_fun(switch_but.if_selected)
        end
    end
    --设置是否可点击
    switch_but.set_enable = function (enable)
        switch_but.enable = enable
        if enable then
            if switch_but.if_selected then
                switch_but.set_color(color_s)
            else
                switch_but.set_color(color_n)
            end
        else
            switch_but.set_color(color_d)
        end
    end
    --改变字体颜色
    switch_but.set_color = function (color)
        switch_but.words:setText(color..words)
    end
    --圆按钮(未选中)
    switch_but.btn_n = SButton:create("sui/systemset/radio_btn.png", "sui/systemset/radio_btn.png")
    switch_but.btn_n:set_click_func(btn_callback)
    switch_but.btn_n:setPosition(switch_but.png_x-9, (h-39)/2)
    switch_but.view:addChild(switch_but.btn_n.view)
    --圆按钮(选中)
    switch_but.btn_s = SButton:create("sui/systemset/radio_btn1.png", "sui/systemset/radio_btn1.png")
    switch_but.btn_s:set_click_func(btn_callback)
    switch_but.btn_s:setPosition(w-44, (h-39)/2)
    switch_but.view:addChild(switch_but.btn_s.view)
    switch_but.btn_s:setIsVisible(false)
    --文字
    switch_but.words = UILabel:create_lable_2(words, words_x, (h-fontsize)/2, fontsize, ALIGN_LEFT)
    switch_but.view:addChild(switch_but.words)
    --设置文字方法
    switch_but.setString = function(str)
        if if_change_color then
            --做颜色切换
            str = str or ""
            --判断是否以颜色开头
            if string.len(str) > 8 then
                local head_str = string.sub(str, 0, 2)
                if head_str == "#c" then
                    str = string.sub(str, 9, -1)
                end
            end
            --根据是否选中设置颜色
            words = str
            if switch_but.if_selected then
                str = color_s..str
            else
                str = color_n..str
            end
        end
        switch_but.words:setString(str)
    end
    switch_but.setString(words)
    --设置大小方法
    switch_but.setSize = function(n_w, n_h)
        switch_but.view:setSize(n_w, n_h)
        switch_but.png_x = n_w-size.width-9
        if switch_but.select_box_n then
            switch_but.select_box_n:setPosition(n_w-size.width-9, (h-size.height)/2)
        end
        if switch_but.select_box_s then
            switch_but.select_box_s:setPosition(n_w-size.width-9, (h-size.height)/2)
        end
        if switch_but.btn_n then
            switch_but.btn_n:setPosition(n_w-size.width-18, (h-39)/2)
        end
        if switch_but.btn_s then
            switch_but.btn_s:setPosition(n_w-44, (h-39)/2)
        end
    end
    switch_but.setFontSize = function(f_size)
        if switch_but.words then
            switch_but.words:setFontSize(f_size)
        end
    end
    return switch_but
end