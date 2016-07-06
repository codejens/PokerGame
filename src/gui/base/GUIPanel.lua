-----------------------------------------------------------------------------
-- 面板容器
-- @author tjh
-- @release 1
-----------------------------------------------------------------------------

--默认九宫格参数rect
local _rect = cc.rect(10,10,10,10)
--!class GUIPanel
-- @see GUIImg
GUIPanel = simple_class(GUITouchBase)

--- 构造函数
-- @param view ccui.ImageView控件对象
-- @see members
function GUIPanel:__init(view)
	self.class_name = "GUIPanel"
	-- print("self.class_name=",self.class_name)
	-- self.init_count = self.init_count or 1
	-- self.init_count = self.init_count + 1
end

--创建图片控件函数
--@param texture 贴图资源
function GUIPanel:create(texture)
	if texture then
		return self(ccui.ImageView:create(texture))
	else
		return self(ccui.ImageView:create())
	end
end

--创建九宫格图片函数
--@param texture 图片路径
--@param rect  拉伸CapInsets
function GUIPanel:create9Img( texture,rect )
	local img = self(self:create(texture).core)
	img:setScale9Enabled(true)
	img:setCapInsets(rect or _rect)
	return img
end

--启用九宫格
function GUIPanel:setScale9Enabled( enabled )
	self.core:setScale9Enabled(enabled)
end
--设置九宫格rect
function GUIPanel:setCapInsets( rect )
	self.core:setCapInsets(rect)
end


function GUIPanel:create_by_layout( layout )
	local nine_size = 0
	local core
	if layout.is_nine then
		-- nine_size = 500
		core = self:create9Img(layout.img_n)-- nine_size,nine_size)
	else
		core = self:create(layout.img_n)
	end
	-- print("layout.img_n=",layout.img_n)
-- print("layout.pos[1],layout.pos[2]=",layout.pos[1],layout.pos[2])
	core:setPosition(layout.pos[1],layout.pos[2])
	-- print("layout.size[1],layout.size[2]=",layout.size[1],layout.size[2])
	core:setContentSize(layout.size[1],layout.size[2])
	return core
end