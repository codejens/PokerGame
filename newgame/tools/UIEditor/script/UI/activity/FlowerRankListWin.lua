-- FlowerRankListWin.lua
-- create by guozhinan 2015-2-5
-- 送花收花子活动弹出的排行榜小面板
super_class.FlowerRankListWin(Window)

function FlowerRankListWin:__init(window_name, texture_name, is_grid, width, height,title_text)

	-- 注册面板事件
	local function bg_event( eventType,x,y )
		if eventType == TOUCH_CLICK then
			UIManager:destroy_window("flower_rank_win");
		end
		return true;
	end 
	self.view:registerScriptHandler(bg_event)

	-- 排行榜背景
	local view_size = self.view:getSize()
	local bg = CCBasePanel:panelWithFile( view_size.width/2-410/2, view_size.height/2-305/2, 410, 305, UILH_COMMON.dialog_bg,500, 500);
	self:addChild(bg);

	local bottom_bg = CCBasePanel:panelWithFile( 10, 10, 410-20, 305-50, UILH_COMMON.bottom_bg,500, 500);
	bg:addChild(bottom_bg);

    --标题背景
	local title_bg = ZImage:create( bg,UILH_COMMON.title_bg, 0, 0, 340, 57,0,500,500 )
	local title_bg_size = title_bg:getSize()
	title_bg:setPosition( ( 410 - title_bg_size.width ) / 2, 267 )
    
	local t_width = title_bg:getSize().width
	local t_height = title_bg:getSize().height
	self.window_title = ZImage:create(title_bg, UILH_LONELY.title_songhua , t_width/2,  t_height-27, -1,-1,999 );
	self.window_title.view:setAnchorPoint(0.5,0.5)

	-- 标题
    local subtitle_bg = ZImage:create(bottom_bg, UILH_NORMAL.title_bg5, 3, 215, 384, 36, 0, 500, 500)   
    local subtitle_text = {Lang.qingrenjie[3],Lang.qingrenjie[4],Lang.qingrenjie[5]}
    --排名 , 角色名 , 赠送数量
    self.subtitle_label = {}
    for i = 1, 3 do 
        local titleLb = ZLabel:create(subtitle_bg,subtitle_text[i], 45+130*(i-1), 20, 18)
        titleLb.view:setAnchorPoint(CCPointMake(0.5, 0.5))  
        self.subtitle_label[i] = titleLb
    end

    -- 我的排名
    self.rank_label = ZLabel:create(bottom_bg,Lang.qingrenjie[6],12,12,16);

	-- 送花或者收花的排行榜
	self.rank_data = nil
	local function scroll_action(self, eventType,args,msgId)
	    if eventType == nil or args == nil or msgId == nil then 
	        return false
	    end

        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
	    elseif eventType == SCROLL_CREATE_ITEM then
	        -- 计算创建的 序列号
	        local temparg = Utils:Split_old(args,":")
	        local x = temparg[1]              -- 行
	        local y = temparg[2]              -- 列
	        local t_itemIndex = x + 1

	        --创建每行子行
	        local t_itemView = nil
            t_itemView = self:create_rankingScroll_item(t_itemIndex)
            self._rankingScroll:addItem(t_itemView. view)
            self._rankingScroll:refresh()

	        return false
	    end
	end
    self._rankingScroll = CCScroll:scrollWithFile(12, 41, 380, 180, 0, "", TYPE_HORIZONTAL)
    self._rankingScroll:registerScriptHandler(bind(scroll_action, self))
    self._rankingScroll:refresh()
    bg:addChild(self._rankingScroll)  


	-- 关闭按钮
	local function close_win( eventType,x,y )
		if eventType == TOUCH_CLICK then
			UIManager:destroy_window("flower_rank_win");
		end
		return true;
	end
	local close_btn = MUtils:create_btn( bg, UILH_COMMON.close_btn_z,UILH_COMMON.close_btn_z,
										close_win,410-56,305-56,60,60 );
end

--创建一行排行榜记录
function FlowerRankListWin:create_rankingScroll_item(itemIndex)
	if self.rank_data == nil or self.rank_data[itemIndex] == nil then
		return;
	end
    local t_data = {itemIndex, self.rank_data[itemIndex][1], self.rank_data[itemIndex][2]}

    --创建视图背景
    local itemLayout = SendFlowerWinLayout.rankingItem
    local itemDk = ZBasePanel:create(nil, "", 0, 0, 475, 32, 0, 500, 500)

    --排名,角色名，赠送数量
    for i = 1, 3 do 
        local lb = ZLabel:create(itemDk, tostring(t_data[i]), 45 + 130 * (i - 1), 30, 16)
        lb.view:setAnchorPoint(CCPointMake(0.5, 1))
    end

    --分割线
    local layout = itemLayout.line
    ZImage:create(itemDk, UILH_COMMON.split_line, 5, 1, 468, 3)   

    return itemDk
end

function FlowerRankListWin:update_ranking_scroll(data,title_path)
	if data ~= nil then
		if data.RankData ~= nil then
			self.rank_data = data.RankData;

		    self._rankingScroll:clear()
		    self._rankingScroll:setMaxNum(#self.rank_data)
		    self._rankingScroll:refresh()
		end
		if data.myRank ~= nil then
			self.rank_label:setText(Lang.qingrenjie[6]..data.myRank)
		end
	end
	if title_path ~= nil then
		self.window_title:setTexture(title_path)
	end
end

function FlowerRankListWin:update_subtitle(index, label_name)
	if self.subtitle_label[index] ~= nil then
		self.subtitle_label[index]:setText(label_name)
	end
end