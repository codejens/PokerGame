--MainWin.lua
GameWin = simple_class(GUIWindow)

function GameWin:__init()
	print("MainWin:__init()")
	self:create_player_array()
end

function GameWin:init(is_fini)
	self.player_array = GameModel:get_cur_player_array()
	self.btn_player = {}
	if is_fini then

	end
end

function GameWin:init_widget()
	
end

function GameWin:create_player_array()
	-- local partner = self.core
	for _ , player_info in pairs(self.player_array) do
		local layout = {
		img_n = "ui/common/gold_home_avatar.png",
		pos = GameConfig.POS[player_info.index],
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

	end
end

function GameWin:registered_envetn_func()

end