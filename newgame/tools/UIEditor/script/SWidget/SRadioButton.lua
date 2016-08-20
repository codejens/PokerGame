--SRadioButton.lua
--create by tjh on 2015.7.13
--组选按钮的一个按钮
--配合SRadioButtonGroup使用

SRadioButton = simple_class(STouchBase)

function SRadioButton:__init(view, layout)
	STouchBase.__init(self,view,layout)
	-- self:set_sound_id(4)
	-- local function on_focus_func()
	-- 	self:setScale(1.05,1.05)
	
	-- end
	-- self:set_touch_func(ON_FOCUS,on_focus_func )

	-- local function out_focus_func()
	-- 	self:setScale(1.0,1.0)
	
	-- end
	-- self:set_touch_func(OUT_OF_FOCUS,out_focus_func )
end

--创建组选按钮单个按钮
--@param nor_img 正常图片
--@param sel_img 选中图片
function SRadioButton:create(nor_img, sel_img, w, h)
	local btn = CCRadioButton:radioButtonWithFile(0, 0, w or -1, h or -1, nor_img)
	
	if sel_img then
		btn:addTexWithFile(CLICK_STATE_DOWN,sel_img)
	else
		btn:addTexWithFile(CLICK_STATE_DOWN,"")
	end
	--不支持 组选按钮会控制状态
	-- if dis_img then
	-- 	btn:addTexWithFile(CLICK_STATE_DISABLE, dis_img)
	-- end
	return self(btn)
end

function SRadioButton:create_by_layout(layout)
	local nine_size = 0
	if layout.is_nine then
		nine_size = 500
	end

	local btn = CCRadioButton:radioButtonWithFile(layout.pos[1],layout.pos[2], layout.size[1] ,layout.size[2],layout.img_n)
	if layout.img_s then
		btn:addTexWithFile(CLICK_STATE_DOWN,layout.img_s)
	else
		btn:addTexWithFile(CLICK_STATE_DOWN,"")
	end
	return self(btn,layout)
end

function SRadioButton:quick_create(x,y,w,h,img_n,img_s,parent,zOrder)
	local btn = CCRadioButton:radioButtonWithFile(x,y,w,h,img_n)
	img_s = img_s or img_n
	btn:addTexWithFile(CLICK_STATE_DOWN,img_s)
	local obj = self(btn)
	obj:addTo(parent,zOrder)
	return obj
end

function SRadioButton:setAnchorPoint(x, y)
	self.view:setAnchorPoint(x, y)
end