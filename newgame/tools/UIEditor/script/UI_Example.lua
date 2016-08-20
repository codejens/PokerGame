
UI_Example = {}
-- local UI_Example = {}
-- UI_Example.__index = UI_Example

--创建九宫格
function UI_Example:create_ninegride()
	print("-----------------create_ninegride------------------")
    -- local ninegrid = CCNineGrid:nineGridWithFile(pos_x, pos_y, siz_x, siz_y, tex_siz_x, tex_siz_y, filename)
    return ninegrid
end

--创建一个labelttf
function UI_Example:create_labelttf( )
	print("-----------------create_labelttf------------------")

	--根据显示字符串、字体名称、大小  来创建
	-- local labelttf_1 = CCLabelTTF:labelWithString("CCLabelTTF:labelWithString_3","Arial",20)
    
	--根据显示字符串、 输入框大小、对齐方式、字体名称、大小  来创建
	local size = CCSize(200,30)  --设置大小
	--注意  对齐方式  可以直接使用: CCTextAlignmentLeft   CCTextAlignmentCenter   CCTextAlignmentRight
	local labelttf_1 = CCLabelTTF:labelWithString("CCLabelTTF:labelWithString_5",size,CCTextAlignmentLeft,"Arial",20)

	--设置位置
	local po2 = CCPoint(100, 200)
    labelttf_1:setPosition(po2)

    --设置旋转
    labelttf_1:setRotation(45)

    --设置颜色
    local col1 = labelttf_1:getColor()
    col1.r = 255 
    col1.g = 255
    col1.b = 100
    labelttf_1:setColor(col1)

    return labelttf_1
end

--创建menu
function UI_Example:create_menu()
	print("-----------------create_menu------------------")

    -- local menu = CCMenu:node()

    --使用CCMenuItemLabel创建item
    local labelttf_1 = CCLabelTTF:labelWithString(LangGameString[2296],"Arial",20) -- [2296]="CCMenuItemLabel 菜单项"
    local ccMenuItemLabel =  CCMenuItemLabel:itemWithLabel(labelttf_1)

    --设置点击（触屏）监听
    local function onTouch(eventType, x, y)
        --print(eventType, x, y)
        if eventType == CCTOUCHBEGAN then
            return onTouchBegan(x, y)
        elseif eventType == CCTOUCHMOVED then
            return onTouchMoved(x, y)
        end
    end
    ccMenuItemLabel:registerScriptHandler(onTouch)  --设置触发的方法

    -- menu.addChild(ccMenuItemLabel)
    local menu = CCMenu:menuWithItem( ccMenuItemLabel )

    --使用CCMenuItemImage创建item
    local item_image = CCMenuItemImage:itemFromNormalImage("test/img_but_nor.png","test/img_but_sel.png")
    -- local menu1 = CCMenu:menuWithItem(item_button1)
    menu:addChild(item_image, 10, 10)

    --使用精灵对象CCMenuItemSprite创建item
    local sprite_normal = CCSprite:spriteWithFile("test/spr_but_nor.png")
    local sprite_select = CCSprite:spriteWithFile("test/spr_but_sel.png")
    local sprite_disable = CCSprite:spriteWithFile("test/spr_but_disl.png")
    local item_sprite = CCMenuItemSprite:itemFromNormalSprite(sprite_normal, sprite_select, sprite_disable)
    menu:addChild(item_sprite, 10, 10)

    --CCMenuItemToggle开关菜单。几个item交替显示
    --加入图片交替item
    local item_image2 = CCMenuItemImage:itemFromNormalImage("test/img_but_nor.png","test/img_but_sel.png")
    local toggle_item = CCMenuItemToggle:itemWithItem(item_image2)
    --加入精灵创建的item
    local sprite_normal2 = CCSprite:spriteWithFile("test/spr_but_nor.png")
    local sprite_select2 = CCSprite:spriteWithFile("test/spr_but_sel.png")
    local sprite_disable2 = CCSprite:spriteWithFile("test/spr_but_disl.png")
    local item_sprite2 = CCMenuItemSprite:itemFromNormalSprite(sprite_normal2, sprite_select2, sprite_disable2)
    toggle_item:addSubItem(item_sprite2)
    --加入label创建的item
    local labelttf_12 = CCLabelTTF:labelWithString(LangGameString[2296],"Arial",20) -- [2296]="CCMenuItemLabel 菜单项"
    local ccMenuItemLabel2 =  CCMenuItemLabel:itemWithLabel(labelttf_12)
    toggle_item:addSubItem(ccMenuItemLabel2)

    menu:addChild(toggle_item, 10, 10)


    menu:setPosition(300,300)    --设置菜单位置
    menu:alignItemsVertically()  --设置菜单纵向排列方式，横向为：alignItemsHorizontally
    -- menu:alignItemsVerticallyWithPadding(60.0)--设置纵向排列并且设置间距，横向为alignItemsHorizontallyWithPadding
    -- menu:setOpacity(100)         --设置透明度
    -- local col = menu:getColor()  --设置颜色
    -- col.r = 255
    -- col.g = 255
    -- col.b = 255
    -- menu:setColor(col)



    menu:setIsTouchEnabled(true)  --设置menu可以触控

    return menu
end

function UI_Example:ui_ex_create( mapLayer )
    --ninegrid
	-- local ninegrid = UI_Example:create_ninegride()
 --    mapLayer:addChild( ninegrid )

    --********  CCLabelTTF  ********
    local labelttf =  UI_Example:create_labelttf() 
    mapLayer:addChild( labelttf )

    --********  菜单  ********
    local menu =  UI_Example:create_menu()
    mapLayer:addChild( menu )

    -- return ninegrid
end


