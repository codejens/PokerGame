-- FubenTongjiView.lua
-- created by fjh on 2013-2-20
-- 副本统计视图

super_class.FubenTongjiView(Window)

--镇妖塔副本统计面板 攻略按钮 回调需要当前层 
local _curr_floor = 1

function _get_count(num) --获得几位数
    if num == nil then
        return 0
    end
    local count = 1 
    while num >9 do
        count = count +1
        num = math.floor(num / 10)
    end
    return count
end

-- 更新增加蟠桃采集次数需要的元宝
function FubenTongjiView:update_pink_gather_count( count )
	if self.gather_label ~= nil then
		self.gather_label:setText(string.format(Lang.tongji[1],count)); -- [2078]="#c00ff00消耗元宝:"
	end
end

-- 更新必杀技副本的经验值
function FubenTongjiView:update_bishaji_fuben_exp( exp )
	local lab = self.label_dict[0];
	if lab then
		lab:update_num(exp)
	end
end


function FubenTongjiView:update(fbId, date )
	-- print("______________________date=")
	for _type,value in pairs(date) do
		print("server _type=",_type)
		local lab = self.label_dict[_type];
		local baifen = self.baifen_dict[_type];
		-- if lab ~=nil then
		-- 	lab:setText(tostring(value));
		-- end
		--遍历当前这个副本配置
		for k,v in pairs(self.fb.items) do 
			--判断当前这个数据是否为show == 3类型，倒计时类型
			-- print("client v.type=",v.type,v.show)

			if v.type == _type and v.show == 2 then
				--倒计时类型的lab，文本需要特殊处理
				-- print("~~~~~~~~~~~~~~value2=",value)
				lab:setText(value);
				break;	
			-- elseif v.type == type and  v.show == 3 then
			-- 	lab:update_num( value )
			-- 	-- lab:setText("#cff0000"..tostring(value));
			-- 	break;	
			elseif v.type == _type and  v.show == 6 then
				-- 秘籍塔开始出现，记录层主用时和最短用时等不变的统计信息
				lab:setText(tostring(value));
				break;	
			elseif v.type == _type and  v.show == 7 then
				-- 秘籍塔开始出现，TimerLabel类型的lab，正向计时器
				lab:setText(value);
				break;	
			elseif v.type == _type  then
				-- print("~~~~~~~~~~~~~~value22=",value)
				if lab.update_num then
					lab:update_num(value);
				end

				if baifen then
					local count = _get_count(value)
					local Y = baifen.view:getPositionY()
					local X = 103+count * 14
					-- print("count=",count)
					baifen.view:setPosition(X,Y)
				end
				break;
			end
		end
	end

	if fbId == 7 and self.gather_label then 
		-- 如果是在蟠桃活动中，随便更新消耗元宝数
		self.gather_label:setText(string.format(Lang.tongji[1],FubenTongjiModel:get_add_gather_yb())); -- [2078]="#c00ff00消耗元宝:"
	end

	if fbId == 119 then --z镇妖塔副本
		_curr_floor  = date[6]
	end
end

function FubenTongjiView:__init( window_name, texture_name, is_grid, width, height )
	
	self.label_dict = {};
	self.baifen_dict = {};

	-- local panel = CCBasePanel:panelWithFile(-3, -11, width, height, UILH_COMMON.bottom_bg, 500, 500)
	-- self.view:addChild(panel)
	-- 先计算出tip信息的动态高度
	local tip_lab = MUtils:create_ccdialogEx(self.view,self.fb.tip,5,0,250,50,10,14);
	local tip_h = tip_lab:getInfoSize().height;
	tip_lab:setAnchorPoint(0,1);
	
	self.content_height = self.content_height+tip_h;
	print("tip高度",tip_h, self.content_height);
	--重新设定self.view的高度
	self.view:setSize(130,self.content_height);
	-- panel:setSize(260,self.content_height+12);
	--重新设定tip_lab的y坐标
	if self.fb.fbID == 7 then
		-- 副本7，蟠桃盛宴
		tip_lab:setPosition( 5, tip_h);
	else
		tip_lab:setPosition( 5, tip_h);
	end
	 
	for i,item in ipairs(self.fb.items) do
		print("item.type",item.type)
		if item.type ~= -1 then
			--每一项的标题
			local y;
			if i==1 then
				y = self.content_height-20;
			elseif i==2 and self.fb.fbID == 7 then
				--副本7，采集蟠桃特殊处理
				local prev_lab = self.label_dict[self.fb.items[i-1].type]
				local point_y = prev_lab:getPositionY()-25+2;
				y = point_y-20;
			else
				-- 每个标题的y坐标是根据前一个标题的y坐标计算出来的，所以这里取一个lab对象
				local prev_lab = self.label_dict[self.fb.items[i-1].type]
				local point_y = prev_lab:getPositionY()+2;
				y = point_y-20;
			end

			local str = "#c00ff00"..item.title;
			local label = UILabel:create_lable_2( str, 5, y, 14, ALIGN_LEFT);
			self:addChild(label);

			--每个标题对应值的label
			local str = "";
			local font_size = 14;
			local x = label:getSize().width+5;--130/2;
			local align = ALIGN_LEFT;
			if item.show == 1 then
				--show 1类型的lab要紧跟在标题之后，而不换行显示,所以x坐标特殊处理
				str = tostring(self.data[item.type]);
				align = ALIGN_LEFT;
			
			elseif item.show == 2 then
				-- y = y-20;
			elseif item.show == 3 then
				--type为-1时，是图标
				if item.type~= -1 then
					if self.data[item.type] then
						str = tostring("#cff0000"..self.data[item.type])
					end
				end
				font_size = 16;
			end

			local value_label;
			if item.show == 2 then
				--show为2，计时类型的lab
				value_label = TimerLabel:create_label(self.view,x+5, y,font_size, self.data[item.type],LH_COLOR[4] );
			elseif item.show == 6 then -- 普通的label显示提示信息，秘籍塔开始出现
				value_label = UILabel:create_lable_2( str, x,y, font_size, align);
				self:addChild(value_label);
			elseif item.show == 7 then --正向计时器，秘籍塔开始出现
				value_label = TimerLabel:create_label(self.view,x+5, y,font_size, self.data[item.type],
				nil,nil, false, 1, true );
			else

				-- value_label = UILabel:create_lable_2( str, x,y, font_size, align);
				-- self:addChild(value_label);
				print("NumView:create( self.data[item.type])",item.type)
				local num = self.data[item.type] or 0
				value_label = NumView:create(num,self.view,x-5,y-3,10 )
				-- print("value_label",value_label,self.data[item.type])
			end
			local cur_fuben = SceneManager:get_cur_fuben()
			if item.show == 5 and item.type >= 14 and item.type <= 17 and cur_fuben >= 76 and cur_fuben <=80 then--仙踪副本加个百分比
				local count  = _get_count(self.data[item.type])
				print("run 166 count",count,item.type)
				local baifen = ZImage:create(self.view,UIResourcePath.FileLocate.normal .. "baifenbi.png",103+ count*14,y-3)
				self.baifen_dict[item.type] = baifen;
			end
			--保存lab
			self.label_dict[item.type] = value_label;
			
			--特殊的按钮和lab，在蟠桃盛宴出现
			if self.fb.fbID == 7 then
				--增加一次采集蟠桃
				local function pantao( )
					FubenTongjiModel:req_add_gather_count( );
				end
                
                --是否选中
			    local function swith_but_func( flag )
			            _dont_open_dialog = flag
			    end

                local  function tip_func()
                	if  not _dont_open_dialog then
                        ConfirmWin2:show( 5, 0, string.format(Lang.tongji[2], FubenTongjiModel:get_add_gather_yb()),  pantao, swith_but_func, title_type )
                	else
                		pantao()
                	end
                end 
				
				local add_btn = TextButton:create(nil, 130, self.content_height-47, 96, 43, Lang.role_info.user_buff_panel.add_e, {UILH_COMMON.lh_button2,UILH_COMMON.lh_button2});		  	 -- [628]="增加"
				add_btn:setTouchClickFun(tip_func);
				self.view:addChild(add_btn.view);

				if not self.gather_label then
					self.gather_label = UILabel:create_lable_2(string.format(Lang.tongji[1],FubenTongjiModel:get_add_gather_yb()), 5, self.content_height-40, 14, ALIGN_LEFT); -- [2078]="#c00ff00消耗元宝:"
					self:addChild(self.gather_label);
				else
					self.gather_label:setText(string.format(Lang.tongji[1],FubenTongjiModel:get_add_gather_yb()))
				end

			end

			if self.fb.fbID == 119 then --镇妖塔添加攻略按钮
				local function zyt_gl_btn_cb_func(eventType,x,y )
		             -- if eventType == TOUCH_CLICK then
						ZhenYaoTaModel:look_info_cb_func(_curr_floor,ZhenYaoTaModel.CLOSE_TYPE )
		             -- end
		             -- return true;
				end
			    local btn = ZButton:create( self.view, {UILH_COMMON.button6_4,UILH_COMMON.button6_4}, zyt_gl_btn_cb_func, 83, 0, 90, 40 )
			    MUtils:create_zxfont(btn,Lang.zhenyaota[13],90/2,15,2,14);	-- [13] = "查看攻略",
				-- local gl_btn = MUtils:create_common_btn( self.view,Lang.zhenyaota[13],zyt_gl_btn_cb_func,20, 0 )	-- [13] = "查看攻略",
				
			end
		end
	end
end


function FubenTongjiView:destroy( )
	print("---------统计面板销毁----------")
	Window.destroy(self);

	for k,v in pairs(self.label_dict) do
		print("销毁timerLabel的 timer",v.destroy_timer);
		if v.destroy_timer then
			v.destroy_timer();
		elseif v.destroy then
			-- 删除掉NumView
			v:destroy();
		end
	end
	
	_curr_floor = 1
end

-- 计算面板的高度
local function utilFunc_get_content_height( fb )
	local height = 0;
	for i,item in ipairs(fb.items) do
		height = height + 20;
	end
	if fb.fbID == 7 then
		height = height + 25;
	end
	if fb.fbID == 119 then --镇妖塔添加攻略按钮
		height = height + 40;
	end
	return height;
end

function FubenTongjiView:create(fb,data)
	for k,item in pairs(fb.items) do
		print("item.type= ",item.type)
	end

	self.fb = fb;
	self.content_height = utilFunc_get_content_height(fb) + 7
	self.data = data;
	return FubenTongjiView("FubenTongjiView", "", false, 150, self.content_height);

end
