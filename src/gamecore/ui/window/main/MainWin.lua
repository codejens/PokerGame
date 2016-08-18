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

function MainWin:test2()
	print("1111111111111111")
	local winSize = {width = 960,height=640}
    local tableView = cc.TableView:create(cc.size(300,60))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setPosition(cc.p(20, winSize.height / 2 - 150))
    tableView:setDelegate()
    self:addChild(tableView)

    local function tableCellAtIndex(table, idx)
        print("tableCellAtIndex")
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            local sprite = cc.Sprite:create("ui/common/gold_home_button_back_click.png")
            sprite:setAnchorPoint(cc.p(0,0))
            sprite:setPosition(cc.p(0, 0))
            cell:addChild(sprite)

            label = cc.Label:createWithSystemFont(strValue, "Helvetica", 20.0)
            label:setPosition(cc.p(0,0))
            label:setAnchorPoint(cc.p(0,0))
            label:setTag(123)
            cell:addChild(label)
        else
            label = cell:getChildByTag(123)
            if nil ~= label then
                label:setString(strValue)
            end
        end

        return cell
    end
    local function numberOfCellsInTableView()
    	return 25
    end
    local function cellSizeForTable()
    	return 60,60
    end
    --registerScriptHandler functions must be before the reloadData funtion
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    -- tableView:registerScriptHandler(TableViewTestLayer.scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    -- tableView:registerScriptHandler(TableViewTestLayer.scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
    -- tableView:registerScriptHandler(TableViewTestLayer.tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

    -- print("---------------------------")
    -- tableView = cc.TableView:create(cc.size(60, 350))
    -- tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    -- tableView:setPosition(cc.p(winSize.width - 150, winSize.height / 2 - 150))
    -- tableView:setDelegate()
    -- tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- self:addChild(tableView)
    -- -- tableView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    -- -- tableView:registerScriptHandler(TableViewTestLayer.scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
    -- -- tableView:registerScriptHandler(TableViewTestLayer.tableCellTouched,cc.TABLECELL_TOUCHED)
    -- tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    -- tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    -- tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    -- tableView:reloadData()
end

function MainWin:test()
	local layout = {
	size = {300,60},
	pos = {20, 640 / 2 - 150},
	item_size = {80,80},
	}
	local ui_root = GUIManager:get_ui_root(  )
	local bg = GUIPanel:create("ui/common/role_bg.png")
	self:addChild(bg)
	-- local max_num = 25
	-- local function numberOfCellsInTableView(p1,p2,p3,p4)
	-- 	-- print("numberOfCellsInTableView p1,p2,p3,p4=",p1,p2,p3,p4)
	-- 	print("max_num=",max_num)
	-- 	return max_num
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
	-- 	-- print("cellSizeForTable p1,p2,p3,p4=",p1,p2,p3,p4)

	-- 	return 80,80
	-- end
	local function click_func(idx)
		print("idx=",idx)
	end
	 local function tableCellAtIndex(cell, idx)
        local strValue = string.format("%d",idx)
        -- local cell = table:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            local sprite = GUIButton:create("ui/common/gold_home_button_back_click.png")
            sprite:setAnchorPoint(0,0)
            sprite:setPosition(0, 0)


            -- local function click_func()
            -- 	print("strValue=",strValue)
            -- end

            -- sprite:set_click_func(click_func)
            sprite:setTag(123)
            cell:addChild(sprite.core)

            label = cc.Label:createWithSystemFont(strValue, "Helvetica", 20.0)
            label:setPosition(cc.p(0,0))
            label:setAnchorPoint(cc.p(0,0))
            label:setTag(111)
            cell:addChild(label)


        else
            label = cell:getChildByTag(111)
            if nil ~= label then
                label:setString(strValue)
            end
        end

        return cell
    end

	-- local winSize = {width = 960,height=640}
 --    local table_view = cc.TableView:create(cc.size(300,60))
 --    table_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
 --    table_view:setPosition(cc.p(20, winSize.height / 2 - 150))
 --    table_view:setDelegate()
    -- self:addChild(tableView)

	local table_view = GUITableView:create_by_layout(layout)
	
    table_view:addTagTouch(123,click_func)
	self:addChild(table_view)

	-- table_view:set_touch_func(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	-- table_view:set_touch_func(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
	-- table_view:set_touch_func(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
	-- table_view:set_touch_func(tableCellTouched,cc.TABLECELL_TOUCHED)
	-- table_view:set_touch_func(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	-- print("cc.TABLECELL_SIZE_AT_INDEX=",cc.TABLECELL_SIZE_AT_INDEX)
	-- table_view.core:registerScriptHandler(tableCellAtIndex,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	-- table_view.core:registerScriptHandler(tableCellAtIndex,cc.SCROLLVIEW_SCRIPT_SCROLL)
	-- table_view.core:registerScriptHandler(tableCellAtIndex,cc.SCROLLVIEW_SCRIPT_ZOOM)
	-- table_view.core:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_TOUCHED)
	-- table_view.core:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_FOR_INDEX)
	table_view:set_touch_func(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	-- table_view:reloadData()

	table_view:update(10)
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