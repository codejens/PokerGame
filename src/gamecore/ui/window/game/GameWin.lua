--MainWin.lua
GameWin = simple_class(GUIWindow)

function GameWin:update(param_1,param_2,param_3,param_4)
	if param_1 == "add_player" then
		self:get_data()
		self:add_player(param_2)
	elseif param_1 == "delete_player" then
		self:get_data()
		self:delete_player(param_2)
	elseif param_1 == "update_poker" then
		self:get_data()
		self:update_poker()
	end
end

function GameWin:__init()
	print("MainWin:__init()")
	self:get_data()
	self:create_makers()
	self:create_player_array()
end

function GameWin:init(is_fini)
	self.define_makers_pos = 1
	self.player_array = {}--GameModel:get_cur_player_array()
	self.panel_player_array = {}
	if is_fini then

	end
end

--获取服务器下发的数据
function GameWin:get_data()
	self.player_array = GameModel:get_cur_player_array()
end

function GameWin:init_widget()
	
end

--创建主/庄家
function GameWin:create_makers()

	local array = {}
    array.id = 1000+self.define_makers_pos
    array.sex = math.random(0,1)
    array.name = "庄家"
    array.yuanbao = math.random(0,10000)
    array.money = math.random(1000,99999999)
    array.cur_money = math.random(1,9999999)
    array.head_type = math.random(1,10)
    array.mantra = ""
    array.index = self.define_makers_pos--GameConfig:get_have_pos(self.define_makers_pos)

	self:create_player(array)
end

--遍历玩家列表创建
function GameWin:create_player_array()
	-- local partner = self.core
	for _ , player_info in pairs(self.player_array) do
		self:create_player(player_info)
	end
end

--创建玩家
function GameWin:create_player(player_info)
	local layout = {
		img_n = "ui/common/gold_home_avatar.png",
		pos = GameConfig:get_pos(player_info.index),
		size = {-1,-1},
	}

	local panel_player = GUIPanel:create_by_layout(layout)
	self:addChild(panel_player)

	--名字
	local label_name = GUIText:create(player_info.name)
	panel_player:addChild(label_name)
	label_name:setPosition(0,73)
	
	--货币
	local label_money = GUIText:create(player_info.money)
	panel_player:addChild(label_money)
	label_money:setPosition(0,-22)

	self.panel_player_array[player_info.index] = panel_player
	-- return panel_player

end

function GameWin:add_player(index)
	local player_info = self:get_player_info_by_index()
	self:create_player(player_info)
end

function GameWin:get_player_info_by_index(index)
	for _ , player in pairs(self.player_array) do
		if player_info.index == index then
			return player_info
		end
	end
end

function GameWin:delete_player(index)
	self.panel_player_array[index]:removeFromParent(true)
	self.panel_player_array[index] = nil
end

function GameWin:update_poker(to_index)
	self:make_deal_action(to_index)
end

function GameWin:make_deal_action(to_index)
	local form_index = self.define_makers_pos
	local form_pos = self.panel_player_array[form_index].layout.pos
	local to_pos = self.panel_player_array[to_index].layout.pos
	
	local layout = {
	img_n = "ui/main/card_back.png",
	pos = form_pos,
	}
	local img_poker = GUIImg:create_by_layout(layout)
	self:addChild(img_poker)
	local arg = {
		x = to_pos[1],
		y = to_pos[2],
		time = 0.2,
	}
	local sp_action = transition.moveTo(img_poker,arg)
	
	-- transition.moveTo()

end

function GameWin:registered_envetn_func()

end