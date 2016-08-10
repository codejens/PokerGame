--MainWin.lua
MainWin = simple_class(GUIWindow)

function MainWin:__init()
	GameLogicCC:login_game()
	-- print("MainWin:__init()")
	self:test()
end

function MainWin:init(is_fini)
	self.cell_list= {}
	if is_fini then
	end
end

function MainWin:test()
	local layout = {
	size = {380,68},
	pos = {100,100},
	}
	local ui_root = GUIManager:get_ui_root(  )
	-- local function numberOfCellsInTableView(p1,p2,p3,p4)
	-- 	-- print("numberOfCellsInTableView p1,p2,p3,p4=",p1,p2,p3,p4)
	-- 	return 25
	-- end
	-- local function scrollViewDidScroll(p1,p2,p3,p4)

	-- 	-- print("scrollViewDidScroll p1,p2,p3,p4=",p1,p2,p3,p4)
	-- end
	-- local function scrollViewDidZoom(p1,p2,p3,p4)
	-- 	-- print("scrollViewDidZoom p1,p2,p3,p4=",p1,p2,p3,p4)
	-- end
	-- local function tableCellTouched(p1,p2,p3,p4)
	-- 	-- print("tableCellTouched p1,p2,p3,p4=",p1,p2,p3,p4)
	-- end
	-- local function cellSizeForTable(p1,p2,p3,p4)
	-- 	print("cellSizeForTable p1,p2,p3,p4=",p1,p2,p3,p4)

	-- 	return 80,80
	-- end
	local function tableCellAtIndex(p1,p2,p3,p4)
		print("tableCellAtIndex p1,p2,p3,p4=",p1,p2,p3,p4)

		local cell = p1--:dequeueCell()
		-- local ss = p1:getVerticalFillOrder()
		-- print("ss=",ss)
		-- print("cell=",cell)
		-- local pp = p2
		local function func()
			print("p2=",p2)
		end

		if cell == nil then
			-- print("p2222222222=",p2)

			-- local function ccc()
			-- 	-- print("p2=",pp)
			-- 	local lb = cell:getChildByTag(123)
			-- 	local pp = lb:getString()
			-- 	print("pp=",pp)
			-- end

			cell = cc.TableViewCell:new()
	        local sprite = GUIPanel:create("ui/common/gold_home_button_setup_click.png")
	        sprite.core:setAnchorPoint(cc.p(0,0))
	        sprite.core:setPosition(cc.p(0, 0))
	        cell:addChild(sprite.core)
	        sprite:setTag(122)
	        -- sprite:set_click_func(ccc)
	        -- sprite:setTouchEnabled(true)

	        local label = cc.Label:createWithSystemFont(p2, "Helvetica", 20.0)
	        label:setPosition(cc.p(0,0))
	        label:setAnchorPoint(cc.p(0,0))
	        label:setTag(123)
	        cell:addChild(label)
	    	self.cell_list[p2] = sprite
	    else

	        local label = cell:getChildByTag(123)
	        if nil ~= label then
	            label:setString(p2)
	        end
	    	-- self.cell_list[p2] = p2
	    end
	    local panel = GUITouchBase(cell:getChildByTag(122))
	    panel:set_click_func(func)
	    return cell
	end

	local table_view = GUITableView:create_by_layout(layout)

	self:addChild(table_view.core,99)

	-- table_view:set_touch_func(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	-- table_view:set_touch_func(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
	-- table_view:set_touch_func(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
	-- table_view:set_touch_func(tableCellTouched,cc.TABLECELL_TOUCHED)
	-- table_view:set_touch_func(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	table_view:set_touch_func(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	table_view:reloadData()
end

function MainWin:registered_envetn_func()
	-- local function btn_zhanghao_func()
	-- 	-- LoginModel:do_login("a","123456")
	-- 	-- print("btn_zhanghao_func")
	-- 	MainHallModel:show_mainhall_win()
	-- 	LoginModel:close_login_win()
	-- 	-- GUIManager:hide_window("login_win")
	-- 	-- print(LoginModel:getInstance():get_test())

	-- end
	-- self.btn_zhanghao:set_click_func(btn_zhanghao_func)
	-- local function btn_youke_func()
	-- end
	-- self.btn_youke:set_click_func(btn_youke_func)
end