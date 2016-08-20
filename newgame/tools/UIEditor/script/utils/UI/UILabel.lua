-- Utils.lua
-- created by fanglilian on 2012-12-5
-- UI控件公共函数

super_class.UILabel();

--一些公用方法

--设置文字颜色
function UILabel:setAttrColor(labelttf, r, g, b)
    local col1 = labelttf:getColor()
    col1.r = r or 0;
    col1.g = g or 0;
    col1.b = b or 0;
    labelttf:setColor(col1)
end

--创建属性的名称显示
-- label: (string), 
-- dimensions: (CCSize), the size of the expected label control.
-- fontsize: (int)
-- pos_x, pos_y: (int), the position of the label.
function UILabel:create_attr_label(label, dimensions, fontsize, pos_x, pos_y, alignment)
    -- local size = CCSize(100,130)

    local align = alignment;
    if (align == nil) then
    	align = CCTextAlignmentCenter;
    end
    local labelttf = CCLabelTTF:labelWithString(label, dimensions, align, "Arial", fontsize);
    UILabel:setAttrColor(labelttf, 255, 255, 0);
    local posi = CCPoint(pos_x, pos_y); 
    labelttf:setPosition(posi);     -- 设置label坐标

    return labelttf;
end

--=========================================
--根据显示字符，坐标，颜色，字体，对齐方式  创建一个label
--label ：字符串，要现实的字符
-- dimensions: (CCSize), label的尺寸
--item_pos_x , item_pos_y： 数字；坐标
--fontsize  ：数字；字体大小
--alignment：对其方式；（可不填，默认center）使用cocos2d定义好的 CCTextAlignmentLeft   CCTextAlignmentCenter   CCTextAlignmentRight
--r, g, b：颜色。可不填，默认0
--=========================================
function UILabel:create_label_1_old(label, dimensions, item_pos_x ,  item_pos_y, fontsize, alignment, r, g, b)
    if (alignment == nil) then
        alignment = CCTextAlignmentCenter;
    end
    --这里限定了，rgb值必须在全都填写和都不填中，选一种
    if (b == nil) then
        r = 0;
        g = 0;
        b = 0;
    end
    local labelttf = CCLabelTTF:labelWithString(label,dimensions, alignment, "Arial", fontsize)
    labelttf:setPosition(CCPoint(item_pos_x,item_pos_y))
    local col1 = labelttf:getColor()
    col1.r = r 
    col1.g = g
    col1.b = b
    labelttf:setColor(col1)
    return labelttf
end

--===============================
-- 使用新控件创建文字   ***********( 以前调用lablettf 的方法转化成自己定义的控件)*****************
--label ：字符串，要现实的字符
-- dimensions: (CCSize), label的尺寸
--item_pos_x , item_pos_y： 数字；坐标
--fontsize  ：数字；字体大小
--alignment：对其方式；（可不填，默认center）使用cocos2d定义好的 CCTextAlignmentLeft   CCTextAlignmentCenter   CCTextAlignmentRight
--r, g, b：颜色。可不填，默认0
--===============================
function UILabel:create_label_1(lable, dimensions, pos_x, pos_y, fontsize, alignment, r, g, b)
    local align = ALIGN_LEFT
    local lable_x = pos_x
    local lable_y = pos_y - fontsize / 2
    if  alignment == CCTextAlignmentLeft then
        align  = ALIGN_LEFT
        lable_x = pos_x - dimensions.width / 2
    elseif alignment == CCTextAlignmentCenter then
        align  = ALIGN_CENTER
        lable_x = pos_x
    elseif alignment == CCTextAlignmentRight then
        align  = ALIGN_RIGHT
        lable_x = pos_x + dimensions.width / 2
    end

    -- 计算颜色
    require "utils/Utils"
    local color_hex = "#c"..Utils:hex_to_dec( r )..Utils:hex_to_dec( g )..Utils:hex_to_dec( b )
    lable = lable or ""

    local lable = CCZXLabel:labelWithText( lable_x, lable_y, color_hex..lable, fontsize - 1, align);

    -- 适应之前调用的一些方法
    --[[
    lable.getColor = function ()
        return { ["r"]= r , ["g"]=g, ["b"]=b }
    end
    lable.setColor = function (color)
        local color_hex = "#c"..Utils:hex_to_dec( color.r )..Utils:hex_to_dec( color.g )..Utils:hex_to_dec( color.b )
        return 
    end
    ]]
    return lable
end

--=========================================
-- 创建自定义字体控件
--label ：字符串，要现实的字符
--pos_x, pos_y:  数字；坐标
--fontsize  ：数字；字体大小。  不传参数，默认16
--alignment：对齐方式；（可不填，默认 ALIGN_LEFT ）使用cocos2d定义好的 ALIGN_LEFT   ALIGN_CENTER   ALIGN_RIGHT
-- 颜色：直接在lable中设置，支持内部颜色变化：例如： 传入  "#c00ff65地球#cff0000太阳" 地球蓝色  太阳红色
--=========================================
function UILabel:create_lable_2( lable, pos_x, pos_y, fontsize, alignment )
    local fontsize = fontsize or 16
    local alignment = alignment or ALIGN_LEFT
    local lable = CCZXLabel:labelWithText( pos_x, pos_y, lable, fontsize, alignment)
    return lable
end