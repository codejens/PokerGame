----HJH
----2013-7-25
----
-- 仙宗神兽
--------------------------------------
super_class.GuildAltarEggPageInfo()
--------------------------------------
function GuildAltarEggPageInfo:__init()
	self.gem_index = 0
	self.cur_process = 0
	self.my_touch_num = 0
	self.touch_num = 0
	self.altar_info = {}
	self.last_scroll_refresh_time = 0
	self.max_scroll_refresh_rate = 20
	self.last_altar_info_refresh_time = 0
	self.max_altar_info_refresh_rate = 30 * 60
	self.is_request_altar_info = false
end
--------------------------------------
super_class.GuildAltarPageInfo()
--------------------------------------
function GuildAltarPageInfo:__init()
	self.pet_level = 0
	self.pet_exp = 0
	self.xian_guo_num = 0
	self.find_xian_guo_num = 0
	self.altar_info = {}
	self.last_scroll_refresh_time = 0
	self.max_scroll_refresh_rate = 20
	self.last_altar_info_refresh_time = 0
	self.max_altar_info_refresh_rate = 30 * 60
	self.is_request_altar_info = false
end
--------------------------------------
super_class.GuildAltarInfo()
--------------------------------------
function GuildAltarInfo:__init(pack)
	self.time = pack:readUInt()
	self.event_type = pack:readByte() 	---事件类型 unsigned char 0表示抚摸，1表示献果
	self.other_one = pack:readInt() 	---参数1 int 如果是抚摸,表示获得的经验  如果是献果,表示获得的声望
	self.other_two = pack:readInt() 	---参数2 int 如果是抚摸,表示获得的仙币  如果是献果,表示获得的经验
	self.name = pack:readString()
end
--------------------------------------
super_class.GuildEventInfo()
--------------------------------------
function GuildEventInfo:__init(pack)
	self.time = pack:readUInt()		--时间 unsigned int
	self.event_type = pack:readByte()	--事件类型 unsigned char 从0开始表示任命，罢免，加入仙宗，踢出仙宗，退出仙宗，捐献，存入仙宗仓库，从仙宗仓库取出，升级建筑，天元之战获得灵石，福地之战获得灵石
	self.other_one = pack:readInt()
	self.other_two = pack:readInt()
	self.other_three = pack:readInt()
	self.player_name_one = pack:readString()
	self.player_name_two = pack:readString()
end
--------------------------------------
super_class.GuildTianyuanRankInfo()
--------------------------------------
function GuildTianyuanRankInfo:__init(pack)
	self.name = pack:readString()	-- 玩家名字
	self.id = pack:readInt()		-- 玩家ID
	self.rank = pack:readInt()		-- 活动排名
	self.point = pack:readInt()		-- 本周积分
	self.count = pack:readInt()		-- 参加次数
	self.time = pack:readInt()		-- 上次参与时间
end