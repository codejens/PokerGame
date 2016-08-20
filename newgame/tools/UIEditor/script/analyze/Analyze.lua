-- Analyze.lua
-- created by aXing on 2013-3-19
-- 游戏调试统计信息类

-- 用于统计：
-- -- 网络流量

Analyze = {}

--------------------------------------
-- 网络流量统计
--------------------------------------

local _proto_map = {}		-- 网络统计结构

-- 记录网络包的大小
function Analyze:parse_proto( sys_id, func_id, size )
	if not size then
		return
	end
	local key = sys_id .. "," .. func_id
	if _proto_map[key] == nil then
		_proto_map[key] = {sys_id = sys_id, func_id = func_id, total_size = 0, times = 0}
	end

	local old = _proto_map[key]
	_proto_map[key].total_size 	= old.total_size + size
	_proto_map[key].times		= old.times + 1
end

-- 流量统计排序
local function compare_proto( a, b )
	if a.total_size > b.total_size then
		return true
	elseif a.total_size < b.total_size then
		return false
	else
		if a.times > b.times then
			return true
		else
			return false
		end
	end
	return true
end

-- 打印流量统计
function Analyze:print_proto(  )

	-- 先复制一份
	local temp = {}
	for k,v in pairs(_proto_map) do
		table.insert(temp,v)
	end

	table.sort(temp, compare_proto)
	print("----------------------------------------")
	print("--------------  流量统计  --------------")
	print(" sys  pid  times  average       total")
	for k,v in pairs(temp) do
		local total
		if v.total_size > 1024 * 1024 then
			total = v.total_size / 1024 / 1024 .. " mb"
		elseif v.total_size > 1024 then
			total = v.total_size / 1024 .. " kb"
		else
			total = v.total_size .. " b"
		end

		local s = string.format(" %3d  %3d  %5d    %.2f     %s\n", v.sys_id, v.func_id, v.times, (v.total_size / v.times), total)
		print(s)
		-- print(" " .. v.sys_id .. "  " .. v.func_id .. "  " .. v.total_size .. "  " .. v.times .. "  " .. (v.total_size / v.times))
	end
	print("----------------------------------------")
end

-- 保存流量统计文件
function Analyze:save_proto(  )
	
	-- 先复制一份
	local temp = {}
	for k,v in pairs(_proto_map) do
		table.insert(temp,v)
	end

	table.sort(temp, compare_proto)
	local total_size = 0		-- 总流量
	require "io"
	local f = io.open("./proto_analyze.txt", "w+")
	f:write(LangGameString[4]) -- [4]="--------------  流量统计  --------------\n"
	f:write(" sys  pid  times  average       total\n")
	for k,v in ipairs(temp) do
		local total
		if v.total_size > 1024 * 1024 then
			total = v.total_size / 1024 / 1024 .. " MB"
		elseif v.total_size > 1024 then
			total = v.total_size / 1024 .. " KB"
		else
			total = v.total_size .. " B"
		end
		total_size = total_size + v.total_size
		local s = string.format(" %3d  %3d  %5d    %.2f     %s\n", v.sys_id, v.func_id, v.times, (v.total_size / v.times), total)
		f:write(s)
	end
	f:write(LangGameString[5]) -- [5]="--------------  总流量  --------------\n"
	f:write("TOTAL:  ", total_size / 1024 / 1024, " MB\n")
	f:write("--------------------------------------\n")
	f:close()
end

-- 发送流量统计到BI服务器
function Analyze:BI_proto(  )
	
	if next(_proto_map) == nil then
		return
	end

	-- 先复制一份
	local temp = {}
	for k,v in pairs(_proto_map) do
		table.insert(temp,v)
	end
	table.sort(temp, compare_proto)
	
	BISystem:log_proto_analyze(temp)
	-- BI打点后把数据清空
	_proto_map = {}
end

--------------------------------------
-- end 网络流量统计
--------------------------------------

--------------------------------------
-- 用户习惯统计
--------------------------------------

-- 玩家操作摇杆的次数
local _control_joystick_times = 0

function Analyze:parse_jostick( )
	_control_joystick_times = _control_joystick_times + 1
end

-- 玩家点击场景进行移动的次数
local _click_scene_move_times = 0

function Analyze:parse_click_scene_move(  )
	_click_scene_move_times = _click_scene_move_times + 1
end

-- 玩家单击任务追踪面板，自动寻路的次数
local _click_task_track_move_times = 0

function Analyze:parse_click_task_track_move(  )
	_click_task_track_move_times = _click_task_track_move_times + 1
end

-- 玩家双击任务追踪面板，速传的次数
local _double_click_task_track_transport_times = 0

function Analyze:parse_double_click_task_track_transport(  )
	_double_click_task_track_transport_times = _double_click_task_track_transport_times + 1
end

-- 点击商城分页分析
local _mall_click_marks = {}
function Analyze:parse_click_mall( index )
	if _mall_click_marks[index] == nil then
		_mall_click_marks[index] = 0
	end

	_mall_click_marks[index] = _mall_click_marks[index] + 1
end

----------------------
----HJH 2013-10-11
---主界面BI打点
---1、主界面下方入口图标 区间1-20
---2、主界面技能 区间 30 - 50
---3、主界面右上角 区间 60 - 100
---4、主界面左上角 区间 110- 120
---5、 other 区间 130-?
Analyze.main_win_bi_info =
{
	[1] = { info = "bag" },			-- 商城
	[2] = { info = "pet" },			-- 炼器
	[3] = { info = "forge" },			-- 坐骑
	[4] = { info = "mount" },			-- 技能
	[5] = { info = "wing" },				-- 背包
	[6] = { info = "guild" }, 			-- 军团
	[7] = { info = "shop" },		-- 梦境
	[8] = { info = "friend" },			-- 好友
	[9] = { info = "skill" },				-- 宠物
	-- [10] = { info = "transform"},		-- 变身
	-- [9] = { info = "genius"},			-- 式神
	-- [11] = { info = "shop" },			-- 商城

	[31] = { info = "skill_btn" },		-- 技能按钮
	[32] = { info = "anger_btn" },		-- 怒气
	[33] = { info = "select_btn" },		-- 选取按钮

	[61] = { info = "map_btn" },		-- 地图
	[62] = { info = "other_menu_btn" }, -- 功能菜单
	[63] = { info = "grow_btn" },	-- 成长之路
	[64] = { info = "activity_btn" },		-- 活动按钮
	[65] = { info = "reward_btn" },	-- 奖励领取
	[66] = { info = "dreamland_btn" },		-- 梦境寻宝
	[67] = { info = "sclb_prict_btn"},  --首充礼包
	[68] = { info = "tzfl"},  			--投资返利
	[69] = { info = "gua_ji_btn" },		-- 挂机

	[81] = { info = "doufatai_price_btn"},	--斗法台排行奖励 
	[82] = { info = "xianzhun3"}, 		--仙尊三vip卡
	[85] = { info = "seven day award"}, --seven day award 
	[86] = { info = "daily_welfare"}, 	--每日福利
	[87] = { info = "luck_guest"}, 		--幸运猜猜
	[88] = { info = "ziyousaijiangli"}, --自由奖励
	[89] = { info = "blue_dialon"}, 	--蓝钻奖励
	[90] = { info = "jipinzhuangbei_btn"},  --极品装备

	[111] = { info = "play_icon" }, 	--玩家头像
	[112] = { info = "select_type" }, 	--状态切换
	[113] = { info = "pet_icon" },		--宠物头像
	[114] = { info = "vip_icon"},		-- VIP按钮（天降雄师项目此按钮不是玩家头像）

	[130] = { info = "task_run_left_btn" }, --任务向左移动按钮
	[131] = { info = "chat_btn" }, 		--聊天按钮
	[132] = { info = "menu_btn"},		--菜单按钮
	[133] = { info = "task_can_do"},	--任务可接按钮
	[135] = { info = "main_task_level_limit"}, --主线任务卡级
	[141] = { info = "daily_page_one" },	--日常活动第一页
	[142] = { info = "daily_page_two" },	
	[143] = { info = "daily_page_three" },
	[144] = { info = "daily_page_four" },
	[145] = { info = "daily_page_five" },

	-- 下面是关于支付和充值的记录
	[201] = { info = "vip_win_buy_btn"},	-- vip界面立即购买按钮和充值按钮合计
	[202] = { info = "sclb_buy_btn"},		-- 首充礼包快速充值按钮
	[211] = {info = "60_yuanbao"},			-- 下面是点击支付页面按钮的记录
	[212] = {info = "100_yuanbao"},
	[213] = {info = "300_yuanbao"},
	[214] = {info = "980_yuanbao"},
	[215] = {info = "1000_yuanbao"},
	[216] = {info = "1680_yuanbao"},
	[217] = {info = "3280_yuanbao"},
	[218] = {info = "5000_yuanbao"},
	[219] = {info = "6480_yuanbao"},
	[220] = {info = "20000_yuanbao"},

	-- 一些新手指引操作的打点
	[251] = {info = "mount_up_level"},	-- 坐骑升级
	[252] = {info = "request_qiandao"},	-- 签到
	[253] = {info = "request_exchange"},	-- 兑换按钮
	[254] = {info = "huguobang_btn"},	-- 护国榜按钮
	[255] = {info = "request_forge_strengthen"},	-- 炼器强化按钮
	[256] = {info = "request_tanbao_1"},	--梦境探宝1次按钮
	[257] = {info = "achieve_page_request_award"},	-- 成就页面请求领取奖励
	[258] = {info = "doufatai_btn"},	-- 斗法台按钮
	[259] = {info = "linggen_active_btn"},	-- 灵根系统激活按钮
	[260] = {info = "zhaocai_win"},	-- 进入黑市钱庄

	-- 前往副本统计
	[281] = {info = "goto_fb_lilian"},	-- 副本前往
	[282] = {info = "goto_fb_yijidangqian"},	-- 副本前往
	[283] = {info = "goto_fb_jiaowuchang"},	-- 副本前往
	[284] = {info = "goto_fb_jinkubaoxue"},	-- 副本前往
	[285] = {info = "goto_fb_huanglingmijing"},	-- 副本前往
	[286] = {info = "goto_fb_biyishuangfei"},	-- 副本前往
	[287] = {info = "goto_fb_poyuzhizhan"},	-- 副本前往
	[288] = {info = "goto_fb_juezhanyanmenguan"},	-- 副本前往
	[289] = {info = "goto_fb_matalianying"},	-- 副本前往
	[290] = {info = "goto_fb_mizongfota"},	-- 副本前往
}
-------------------
--主界面分析
local _main_menu_panel_info = {}
function Analyze:parse_click_main_menu_info(index)
	-- 预防一下
	if Analyze.main_win_bi_info[index] == nil or Analyze.main_win_bi_info[index].info == nil then
		return;
	end
	print("成功打点统计：",Analyze.main_win_bi_info[index].info)
	if _main_menu_panel_info[index] == nil then
		_main_menu_panel_info[index] = 0
	end
	_main_menu_panel_info[index] = _main_menu_panel_info[index] + 1	
end

-- -------------------
-- ----HJH 2013-10-11
-- ----主界面下方入口图标分析
-- -- 1 人物，2 背包，3技能 ，4 好友,  5宠物 ，6 坐骑，7炼器 ，8 仙宗，，9 梦境 10 商城
-- local _menu_panel_info = {}
-- function Analyze:parse_click_menu_panel_info(index)
-- 	if _menu_panel_info[index] == nil then
-- 		_menu_panel_info[index] = 0
-- 	end
-- 	_menu_panel_info[index] = _menu_panel_info[index] + 1
-- end

-------------------
----HJH 2013-10-11
-----功能菜单入口图标
local _menuspanelt_menus_panel_info = {}
function Analyze:parse_click_menuspanelt_menus_panel_info(menus_name)
	if _menuspanelt_menus_panel_info[menus_name] == nil then
		_menuspanelt_menus_panel_info[menus_name] = 0 
	end
	_menuspanelt_menus_panel_info[menus_name] = _menuspanelt_menus_panel_info[menus_name] + 1
end

-- -------------------
-- ----HJH 2013-10-11
-- ----主界技能栏图标分析
-- -- 1 技能 2怒气 3选取按钮
-- local _menu_panel_skill_info = {}
-- function Analyze:parse_click_menu_skill_panel_info(index)
-- 	if _menu_panel_skill_info[index] == nil then
-- 		_menu_panel_skill_info[index] = 0
-- 	end
-- 	_menu_panel_skill_info[index] = _menu_panel_skill_info[index] + 1
-- end

-------------------
----HJH 2013-10-11
----活动界面图标分析
-- 1 投资返利 2首充袍 3开服活动 4淘宝树活动 5消费礼包 6封测活动 10跑环 11强者之路 12至强伙伴 13至强法宝 18国庆活动 22强力来袭活动 
----这个应策划需求增加首次点击打开等级
----内容为times,level
Analyze.activity_win_bi_info = 
{
	[1]		= { info = "open_ser" },	-- 开服活动
	[2]		= { info = "renzhejijin" },	-- 忍者基金活动
	[998]	= { info = "weixin" },		-- 微信活动
	[999]	= { info = "jihuolibao" },	-- 激活礼包活动
	[10] = { info = "paohuan" },
	-- [11] = { info = "qiangzhezhilu" },
	-- [12] = { info = "zhiqianghuoban" },
	-- [13] = { info = "zhiqiangfabao" },
	-- [15] = { info = "zhongqiu"},
	-- [16] = { info = "luopan"},
	-- [18] = { info = "guoqing" },
	-- [19] = { info = "tzfl" },
	-- [20] = { info = "open_ser" },
	-- [22] = { info = "qianglilaixi" },
	-- [23] = { info = "shengdankuanghuan" },
	-- [25] = { info = "huanqingyuandan" },
	-- [26] = { info = "xianjieqiyuan" },
	-- [27] = { info = "xinnianhuodong" },
	-- [28] = { info = "yuanxiaohuodong" },
	-- [29] = { info = "hefuhuodong" },
	-- [30] = { info = "meirixiaofei" },
	-- [31] = { info = "qq_browser" },
	-- [33] = { info = "qingming" },
	-- [35] = { info = "jubaodai" },
	-- [999] = { info = "jihuolibao" },
}
local _activity_panel_info = {}
function Analyze:parse_click_acitvity_panel_info(index)
	if _activity_panel_info[index] == nil then
		local play = EntityManager:get_player_avatar()
		_activity_panel_info[index] = { times = 0, level = play.level }
	end
	_activity_panel_info[index].times = _activity_panel_info[index].times + 1
end

-- -------------------
-- ----HJH 2013-10-11
-- ----主界面-右上角的按钮图标分析
-- -- 1 功能菜单 2活动 3挂机 4小秘书 11,斗法台排行奖励 12,仙尊三vip卡 13,qqvip 14首充礼包
-- ----这个应策划需求增加首次点击打开等级
-- ----内容为times,level
-- local _righttop_panel_info = {}
-- function Analyze:parse_click_acitvity_panel_info(index)
-- 	if _righttop_panel_info[index] == nil then
-- 		local play = EntityManager:get_player_avatar()
-- 		_righttop_panel_info[index] = 0
-- 	end
-- 	_righttop_panel_info[index] = _righttop_panel_info[index] + 1
-- end


function Analyze:BI_user_habits(  )

	if _control_joystick_times ~= 0 or _click_scene_move_times ~= 0 or
		_click_task_track_move_times ~= 0 or _double_click_task_track_transport_times ~= 0 then

		BISystem:log_user_habits(_control_joystick_times,
								 _click_scene_move_times,
								 _click_task_track_move_times,
								 _double_click_task_track_transport_times)

		_control_joystick_times	= 0
		_click_scene_move_times	= 0
		_click_task_track_move_times = 0
		_double_click_task_track_transport_times = 0

	end

	if next(_mall_click_marks) ~= nil then
		BISystem:log_mall_habits(_mall_click_marks)
		_mall_click_marks = {}
	end
	
	if next(_main_menu_panel_info) ~= nil then
		BISystem:menu_panel_habits(_main_menu_panel_info)
		_main_menu_panel_info = {}
	end

	if next(_menuspanelt_menus_panel_info) ~= nil then
		BISystem:menupanelt_panel_habits(_menuspanelt_menus_panel_info)
		_menuspanelt_menus_panel_info = {}
	end

	if next(_activity_panel_info) ~= nil then
		BISystem:acitivity_panel_habits(_activity_panel_info)
		_activity_panel_info = {}
	end

end

--------------------------------------
-- end 用户习惯统计
--------------------------------------


-- 最后写分析模块的析构函数
function Analyze:fini( )
	Analyze:BI_proto()
	Analyze:BI_user_habits()
end
