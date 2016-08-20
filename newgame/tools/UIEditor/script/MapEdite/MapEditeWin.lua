--MapEditeWin.lua
--create by tjh on 2015.7.8
--地图编辑器 怪物，npc刷新点


super_class.MapEditeWin(Window)

--当前场景配置
local _curr_scene_info = {}
local _root = {}

local _monster_page = nil
local _npc_page = nil

local _page = {}

--初始化
function MapEditeWin:__init(  )

	require "SWidget/__init"
	SWidgetManage:init(  )

	_root = UIManager:get_main_panel()

	self.start_page = MapStartPage:create(  )
	self.view:addChild(self.start_page)

	self.menu_page = nil
	self.monster_page = nil

	self.view:setDefaultMessageReturn(false)          -- 设置穿透，不影响其他ui的事件消息
end

function MapEditeWin:enter_scene( )
	self.view:setDefaultMessageReturn(false)
	-- local scene_id = self.editbox_title:getText()
	-- scene_id = tonumber(scene_id)
	_curr_scene_info = MapEditeUtil:txt_to_lua( "data/envir/scene/scene1" )
	_curr_scene_info = _curr_scene_info[1]

	UIManager:hide_window("mapedite_win")
	SceneManager:enter_scene( 0, scene_id, 100, 100, false,"", _curr_scene_info.mapfilename, "" )
	
	MapModel:init_npc_date( _curr_scene_info.npc )

	MapModel:init_tp_date( _curr_scene_info.teleport )


	MapModel:init_monster_info("data/envir/scene/refresh1")
	MapMonsterEdite:init(  )
	
	self:enter_scene_ui()

	
end

function MapEditeWin:enter_scene_ui(  )
	self.start_page:setIsVisible(false)

	self.menu_page = MapMenuPage:create(  )
	_root:addChild(self.menu_page)

	_page[1] = MapMonsterEdite:create(  ).view
	_root:addChild(_page[1])

	_page[2] = MapNpcEdite:create().view
	_page[2]:setIsVisible(false)
	_root:addChild(_page[2])

	_page[3] = MapTpEdite:create().view
	_page[3]:setIsVisible(false)
	_root:addChild(_page[3])
	--MapEditeWin:test_new_ui(  )
end

function MapEditeWin:select_page( index )
	for i=1,#_page do
		_page[i]:setIsVisible(false)
	end
	if _page[index] then
		_page[index]:setIsVisible(true)
	end
end

function MapEditeWin:test_new_ui(  )

	print(ALIGN_DEFAULT)
	local btn = SRadioButtonGroup:create(UILH_COMMON.bg_01,300,40)
	for i=1,3 do
		local btn1 = SRadioButton:create(UILH_COMMON.button4,UILH_COMMON.button2_sel)
		btn1:setPosition(100*(i-1),0)
		local function cb( ... )
	
		end
		btn1:set_click_func(cb)
		btn:add_button(btn1)

		local key = string.format("mew_btn_%d",i)
		btn1:set_edit_key(key)
	end
	
	btn:setPosition(200,300)
	_root:addChild(btn.view)
end


