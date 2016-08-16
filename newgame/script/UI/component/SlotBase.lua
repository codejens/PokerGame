-- SlotBase.lua
-- created by aXing on 2012-12-8
-- 基础slot只用于显示图片和右下角的数量label
-- 实现点击事件和双击事件的注册
super_class.SlotBase()

local _Width = 75
local _Height = 75

--SlotBase重新整理了下
--所有元素放在一个空面板上面 创建时候都使用默认道具资源创建背景大小的
--整体缩放
function SlotBase:setScale(x,y)
	if x and y then
		self.view:setScaleX(x)
		self.view:setScaleY(y)
	elseif x then
		self.view:setScale(x)
	end
end

--隐藏背景
function SlotBase:set_visible_bg(flags)
	self.icon_bg:setIsVisible(flags)
end

--消息透传
function SlotBase:set_message_cut(flags)
	 self.view:setDefaultMessageReturn(flags)
end

--其他元素需要修改的 再添加方法 或者一些旧方法

-- 初始化格子
function SlotBase:__init(width, height, image)
	self.width 	= width
	self.height	= height

	local scalex = width/_Width
	local scaley = height/_Height
	--edit by tgh 资源统一了  统一处理下 为了方便位置对准
	self.view = CCBasePanel:panelWithFile(0, 0, _Width, _Height,"")
	self:setScale(scalex,scaley)

	self.icon_bg= nil
	self.color_frame = nil
	self.color_cover = nil        -- 色板遮挡,层级为 999（要在最上层）
	self.cur_icon_texture = ""

	--local icon_bg = "sui/common/slot_frame.png" or image
	--if image then
	   self.icon_bg = CCBasePanel:panelWithFile(0, 0, -1, -1, "sui/common/slot_bg.png")
	   self.icon_bg:setAnchorPoint(0.5,0.5)
	   self.icon_bg:setPosition(_Width/2,_Height/2)
	   self.view:addChild(self.icon_bg,0)
	--end

	--没有资源隐藏背景
	if image then
		--兼容传""字符串为透明处理
		local pos1,pos2 = string.find(image , "/")
		if not pos1 then
			local pos1,pos2 = string.find(image , "\\")
		end
		if not pos1 then
			self:set_visible_bg(false)
		else
			self:set_icon_bg_texture(image,nil,nil,width,height)
		end
	-- else
	-- 	self:set_visible_bg(false)
	end
	--self.view	= CCBasePanel:panelWithFile(0, 0, width, height, image)

	self.icon = MUtils:CCSprite(nil,"",_Width, _Height)
	self.icon:setAnchorPoint(CCPointMake(0.5, 0.5))
	self.icon:setPosition(_Width/2, _Height/2)
	self.view:addChild(self.icon, 3)


	--遮罩
	self.color_cover_path = "sui/other/slot_disable.png"
	self.color_cover = CCBasePanel:panelWithFile(_Width/2,_Height/2, _Width, _Height,self.color_cover_path)
	self.color_cover:setAnchorPoint(0.5,0.5)
    self.view:addChild(self.color_cover, 999)
    self.color_cover:setIsVisible(false)

	-- add by fjh ,2012-12-27
	self.tag 	= 0
	
	-- 注册点击事件
	local function on_click_event(eventType, args, msgid)
		if eventType == TOUCH_BEGAN then
			if self.on_begin_event ~= nil then
				self.on_begin_event(self,args)
			end
			return true
		elseif eventType == TOUCH_CLICK then
			if self.on_click_event ~= nil then
			    self.on_click_event(self,args)
		    end
			return true
		elseif eventType == TOUCH_DOUBLE_CLICK then
			if self.on_double_click_event ~= nil then
				self.on_double_click_event(self,args)
			end
			return true
		elseif eventType == ITEM_DELETE then
			if self.on_delete_event ~= nil then
				self.on_delete_event(self,args)
			end
			return true
		end
	end

	self.view:registerScriptHandler(on_click_event)
end

-- 设置格子的图标
-- 每个功能派生需要实现自己的icon id索引
function SlotBase:set_icon_texture(icon_texture)
	--self:set_visible_bg(true)
	self.cur_icon_texture = icon_texture
	-- 如果icon为空的话要去掉color_frame
	if (icon_texture == "") then
		self:set_color_frame(nil)
		self.icon:replaceTexture("")
		MUtils:close_slot_day_time(self)
	else
		--test by tjh 因为道具全改了 很多没有icon 方便测试
		local r = -1
		local name,r = phone_findFile(icon_texture,r)
		if r == 0 then
			icon_texture ="icon/item/test_bag.pd" 
		end
		--test end

		--safe_retain(self.icon)
		ResourceManager.ImageUnitTextureBackgroundLoad(icon_texture, self.set_icon_texture_load, self)
	end
	-- 设置背景和框不可见
	if self.color_frame then
        self.view:removeChild(self.color_frame, true)
        self.color_frame = nil  
    end
    if self.color_bg then
        self.view:removeChild(self.color_bg, true)
        self.color_bg = nil  
    end
    if self.recovery_frame then
    	self:recovery_frame()
    end
end

--后台加载回调
function SlotBase:set_icon_texture_load(icon_texture, texture_loaded)
    if not texture_loaded then
        return
    end
	if self.cur_icon_texture == icon_texture then
		pcall(function() self.icon:replaceTexture(icon_texture) end)
	end
	--safe_release(self.icon)
end

--设置icon的大小，add by fjh , 2012-12-27
function SlotBase:set_icon_size(width,height)
	if self.icon ~= nil then
		-- self.icon:setSize(width,height)
		self.icon:setContentSize(CCSizeMake(width,height))
	end
end

-- 设置icon的背景框
function SlotBase:set_icon_bg_texture(icon_bg_textures, po_x, po_y, width, height)
	-- if self.icon_bg == nil then
	--     self.icon_bg= CCZXImage:imageWithFile(0, 0, self.width, self.height,nil)
	--     self.view:addChild(self.icon_bg, 0)
	-- end
	self:set_visible_bg(true)
	self.icon_bg:setTexture(icon_bg_textures)
	-- if po_x and po_y and width and height then
		-- self.icon_bg:setPosition(po_x, po_y)
		-- self.icon_bg:setSize(width, height)
	-- end
	if width and height then
		self.icon_bg:setSize(width, height)
	end
end

-- 设置icon的边框
function SlotBase:set_icon_frame_texture(icon_frame_texture)
	if self.color_frame == nil then
	    self.color_frame = CCZXImage:imageWithFile(0, 0, -1, -1, icon_frame_texture)
	    self.color_frame:setAnchorPoint(0.5, 0.5)
	    self.color_frame:setPosition(_Width/2, _Height/2)
		self.view:addChild(self.color_frame, 9)
	else
		self.color_frame:setTexture(path)
	end
end

-- 设置icon的title（精灵技能）
function SlotBase:set_icon_text(text)
	if self.title_lab == nil then
	    self.title_lab=  CCZXLabel:labelWithText(31, 25, '#c929292'..text, 16, ALIGN_CENTER)
	    self.view:addChild(self.title_lab, 0)
	end
	self.title_lab:setText('#c929292'..text)
end

-- 设置icom边框的颜色(例如武器分蓝，绿，紫三种颜色)  
function SlotBase:set_color_frame(item_id)
	local path = string.sub(self.cur_icon_texture, 1,11)
	--print (path)
	if self.color_effect then
		--self.color_effect:removeChild(self.color_effect, true)
		self.color_effect:removeFromParentAndCleanup(true)
		self.color_effect = nil
	end

	--也许不需要这种监听功能
	--self.view:set_touch_func(ITEM_DELETE, call_back)
	
	--UIManager 这里先被调用，所以find_visible_window是找不到的，必须下一帧加载
	local function cb ()
		if path ~= "icon/money/" and (
				UIManager:find_visible_window("open_service_win") 
				or UIManager:find_visible_window("reward_win") 
				or UIManager:find_visible_window("activity_yy_win") 
				or UIManager:find_visible_window("special_activity_win") 
				or UIManager:find_visible_window("geocaching_win") 
				or UIManager:find_visible_window("vip_win") 
				or UIManager:find_visible_window("first_recharge") 
				or UIManager:find_visible_window("choubin_win") 
				or UIManager:find_visible_window("meirihaoli_tip") 
				or UIManager:find_visible_window("leijidenglu_tip") 
				--or UIManager:find_visible_window("sactivity_win") 
			) then
			local eff_color = 0
			if item_id and item_id > 0 then
				local item_base = ItemConfig:get_item_by_id(item_id)
				if item_base then
					if item_base.color == 3 then
						eff_color = 92
					elseif item_base.color == 4 then
						eff_color = 93
					elseif item_base.color == 5 then
						eff_color = 94
					end
				end
			end

			-- if self.color_effect then
			-- 	--self.color_effect:removeChild(self.color_effect, true)
			-- 	self.color_effect:removeFromParentAndCleanup(true)
			-- 	self.color_effect = nil
			-- end

			if not self.color_effect and eff_color > 0 then
				self.color_effect = SEffectBuilder:create_a_effect(eff_color, -1)
				self.color_effect:setPosition(_Width/2-2, _Height/2+4)
				self.view:addChild(self.color_effect, 9999)
			end

			--self.color_effect:setIsVisible(true)
		end
	end
	new_call_back(0, cb)

	if self.bg_frame then
		self.bg_frame:setIsVisible(false)
	end
	if item_id == nil or item_id == 0 then 
		if self.color_frame then
            self.view:removeChild(self.color_frame, true)
            self.color_frame = nil  
        end
        if self.color_bg then
            self.view:removeChild(self.color_bg, true)
            self.color_bg = nil  
        end
		return 
	end
	require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id(item_id)
    if item_base == nil then 
    	if self.color_frame then
            self.view:removeChild(self.color_frame, true)
            self.color_frame = nil  
        end
        if self.color_bg then
            self.view:removeChild(self.color_bg, true)
            self.color_bg = nil  
        end
        return
    end
    if item_base.color and item_base.color >=0 and item_base.color <= 5 then
		local color_type = item_base.color
	    local path = string.format("sui/other/f%d.png",color_type)
	    if self.color_frame == nil then
	    	self.color_frame = CCZXImage:imageWithFile(0, 0, -1, -1, path)
	    	self.color_frame:setAnchorPoint(0.5,0.5)
	    	self.color_frame:setPosition(_Width/2,_Height/2)
		    self.view:addChild(self.color_frame, 9)
		else
			self.color_frame:setTexture(path)
	    end
	    local path = string.format("sui/other/%d.png",color_type)
	    if self.color_bg == nil then
	    	self.color_bg = CCZXImage:imageWithFile(0, 0, -1, -1, path)
	    	self.color_bg:setAnchorPoint(0.5,0.5)
	    	self.color_bg:setPosition(_Width/2,_Height/2)
		    self.view:addChild(self.color_bg, 1)
		else
			self.color_bg:setTexture(path)
	    end
    end

end

-- add by chj(0灰色，1绿色，2蓝色，3紫，4橙，5,红)
function SlotBase:set_quality_color(color)
	 if color and color >=0 and color <= 5 then
	    local path = string.format("sui/other/f%d.png", color)

	    if self.color_frame == nil then
	    	self.color_frame = CCZXImage:imageWithFile(0, 0, -1, -1, path)
	    	self.color_frame:setAnchorPoint(0.5,0.5)
	    	self.color_frame:setPosition(_Width/2,_Height/2)
		    self.view:addChild(self.color_frame, 9)
		else
			self.color_frame:setTexture(path)
	    end

	    local path = string.format("sui/other/%d.png", color)
	    if self.color_bg == nil then
	    	self.color_bg = CCZXImage:imageWithFile(0, 0, -1, -1, path)
	    	self.color_bg:setAnchorPoint(0.5,0.5)
	    	self.color_bg:setPosition(_Width/2,_Height/2)
		    self.view:addChild(self.color_bg, 1)
		else
			self.color_bg:setTexture(path)
	    end

    end
end

--数量上，是否显示0和1
function SlotBase:set_show_0_1(bool)
	self.show_0_1 = bool
end

--设置格子的数量
function SlotBase:set_count(count)
	self.count = count
	--如果数量是0或者1的话，则隐藏数字控件
	self:create_count_label()
	if not self.show_0_1 and (count == 0 or count == 1) then
		self._count_image.view:setIsVisible(false)
	else
		self._count_image.view:setIsVisible(self.cur_icon_texture ~= "" and true or false)
		self._count_image:set_number(count, true)
	end
end

--设置icon的位置，暂时只有坐骑技能在用这个方法
function SlotBase:set_icon_position(x,y)
	self.icon:setPosition(tonumber(x),tonumber(y))
end

function SlotBase:set_setScale(scale)
	self.scale = scale
	--local size = 86 * Scale
    self.icon:setScale(scale)
    --self.icon:setPosition(size/2,size/2)
    self.color_cover:setScale(scale)
end

-- 取得格子的数量
function SlotBase:get_count()
	return self.count
end


function SlotBase:set_tag(tag)
	self.tag = tag
end
function SlotBase:get_tag()
	return self.tag
end

-- 移动格子
function SlotBase:setPosition(x, y)
	self.view:setPosition(tonumber(x), tonumber(y))
end

function SlotBase:getPosition()
	return self.view:getPosition()
end

--设置锚点，by fjh,
function SlotBase:setAnchor(x,y)
	self.view:setAnchorPoint(x,y)
end

--设置单击回调函数
function SlotBase:set_click_event(fn)
	self.on_click_event = fn
end

--设置单击回调函数
function SlotBase:set_begin_event(fn)
	self.on_begin_event = fn
end

--设置双击回调函数
function SlotBase:set_double_click_event(fn)
	self.on_double_click_event = fn
	self.view:setEnableDoubleClick(true)
end

--设置单击回调函数
function SlotBase:set_begin_event(fn)
	self.on_begin_event = fn
end

-- view销毁时的回调函数
function SlotBase:set_delete_event(fn)
	self.on_delete_view_event = fn
end

-- 设置无效
function SlotBase:set_slot_disable()
	self:set_icon_dead_color()
	self.color_cover:setDefaultMessageReturn(true)
end

-- 设置生效
function SlotBase:set_slot_enable()
	self:set_icon_light_color()
	self.color_cover:setDefaultMessageReturn(false)
end

-- 设置icon 变暗色
function SlotBase:set_icon_dead_color()

	self.color_cover:setTexture(self.color_cover_path)
	self.color_cover:setIsVisible(true)
end

--设置icon变成亮色
function SlotBase:set_icon_light_color()
	self.color_cover:setIsVisible(false)
end

--设置覆盖的资源路径
function SlotBase:show_cover_color(path)
	self.color_cover_path = path
end

--创建格子右下角label控件
function SlotBase:create_count_label()
	if self._count_image ~= nil then
		return
	end
	local function get_num_img(num)
		return string.format("ui/fonteffect/e%s.png", num)
	end
	self._count_image = ImageNumberEx:create(0, get_num_img, 10)
	self._count_image.view:setAnchorPoint(CCPoint(1.0, 0.0))
	local size = self.view:getSize()
	self._count_image.view:setPosition(CCPoint(size.width, 12))
	self.view:addChild(self._count_image.view, 99)
end

--设置是否显示数量
function SlotBase:set_count_is_show(is_show)
	if not self._count_image then
		return
	end
	self._count_image.view:setIsVisible(is_show)
end

-- 设置分数进度
function SlotBase:set_fractions(fenzi, fenmu)
	if self._image_fenmu then
		self._image_fenmu.view:removeFromParentAndCleanup(true)
		self._image_fenmu = nil
	end
	if self._image_fenzi then
		self._image_fenzi.view:removeFromParentAndCleanup(true)
		self._image_fenzi = nil
	end
	if self.xiegan_ima then
		self.xiegan_ima:removeFromParentAndCleanup(true)
		self.xiegan_ima = nil
	end

	local size = self.view:getSize()
	if self._image_fenmu == nil then	
		local function get_num_img(num)
			return string.format("ui/fonteffect/e%d.png", num)
		end
		self._image_fenmu = ImageNumberEx:create(0, get_num_img, 10)
		self._image_fenmu.view:setAnchorPoint(CCPoint(1.0, 0.0))
		self._image_fenmu.view:setPosition(CCPoint(size.width, 12))
		self.view:addChild(self._image_fenmu.view, 99)
	end
	self._image_fenmu:set_number(fenmu)
	-- local size = self._image_fenmu.view:getSize()
	local csize = self._image_fenmu.view:getContentSize()
	-- print("-----size:", csize.width, csize.width)
	-- 斜杠
	self.xiegan_ima = CCSprite:spriteWithFile("ui/fonteffect/xiegang.png")
    self.view:addChild(self.xiegan_ima, 99)
    self.xiegan_ima:setPosition(size.width-csize.width-10, 12)

	if self._image_fenzi == nil then	
		local function get_num_img(num)
			return string.format("ui/fonteffect/e%d.png", num)
		end
		self._image_fenzi = ImageNumberEx:create(0, get_num_img, 10)
		self._image_fenzi.view:setAnchorPoint(CCPoint(1.0, 0.0))
		local size = self.view:getSize()
		self._image_fenzi.view:setPosition(CCPoint(size.width-csize.width-10, 12))
		self.view:addChild(self._image_fenzi.view, 99)
	end
	self._image_fenzi:set_number(fenzi)
end