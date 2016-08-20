-- DujieModel.lua
-- created by fjh on 2013-2-2
-- 渡劫数据模型

-- super_class.DujieModel()

DujieModel = {}

-- 最大层数
local FLOOR_MAX = 45

local jingjie_table = {LangModelString[63],LangModelString[64],LangModelString[65],LangModelString[66],LangModelString[67],LangModelString[68],LangModelString[69],LangModelString[70],LangModelString[71], -- [63]="炼气一阶" -- [64]="炼气二阶" -- [65]="炼气三阶" -- [66]="炼气四阶" -- [67]="炼气五阶" -- [68]="炼气六阶" -- [69]="炼气七阶" -- [70]="炼气八阶" -- [71]="炼气九阶"
						LangModelString[72],LangModelString[73],LangModelString[74],LangModelString[75],LangModelString[76],LangModelString[77],LangModelString[78],LangModelString[79],LangModelString[80], -- [72]="筑基一阶" -- [73]="筑基二阶" -- [74]="筑基三阶" -- [75]="筑基四阶" -- [76]="筑基五阶" -- [77]="筑基六阶" -- [78]="筑基七阶" -- [79]="筑基八阶" -- [80]="筑基九阶"
						LangModelString[81],LangModelString[82],LangModelString[83],LangModelString[84],LangModelString[85],LangModelString[86],LangModelString[87],LangModelString[88],LangModelString[89], -- [81]="结丹一阶" -- [82]="结丹二阶" -- [83]="结丹三阶" -- [84]="结丹四阶" -- [85]="结丹五阶" -- [86]="结丹六阶" -- [87]="结丹七阶" -- [88]="结丹八阶" -- [89]="结丹九阶"
						LangModelString[90],LangModelString[91],LangModelString[92],LangModelString[93],LangModelString[94],LangModelString[95],LangModelString[96],LangModelString[97],LangModelString[98], -- [90]="元婴一阶" -- [91]="元婴二阶" -- [92]="元婴三阶" -- [93]="元婴四阶" -- [94]="元婴五阶" -- [95]="元婴六阶" -- [96]="元婴七阶" -- [97]="元婴八阶" -- [98]="元婴九阶"
						LangModelString[99],LangModelString[100],LangModelString[101],LangModelString[102],LangModelString[103],LangModelString[104],LangModelString[105],LangModelString[106],LangModelString[107], -- [99]="化神一阶" -- [100]="化神二阶" -- [101]="化神三阶" -- [102]="化神四阶" -- [103]="化神五阶" -- [104]="化神六阶" -- [105]="化神七阶" -- [106]="化神八阶" -- [107]="化神九阶"
						};
--境界标题
local jingjie_title_img = {
	[1] = { img = UILH_HUGUO.post_1, w=59,  h=26 },
	[2] = { img = UILH_HUGUO.post_2, w=59,  h=26 },
	[3] = { img = UILH_HUGUO.post_3, w=59,  h=26 },
	[4] = { img = UILH_HUGUO.post_4, w=59,  h=26 },
	[5] = { img = UILH_HUGUO.post_5, w=113, h=26 },
	[6] = { img = UILH_HUGUO.post_6, w=141, h=26 },
	[7] = { img = UILH_HUGUO.post_7, w=141, h=26 },
	[8] = { img = UILH_HUGUO.post_8, w=87,  h=26 },
	[9] = { img = UILH_HUGUO.post_9, w=87,  h=26 },
};

local jingjie_title_txt = Lang.huguo[1]
--boss图片
-- local jingjie_boss_img = {
-- UIResourcePath.FileLocate.duJie .. "dujie_boss1.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss2.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss3.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss4.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss5.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss6.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss7.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss8.png",
-- UIResourcePath.FileLocate.duJie .. "dujie_boss9.png"};
local dujie_info = nil;			--渡劫的数据
local yuanbao_info = nil;		--渡劫元宝获取状态的数据

local dujie_doing_index = 0;	--当前正在渡劫的index

-- added by aXing on 2013-5-25
function DujieModel:fini( ... )
	dujie_info = nil;	
	dujie_doing_index = 0;
end

------------------游戏业务逻辑
--获取当前的境界标题(img图片路径)
function DujieModel:get_current_jingjie_title( page )
	-- local path = nil
	-- local image = nil

	if dujie_info ~= nil then
		local grade = math.ceil(page/9) - 1
		local pin = 10 - (page-grade*9)

		local path  = string.format("ui/lh_title/%d/%05d.png", grade+1, grade+1)
		local image = CCZXImage:imageWithFile( -18, -15, -1, -1, path )

		-- title
		path  = string.format("ui/lh_title/%d/title.png", grade+1)
		local image_title = CCZXImage:imageWithFile( 65, 10, -1, -1, path )
		image_title:setScale(1.2)
		image:addChild(image_title)
		-- n品
		path  = string.format("ui/lh_title/%d/%d.png", grade+1, pin)
		local image_pin = CCZXImage:imageWithFile( 67, 22, -1, -1, path )
		image_pin:setScale(1.2)
		image_pin:setAnchorPoint(1, 0.5);
		image:addChild(image_pin)

		return image
	-- 	return jingjie_title_img[page];
	end
end

--获取当前的境界标题(txt文字title)
function DujieModel:get_cur_jingjie_title_txt( page )
	if dujie_info ~= nil then
		return jingjie_title_img[page];
	end
end

--获取boss图片
function DujieModel:get_boss_img( index )
	return "ui/lh_huguo/boss" ..tostring(index).. ".png"
end
--获取当前的境界名字
function DujieModel:get_current_jingjie_name( )
	if dujie_info ~= nil then
		local count = #dujie_info;
		return jingjie_table[count+1];
	end
	return "";
end
-- 获取当前境界的index
function DujieModel:get_current_jingjie_index( )
	if dujie_info ~= nil then
		local count = #dujie_info;
		return count+1;
	end
	return 0;
end
function DujieModel:get_floor_max( )
	return FLOOR_MAX
end
-- 设置渡劫信息
function DujieModel:set_dujie_info( dj_data,yb_data )
	dujie_info = dj_data;
	yuanbao_info=yb_data;
end

-- 获取渡劫信息
function DujieModel:get_dujie_info( )
	return dujie_info;
end

-- 获取渡劫信息
function DujieModel:get_yb_info( )
	return yuanbao_info;
end

-- 获取当前境界应得的属性奖励
function DujieModel:get_attri_reward_by_index( index )
	local dujie_config = DjConfig:get_dj_config_by_index(index);
	
	local attri_type = staticAttriTypeList[dujie_config.propertyId];
	return attri_type,dujie_config.propertyValue;
end

-- 进入了渡劫场景的回调
function DujieModel:did_enter_dujie_scene(  )
	UIManager:hide_window("dujie_win");		
	

	local player = EntityManager:get_player_avatar();
	if player then
		print("进入了渡劫场景的回调");	
		player:change_avatar_dir_right();
	end

	-- 进入了渡劫场景要随即播放打雷特效
    --LuaEffectManager:play_thunder_effect( );

end

------------------接口请求逻辑
function DujieModel:request_dujie_info( )
	
	MiscCC:request_dujie_info()
end
-- 更新渡劫信息
function DujieModel:update_dujie_info( dujie_info,yb_info )
	DujieModel:set_dujie_info(dujie_info,yb_info);
	
	local win = UIManager:find_visible_window("dujie_win");
	print("------win: dujie ", win)
	if win ~= nil then
		win:update();
	end
end


--进入渡劫的某个副本
function DujieModel:enter_dujie_fuben( index )
	local need_level = DjConfig:get_dj_config_by_index( index ).level;
	local cur_level = EntityManager:get_player_avatar().level;
	
	if cur_level >= need_level then
		if index > 0 then
			dujie_doing_index = index;
			MiscCC:request_enter_dujie(index);
		end
	else 
		GlobalFunc:create_screen_notic( LangModelString[108]..need_level..LangModelString[109] ); -- [108]="进入该阶副本需要" -- [109]="级"
	end

end

-- 渡劫成功后的结果
function DujieModel:dujie_succss_callback( jingji,star,frist_dujie )
	print("DujieModel:dujie_succss_callback jingji,star,frist_dujie",jingji,star,frist_dujie)
	dujie_doing_index = 0;
	local win = UIManager:show_window("dujie_result_win");
    win:create_succss_panel(star,jingji,frist_dujie);

end

-- 渡劫失败的回调
function DujieModel:dujie_fail_callback( )
	local win = UIManager:show_window("dujie_result_win");
    win:create_fail_panel();
end

-- 退出渡劫
function DujieModel:exit_dujie( )
	MiscCC:request_exit_dujie();
	-- 退出渡劫场景要停止打雷特效
	--LuaEffectManager:stop_thunder_effect()
end
-- 再次渡劫
function DujieModel:dujie_again( )
	DujieModel:enter_dujie_fuben( dujie_doing_index );
end

-- 分享渡劫成就
function DujieModel:share_dujie_achievement( jingjie )
	print("分享渡劫成就")
	
	if PlatformInterface.share then
		-- 如果有分享接口
		local table = ShareConfig:get_achieve_table_by_sysid( 9 );
		local config = ShareConfig:get_achieve_config_by_sysid( 9 );

		local achieve = string.format(table.achieve, jingjie_table[jingjie]);
		local desc = string.gsub( config.desc, "achieve", achieve )

		local title = string.gsub( config.title, "title", table.title );

		-- print( "share 字段", desc, title );

		local share_info = { title = title, desc = desc, imgUrl = table.img_url };
		PlatformInterface:share(share_info)
	end

end


-- 获取渡劫奖励元宝
function DujieModel:fetch_dujie_yb( dujie_index )
	MiscCC:fetch_dujie_yb( dujie_index )
end