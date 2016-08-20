-- ZSlotBase.lua
-- created by aXing on 2014-5-12
-- 创建格子控件的基类
-- 格子控件是与游戏逻辑密切相关的组合型控件
-- 它必然有一个icon图标
-- 可以根据设置的高宽，拉伸图标

super_class.ZSlotBase(ZAbstractBasePanel)

function ZSlotBase:__init(width, height)

	self.width 	= width or 64
	self.height	= height or 64

	self.view 	= CCBasePanel:panelWithFile( 0, 0, self.width, self.height, "", 0, 0, 0, 0, 0, 0, 0, 0 )

	-- icon 为必选项
	self.icon 	= ZImage.new()
	self.icon:setAnchorPoint(0.5, 0.5)	-- 图标默认居中
	local icon_x = self.width / 2
	local icon_y = self.height/ 2
	self.icon:setPosition(icon_x, icon_y)
	self:addChild(self.icon, 10)

	self.is_gray = false				-- 是否灰度化
end

function ZSlotBase:fini(  )
	self.is_gray = false
end

function ZSlotBase:set_icon_texture( texture )
	if self.icon ~= nil then
		self.icon:setTexture(texture)
	end
end

function ZSlotBase:setSize( width, height )
	ZAbstractBasePanel.setSize(self, widht, height)
	-- 改变图标的大小
	self.icon:setSize(width, height)
	local icon_x = self.width / 2
	local icon_y = self.height/ 2
	self.icon:setPosition(icon_x, icon_y)
end

-- 所有的图标都可以设置灰度图
function ZSlotBase:setGray( is_gray )
	if self.is_gray == is_gray then
		return
	end

	if is_gray then
		self:show_cover_color( 0xff000050 )
	else
		self:hide_cover_color()
	end

	self.is_gray = is_gray
end

-- 设置覆盖的色板
function ZSlotBase:show_cover_color( rbga_value )
	local rbga = rbga_value or 0xffffff00
	if self.color_cover == nil then
         self.color_cover = CCArcRect:arcRectWithColor( 0, 0, self.width, self.height, 0xffffff00  )
         self:addChild( self.color_cover, 999 )
	end
	-- self.color_cover:setIsVisible( true )
	self.color_cover:setColor( rbga )
	self.color_cover:setDefaultMessageReturn( true )
end

-- 隐藏覆盖的色板
function ZSlotBase:hide_cover_color(  )
	if self.color_cover then
		-- self.color_cover:setIsVisible( false )
		self.color_cover:setColor( 0xffffff00 )
        self.color_cover:setDefaultMessageReturn( false )
	end
end