-- CampBattleTaskWin.lua
-- created by fjh on 2013-7-8
-- 阵营战任务窗口

super_class.CampBattleTaskWin(Window)

function CampBattleTaskWin:active( show )
	if show then
		CampBattleModel:req_battle_task(  )
	end
end

function CampBattleTaskWin:__init(  )
	
	-- 标题
	-- local activity_title_sp = CCZXImage:imageWithFile(389/2-230/2,429-45,226,46, UIResourcePath.FileLocate.common.."win_title1.png");
	-- self:addChild(activity_title_sp);
	-- self.activity_title = CCZXImage:imageWithFile(226/2-87/2-5,46/2-23/2+3,87,23, UIResourcePath.FileLocate.camp.."camp_task_title.png");
	-- activity_title_sp:addChild(self.activity_title);

	-- -- 关闭按钮
	-- local self_size = self:getSize()
	-- local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.common.."close_btn_n.png")
	-- local close_btn_size = close_btn:getSize()
	-- close_btn:setPosition( self_size.width - close_btn_size.width, self_size.height - close_btn_size.height )
 --  	close_btn:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common.."close_btn_s.png")
 --  	local function close_fun( eventType,x,y )
	-- 	--关闭事件
	-- 	if eventType == TOUCH_CLICK then
	-- 		UIManager:hide_window("camp_task_win");
	-- 	end
	-- 	return true;
	-- end
	-- close_btn:registerScriptHandler(close_fun) 
 --    self:addChild(close_btn,99);

    -- 任务cell
    self.cell1 = CampTaskCellView(15,265,CampTaskCellView.TASK_TYPE_1);
    -- self.cell1:update( CampTaskCellView.TASK_TYPE_1, 1 );
    self:addChild(self.cell1.view);

    self.cell2 = CampTaskCellView(15,265-135+10,CampTaskCellView.TASK_TYPE_2);
    -- self.cell2:update( CampTaskCellView.TASK_TYPE_2, 1 );
    self:addChild(self.cell2.view);

    self.cell3 = CampTaskCellView(15,265-135*2+20,CampTaskCellView.TASK_TYPE_3);
    -- self.cell3:update( CampTaskCellView.TASK_TYPE_3, 1 );
    self:addChild(self.cell3.view);
end


function CampBattleTaskWin:update( data )
	
	self.cell1:update( data[1].index, data[1].status);
	self.cell2:update( data[2].index, data[2].status);
	self.cell3:update( data[3].index, data[3].status);

end
