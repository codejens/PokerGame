-- FubenTongjiModel.lua
-- created by fjh on 2013-2-20
-- 副本统计数据模型

-- super_class.FubenTongjiModel()
FubenTongjiModel = {}

local _fbId = 0;	--副本id
local _actId = 0;	--活动id
local _data = nil;	--数据

local _special_data = nil;	--存放一些特殊数据，比如阵营战中的联盟信息

local _yuanbao_for_add_gather = 0; --蟠桃活动中，增加采集数需要的元宝数

-- added by aXing on 2013-5-25
function FubenTongjiModel:fini( ... )
	_fbId = 0;	--副本id
	_actId = 0;	--活动id
	_data = nil;	--数据
	_special_data = nil;	--存放一些特殊数据，比如阵营战中的联盟信息
	_yuanbao_for_add_gather = 0; --蟠桃活动中，增加采集数需要的元宝数
end

--更新最新的数据
local function update_data( data  )
	for type,value in pairs(data) do
		_data[type] = value;
	end
end

--获取联盟数据
function FubenTongjiModel:get_league_data(  )
	if _special_data ~= nil then
		return _special_data;
	end
end

--只有在阵营战中，才有联盟信息的更新
function FubenTongjiModel:update_campBattle_league( league_dict )
	
	_special_data = league_dict;
	MiniTaskPanel:update_special_status( 59,league_dict,0 );

end

-- 获取蟠桃盛宴中的可采集次数
function FubenTongjiModel:get_pantao_gather_count(  )
	if _fbId == 7 and _actId == 1 then
		-- 蟠桃活动配置中，6为采集次数
		print("获取蟠桃盛宴中的可采集次数",_data[6]);
		return _data[6];
	end
	return;
end

-- 只有在八卦地宫中，才有boss刷新时间
function FubenTongjiModel:update_baguadigong_boss_time( time )
	MiniTaskPanel:update_special_status( 69,time );
end


--更新统计信息
function FubenTongjiModel:update_tongji( fbId, actId, data )
	print("FubenTongjiModel:update_tongji( fbId, actId, data )",fbId,actId,data)
	
	  -- print("更新统计信息",fbId);
	if fbId ~= 0 and fbId ~= 1 then
		print("副本统计 活动id",actId,"副本id",fbId);
		if _fbId == fbId and _actId == actId then
			print("run if")
			
			if _fbId == 59 then
				--副本56，阵营战的数据特殊，
				_data = data;
			elseif _fbId == 69 then
				_data = data;
			elseif _fbId == 999 and actId == 1 then	

				--天元之战活动没有副本id，所以用了一个特殊值fbid和一个活动id来确定
				_data = data;
			elseif _fbId == 998 and actId == 1 then
				-- 自由赛活动没有副本id,所以用了一个特殊值fbid和一个活动id来确定
				_data = data;
			elseif _fbId == 998 and actId == 2 then
				-- 自由赛活动没有副本id,所以用了一个特殊值fbid和一个活动id来确定
				_data = data;
			elseif _fbId == 11 then 
				--副本11为诛仙阵, 		
				if data[5] == 5 then
					--这里倒计时为5秒
					--如果诛仙副本的数据中有type为5，下波怪物进攻时间，则需要开始显示倒计时
					local win = UIManager:find_window("menus_panel");
					win:show_fuben_countdown(4);
				else 
					_data[5] = nil;
				end
				-- 如果已经时间计数已经有了，将数值置空，防止在更新统计面板时干扰倒计时
				if _data[4] ~= nil then
					_data[4] = nil;
				end
				--将变化的数据更新到 _data 里去。
				update_data(data)
			elseif _fbId == 119 then --镇妖塔
				if data[8] then  --层主用时
					if data[8] == 0 then
						 data[8] = Lang.zhenyaota[1] -- "暂无"
					else
						local fen = math.floor(data[8]/60)
						local miao = data[8]%60
						 data[8] = string.format(Lang.zhenyaota[2],fen,miao)	-- [2] = "%d分%d秒",
					end
				end
				if data[14] then  --最短用时
					if data[14] == 0 then
						 data[14] = Lang.zhenyaota[1] -- "暂无"
					else
						local fen = math.floor(data[14]/60)
						local miao = data[14]%60
						 data[14] = string.format(Lang.zhenyaota[2],fen,miao)	-- [2] = "%d分%d秒",
					end
				end

				update_data(data);
			else
				-- 一些时间给去除掉。
				if _data[4] ~= nil then 
					_data[4] = nil;
				end
				if _data[5] ~= nil then
					_data[5] = nil;
				end
				-- if _data[9] ~= nil then
				-- 	_data[9] = nil;
				-- end
				if _data[10] ~= nil then
					_data[10] = nil;
				end
				--将变化的数据更新到 _data 里去。
				update_data(data);
			end
			
			MiniTaskPanel:update_tongji_panel(fbId, _data)

			-- 新手指引代码
			--[[if (  XSZYManager:get_state() == XSZYConfig.FUBEN_ZY ) then
				if ( fbId == 4  ) then
					if ( data[9] == 0 ) then 
						XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
	                    -- 指向退出副本按钮
	                    XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.TUICHUFUBEN_BTN,1 ,XSZYConfig.OTHER_SELECT_TAG );
					end
				end	
			end--]]
		else
			_fbId = fbId;
			_actId = actId;
			_data = data;
			--如果副本id、活动id不同，则认为是一个新的统计类型
			MiniTaskPanel:get_miniTaskPanel():do_tab_button_method(4);
			MiniTaskPanel:get_miniTaskPanel():change_tongji_kejie_state( false );
			-- print("切换小地图按钮为统计...")
		end	
	end
end

-- 获取统计面板
function FubenTongjiModel:get_tongji_panel(  )
   -- print("get_tongji_panel",_fbId,_actId)
	local tongji_panel = nil;

	-- fbId为59,是阵营战副本，阵营战的统计特殊处理
	if _fbId == 59 then
		-- require "UI/tongji/CampBattleTongjiView"
		tongji_panel = CampBattleTongjiView:create(_data);

	elseif _fbId == 69 then

		tongji_panel = BaguadigongTongjiView:create( _data );
	elseif _fbId == 999 and _actId == 1 then
		--天元之战活动没有副本id，所以用了一个特殊值fbid和一个活动id来确定
		tongji_panel = TianYuanTongjiView:create( _data )
	elseif _fbId == 998 and _actId == 1  then
		--自由赛活动没有副本id，所以用了一个特殊值fbid和一个活动id来确定
		tongji_panel = ZiYouSaiView:create(  );
	elseif _fbId == 998 and _actId == 2 then
		tongji_panel = ZhengBaSaiView:create();
	else
		-- print("_fbId,_actId",_fbId,_actId)
		local fb = TongjiConfig:get_fuben_config(_fbId,_actId);
		-- print("fb",fb)
		if fb ~= nil and _data ~= nil then
			-- require "UI/tongji/FubenTongjiView"
			-- print("fb.items[1].show=",fb.items[1].show)
	    	tongji_panel = FubenTongjiView:create(fb,_data);
	    end	
	end
	
    return tongji_panel; 
end


local function get_title_by_type(items, type )
	for i,item in ipairs(items) do
		if item.type == type then
			return item.title;
		end
	end
end

--退出副本时显示副本统计结果
function FubenTongjiModel:show_tongji_result(  )
	local result_str = "";
	
	local fb = TongjiConfig:get_fuben_config(_fbId,_actId);
	if fb ~= nil and fb.result ~= nil then

		for k,type in pairs(fb.result) do
			
			local title = get_title_by_type(fb.items, type );
			local value = _data[type];
			result_str = result_str..title..tostring(value).."#r";
		end
		
		NormalDialog:show( result_str,nil,1 );
	end
	
end

--关闭副本统计
function FubenTongjiModel:close_tongji_panel(  )
--	xprint("FubenTongjiModel:close_tongji_panel(  )")
	if _fbId ~= 0 and _fbId ~= 1 then
		--显示统计结果面板
		if _fbId == 59 or _fbId == 999 or _fbId == 69 then
			--fbId59,阵营战，轮空处理
			--fbId999,天元之战 轮空处理
			--fbid69 , 八卦地宫
		else
			local cfb = FubenCenterModel:get_current_fb_id( );
			if cfb ~= _fbId or _fbId == 7 then
				--只有当前的副本id和场景管理器里的副本id不一致，才是正在推出了副本
				--但 _fbid77（仙宗领地）特殊，里面有个蟠桃盛宴活动结束时并没有退出副本，但又需要立即显示出结果
				FubenTongjiModel:show_tongji_result( );
			end
		end

		if _fbId == 11 then
			--诛仙阵副本，退出时一律先销毁倒计时
			local win = UIManager:find_window("menus_panel");
			win:destroy_fuben_countdown();
		end

		if FubenCenterModel:get_current_fb_id( ) ~= _fbId or _fbId == 7 then
			print("-------退出副本，关闭副本统计");
			--通知第三方退出副本
			FubenCenterModel:did_exit_fuben(_fbId);
			--重置数据
			_fbId=0;
			_actId=0;
			_data=nil;
			MiniTaskPanel:get_miniTaskPanel():remove_tongji_panel( )
			-- MiniTaskPanel:do_tab_button_method(index)
		end
	end
end

-- 服务发送过来增加蟠桃采集次数需要的元宝数
function FubenTongjiModel:do_add_gather_count( yuanbao )
	print("下发 增加蟠桃采集次数需要的元宝数",yuanbao);
	_yuanbao_for_add_gather = yuanbao;
	MiniTaskPanel:update_special_status( _fbId,_yuanbao_for_add_gather,0 )
end

-- 服务发送过来必杀技副本的经验值
function FubenTongjiModel:do_bishaji_fuben_exp( exp )
	MiniTaskPanel:update_special_status( _fbId,exp,0 )
end

-- 发送 增加蟠桃采集次数 的请求
function FubenTongjiModel:req_add_gather_count( )
	-- local player = EntityManager:get_player_avatar();
	-- if player.yuanbao < _yuanbao_for_add_gather then
	-- 	-- GlobalFunc:create_screen_notic( "元宝不足" );
	-- 	local function confirm2_func()
 --            GlobalFunc:chong_zhi_enter_fun()
 --            --UIManager:show_window( "chong_zhi_win" )
 --    	end
 --    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
	-- else 
	-- 	MiscCC:req_add_gather_pink_count();
	-- end
	local price = _yuanbao_for_add_gather
	local money_type = MallModel:get_only_use_yb() and 3 or 2
	local param = {money_type}
	local add_func = function( param )
		MiscCC:req_add_gather_pink_count(param[1])
	end
	MallModel:handle_auto_buy( price, add_func, param )
end
-- 获取增加蟠桃采集次数需要的元宝数
function FubenTongjiModel:get_add_gather_yb(  )
	return _yuanbao_for_add_gather;
end




-- 请求下发天元之战的统计数据

function FubenTongjiModel:req_tianyuan_battle_tongji(  )
	require "control/MiscCC"
	MiscCC:req_tianyuan_battle_tongji( )
end
