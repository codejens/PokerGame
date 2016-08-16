-- ExamplePageWin.lua (结合ExamplePage使用)
-- windows 创建范例 (基于ui编辑器的)
--页构建类配置

super_class.ExamplePageWin(BaseEditWin)

-- 对外接口：事件处理、更新接口-----------
local  function btn_xx( eventType, x, y, self )
	-- body
end 

-- ========================================== 更新部分(自定义更新部分可卸载update下面)
-- 更新统一接口
function ExamplePageWin:update( utype,date )
	----print("ExamplePageWin update",utype)
	--add todo
	if utype == "xxx" then
		self:update_xxx( date )
	end
	--派发给子页
	self.cur_page:update( utype, date)
end

function ExamplePageWin:update_xxx( date)
	----print( "ExamplePageWin update_xxx")
end


-- ========================================== 本窗口构造部分
function ExamplePageWin:__init( )
	self._page = {
		class = { Examplepage, Examplepage, Examplepage },
		config = { "page_1", "page_2", "page_3"},	
	}

	-- 保存
	self.cur_page = nil
	self.all_page = { }
	-- 选择第一分页
	self:change_page( 1)
end

-- ========================================== 自定义部分

-- 切换页
function ExamplePageWin:change_page( index)
	if index and index >=1 and index<=#self._page.class then
		if self.all_page[index] then
			if self.cur_page == self.all_page[index] then
				return
			else
				self.cur_page.view:setIsVisible(false)
			end
		else
			if self.cur_page then
				self.cur_page.view:setIsVisible(false)
			end
			self.all_page[index] = self._page.class[index]:create( self, self._page.config[index])
		end
		self.cur_page = self.all_page[index]
		self.cur_page.view:setIsVisible(true)
	end
end

-- ========================================== 重写部分(由父类构造函数调用)
-- 获取UI控件
function ExamplePageWin:save_widget( )
	--定义好需要用到的控件
	-- self.root = self:get_widget_by_name("win_root")

	-- 分页按钮
	self.page_btn = {}
	for i=1, 3 do
		self.page_btn[i] = self:get_widget_by_name( string.format("rbtn_%d", i))
	end
end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function ExamplePageWin:registered_envetn_func(  )
	for i=1, #self.page_btn do
		function page_btn_func( )
			-- Logic
			self:change_page(i)
		end
		self.page_btn[i]:set_click_func( page_btn_func)
	end
end

-- ====== ui 规格 =======
-- 分页主面板
-- panel_main(913x605)
-- 分页面板
-- page_n(n=1,2,3) (860x525)

-- 关闭按钮
-- btn_close

-- 顶部title面板
-- panel_top
-- panel_yu

-- 分页按钮 & 按钮上的文字
-- groupbtn_main
-- rbtn_n(n=1,2,3)
-- rbtn_txt_n(1,2,3)
-- ======================

-- 速传or功能 ============
-- local function func_1(  )    -- 自动前往回调
--     	GlobalFunc:ask_npc_by_scene_name( scene_name, npc_name)
--     	AlertWin:close_alert(  )
-- end
-- local function func_2(  )    -- 速传回调
--     	GlobalFunc:teleport_by_name( scene_name, npc_name )
-- 		or
-- 		GlobalFunc:teleport( scene_id, npc_name )
--     	AlertWin:close_alert(  )
-- end

-- GuildModel:create_go_to_panel( notice_content, func_1, func_2)
-- local confirmWin2_temp = ConfirmWin2:show( 6, nil, "弹窗提示内容", func_1, nil, nil )
-- confirmWin2_temp:set_yes_but_func_2( func_2 )