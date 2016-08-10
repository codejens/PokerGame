GUIWindow = simple_class(GUIBase)



-------------------------------------------------------
--直接拷贝luaExtend.lua实现用点号检索节点树
local luaExtend = {}
local function getChildInSubNodes(nodeTable, key)
    if #nodeTable == 0 then
        return nil
    end
    local child = nil
    local subNodeTable = {}
    for _, v in ipairs(nodeTable) do
        child = v:getChildByName(key)
        if (child) then
            return child
        end
    end
    for _, v in ipairs(nodeTable) do
        local subNodes = v:getChildren()
        if #subNodes ~= 0 then
            for _, v1 in ipairs(subNodes) do
                table.insert(subNodeTable, v1)
            end
        end
    end
    return getChildInSubNodes(subNodeTable, key)
end

luaExtend.__index = function(table, key)
local root = table.root
local child = root[key]
    if child then
        return child
    end

    child = root:getChildByName(key)
    if child then
        root[key] = child
        return child
    end

    child = getChildInSubNodes(root:getChildren(), key)
    if child then root[key] = child end
    return child
end
------------------------------------------------------

function GUIWindow:__init()
	local hw = GameScreenFactors.viewPort_width*0.5
	local hh = GameScreenFactors.viewPort_height*0.5

	-- local window = {}
	-- setmetatable(window, {__index = GUIWindow})	
	local win = GUIPanel:create9Img()
	safe_retain(win.core)
	-- window.core = gameNode
	-- window.result = {}
	win:setContentSize(GameScreenFactors.viewPort_width,GameScreenFactors.viewPort_height)
	win:setTouchEnabled(true)
	-- print("GameScreenFactors.viewPort_width=,GameScreenFactors.viewPort_height=",GameScreenFactors.viewPort_width,GameScreenFactors.viewPort_height)
	-- print("winSize",winSize.width,winSize.height)
	-- print("hw,hh=",hw,hh)
	-- print("aaaaaaa=",hw*GameScaleFactors.ui_scale_factor)
	-- hw = hw - hw*GameScaleFactors.ui_scale_factor + hw
	-- hh = hh - hh*GameScaleFactors.ui_scale_factor + hh
	-- win:setPosition(480,320)
	-- win:setContentSize(GameScreenFactors.viewPort_width,GameScreenFactors.viewPort_height)
	-- win:setAnchorPoint(0.5,0.5)
	self.core = win.core
	if self.layout ~= nil then
		self:create_by_layout()
	end
	self:init()
	-- self:create_widget()
	self:init_widget()
	self:registered_envetn_func()

	-- print("GUIWindow:__init self.layout,self.core=",self.layout,self.core)
	return self

	-- window._comps = {}
end

function GUIWindow:create_by_layout()
	-- print("create_by_layout,layout=",layout)
	-- self.result = UICreateByLayout(self.layout)
	UICreateByLayout(self)
	-- print("self.result[root].view=",self.result["root"].view)
	-- self.result["root"]:setPosition(200,200)
	self.core:addChild(self.root.core)
end

-- 根据名字获取控件
function GUIWindow:get_widget_by_name( name )
	
	if not self.result[name] then
		--获得不到控件的情况下  可能是不需要加载的控件
		----print( "BaseEditWin", "找不到该控件", name)
	end
	return self.result[name]
end

function GUIWindow:get_page_by_name( name )
	if not self.result[name] then
		--获得不到控件的情况下  可能是不需要加载的控件
		self.result = UICreateLayoutByName( self.result,self.layout,name)
	end
	return self.result[name]
end

function GUIWindow:init()
	print("父类init,子类要重写")
end

-- 子类重写
-- 获取UI控件
function GUIWindow:save_widget( )
	print("父类save_widget ,子类要重写")
end

function GUIWindow:init_widget()
	print("父类init_widget,子类要重写")
end

-- 子类重写
-- 注册事件方法
function GUIWindow:registered_envetn_func(  )
	print("父类registered_envetn_func,子类要重写")
end




function GUIWindow:viewCreateCompleted()
    return true
end

function GUIWindow:_create(layout_file,param)
	-- local layout = nil
	-- local view = nil

	local win = self()
	
	
	if layout_file == nil then
		return window
	else	
		win.layout = layout_file
		-- local result = {}
		-- setmetatable(result, luaExtend)	
		-- local gameNode = cc.Node:create()
		-- result['view'] = gameNode
		win._param = param
		-- local win = creator(param)
		-- window['view'] = gameNode
		-- window()
		-- window:create_by_layout(layout_file)

		-- win.layout_file = layout_file
		-- win.children = {}
		-- win.layout_file = file
		win.children = {};
		-- _UILoader(file,win,win.children)
		-- if win.onLoad then
		-- 	win:onLoad( true );
		-- end
		-- _UILoader(layout_file,win,win.children)
		-- if win.onLoad then
		-- 	win:onLoad( true )
		-- end
	end
	-- safe_retain(gameNode)
	return window
	-- return nil
	-- local window = self( view )
	-- if window then
	-- 	-- window.studio_layout = layout
	-- 	window:viewCreateCompleted(  )
	-- 	return window
	-- else
	-- 	return nil
	-- end
end




--[[
function _UILoader(file,rootComponent,children)
	-- file = string.format("../data/layouts/%s",file);
	-- local filetable = loadLayout(file)
	local dataSection = _G[file]
	print("file,filetable",file,dataSection)
	createComponent( dataSection,rootComponent,file,children )
end

function createComponent( dataSection,rootComponent,file,children )
	assert(dataSection,'failed to create,dataSection为nil',file)
	assert(rootComponent,'root为nil',file)
	local childrenlist = {}
	Utils:print_table(dataSection)
	for i,subSection in ipairs(dataSection) do
		local ccClass = subSection.class
		print("subSection.class",ccClass,subSection)
		assert( ComponentCreateTable[ccClass],string.format("创建%s第%d个控件失败,没有%s",file,i,ccClass) )
		local cc = ComponentCreateTable[ccClass](subSection)
		if cc then 
			
			local layout = subSection.layout
			local z = layout.z or 0
			local tag = subSection.tag;

			--children key parent value
			if childrenlist[tag] then
				-- ----print("childrenlist[tag].__classname",childrenlist[tag].__classname,ZRadioButtonGroup)
				if childrenlist[tag].__classname == "ZRadioButtonGroup" then
					childrenlist[tag]:addItem(cc);
				else
					childrenlist[tag].view:addChild(cc.view,z,tag);
				end
				childrenlist[tag] = nil
			else
				rootComponent.view:addChild(cc.view,z,tag)
			end
			local anchorPoint = layout.anchorPoint
			if anchorPoint then
				cc:setAnchorP(CCPoint(anchorPoint[1],anchorPoint[2]))
			end
			local name = subSection.name
			-- ----print("name = ",name)
			if name then
				cc.name = name;
				children[cc.name] = cc
			end
			children[tag] = cc

			-- 把自己的子类保存到列表中
			if subSection.children then
				local subSectionChilren = subSection.children
				for i2,v2 in ipairs(subSectionChilren) do
					childrenlist[v2] = cc;
				end
			end
		else
			----print("创建失败",subSection.class,file)
		end
	end	
end


function GUIWindow:findWidgetByName(name)
	xprint("------外部不允许调这个函数了,name=",name)
	if name == nil then
		return
	end
	local _comps = self._comps
	local comp = _comps[name]
	if not comp then
		comp = cocosHelper.findWidgetByName(self.view,name)
		_comps[name] = comp
	end
	return comp
end

function GUIWindow:addTouchEventListener(name, func)
	local comp = self:findWidgetByName(name)
	-- comp:setTouchEnabled(true)
	-- comp:addTouchEventListener(func)
	if comp then
		comp:addTouchEventListener(func)
	end
end

function GUIWindow:set_click_func(name,func)
	local comp = self:findWidgetByName(name)
	if comp then
		comp:set_click_func(func)
	end
end

function GUIWindow:addClickEventListener(name, func)
	local comp = self:findWidgetByName(name)
	-- local function _click_func( sender,eventType )
	--   if eventType == ccui.TouchEventType.ended then
	--   	func(sender,eventType)
	--   end
	-- end
	-- comp:setTouchEnabled(true)
	-- comp:addTouchEventListener(_click_func)
	if comp then
		comp:set_click_func(func)
	end
end

function GUIWindow:addEventListener(name, func)
	local comp = self:findWidgetByName(name)
	if comp then
		comp:addEventListener(func)
	end
end
--]]

function GUIWindow:removeFromParent(flag)
	self.core:removeFromParent(flag)
end


--- 变成激活（显示）情况调用
function GUIWindow:active(  )
	
end

-- 变成 非激活
function GUIWindow:unActive(  )
	
end

--- 销毁方法
function GUIWindow:destroy()

end