-- TransformAvatarTitile.lua
-- created by mwy on 2014-6-04
-- 人物头顶文字和图标显示

TransformAvatarTitile = {}

---创建QQVIP名字
function TransformAvatarTitile:create_avatar_titile(info, name, aline,id,level)
	local add_list = {}
    ---getContentSize
    local qq_vip_icon = CCSprite:spriteWithFile("icon/bianshen/tag/"..level..".pd")
    qq_vip_icon:setContentSize(CCSizeMake(16,15))
    qq_vip_icon:setAnchorPoint(CCPointMake(0,0))

    local qq_vip_icon_size = qq_vip_icon:getContentSize()

    table.insert( add_list, qq_vip_icon )

    --------------------角色名字
    local name_lab = Label:create( nil, 0, 0, name )
    table.insert( add_list, name_lab.view )
    local name_lab_size = name_lab:getSize()

    ----------------------------
    local panel_height = name_lab_size.height
    local temp_panel = ZBasePanel:create( nil, "", 0, 0, qq_vip_icon_size.width+10  + name_lab_size.width, panel_height )
    local temp_panel_size = temp_panel:getSize()

	temp_panel.temp_panel_size=temp_panel_size
	temp_panel.qq_vip_icon_size=qq_vip_icon_size
	temp_panel.qq_vip_icon = qq_vip_icon
	temp_panel.name_lab = name_lab
    temp_panel.aline = aline
    temp_panel.name_lab_size = name_lab_size

    temp_panel.qq_vip_icon:setPosition( CCPointMake( 0, 0 ) )
    temp_panel.name_lab:setPosition( qq_vip_icon_size.width+10, 3 ) 

    -------------
    for i = 1, #add_list do
        temp_panel:addChild( add_list[i] )
    end

    self:reset_title_position(temp_panel,id)

    temp_panel.change_super_icon = function( level )
        temp_panel.qq_vip_icon:replaceTexture("icon/bianshen/tag/"..level..".pd")
        temp_panel.qq_vip_icon:setContentSize(CCSizeMake(16,15))
        temp_panel.qq_vip_icon:setAnchorPoint(CCPointMake(0,0))
    end
    return temp_panel
end

-- 判断是否在变形状态以调整图标和人物名字的显示位置
function TransformAvatarTitile:reset_title_position(temp_panel,id)
	if temp_panel==nil then
		return
	end
	local temp_panel_size = temp_panel.temp_panel_size
	local qq_vip_icon_size = temp_panel.qq_vip_icon_size
	local qq_vip_icon = temp_panel.qq_vip_icon
	local name_lab = temp_panel.name_lab
	local aline = temp_panel.aline
	local name_lab_size=temp_panel.name_lab_size

	if id~=0 then
		 temp_panel.qq_vip_icon:setIsVisible(true)
	     temp_panel.qq_vip_icon:setPosition( CCPointMake( 0, 0 ) )
	     temp_panel.name_lab:setPosition( qq_vip_icon_size.width+10, 3 ) 

	else--非变形状态，隐藏变身图标
		 temp_panel.qq_vip_icon:setIsVisible(false)
		 temp_panel.qq_vip_icon:setPosition( CCPointMake( 0, 0 ) )
     	 temp_panel.name_lab:setPosition( ( qq_vip_icon_size.width+10 ) / 2, 3 )
	end
end

