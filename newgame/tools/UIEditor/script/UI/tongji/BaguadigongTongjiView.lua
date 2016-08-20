-- BaguadigongTongjiView.lua
-- created by fjh on 2013-7-9
-- 八卦地宫统计视图

super_class.BaguadigongTongjiView(Window)

local _data = nil;

function BaguadigongTongjiView:destroy(  )
	
	if self.cell_dict[6] then
		self.cell_dict[6]:destroy();
	end
	_data = nil;

	Window.destroy(self);

end

-- 重新排版cell
function BaguadigongTongjiView:relayout_cell(  )
	local i=1;
	for k,v in pairs(self.cell_dict) do
		if v ~= nil then
			v.view:setPosition(2, 280-(i-1)*54);
			i = i+1;
		end
	end
end

-- 更新八卦地宫的boss刷新时间
function BaguadigongTongjiView:update_boss_refresh_time( time )

	if self.cell_dict[6] then
		self.cell_dict[6]:update(time);
	end
end

-- 更新八卦地宫统计
function BaguadigongTongjiView:update( fbId, data )

	if fbId == 69 then
		
		if #data ~= 0 then
			_data = data;
		end
		for i,v in ipairs(data) do
			-- if v.award_status == 2 then
			-- 	local cell = self.cell_dict[i];
			-- 	if cell then
			-- 		cell.view:removeFromParentAndCleanup(true);
			-- 		self.cell_dict[i] = nil;
			-- 	end
			-- else
				self.cell_dict[i]:update(v);
			-- end
		end

		-- self:relayout_cell();

	end
end

-- 初始化函数
function BaguadigongTongjiView:__init(  )
	
	self.cell_dict = {};
-- print("SceneManager:get_cur_scene()",SceneManager:get_cur_scene())
	local scene_config = SceneConfig:get_scene_by_id( SceneManager:get_cur_scene() );
	local cell_h = 64
	local beg_y = 330
	local beg_task_id = 590

	for i=1,5 do
		local cell = BaguadigongCellView( BaguadigongCellView.CELL_STYLE_TASK, 2, beg_y-(i-1)*cell_h);
		self:addChild(cell.view);
		local function get_award_func(  )
			
			if _data and #_data > 0 then 	
				
				if _data[i].award_status == 1 then
					-- 可领取八卦地宫奖励
					BaguadigongModel:get_award( beg_task_id+i )
				elseif _data[i].award_status == 2 then
					-- 已领取
					GlobalFunc:create_screen_notic(LangGameString[2067]); -- [2067]="已领取任务奖励"
				elseif _data[i].award_status == 0 then
					-- 未完成
					
					BaguadigongModel:move_to_monster_position( scene_config, beg_task_id+i )
				end
			end
		end
		cell:set_click_func(get_award_func);

		self.cell_dict[i] = cell;

	end

	-- boss刷新
	local boss_cell = BaguadigongCellView( BaguadigongCellView.CELL_STYLE_BOSS, 2, beg_y-(6-1)*(cell_h));
	local function find_boss(  )
		BaguadigongModel:move_to_boss_position(  )
	end
	boss_cell:set_click_func(find_boss);
	self:addChild(boss_cell.view);
	self.cell_dict[6] = boss_cell;

	self:update(69,_data);
end

function BaguadigongTongjiView:create( data )
	_data = data;
	self.content_height = 390
	return BaguadigongTongjiView("BaguadigongTongjiView", "", true, 150, self.content_height);
end
