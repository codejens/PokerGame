fuben_dialog = 
{
	-- 副本id
	[8] = {
		[1] = {
			talk = "今日羽山好热闹啊……",
			face = 7,
			name = "箴机奇图|执事",
			dir = -1,
		},
	},
	-- 副本id
	[13] = {
		[1] = {
			talk = "轩辕封印已破，妖魔横行，生灵涂炭，斩魔最众者，可掌轩辕！活动于每周日 20:00-20:30 举行。",
			face = 7,
			name = "梓元",
			dir = -1,
		},
	},
}

-- add by chj @2016-1-10
-- 副本id对应的npc名字
-- 根据副本id在此处转化为npc名字,在有名字在std_scene获取到npcid
-- 转化为npcid是为了和任务对话的接口一致(副本npc和人物发送的字符串数据是不一样的)
-- 最后的目的是，为了策划配置同一份配置表 normal_talk_dialog
-- 然后上面的 fuben_dialog就没用了.当然使用上面的配置表，fbto_npcid就没用了,策划需要维护上面的对话内容(fuben_dialog)
