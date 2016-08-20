-- MarriagePlayWin.lua
-- create by fjh 2013-8-28
-- 婚宴的嬉戏功能

super_class.MarriagePlayWin(Window)

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _winShowY = {205+64, 125+64}

function MarriagePlayWin:destroy(  )
	
	for i,v in ipairs(self.lab_dict) do
		v.cd_lab:stop_timer();
	end

	Window.destroy(self);
end


function MarriagePlayWin:__init(  )
	
	self.lab_dict = {};
	
	for i=1,4 do

		local function btn_event( eventType  )
			if eventType == TOUCH_CLICK then
				if i == 4 then
					local data = MarriageModel:get_wedding_data(  );
					if data.xitang == 0 then
						-- 如果撒喜糖次数等于0，则询问是否增加
						local function buy_xitang( )
							MarriageModel:add_sa_xitang_count(  )
						end
						ConfirmWin2:show( 4, nil, LangGameString[1507],  buy_xitang); -- [1507]="是否花费15元宝增加一次撒喜糖的机会?"
					else
						if self.lab_dict[i].cd_state then
							GlobalFunc:create_screen_notic("冷却时间未结束"); -- [1508]="冷却时间未结束"
						else
							MarriageModel:req_wedding_play( i );
							self:set_cd_time(i,true);
							
						end
					end
				else
					if self.lab_dict[i].cd_state then
						GlobalFunc:create_screen_notic("冷却时间未结束"); -- [1508]="冷却时间未结束"
					else
						MarriageModel:req_wedding_play( i );	
						self:set_cd_time(i,true);
					end
				end

			end
		end
		
		local play_btn = MUtils:create_btn( self.view, UIResourcePath.FileLocate.lh_marriage.."play_"..i..".png", UIResourcePath.FileLocate.lh_marriage.."play_"..i..".png",
											btn_event,0+(i-1)*80,0,67,67 );


		local count_bg = MUtils:create_zximg( play_btn, UILH_MARRIAGE.play_count_bg,48, 48, 23, 23);
		
		-- 剩余次数
		local count_lab = UILabel:create_lable_2( "1", 11, 5, 14, ALIGN_CENTER );
		count_bg:addChild( count_lab );
		
		-- cd时间lab
		local cd_timer_lab = TimerLabel:create_label( play_btn, 13, 70, 16, 0, nil, nil, true );
		local function cd_end_fun()
			self:set_cd_time( i,false );
		end
		cd_timer_lab:set_end_call( cd_end_fun );

		

		self.lab_dict[i] = { lab = count_lab, btn = play_btn, cd_lab = cd_timer_lab, cd_state = false };

		-- 是否有按钮在cd中
		local time = MarriageModel:get_wedding_cd_time( i );
		if time == nil then
			cd_timer_lab:setIsVisible(false);
		else
			self:set_cd_time( i, true, time );
		end
		
	end

	-- 根据菜单栏是否显示来校正位置，UIManager的配置其实是没打算去使用的。
	local win = UIManager:find_visible_window("menus_panel")
	if win then
		local is_menus_show = win:get_is_show()
		if is_menus_show ~= nil then
	        if is_menus_show == true then
	            self.view:setPosition(_refWidth(0.5),_winShowY[1])
	        else
	        	self.view:setPosition(_refWidth(0.5),_winShowY[2]) 
	        end
	    end
	end
end

function MarriagePlayWin:active( show )
	
	if show then
		self:update();
	end

end

function MarriagePlayWin:update(  )
	
	local data = MarriageModel:get_wedding_data(  );
	if data ~= nil then

		-- 敬酒次数
		self.lab_dict[1].lab:setText( data.jingjiu.."" );
		-- 祝福此时
		self.lab_dict[2].lab:setText( data.zhufu.."" );
		-- 嬉戏
		self.lab_dict[3].lab:setText( data.guilian );
		
		local player = EntityManager:get_player_avatar();
		if player.id == data.woman_id or player.id == data.male_id then
			self.lab_dict[4].btn:setIsVisible(true);	
			self.lab_dict[4].lab:setText( data.xitang.."" );
		else
			self.lab_dict[4].btn:setIsVisible(false);	
		end
	end

end

-- 设置cd状态
function MarriagePlayWin:set_cd_time( index, bool, cd_time )
	
	if cd_time ~= nil then
		self.lab_dict[index].cd_lab:setText(cd_time);
	else
		self.lab_dict[index].cd_lab:setText(60);
	end

	if bool == true then
		-- 进入cd时间
		self.lab_dict[index].cd_lab:setIsVisible(true);
		-- self.lab_dict[index].cd_lab:setText(60);
		self.lab_dict[index].cd_state = true;
	elseif bool == false then
		self.lab_dict[index].cd_lab:setIsVisible(false);
		self.lab_dict[index].cd_state = false;
	end
end

function MarriagePlayWin:menuChangeVisible(is_menus_show)
    local win = UIManager:find_visible_window("marriage_play_win")
    if ( win ) then
        if is_menus_show then
            local p = CCPointMake(_refWidth(0.5),_winShowY[1])
            win.view:runAction(CCMoveTo:actionWithDuration(0.3,p))   
        else
            local p = CCPointMake(_refWidth(0.5),_winShowY[2])
            win.view:runAction(CCMoveTo:actionWithDuration(0.3,p))    
        end
    end
end