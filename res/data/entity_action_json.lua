--实体动作josn配置表
--create by tjh on 2015-5-6

entity_action = {}

entity_action.res = {
	XianNv="",				-- 护送仙女里面的仙女
	PlayerPet="",				-- 玩家的宠物
	PlayerAvatar="animations/playeravatar/",			-- 主玩家
	Avatar="animations/playeravatar/",					-- 玩家
	Monster="animations/monster/",						-- 怪物
	NPC = "animations/npc/",							-- npc
	"MovingNPC",					-- 巡逻的npc
	"Pet",							-- 宠物
	-- 非生物
	"Totem",						-- 图腾
	"Mine",							-- 矿物，采集对象
	"Defender",						-- 防御措施
	--"Monster",
	"Plant",						-- 植物，采集对象
	-- 特效类
	"Teleport",						-- 传送门
	"Building",						-- 建筑
	"Effect",						-- 特效
	-- 其他
	"Collectable",					-- 采集怪
	"DisplayMonster",				-- 显示怪，如炸药包
	"",--/** 14-人形怪 **/
	"",	--/** 15-分身宠物 **/
	-- 拾取物品
	"DropItem",				-- 拾取物品
}

--人物配置要是一个文件
entity_action.Avatar = "animations/playeravatar/action.josn"
entity_action.PlayerAvatar =  entity_action.Avatar

--npc动作配置
entity_action.NPC = [[
    {
      "actions": {
          "0": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 0, "end": 2 }
          }
        }
    }
]]

--怪物动作配置
entity_action.Monster= [[
    {
      "actions": {
          "0": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 0, "end": 2 }
          },
          "1": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 3, "end": 5 }
          },
          "2": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 6, "end": 8 }
          },
          "3": {
              "restoreOriginalFrame" : false,
              "loop" : 0,
              "delay" : 0.07,
              "frames": { "start": 9, "end": 12 }
          },
          "4": {
              "restoreOriginalFrame" : false,
              "loop" : 0,
              "delay" : 0.07,
              "frames": { "start": 13, "end": 16 }
          },
          "5": {
              "restoreOriginalFrame" : false,
              "loop" : 0,
              "delay" : 0.07,
              "frames": { "start": 17, "end": 20 }
          }
          ,
          "6": {
              "restoreOriginalFrame" : false,
              "loop" : 0,
              "delay" : 0.07,
              "frames": { "start": 21, "end": 24 }
          },
          "7": {
              "restoreOriginalFrame" : false,
              "loop" : 0,
              "delay" : 0.07,
              "frames": { "start": 25, "end": 28 }
          },
          "8": {
              "restoreOriginalFrame" : false,
              "loop" : 0,
              "delay" : 0.07,
              "frames": { "start": 29, "end": 32 }
          }
      }
    }
]]

