-- BaguadigongCellView.lua
-- created by fjh on 2013-7-10
-- 八卦地宫统计cell

super_class.BaguadigongCellView()

BaguadigongCellView.CELL_STYLE_TASK = 1;
BaguadigongCellView.CELL_STYLE_BOSS = 2;


function BaguadigongCellView:destroy(  )
	if self.boss_timer_lab then
		self.boss_timer_lab:destroy();
	end
end

function BaguadigongCellView:__init( style, x,y )
	
	self.style = style;
	self.view = CCBasePanel:panelWithFile( x,y,216, 60, UILH_COMMON.m_mini_task_bg,3,3,3,3,3,3,3,3);
	
	local str;	
	if self.style == BaguadigongCellView.CELL_STYLE_TASK then
		-- 目标任务style
		str = LangGameString[2053]; -- [2053]="#c33ff33采集仙草(20/20)#r奖励:17800经验,#cff66cc幽煌珠#cffffffx1"
		
		self.award_statue_lab = UILabel:create_lable_2( LangGameString[2054], 60+18+68, 4, 14, ALIGN_RIGHT ); -- [2054]="#c33ff33点击领取"
    	self.view:addChild(self.award_statue_lab);

	elseif self.style == BaguadigongCellView.CELL_STYLE_BOSS then
		-- boss刷新倒计时style
		str = LangGameString[2055]; -- [2055]="#cffffffBOSS刷新倒计时#r已出现#r点击自动前往"
	end

	self.cell_dialog = MUtils:create_ccdialogEx(self.view,str,0,0,216,60,3,14);
	
	local function touch_event( eventType,arg,msgid )
	
		if eventType == TOUCH_BEGAN then
            self.view:setColor(0x44f2f2f2);
            
            local call_back = callback:new();
            local function cancel( dt )
            	if self then
	            	self.view:setColor(0xffffffff);
	            	call_back:cancel(); call_back = nil;
	            end
            end
            call_back:start(0.5,cancel);

            return true
        elseif  eventType == TOUCH_ENDED then
            self.view:setColor(0xffffffff);
            return true;
        elseif eventType == TOUCH_CLICK then
        	if self.click_func then
        		self.click_func();
        	end
        	return true;
        end
        return false
	end
	self.cell_dialog:setMessageCut(true);
	self.cell_dialog:registerScriptHandler(touch_event);
    -- self.view:setEnableDoubleClick(true);
end

-- 单击事件
function BaguadigongCellView:set_click_func( fn )
	self.click_func = fn;
end

-- 刷新cell
function BaguadigongCellView:update( data )
	print("BaguadigongCellView data",data)
	-- for k,v in pairs(data) do
	-- 	print(k,v)
	-- end
	if self.style == BaguadigongCellView.CELL_STYLE_TASK then
		local target_name, award_item;
		-- if data.target_id == 701 then
		-- 	target_name = LangGameString[2056]; award_item = LangGameString[2057]
		-- elseif data.target_id == 702 then
		-- 	target_name = LangGameString[2058]; award_item = LangGameString[2057]
		-- elseif data.target_id == 703 then
		-- 	target_name = LangGameString[2059]; award_item = LangGameString[2057]
		-- elseif data.target_id == 704 then
		-- 	target_name = LangGameString[2060]; award_item = LangGameString[2061]
		-- elseif data.target_id == 705 then
		-- 	target_name = LangGameString[2062]; award_item = LangGameString[2061]
		-- end

		if data.target_id == 591 then
			target_name = Lang.baguadigong[3];award_item = Lang.baguadigong[4]; -- [2056]="采集仙草" -- [2057]="幽煌珠"
		elseif data.target_id == 592 then
			target_name = Lang.baguadigong[5];award_item = Lang.baguadigong[4]; -- [2058]="击杀幽魂" -- [2057]="幽煌珠"
		elseif data.target_id == 593 then
			target_name =Lang.baguadigong[6];award_item = Lang.baguadigong[4]; -- [2059]="击杀绿妖" -- [2057]="幽煌珠"
		elseif data.target_id == 594 then
			target_name = Lang.baguadigong[7];award_item = Lang.baguadigong[8]; -- [2060]="击杀魔刃" -- [2061]="焚离珠"
		elseif data.target_id == 595 then
			target_name =Lang.baguadigong[9];award_item = Lang.baguadigong[8]; -- [2062]="击杀傀儡" -- [2061]="焚离珠"
		end
		

		local str = string.format(Lang.baguadigong[10], -- [2063]="#c33ff33%s #cffffff(%d/%d)#r奖励:%d经验,#cff66cc%s#cffffffx1"
			target_name, data.completed_count, data.target_count, data.award_exp, award_item);
		--local str = "#cffffff采集仙草(20/20)#r奖励:17800经验,#cff66cc幽煌珠#cffffffx1";
		-- print("更新八卦",str);
		self.cell_dialog:setText(str);
		-- if data.completed_count < data.target_count then
		-- 	self.award_statue_lab:setIsVisible(false);
		-- else
		if data.award_status == 0 then
			self.award_statue_lab:setIsVisible(false);
		elseif data.award_status == 1 then
			self.award_statue_lab:setIsVisible(true);
			self.award_statue_lab:setText(Lang.baguadigong[15]); -- [2054]="#c33ff33点击领取"
		elseif data.award_status == 2 then
			self.award_statue_lab:setIsVisible(true);
			self.award_statue_lab:setText(Lang.baguadigong[11]); -- [2064]="#cff0000已领取"
		end
		-- end

	elseif self.style == BaguadigongCellView.CELL_STYLE_BOSS then

		
		if data > 0 then
			local str = LangGameString[2065]; -- [2065]="#cffffffBOSS刷新倒计时#r#r点击自动前往"
			self.cell_dialog:setText(str);

			if self.boss_timer_lab == nil then
				self.boss_timer_lab = TimerLabel:create_label(self.view, 0, 5, 14, data,"#cff0000");
				local function end_func(  )
					self.boss_timer_lab:setIsVisible(false);

					local str = LangGameString[2066]; -- [2066]="#cffffffBOSS刷新倒计时#r#c33ff33已出现#r#cffffff点击自动前往"
					self.cell_dialog:setText(str);
				end
				self.boss_timer_lab:set_end_call(end_func);
			else
				self.boss_timer_lab:setIsVisible(true);
				self.boss_timer_lab:setText(data);
			end
			
		else
			local str = LangGameString[2066]; -- [2066]="#cffffffBOSS刷新倒计时#r#c33ff33已出现#r#cffffff点击自动前往"
			self.cell_dialog:setText(str);
			if self.boss_timer_lab then
				self.boss_timer_lab:setIsVisible(false);
			end
		end
	end

end
