-- MeirenHouse.lua 
-- createed by xiehande on 2015-3-19
-- 美人后宫
super_class.MeirenHouse(Window)
require "../data/collectcard"
--创建方法

function  MeirenHouse:create( )
	return MeirenHouse( "MeirenHouse", "", true, 880, 500)
end
-- 控件坐标
local right_bg_w = 700	

--美人卡牌数组
local meiren_pai = {
   [1] =UILH_LINGQI.pai1,
   [2] =UILH_LINGQI.pai2,
   [3] =UILH_LINGQI.pai3,
   [4] =UILH_LINGQI.pai4,
   [5] = UILH_LINGQI.pai5,
}

function MeirenHouse:__init( )

	self.card_info = {}

	--主目录选中index
	self.selectIndex = 1 	-- 选中的章节id(显示奖励用)

	--子目录选中
	self.sub_selectIndex = 0

	self.cards = {}
  
    self._curr_selec_card = nil

    self.meiren_id_list = {}

    --左边背景
    self.left_panel = CCBasePanel:panelWithFile( 7, 0, 165, 500, UILH_COMMON.bottom_bg, 500, 500 )
	self.view:addChild(self.left_panel)

    --右边背景
	self.right_panel = CCBasePanel:panelWithFile( 328-160+5, 0, right_bg_w, 500, "", 500, 500 )
	self.view:addChild(self.right_panel)
    --创建左边

	self:create_left_panel(self.left_panel)
	--默认选中第一个
	self.synthSpinner:slt_title_func(1)

	--创建右边
	self:create_right_panel(self.right_panel)
end


function MeirenHouse:show( page , card_info )

    if card_info then
        local card = HeLuoConfig.getCardByItemID( card_info)
        if not card then
            return
        end

        local starNum = HeluoBooksModel:get_card_star_by_id( card.id )
        HeluoBooksModel:set_main_curr_card_page( card.id )
        if starNum then
            -- local function confirm2_func()
                MeirenHouse:show( 1 )
            -- end
            -- ConfirmWin2:show( 4, nil, "卡牌已经激活，是否分解卡牌",  confirm2_func)
        else

            MeirenHouse:show( 1 )

        end

    else

        local win = UIManager:show_window("lingqi_win")

        if page then

            win:change_page(5)

        end

    end

end

-------------------------

-- 创建左边面板

-------------------------

function MeirenHouse:create_left_panel( panel )

    --这里应该使用配置来读取主目录和子目录
	local item_data = {}

	--设置
	for i = 1, #collectcard.cardGroup do

		local card_data = collectcard.cardGroup[i]
		table.insert(self.card_info, card_data)
		local title = card_data.typeName
		local temp = { items = {} }
		temp[1] = title

		--获取子目录

		for i=1,#card_data.subList do
			local sub_card_id =  card_data.subList[i]
			local sub_data = collectcard.cardSubGroup[sub_card_id].typeName
			local item = {[1] = sub_data,[2]=""}
			table.insert(temp.items,item)

		end
		item_data[#item_data+1] = temp
	end

	local beg_y = 490
	local int_h = 45
	local ui_params = { title_h = 45, title_w = 150, item_h = 45, item_w = 155, title_x = 5 }
	-- require "UI/task/LHExpandListView"

	require "UI/fabao/LHDirectoryList"
	self.synthSpinner = LHDirectoryList:create( panel, item_data, ui_params, 1, 3, 0, 160, 495, ""
	, 500, 500 ) 
	--

	for i, chapter in ipairs(self.card_info) do
		local title_item = CCBasePanel:panelWithFile( 5, beg_y - int_h*i, 150, 45, UILH_COMMON.bg_08, 500, 500)
		self.synthSpinner:addTitle(title_item, i)
	end

--------------------------------------------

--------------------------------------------

--主目录的触发事件

	local function spinner_title_func( title_index)
		self.selectIndex = title_index
        local series = HeLuoConfig.getBookSeriesTable(  )
		self.meiren_id_list = {}
		local series_array =series[title_index].subList
         for i=1,#series_array do
         	 local cardsubGroups = HeLuoConfig.getCardSubGroup( series_array[i] )
	        for i=1,#cardsubGroups do
	        	local seriesGroup =  HeLuoConfig.getCardSeriesGroup( cardsubGroups[i] )
		    	for k=1,#seriesGroup do 
		    		 table.insert(self.meiren_id_list,seriesGroup[k])
		    	end  
	        end
         end
        print("主目录的个数",#self.meiren_id_list)
		if self.right_scroll then
			HeLuoBooksCC:req_base_heluo_info( )
			self.right_scroll:clear()
			self.right_scroll:setMaxNum(math.ceil(#self.meiren_id_list/4))
			self.right_scroll:refresh()
	    end

	end

--------------------------------------------

--------------------------------------------
self.synthSpinner:registerScriptFunc_t( spinner_title_func )





--------------------------------------------

--------------------------------------------
--子目录的触发事件

    local function spinner_item_func( title_index, item_index )
    	self.sub_selectIndex = item_index
        -- print("子目录的触发事件",title_index,item_index)
        --系列
		local series = HeLuoConfig.getBookSeriesTable(  )
		self.meiren_id_list = {}
		local series_info =series[title_index].subList[item_index]
        local cardsubGroups = HeLuoConfig.getCardSubGroup( series_info )
        for i=1,#cardsubGroups do
        	local seriesGroup =  HeLuoConfig.getCardSeriesGroup( cardsubGroups[i] )
	    	for k=1,#seriesGroup do 
	    		 table.insert(self.meiren_id_list,seriesGroup[k])
	    	end  
        end       
        -- print("子目录下有多少卡牌",#self.meiren_id_list)

		if self.right_scroll then
		HeLuoBooksCC:req_base_heluo_info( )
		self.right_scroll:clear()
	    self.right_scroll:setMaxNum(math.ceil(#self.meiren_id_list/4))
		self.right_scroll:refresh()
	    end
    end
--------------------------------------------

--------------------------------------------
    self.synthSpinner:registerScriptFunc_i( spinner_item_func )

end

-------------------------

-- 创建右边面板

-------------------------

-- 创建可拖动区域 

--list_data 为美人的配置数据ID    //cardConfig          
function MeirenHouse:create_scroll_area( panel , pos_x, pos_y, size_w, size_h, bg_name, list_date)

	 -- ui param
	    local row_h = 261 
	    local row_w = 175
	    local row_inter_h = 15
	    local colu_num = 4 --一行中列数
	    local item_num = #self.meiren_id_list
	    local line_num = math.ceil(item_num/colu_num)   --行数

	    --总行数，每列的最大值
	    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum =line_num, image = bg_name, stype= TYPE_HORIZONTAL }
	    local  scroll  = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype, 500, 500 )
	    local function scrollfun(eventType, args, msg_id)
	        if eventType == nil or args == nil or msg_id == nil then 
	            return
	        end

	        if eventType == TOUCH_BEGAN then
	            return true
	        elseif eventType == TOUCH_MOVED then
	            return true
	        elseif eventType == TOUCH_ENDED then
	            return true
	        elseif eventType == SCROLL_CREATE_ITEM then

	            local temparg = Utils:Split(args,":")

	            local x = temparg[1]              -- 行

	            local y = temparg[2]              -- 列

	            local index = x * colu_num    

	            local panel_items = CCBasePanel:panelWithFile( 0, 0, size_w-5, row_h, "" )

	            scroll:addItem(panel_items)

	            for i=1, colu_num do

	        		self:create_meiren_item( panel_items, 3+(i-1)*(row_w), 10, row_w, row_h, self.meiren_id_list[index+i])

	            end
	            scroll:refresh()
	            return false
	        end

	    end

	    scroll:registerScriptHandler(scrollfun)
	    scroll:refresh()
	    panel:addChild( scroll )

    return scroll

end



function MeirenHouse:create_right_panel( panel)

    
    --上板
    local up_panel = CCBasePanel:panelWithFile( 0, 70, right_bg_w, 430, UILH_COMMON.bottom_bg, 500, 500 )
    panel:addChild(up_panel)

    --下板
    local down_panel = CCBasePanel:panelWithFile( 0, 0, right_bg_w, 70, UILH_COMMON.bottom_bg, 500, 500 )

    panel:addChild(down_panel)

	local scroll_info = {x = 5, y = 77, width = right_bg_w-10, height = 505-90}
	--美人数组
	 self.right_scroll = self:create_scroll_area( panel , scroll_info.x, scroll_info.y, scroll_info.width, scroll_info.height, "", self.meiren_id_list)
    --系列战斗力

    local zhandouli_txt = ZLabel:create(panel, Lang.lingqi.hougong[2], 75, 28, 16, 2)

    local function show_func(  )
                --炫耀
        if self._curr_selec_card.starNum then
            HeluoBooksModel:xuanyao_book_event( self._curr_selec_card.card_data.id, self._curr_selec_card.starNum  )
            return
        end
    end

    --炫耀/激活按钮
    self.show_btn = ZTextButton:create( panel, LH_COLOR[2]..Lang.lingqi.hougong[3], UILH_COMMON.btn4_nor, show_func, 309, 8, -1, -1, 1)


    --激活按钮
    local function activate_func(  )

        if not self._curr_selec_card then
            GlobalFunc:create_screen_notic(Lang.lingqi.hougong[4])
            return
        end

        if not (self._curr_selec_card and self._curr_selec_card.series) then
            GlobalFunc:create_screen_notic(Lang.lingqi.hougong[5])
            return
        end
        HeLuoBooksCC:req_update_one_book( 0, self._curr_selec_card.card_data.id, self._curr_selec_card.series)
    end

    self.activate_btn = ZTextButton:create( panel, LH_COLOR[2]..Lang.lingqi.hougong[6], UILH_COMMON.btn4_nor, activate_func, 309, 8, -1, -1, 1)

    local function exchange_func(  )
       UIManager:show_window("meiren_exchange_win")	

    end
    --兑换按钮
    -- self.exchange_btn = ZTextButton:create( panel, LH_COLOR[2]..Lang.lingqi.hougong[7], UILH_COMMON.btn4_nor, exchange_func, 558, 8, -1, -1, 1)	

end

--创建一个美人卡牌

function  MeirenHouse:create_meiren_item( panel, x, y, w, h, meiren_id )

	-- print("美人卡牌信息数据 meiren_id",meiren_id)
	if meiren_id then

			local meiren_item = {}

		    local card_data = HeLuoConfig.getCardConfig( meiren_id )             -- 卡牌静态数据

            --创建比请求返回的数据早，这里starNum未拿到值  在update时再次赋值
	        local starNum = HeluoBooksModel:get_card_star_by_id( card_data.id )      -- 卡牌动态数据
            
	        local item = ItemModel:get_item_info_by_id( card_data.itemId)         -- 卡牌物品数据

	        local series = item and item.series

            meiren_item.card_data =card_data

            meiren_item.starNum =starNum

            meiren_item.item =item

            meiren_item.series =series

			--美人卡牌图片

		      --获取卡牌资源路径
		      -- print("card_data.id",card_data.id)
    		local resPath = string.format( "%s%s.png","ui/lh_lingqi_hg/",string.format("kapai_%04d",card_data.id))
		    meiren_item.meiren = CCBasePanel:panelWithFile(x, y, 166*0.97, 221*0.97, resPath )

		    panel:addChild(meiren_item.meiren)

		   	meiren_item.bg = meiren_item.meiren

		    -- 背景框
		    self.meiren_item_gb = CCBasePanel:panelWithFile( -5, -9, -1, -1, meiren_pai[card_data.quality], 500, 500 )
		    meiren_item.bg:addChild( self.meiren_item_gb )


		    --美人名字	  
			local name_color = ItemModel:get_item_color( card_data.itemId )
		    local item_base = ItemConfig:get_item_by_id( card_data.itemId )
		    if item_base == nil then
		        return 
		    end


            local index_table  = string.find(item_base.name,"·")
            index_table = index_table+2

           local name =  string.sub(item_base.name,index_table,#item_base.name)
            -- local name = string.sub(item_base.name, 11,#item_base.name) --手动减去前面星级

		    meiren_item.name = ZLabel:create(meiren_item.bg, name_color..name, 84, 222, 14, 2)

		    -- -- 选中标志

		    meiren_item.frame_sld = CCZXImage:imageWithFile( -3, -10, w, h, UILH_COMMON.slot_focus, 500, 500 )

		    meiren_item.bg:addChild(meiren_item.frame_sld)

		    meiren_item.frame_sld:setIsVisible(false)

		   
		    --激活状态

			local item = ItemModel:get_item_info_by_id(card_data.itemId)
		    local series = item  and item.series

		    meiren_item.status_img =  CCZXImage:imageWithFile( 18, 17, -1,-1, UILH_LINGQI.no_active, 500, 500 )

		    if series then
		    	meiren_item.status_img:setTexture(UILH_LINGQI.can_active)
	        end

		    meiren_item.bg:addChild(meiren_item.status_img)
		 

		    -- 副本item事件 ------------------------------------------------------

		    local function meiren_item_func(eventType, arg, msgid, selfitem)

		        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then

		            return

		        end

		        if eventType == TOUCH_BEGAN then
		            return true
		        elseif eventType == TOUCH_CLICK then

		        	--显示tip

		            if card_data then
						-- print("美人卡牌信息数据 meiren_id",meiren_id)
                        local starNum = HeluoBooksModel:get_card_star_by_id( card_data.id ) 
                        -- print("starNum",starNum)
		                local click_pos = Utils:Split(arg, ":")

		                local start_x = click_pos[1];

		                local start_y = click_pos[2];
                        
                        --选中
		                local attr = HeluoBooksModel:getCardAttrs( card_data )

		                local data = HeluoBooksModel:get_tips_attr_data( attr)
		                data.attr = attr
		                data.card_data = card_data
		                TipsModel:show_meiren_tip( start_x + 100, 200, data ) 


		                --选中框处理
		                for i=1,#self.cards do
		                	self.cards[i].frame_sld:setIsVisible(false)
		                end
	                    meiren_item.frame_sld:setIsVisible(true)

	                    --当前的卡牌
		                self._curr_selec_card = meiren_item

		                --更新按钮
		                self:update_btn_show()

		            end

		            return true;
		        end
		        return true;

		    end

		    meiren_item.bg:registerScriptHandler( meiren_item_func )  --注册 -------------

		    self.cards[meiren_id] = meiren_item
		return meiren_item

    end

end






-- ===============================================

-- 更新

-- ===============================================

function MeirenHouse:update( update_type )
end




-- 更新卡牌列表 data配置中的卡牌数据

function MeirenHouse:update_card_panel( )

--short 卡牌ID
-- cahr 当前卡牌的星数(1=已激活，2=1星，3=2星，以此类推......)
    for id, star in pairs( HeluoBooksModel.cards_date) do
    	-- self.cards[id].frame_sld:setIsVisible(false)
    	--在创建的时候还没拿到值 现在赋值
    	if self.cards[id] then
	    	self.cards[id].starNum = star
	    	self.cards[id].status_img:setTexture(UILH_LINGQI.had_active)
	    	self.cards[id].status_img:setSize(142,134)
        end
    end
end


--更新美人战斗力

function MeirenHouse:update_fight_value( fight_value )

       --更新战斗力

    if fight_value ~= nil then

        if  self.sum_fight_value ~= nil then

            self.sum_fight_value:removeFromParentAndCleanup( true )

            self.sum_fight_value = nil

        end

        self.sum_fight_value = MUtils:create_num_img( fight_value , 300, 22, self.view)

    end

   

end


function MeirenHouse:update_btn_show( )
 
  if self._curr_selec_card.starNum then
        self.show_btn.view:setIsVisible(true)
        self.activate_btn.view:setIsVisible(false)
  else
        self.show_btn.view:setIsVisible(false)
        self.activate_btn.view:setIsVisible(true)
   end

end


function MeirenHouse:destroy( )

	self.card_info = {}
	self.cards = {}
    self._curr_selec_card = nil
    self.meiren_id_list = {}
	Window.destroy(self)

end

function MeirenHouse:active( show )
    if show then
        HeLuoBooksCC:req_base_heluo_info( )
    end
end





