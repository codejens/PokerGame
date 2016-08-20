
require "UI/component/Window"
super_class.ChaAttrWin(Window)
super_class.ChaAttrPanel(Window)



--一些公用方法

--设置文字位置
local function setAttrPosi( labelttf, x, y )
    local posi = CCPoint(x, y)
    labelttf:setPosition(posi)
end

--设置文字颜色
local function setAttrColor(labelttf, r, g, b)
    local col1 = labelttf:getColor()
    col1.r = r 
    col1.g = g
    col1.b = b
    labelttf:setColor(col1)
end
--创建属性的名称显示
local function create_attr_lab( label, dimensions, fontsize, po_x, po_y )
    -- local size = CCSize(100,130)
    local labelttf_1 = CCLabelTTF:labelWithString(label, dimensions, CCTextAlignmentRight, "Arial", fontsize)
    setAttrPosi( labelttf_1, po_x, po_y )
    -- self:setAttrColor(labelttf_1, 97, 169, 117)
    setAttrColor(labelttf_1, 255, 255, 0)
    return labelttf_1
end

--创建属性的数值显示
local function create_attr_num( label, dimensions, fontsize, po_x, po_y )
    -- local size = CCSize(100,130)
    local labelttf_1 = CCLabelTTF:labelWithString(label, dimensions, CCTextAlignmentLeft, "Arial", fontsize)
    setAttrPosi( labelttf_1, po_x, po_y )
    setAttrColor(labelttf_1, 255, 255, 255)
    return labelttf_1
end






--ChaAttrWin初始化方法
function ChaAttrWin:__init( texture_name )
    --背景
    -- self.view = CCNineGrid:nineGridWithFile(300, 100, 300, 400, 126, 62, texture_name)
    self.view = CCBasePanel:panelWithFile( 300, 100, 300, 400, nil, -1, -1 )
    
    --创建属性面板
    local attrPanel = ChaAttrPanel:create("testImage.png", 300, -200, 200, 800)
    self.view:addChild( attrPanel.view )
end

--创建ChaAttrWin
function ChaAttrWin:create()
	return ChaAttrWin()
end






--======================================
--ChaAttrPanel 属性显示面板
--用于布局属性和数值
--
--======================================

--ChaAttrPanel初始化方法
function ChaAttrPanel:__init( window_name, texture_name, x, y, w, h )
    --背景
    -- self.panel_bg = CCNineGrid:nineGridWithFile(300, 100, 300, 400, 126, 62, texture_name)
    self.view = CCBasePanel:panelWithFile( x, y, w, h, texture_name, -1, -1 )
    self:addattribute( self.view )
end

function ChaAttrPanel:create( window_name, texture_name, x, y, w, h  )
    return ChaAttrPanel(window_name, {texture = texture_name, x = x, y = y, width = w, height = h} )
end
--显示测试用的方法
function ChaAttrPanel:show( mapLayer )

	-- local ninegrid_pos = self.ninegrid_bg:getPos()  --九宫格坐标
    --title文字1
    -- local dimensions = CCSize(100,15)   --lable尺寸
    -- local title_1 = CCLabelTTF:labelWithString("物理攻击", dimensions, CCTextAlignmentLeft, "宋体", 15)
    -- self:setAttrPosi( title_1, ninegrid_pos.x + 100, ninegrid_pos.y + 320)
    -- self:setAttrColor(title_1, 255, 255, 0)
    -- self.ninegrid_bg:addChild(title_1)

    --添加属性-数值显示
	-- self:addattribute( self.view )
 --    mapLayer:addChild( self.view )
end

--添加属性
function ChaAttrPanel:addattribute( )
    --背景
    local ninegrid = self.view

    --获取面板位置坐标，用于计算文字的相对坐标
    local pos = ninegrid:getPosition()
    local ninegrid_x, ninegrid_y = pos.x, pos.y + ninegrid:getSize().height / 2   --面板坐标
	
	--起始坐标、间距等固定值
	local fontsize = 15          --字体大小
	local lable_siz_w = 150      --label尺寸的宽度值
    local lable_siz_h = fontsize --尺寸高度设置成和字体大小一样，就不会出现中文和数字不对齐的问题
    local dimensions = CCSize(lable_siz_w,lable_siz_h)   --lable尺寸
    local lable_inteval_x = 0        --labelx坐标的间距
    local lable_inteva_y = lable_siz_h  --labely坐标的间距，等于label高度

    --基准坐标
    local lable_nam_sta_x = ninegrid_x + 20 --属性名称的起始x坐标,通过九宫格坐标计算
    local lable_nam_sta_y = ninegrid_y + 130  --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local lable_num_sta_x = lable_nam_sta_x + lable_siz_w   --属性数值的起始x坐标
    local lable_num_sta_y = lable_nam_sta_y  --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local count = 1      --用于计算第几行，计算坐标

    --加入属性
    ninegrid:addChild( create_attr_lab( LangGameString[356]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [356]="物理攻击"
    ninegrid:addChild( create_attr_num( "327",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[339]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [339]="物理防御"
    ninegrid:addChild( create_attr_num( "299",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[338]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [338]="法术防御"
    ninegrid:addChild( create_attr_num( "216",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[712]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [712]="生    命"
    ninegrid:addChild( create_attr_num( "2714 / 2714",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[713]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [713]="法    力"
    ninegrid:addChild( create_attr_num( "887 / 887",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    --分块：
    lable_nam_sta_y = lable_nam_sta_y - 10 
    lable_num_sta_y = lable_num_sta_y - 10
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[714]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [714]="命    中"
    ninegrid:addChild( create_attr_num( "59",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[715]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [715]="闪    避"
    ninegrid:addChild( create_attr_num( "133",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[716]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [716]="暴    击"
    ninegrid:addChild( create_attr_num( "69",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[717]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [717]="抗 暴 击"
    ninegrid:addChild( create_attr_num( "150",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[718]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [718]="会    心"
    ninegrid:addChild( create_attr_num( "100",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    --分块：
    lable_nam_sta_y = lable_nam_sta_y - 10 
    lable_num_sta_y = lable_num_sta_y - 10
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[719]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [719]="追加伤害"
    ninegrid:addChild( create_attr_num( "12",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[358]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [358]="无视防御"
    ninegrid:addChild( create_attr_num( "333",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[364]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [364]="物理免伤"
    ninegrid:addChild( create_attr_num( "124",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[363]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [363]="法术免伤"
    ninegrid:addChild( create_attr_num( "165",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )
    --分块：
    lable_nam_sta_y = lable_nam_sta_y - 10 
    lable_num_sta_y = lable_num_sta_y - 10
    count = count + 1
    ninegrid:addChild( create_attr_lab( LangGameString[21]..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_sta_y - lable_inteva_y * (count - 1) ) ) -- [21]="移动速度"
    ninegrid:addChild( create_attr_num( "3333333",dimensions, fontsize, lable_num_sta_x, lable_num_sta_y - lable_inteva_y * (count - 1) ) )



    --显示的属性和数值
 --    local allAttrTable = {{"第一属性","1111111"},{"第二属性","222222"},{"第三属性","333333"}
 --                         ,{"第三属性","333333"},{"第三属性","333333"},{"第三属性","333333"}
 --                         ,{"第三属性","333333"},{"第三属性","333333"},{"第三属性","333333"}}
 --    local lable_nam_sta_x = 380  --属性名称的起始x坐标
 --    local lable_nam_end_y = 420
 --    local lable_num_sta_x = lable_nam_sta_x + lable_siz_w   --属性数值的起始x坐标
 --    local lable_num_end_y = 420

	-- local dimensions = CCSize(lable_siz_w,lable_siz_h)
    
 --    for i=1, #allAttrTable do
 --    	local name, numb = unpack( allAttrTable[i] )
 --    	local attribute_1_name = self:create_attr_lab( name..": ", dimensions, fontsize, lable_nam_sta_x, lable_nam_end_y - lable_int_y * (i - 1) )
 --        local attribute_1_number = self:create_attr_num( numb,dimensions, fontsize, lable_num_sta_x, lable_num_end_y - lable_int_y * (i - 1) )
 --        ninegrid:addChild( attribute_1_name )
 --        ninegrid:addChild( attribute_1_number )
 --    end


end


