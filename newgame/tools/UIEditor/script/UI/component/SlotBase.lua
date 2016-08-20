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
function SlotBase:setScale( x,y )
	if x and y then
		self.view:setScaleX(x)
		self.view:setScaleY(y)
	elseif x then
		self.view:setScale(x)
	end
end

--隐藏背景
function SlotBase:set_visible_bg( flags )
	self.icon_bg:setIsVisible(flags)
end

--消息透传
function SlotBase:set_message_cut( flags )
	 self.view:setDefaultMessageReturn( flags )
end

--其他元素需要修改的 再添加方法 或者一些旧方法



-- 初始化格子
function SlotBase:__init( width, height, image)
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
			self:set_icon_bg_texture(image)
		end
	-- else
	-- 	self:set_visible_bg(false)
	end
	--self.view	= CCBasePanel:panelWithFile(0, 0, width, height, image)

	self.icon	= MUtils:CCSprite(nil,"",_Width, _Height)
	self.icon:setAnchorPoint(CCPointMake(0.5,0.5))
	self.icon:setPosition(_Width/2,_Height/2)
	self.view:addChild(self.icon, 3)


	self.color_cover = CCArcRect:arcRectWithColor( 0, 0, self.width, self.height, 0xffffff00  )
    self.view:addChild( self.color_cover, 999 )

	-- add by fjh ,2012-12-27
	self.tag 	= 0;
	
	-- 注册点击事件
	local function on_click_event( eventType, args, msgid )
		
		if eventType == TOUCH_BEGAN then
			if self.on_begin_event ~= nil then
				self.on_begin_event(self,args )
			end
			return true
		elseif eventType == TOUCH_CLICK then
			if self.on_click_event ~= nil then
			    self.on_click_event(self,args )
		    end
			return true
		elseif eventType == TOUCH_DOUBLE_CLICK then
			if self.on_double_click_event ~= nil then
				self.on_double_click_event(self,args)
			end
			return true
		end

	end

	self.view:registerScriptHandler(on_click_event)

end

-- 设置格子的图标
-- 每个功能派生需要实现自己的icon id索引
function SlotBase:set_icon_texture( icon_texture )
	
	--self:set_visible_bg(true)
	self.cur_icon_texture = icon_texture
	-- 如果icon为空的话要去掉color_frame
	if ( icon_texture == "") then
		self:set_color_frame(nil);
		self.icon:replaceTexture("")
	else
		--test by tjh 因为道具全改了 很多没有icon 方便测试
		local r = -1
		local name,r = phone_findFile(icon_texture,r)
		if r == 0 then
			icon_texture ="icon/item/test_bag.pd" 
		end
		--test end

		safe_retain(self.icon)
		ResourceManager.ImageUnitTextureBackgroundLoad(icon_texture, self.set_icon_texture_load, self)
	end
end

--后台加载回调
function SlotBase:set_icon_texture_load(icon_texture, texture_loaded)
    if not texture_loaded then
        return
    end
	if self.cur_icon_texture == icon_texture then
		pcall(function() self.icon:replaceTexture( icon_texture) end)
	end
	--safe_release(self.icon)
end

--设置icon的大小，add by fjh , 2012-12-27
function SlotBase:set_icon_size( width,height )
	if self.icon ~= nil then
		-- self.icon:setSize(width,height);
	end
end

-- 设置icon的背景框
function SlotBase:set_icon_bg_texture( icon_bg_textures, po_x, po_y, width, height )
	-- if self.icon_bg == nil then
	--     self.icon_bg= CCZXImage:imageWithFile(0, 0, self.width, self.height,nil)
	--     self.view:addChild(self.icon_bg, 0)
	-- end
	self:set_visible_bg(true)
	self.icon_bg:setTexture(icon_bg_textures)
	-- if po_x and po_y and width and height then
 --        self.icon_bg:setPosition(po_x, po_y)
 --        self.icon_bg:setSize(width, height)
	-- end
end

-- 设置icon的title（精灵技能）
function SlotBase:set_icon_text(text )
	if self.title_lab == nil then
	    self.title_lab=  CCZXLabel:labelWithText( 31, 25, '#c929292'..text, 16, ALIGN_CENTER)
	    self.view:addChild(self.title_lab, 0)
	end
	self.title_lab:setText('#c929292'..text)
end

-- 设置icom边框的颜色(例如武器分蓝，绿，紫三种颜色)  
function SlotBase:set_color_frame( item_id, po_x, po_y, width_para, height_para )
	--这里把默认item的颜色框设置默认大小为72,原来值为68
	--modify by mwy@2014-08-14
	--modify begin
	-- 天降雄师项目又要求改成68了。
	-- 目前背包中slot图片64，背景72，颜色框68。 modify by gzn@2014-09-18
	local frame_with   = width_para  or 68
	local frame_height = height_para or 68
	
	if item_id == nil or item_id == 0 then 
		if self.color_frame then
            self.view:removeChild(self.color_frame, true)
            self.color_frame = nil  
        end
		return 
	end
	require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then 
    	if self.color_frame then
            self.view:removeChild(self.color_frame, true)
            self.color_frame = nil  
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
    -- local texture_t = {UIResourcePath.FileLocate.lh_normal .. "item_frame_1.png",
    -- 				 UIResourcePath.FileLocate.lh_normal .. "item_frame_2.png",
    -- 				 UIResourcePath.FileLocate.lh_normal .. "item_frame_3.png", 
    --                  UIResourcePath.FileLocate.lh_normal .. "item_frame_4.png",
    --                  UIResourcePath.FileLocate.lh_normal .. "item_frame_5.png",
    --                  UIResourcePath.FileLocate.lh_normal .. "item_frame_6.png"}
   
    -- if color_type < 7 then
    --     self.color_frame:setTexture(texture_t[color_type + 1])
    -- end
 --    if po_x and po_y and width_para and height_para then
 --        self.color_frame:setPosition(po_x, po_y)
 --        self.color_frame:setSize(width_para, height_para)
	-- end
end

-- 设置格子的数量
function SlotBase:set_count( count )
	self.count 	= count
	-- self._count_label:setText(string.format("%d",count))
	------print("SlotBase:set_count id", self._handle, " count", count)
	-- 如果数量是0或者1的话，则隐藏数字控件
	self:create_count_label()
	if count == 0 or count == 1 then
		self._count_image.view:setIsVisible(false)
	else
		self._count_image.view:setIsVisible(true)
		self._count_image:set_number(count,nil,self.scale)
	end
	-- if ( count == 0 ) then
	-- 	self:set_icon_dead_color();
	-- else
	-- 	self:set_icon_light_color();
	-- end
end

--设置icon的位置，暂时只有坐骑技能在用这个方法
function SlotBase:set_icon_position( x,y )
	self.icon:setPosition(tonumber(x),tonumber(y))
end

function SlotBase:set_setScale( Scale )
	self.scale = Scale
	--local size = 86 * Scale
    self.icon:setScale(Scale)
    --self.icon:setPosition(size/2,size/2)
end

-- 取得格子的数量
function SlotBase:get_count(  )
	return self.count;
end


function SlotBase:set_tag( tag)
	self.tag = tag;
end
function SlotBase:get_tag(  )
	return self.tag;
end

-- 移动格子
function SlotBase:setPosition( x, y )
	self.view:setPosition(tonumber(x), tonumber(y))
end

--设置锚点，by fjh,
function SlotBase:setAnchor( x,y )
	self.view:setAnchorPoint(x,y);
end

--设置单击回调函数
function SlotBase:set_click_event( fn )
	self.on_click_event = fn
end

--设置单击回调函数
function SlotBase:set_begin_event( fn )
	self.on_begin_event = fn
end

--设置双击回调函数
function SlotBase:set_double_click_event( fn )
	self.on_double_click_event = fn
	self.view:setEnableDoubleClick(true)
end

--设置单击回调函数
function SlotBase:set_begin_event( fn )
	self.on_begin_event = fn
end

-- view销毁时的回调函数
function SlotBase:set_delete_event( fn )
	self.on_delete_view_event = fn
end

-- 设置无效
function SlotBase:set_slot_disable(  )
	--self.view:setCurState( CLICK_STATE_DISABLE )
	--edit by tjh 别灰图了 直接蒙黑板
	--这里以后还是要换成黑色图片来蒙，技能是圆形的
	self:show_cover_color(  )
	-- if self.cur_icon_texture ~= '' then
	-- 	local grayname = MUtils.GetGrayscaleName(self.cur_icon_texture)
	-- 	self.icon:replaceTexture(grayname)
	-- end
	-- -- if self.icon_bg then
 -- --        self.icon_bg:setCurState( CLICK_STATE_DISABLE )
	-- -- end
	-- -- if self.color_frame then
 -- --        self.color_frame:setCurState( CLICK_STATE_DISABLE )
	-- -- end
end

-- 设置生效
function SlotBase:set_slot_enable(  )
	self:hide_cover_color(  )
	-- self.view:setCurState( CLICK_STATE_UP )
	-- --self.icon:setCurState( CLICK_STATE_UP )
	-- self.icon:replaceTexture(self.cur_icon_texture)
	-- if self.icon_bg then
 --        self.icon_bg:setCurState( CLICK_STATE_UP )
	-- end
	-- if self.color_frame then
 --        self.color_frame:setCurState( CLICK_STATE_UP )
	-- end
end

-- 设置icon 变暗色
function SlotBase:set_icon_dead_color(  )
	-- self.cur_icon_texture = MUtils.CCSpriteSetGrayscale(self.icon, self.cur_icon_texture)
	-- self:set_icon_texture(self.cur_icon_texture)
	local rbga = rbga_value or 0x00000080
	self.color_cover:setColor( rbga )
end

-- 设置icon变成亮色
function SlotBase:set_icon_light_color(  )
	-- self.cur_icon_texture = MUtils.GetNormalName(self.cur_icon_texture)
	-- self:set_icon_texture(self.cur_icon_texture)
	--self.icon:replaceTexture(self.cur_icon_texture)
	local rbga = rbga_value or 0xffffff00
	self.color_cover:setColor( rbga )
end

-- 设置覆盖的色板
function SlotBase:show_cover_color( rbga_value )
	local rbga = rbga_value or 0x00000080
	self.color_cover:setColor( rbga )
	self.color_cover:setDefaultMessageReturn( true )
end

-- 隐藏覆盖的色板
function SlotBase:hide_cover_color(  )
	self.color_cover:setColor( 0xffffff00 )
    self.color_cover:setDefaultMessageReturn( false )

end

-- 创建格子右下角label控件
function SlotBase:create_count_label(  )
	if self._count_image ~= nil then
		return
	end

	-- self._count_label = CCZXLabel:labelWithText(self.width - 3, 2, "", 12, ALIGN_RIGHT);
	-- self._count_label:setAnchorPoint(CCPoint(1.0,0.0))
	-- self._count_label:setPosition(CCPoint(self.width - 13, 5))
	-- self.view:addChild(self._count_label,99);
	local function get_num_img( num )
		return string.format("ui/fonteffect/e%d.png",num);
	end
	self._count_image = ImageNumberEx:create(0,get_num_img,15)
	--self._count_image.view:setScale(1.0)
	self._count_image.view:setAnchorPoint(CCPoint(1.0,0.0))
	-- 22,7
	self._count_image.view:setPosition(CCPoint(self.width - 10, 12))
	self.view:addChild(self._count_image.view, 99)
end
