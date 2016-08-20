-- ForgeCommon.lua
-- created by lyl on 2012-12-31
-- 炼器--宝石镶嵌面板

super_class.ForgeCommon()

local _if_can_show_confirm = nil

-- 显示确认框.   参数：加入的父panel， 回调函数， 提示信息, 回调函数的参数
function ForgeCommon:show_confirm(fath_panel, fun, notice_content, param, pos_x, pos_y )
	local loc_pos_x = pos_x or 30
	local loc_pos_y = pos_y or 60

    local confirm_panel = CCBasePanel:panelWithFile( loc_pos_x, loc_pos_y, 280, 200, UIResourcePath.FileLocate.common .. "bg_blue.png", 500, 500 )
    fath_panel:addChild( confirm_panel )

    confirm_panel:setDefaultMessageReturn(true)   -- 设置不可穿透

    local confirm_title_bg = CCZXImage:imageWithFile(  20, 155, 220, 25, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    confirm_panel:addChild( confirm_title_bg )
    
    local confirm_title_name = CCZXImage:imageWithFile(  121, 160, 41, 18, UIResourcePath.FileLocate.normal .. "tishi.png" )
    confirm_panel:addChild( confirm_title_name )

    local confirm_content = notice_content
    -- confirm_label = UILabel:create_label_1(confirm_content, CCSize(230,60), 140, 115, 15, CCTextAlignmentLeft, 255, 255, 0)
    local notice_dialog = CCDialog:dialogWithFile( 20, 65, 230, 85, 20000, nil, TYPE_VERTICAL, ADD_LIST_DIR_UP )
    notice_dialog:setText( confirm_content )
    confirm_panel:addChild( notice_dialog )

    local confirm_tail_line = CCZXImage:imageWithFile( 30, 20, 220, 1, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    confirm_panel:addChild( confirm_tail_line )
   
    -- "确认"按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_1 = CCNGBtnMulTex:buttonWithFile( 45, 30, 60, 31, UIResourcePath.FileLocate.common .. "button2_bg.png", 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2_bg.png")
    --but_1:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button2_bg.png")
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
        	if param then
                fun( nil, param[1], param[2], param[3], param[4], param[5], param[6], param[7], param[8], param[9]  )
            else
            	fun()
        	end
            
            fath_panel:removeChild(confirm_panel, true)
            _if_can_show_confirm = false
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)                  --注册
    confirm_panel:addChild(but_1)
    --按钮显示的名称
    local label_but_1 = UILabel:create_label_1(LangGameString[989], CCSize(100,15), 64 , 18, 14, CCTextAlignmentLeft, 255, 255, 0) -- [989]="确认"
    but_1:addChild( label_but_1 ) 

    -- "取消"按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_2 = CCNGBtnMulTex:buttonWithFile( 165, 30, 60, 31, UIResourcePath.FileLocate.common .. "button2_bg.png", 500, 500)
    but_2:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2_bg.png")
    --but_2:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button2_bg.png")
    local function but_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            fath_panel:removeChild(confirm_panel, true)
        end
        return true
    end
    but_2:registerScriptHandler(but_2_fun)                  --注册
    confirm_panel:addChild(but_2)
    --按钮显示的名称
    local label_but_2 = UILabel:create_label_1(LangGameString[794], CCSize(100,15), 64 , 18, 14, CCTextAlignmentLeft, 255, 255, 0) -- [794]="取消"
    but_2:addChild( label_but_2 ) 
    
    -- 关闭按钮
    local but_close = CCNGBtnMulTex:buttonWithFile( 240, 160, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_z.png")
    local exit_btn_size = but_close:getSize()
    local spr_bg_size = confirm_panel:getSize()
    but_close:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    but_close:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "close_btn_s.png")
    --but_close:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/close_btn_s.png")
    local function but_close_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            fath_panel:removeChild(confirm_panel, true)
        end
        return true
    end
    but_close:registerScriptHandler(but_close_fun)    --注册
    confirm_panel:addChild(but_close)

end



-- 根据颜色类型，修改对应的label颜色
function ForgeCommon:set_label_color_by_type( color_type, lable )
    require "config/StaticAttriType"
    local color_value = _static_quantity_color[ color_type + 1] or ""
    local lable_temp = color_value .. lable:getText()
    lable:setText( lable_temp )
end

-- 根据装备属性类型获取名称
function ForgeCommon:get_attr_name_by_type( type )
    require "config/ComAttribute"
    if attrNameforForge[ type + 1 ] then
        return attrNameforForge[ type + 1 ]
    end
    return ""
end
