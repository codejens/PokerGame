
-- 挖孔  可以挖各种不规则图形



	--[[
	#define GR_GL_ZERO                           0
	#define GR_GL_ONE                            1
	#define GR_GL_SRC_COLOR                      0x0300
	#define GR_GL_ONE_MINUS_SRC_COLOR            0x0301
	#define GR_GL_SRC_ALPHA                      0x0302
	#define GR_GL_ONE_MINUS_SRC_ALPHA            0x0303
	#define GR_GL_DST_ALPHA                      0x0304
	#define GR_GL_ONE_MINUS_DST_ALPHA            0x0305
	--]]

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)


HollowMask = simple_class()

--[[
	params {
		hollows {
			[1] = {obj,img_path}  -- obj 挖孔参照对象，img_path 孔的图形
			...
		}
	}

	可以参考 SDrttPage
--]]

local g_timer = false
local count_down = 0

function HollowMask:__init(params)
	self.params = params
	self:create_mask_layer()
end

function HollowMask:create_mask_layer()
	local bg = CCBasePanel:panelWithFile(0, 0, panelWidth, panelHeight, "nopack/xszy/zezhao1.png", 500, 500)
	bg:setAnchorPoint(0.5,0.5)
	bg:setPosition(panelWidth/2, panelHeight/2)

	--local bg = CCSprite:spriteWithFile("nopack/xszy/zezhao1.png")
	-- bg:setAnchorPoint(CCPointMake(0.5,0.5))
	-- bg:setPosition(CCPointMake(panelWidth/2, panelHeight/2))
	--bg:setTextureRect(CCRect(0, 0, panelWidth,panelHeight))
	--bg:setSize(panelWidth,panelHeight)

	local tmp_table = {}
	self.hollow_objs = tmp_table
	table.insert(tmp_table, bg)

	for k,v in ipairs(self.params.hollows) do
		local obj = v.obj
		local anchorPoint = obj.view and obj.view:getAnchorPoint() or obj:getAnchorPoint()
		local size = obj:getSize()
		local pos = obj.view and obj.view:convertToWorldSpace(anchorPoint) or obj:convertToWorldSpace(anchorPoint)
		local panel = CCBasePanel:panelWithFile(0, 0,  size.width, size.height, v.img_path, 500, 500)
		local b = ccBlendFunc()
		b.src = 0
		b.dst = 0x0303
		panel:setSize(size.width, size.height) 
		--panel:setPosition(pos.x,  pos.y)
		panel:setPosition(pos.x /GameScaleFactors.ui_scale_factor,  pos.y /GameScaleFactors.ui_scale_factor)
		panel:setBlendFun(b.src, b.dst)
		table.insert(tmp_table, panel)
	end

	local rtx = CCRenderTexture:renderTextureWithWidthAndHeight(panelWidth,panelHeight)
	rtx:begin()
	for k,v in ipairs(tmp_table) do
		v:visit()
	end
	rtx:endToLua()

	for k,v in ipairs(tmp_table) do
		v:cleanup()
	end

	rtx:setPosition(CCPointMake(panelWidth/2, panelHeight/2))
	rtx:setAnchorPoint(CCPointMake(0, 0))

	local touch = SPanel:create("",panelWidth, panelHeight)
	touch:set_click_func(function() 
		print "touch:set_click_func >>>>"
	 end)
	touch.view:addChild(rtx)

	local root = ZXLogicScene:sharedScene():getUINode()
	--先删除 再添加 以免重复
	root:removeChildByTag(UI_TAG_TUXIAN,true)
	root:addChild(touch.view, 99999999, UI_TAG_TUXIAN)

	self.touch_layer = touch
	self.mask_bg = bg
	self.rtx = rtx
	--return touch.view
	SGuidePanel:show_guide_base_panel(false)
end

function HollowMask:remove_mask()
	local root = ZXLogicScene:sharedScene():getUINode()
	root:removeChildByTag(UI_TAG_TUXIAN,true)
	self:clear_timer()
	SGuidePanel:show_guide_base_panel(true)
end

function HollowMask:clear_timer()
	if g_timer then
		g_timer:stop()
		g_timer = false
		count_down = 0
	end
end

-- 向遮罩添加元素，index 参照物对象索引，offset 跟该对象的偏移量
-- obj 要添加的对象
function HollowMask:addelement(index, obj, offsetX, offsetY)
	-- 过滤掉 mask_bg
	local tmp_index = index +1
	local target = self.hollow_objs[tmp_index]
	if target then
		local x,y = target:getPosition()

		obj:setPosition(x + offsetX, y + offsetY)
		self.touch_layer:addChild(obj.view or obj)
	end
end


--------------   拓展部分，可选

---------------------------------------- 倒计时定时器 ---------------------------------

--[[
	params
		type   -- 类型 不填为默认
		ref_offset = {index, ofx,ofy}  -- index 数字以那个孔对象未参照， of 偏移
		time_over_callbak              -- 定时器结束回调
--]]

function HollowMask:show_count_down(params)
	--self.timer_params = params
	self:clear_timer()

	g_timer = timer()
	if not params.type then
		self:timer_1(params)
	end
end

function HollowMask:timer_1(params)
	count_down = 3
	local index = params.ref_offset.index
	local img = SImage:create(self:get_count_down_numb(count_down))
	self:addelement(index, img, params.ref_offset.ofx, params.ref_offset.ofy)

	local function timer_callback()
		count_down = count_down -1
		if count_down <= 0 then
			self:clear_timer()
			params.time_over_callbak()
			self:remove_mask()
			return
		end
		local tex = self:get_count_down_numb(count_down)
		img:setTexture(tex)
	end
	g_timer:start(1, timer_callback)
end

function HollowMask:get_count_down_numb(numb)
	return string.format("sui/fuben/jishi_%d.png", numb)
end

