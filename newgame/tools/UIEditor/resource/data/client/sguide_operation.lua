
--新手引导中的操作某个按钮，响应映射表

sguide_auto_show_items = {
	["huoban"] = {
		[25101] = true,
		[25102] = true,
		[25103] = true,
		[25104] = true,
		[25105] = true,
		[25106] = true,
		[25107] = true,
		[25108] = true,
		[25109] = true,
		[25110] = true,
		[25111] = true,
		[25112] = true,
		[25113] = true,
		[25114] = true,
		[25115] = true,
		[25116] = true,
		[25117] = true,
		[25118] = true,
		[25119] = true,
		[25120] = true,
	},

	["zuoji"] = {
		[23101] = true,
		[23102] = true,
		[23103] = true,
		[23104] = true,
		[23105] = true,
	},

	["wujiang"] = {
		[30560] = true,
		[30561] = true,
		[30562] = true,
		[30563] = true,
		[30564] = true,
		[30565] = true,
		[30566] = true,
		[30567] = true,
		[30568] = true,
		[30569] = true,
		[30570] = true,
		[30571] = true,
		[30572] = true,
		[30573] = true,
		[30574] = true,
		[30575] = true,
		[30576] = true,
		[30577] = true,
		[30578] = true,
		[30579] = true,
		[30580] = true,
		[30581] = true,
		[30582] = true,
		[30583] = true,
		[30584] = true,
		[30585] = true,
		[30586] = true,
		[30587] = true,
	},
}


--
sguide_win_map ={
	[1] = "vip_card_win",  --vip体验卡
	[2] = "sactivity_win",  -- 玩法
	[3] = "task_win",			-- 日常
	[4] = "zhuzhao_win",		-- 铸造
	[5] = "spartner_win",		-- 伙伴
	[6] = "chiYing_win",	-- 剧情
	[7] = "right_top_panel",   -- 主界面右上角的那个面板

	[8] = "guild_win", 	 	-- 世族
	[9] = "contact_win", 	-- 好友页面
	[10] = "get_red_pot_win", -- 红包系统
	[11] = "mall_win",		-- 商城系统
	[12] = "shop_win",		-- 背包商店
	[13] = "zhuzhao_win",	-- 铸造
	-- [14] = "",		
}

weak_guide_type = {}

weak_guide_type.accept_task = 1

weak_release_map = {
	--关闭 聚宝盆
	[1] = {
		[weak_guide_type.accept_task] = {
			[5148] = true,
		},
	},

	--关闭整个 RightTopPanel
	[2] = {
		[weak_guide_type.accept_task] = {
			[5148] = true,
		},
	},

	--关闭 铸造界面
	[3] = {
		[weak_guide_type.accept_task] = {
			[5149] = true,
		},
	},
}

-- win
-- 外设变量 node, 
-- weak_guide_node_map的key的值为 弱引用 表~！！！！
weak_guide_node_map ={

	

	["101"] = {},  --铸造界面基础节点
	["100"] = {},  --镶嵌分页基础节点
	["200"] = {},   --洗练分页基础节点

	-- ["300"] = {},  --玩法 副本分页基础节点
	-- ["400"] = {},  --玩法 通缉分页基础节点
	-- ["600"] = {},  --玩法 活动分页基础节点
	-- ["700"] = {},  --玩法 活动 演武场 基础节点
	-- ["800"] = {},  --玩法 活动 武力试炼 基础节点

	-- ["500"] = {},  -- 日常 悬赏分页基础节点


	["900"] = {},  -- 主界面右上角的那个面板 基础节点
	["1000"] = {},  -- 主界面右上角的那个面板 箭头基础节点
	["2000"] = {},  -- 聚宝盆基础节点
}

-- sguide_operation_map 弱引用 表~！！！！key>0弱引用 <0非弱引用，fini也不会置空它
sguide_operation_map = {
	[11] = {},  -- 主界面人物头像

	[1101] = {},  -- 技能图标按钮
	[110101] = {},  -- 技能面板升级按钮

	[1102] = {},   --角色按钮
	[110201] = {},  --称号按钮

	[1103] = {}, --伙伴按钮
	[110301] = {}, --伙伴 属性分页
	[11030101] = {}, --伙伴 属性分页 培养按钮
	[110302] = {},  --伙伴 加成分页 培养按钮


	[1104] = {}, --好友按钮
	[110401] = {}, --推荐好友按钮

	[1105] = {}, --铸造按钮
	[110501] = {}, --装备栏里的第一个装备
	[110502] = {}, -- 进阶分页
	[110503] = {}, -- 洗练分页
	[110504] = {}, -- 神铸分页
	[110505] = {}, -- 镶嵌分页  --少了一个镶嵌分页，可看引导任务5146

	[1106] = {}, --坐骑按钮
	[110601] = {}, --坐骑 培养分页
	[11060101] = {}, --坐骑 培养按钮
	[11060102] = {}, --坐骑 骑乘按钮
	

	[1107] = {}, --翅膀按钮

	[1108] = {},  -- 琴棋书画
	[110801] = {}, -- 琴

	[1109] = {},  -- 世族按钮

	[1110] = {},   --武将按钮 --差一个武将,看36级

	--要加武将图鉴的按钮
-----------------------------------
	
	[12] = {},   -- 主界面《 按钮



	[1202] = {},  -- 寻宝
	[120201] = {}, --寻宝天级抽奖
	[120202] = {}, --寻宝天级抽奖 抽一次
	[120203] = {}, --寻宝抽奖后的 确定

	[1203] = {},  -- 聚宝盆按钮

	[1204] = {}, -- 赤影传说
	--[120401] = {}, --剧情标签
	[12040101] = {}, -- 赤影传说 第一章
	[12040102] = {}, -- 赤影传说 第一章 第一节
	[12040103] = {},  -- 精英/普通按钮  --少了剧情副本的精英页签的id和一系列操作的id，可看引导任务5147
	
	[120402] = {}, -- 星图标签
	

	

-----------------------------------------
	[13] = {},  -- 主界面其它图标 虚设的不要拿来用
	
	[1303] = {},  -- 奖励
	--[130301] = {}, -- 每日签到

	[1301] = {},  -- 玩法按钮
	[130101] = {},  -- 玩法 活动标签
	[13010101] = {},  -- 玩法 活动 第一个活动
	[13010102] = {},  -- 玩法 活动 第二个活动 好像暂时用不到

	[130102] = {},  -- 玩法 副本标签
	[13010201] = {}, -- 玩法 副本 第一个 --缺一个神驹猎狩的id，可参考引导任务5141
	[13010202] = {}, -- 玩法 副本 第二个

	[130103] = {},  -- 玩法异兽标签



	[1302] = {},   -- 日常按钮  --差一个日常，加一个id即可，可看22级引导
 	[130201] = {},   -- 日常-悬赏标签  --差一个悬赏任务页签的id，可看接受任务68

 	[1304] = {},   -- 主界面 聊天按钮

---------------------------------------------------------------
	[14] = {},   --主界面 展开活动按钮



-------------------------------------
--强制调用 模式  该模式为 小于0的key，且不参与弱引用设置


	--打开赤影传说第一章第一节
	[-1] = {touch_func = function ()
				local win = UIManager:show_window("chiYing_win")
		        if win then
		        	win.all_page[1]:updateChapter()
		        	win.all_page[1]:updateHuiBtn(1)
		            win.all_page[1]:move_auto(1, 1, true)
		        end
			end
	},
}

xpcall(function () 
		for k,v in pairs (sguide_operation_map) do
			if k > 0 then
				setmetatable(v, {__mode = "v"})
			end
		end
	end,
	function (msg)
		__G__TRACKBACK__(msg)
	end
	)

xpcall(function () 
		for k,v in pairs (weak_guide_node_map) do
			 setmetatable(v, {__mode = "v"})
		end
	end,
	function (msg)
		__G__TRACKBACK__(msg)
	end
	)

sguide_operation = {}

sguide_operation.fini = function()
	for k,v in pairs (sguide_operation_map) do
		if k > 0 and v.touch_func then
			v.touch_func = nil
		end
	end

	for k,v in pairs(weak_guide_node_map) do
	 	if v.node then
	 		v.node = nil
	 	end
	 end
end

sguide_operation.register_weak_guide_node = function(tag, node)
	local data = sguide_operation.get_weak_guide_data_by_tag(tag)
	if data then
		data.node = node
	end
end

sguide_operation.get_weak_guide_data_by_tag = function(tag)
	return weak_guide_node_map[tag]
end


sguide_operation.register_touch_func = function (target_index, touch_func, obj)
	local target = sguide_operation_map[target_index]
	if target then
		if obj then
			target.touch_func = bind(touch_func, obj)
		else
			target.touch_func = touch_func
		end
	end
end

sguide_operation.do_touch_func = function (target_index, eventType,x,y)
	local target = sguide_operation_map[target_index or 0]
	if target then
		if target.touch_func then
			print ("执行该引导的操作回调 >>>", target_index)
			target.touch_func(eventType,x,y)
			return true
		else
			print ("该引导没有注册操作回调 !!!!>>", target_index)
			return false
			--return true --测试用，不穿透可以明显发现错误
		end
	else
		print ("没有这个引导操作配置 >>>>", target_index)
		return false
		--return true --测试用，不穿透可以明显发现错误
	end
end


sguide_operation.open_win = function (info)
	
	local map_id = info.win_map_id
	local win_page = info.win_page
	local page_index = info.page_index
	if map_id then
		local win_name = sguide_win_map[map_id]
		if win_name then
			local win = UIManager:show_window(win_name)
			-- printc("map_id..................", map_id, 14)
			if win then
				if map_id == 4 or map_id == 9 or map_id == 11 and win_page then
					-- win:charge_page(win_page)
					-- printc("做了change_page", win.charge_page, win.change_page,14)
					if win.charge_page then
						win:charge_page(win_page)
					else
						win:change_page(win_page)
					end
					if page_index and win.all_page[win_page] then
						win.all_page[win_page]:change_page(page_index)
					end

				end
			end
		end

	end
end