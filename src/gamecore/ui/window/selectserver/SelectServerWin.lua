--SelectServerWin.lua
SelectServerWin = simple_class(GUIWindow)
---对外接口
--组按钮回调
local function select_btn_func( index )
	SelectServerModel:do_group_btn(index)
end
--选择具体服务器回调
local function server_btn_func( date )
	SelectServerModel:do_select_server( date )
end


local function back_btn_func( )
	gameStateManager:setState(loginState)	
end 
-------------


local btn_name = {
	"常用服",
	"推荐服"
}

local state_img_path = {
	"huobao",
	"gongce",
	"liuchang",
	"tuijian",
	"weihu",
	"weikaifu",
}

function SelectServerWin:__init(view)
	self.view = view
	self._comps = {}
	self.select_btn_list = self:findWidgetByName("select_btn")
	self.server_list = self:findWidgetByName("server_list")
	self:register_listener()
end

function SelectServerWin:register_listener(  )
	local function touchfunc( sender,eventType )
			if eventType == ccui.TouchEventType.ended then
				back_btn_func()
			end
		end 
	self:addTouchEventListener('back_btn',touchfunc)
end

function SelectServerWin:update_select_btn( server_num )
	self.select_btn_list:removeAllItems()
	local num_btn = 2
	local add_btn = math.ceil(server_num/10)
	local cur_num = 1
	local cur_name = ""
	num_btn = num_btn + add_btn
	for i=1,num_btn do
		local select_btn = GUIButton:create("res/ui/selectserve/left_btn_normal.png")
		select_btn:setTexturePressed("res/ui/selectserve/left_btn_press.png")
		if btn_name[i] then
			select_btn:setTitleText(btn_name[i])
		else 
			cur_num = num_btn - i+1
			print(cur_num)
			cur_name = string.format("%d-%d服",tostring(cur_num*10 -9),tostring(cur_num*10))
			select_btn:setTitleText(cur_name)
		end
		local function touchfunc( sender,eventType )
			if eventType == ccui.TouchEventType.ended then
				select_btn_func(i)
			end
		end 
		select_btn:addTouchEventListener(touchfunc)
		self.select_btn_list:insertCustomItem(select_btn.view,i-1)
	end
end

function SelectServerWin:update_server_list( date )
	self.server_list:removeAllItems()
	local bg_img = ""
	local path = ""
	local state_img = ""
	local name_label = ""
	for i=1,#date do
		local cur_date = {}
		cur_date = date[i]
		for k,v in pairs(cur_date) do
			print(k,v)
		end
		bg_img = GUIImg:create("res/ui/selectserve/right_btn_normal.png")
		path = string.format("res/ui/selectserve/%s.png",state_img_path[tonumber(cur_date.state)])
		state_img = GUIImg:create(path)
		state_img.view:setPosition(50,25)

		bg_img.view:addChild(state_img.view)


		name_label = GUIText:create()
		name_label:setString(cur_date.servername)
		name_label.view:setPosition(200,25)
		bg_img.view:addChild(name_label.view)

		local function touchfunc( sender,eventType )
			if eventType == ccui.TouchEventType.ended then
				server_btn_func(cur_date)
			end
		end 
		bg_img:addTouchEventListener(touchfunc)
		self.server_list:insertCustomItem(bg_img.view,i-1)
	end
end