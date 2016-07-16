-----------------------------------------------------------------------------
-- 图片控件
-- @author tjh
-- @release 1
-----------------------------------------------------------------------------

--!class GUIImg
-- @see GUITouchBase
GUIImg = simple_class(GUITouchBase)

--默认九宫格参数rect
local _rect = cc.rect(10,10,10,10)


--- 构造函数
-- @param view ccui.ImageView控件对象
-- @see members
function GUIImg:__init( view )
	self.class_name = "GUIImg"
	-- print("self.class_name=",self.class_name)
	-- self.init_count = self.init_count or 1
	-- self.init_count = self.init_count + 1
	-- print(self.init_count)
	self:setTouchEnabled(false)
end

--创建图片控件函数
--@param texture 贴图资源
function GUIImg:create(texture)
	if texture then
		return self(ccui.ImageView:create(texture))
	else
		return self(ccui.ImageView:create())
	end
end

function GUIImg:create_by_layout(layout)
	local img = self(self:create(layout.img_n).core)
	img:setPosition(layout.pos[1],layout.pos[2])
	if layout.size then
		img:setContentSize(layout.size[1],layout.size[2])
	end
	if img.is_nine then
		img:setScale9Enabled(true)
	end
	return img
end

--创建九宫格图片函数
--@param texture 图片路径
--@param rect  拉伸CapInsets
function GUIImg:create9Img( texture,rect )
	local img = self(self:create(texture).core)
	img:setScale9Enabled(true)
	img:setCapInsets(rect or _rect)
	return img
end

--设置贴图函数
--@param texture 贴图资源
function GUIImg:loadTexture( texture )
	self.core:loadTexture(texture)
end

--启用九宫格
function GUIImg:setScale9Enabled( enabled )
	self.core:setScale9Enabled(enabled)
end
--设置九宫格rect
function GUIImg:setCapInsets( rect )
	self.core:setCapInsets(rect)
end

