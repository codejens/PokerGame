--
-- 剧情动画配置文件
--	
-- entity_body_id:实体模型id(怪物id) ex:蚩尤,33,
-- entity_name:实体名字
-- pos_x,pos_y:实体对应玩家的位置  注意pos_y的坐标是上面是0，下面是480
-- dir:实体朝向 1向右 6向左
-- action_type : 1,对话2,实体移动3,创建实体4,屏幕变黑5,删除实体,6,黑屏幕上显示文字,
--               7,实体身上添加特效 8泡泡框 9实体执行动作(0倒地1攻击2跳) 10 实体瞬移
--				 11,显示关闭剧情对话框 12,移动镜头 13,屏幕中间出现字 ,14 必杀技背景
-- entity_face_id: -1 萱儿,0 玩家
-- jq_str:动作1的对话内容
-- move_x:动作2 x轴移动像素值

jqdh = {
	-- 1 万剑愁
	[1] = {
		-- 创建实体
		entity = { 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb一梦千年，沧海桑田。咦，轩辕之息？#c00FF00萱儿#c71cecb好喜欢^_^！"},
			{ action_type = 1 , entity_face_id = 0, jq_str = "#c71cecb你……你是谁？"},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb我是#c00FF00萱儿#c71cecb呀！——不好，竟让炎魔开启封印释放出上古魔族！#c00FF00@player#c71cecb，使用#c00FF00必杀技#c71cecb释放我的魂力诛杀魔族！"},
		},
	},
	-- 2 渡劫
	[2] = {
		-- 创建实体
		entity = { 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb凡人修仙到一定的境界，必得经历天劫，经历九九重劫，方能有机会化成真仙。#c00FF00@player#c71cecb，在这里我无法相助你，你好自为之，保重！"},
			{ action_type = 1 , entity_face_id = 0, jq_str = "#c00FF00萱儿#c71cecb无须担心，我定会渡劫归来！"},
		},
	},
	-- 3:封魔殿 蚩尤复苏
	[3] = {
		-- 创建实体
		entity = { 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			{ entity_body_id = 33,entity_name = "蚩尤残魂",pos_x = 700,pos_y = 240 ,dir = 6,entity_type = 1,entity_tag = 1}, 
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb好浓郁的混沌魔气，这是……蚩尤之息？！"},
			{ action_type = 1 , entity_face_id = 2000, jq_str = "#c71cecb轩辕剑灵！！！——哈哈哈，你以为你能阻止得了我重返凡间吗？"},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb蚩尤，无论是上古，还是现在，老娘……咳咳，本姑娘都能斩杀你！"},
			{ action_type = 1 , entity_face_id = 2000, jq_str = "#c71cecb哼，多说无益，如今封魔殿里我的子民已全部复苏，看你如何平息他们的怒火！"},
			{ action_type = 2 , entity_tag = 1, move_x = 400},
		},
	},
	-- 4:蚩尤挂掉动画
	[4] = {
		-- 创建实体
		entity = { 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			{ entity_body_id = 33,entity_name = "蚩尤残魂",pos_x = 700,pos_y = 240 ,dir = 6,entity_type = 1,entity_tag = 1}, 
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},			
			{ action_type = 1 , entity_face_id = 2000, jq_str = "#c71cecb可恶，魂魄残缺，魔元不足，竟不是#c00FF00@player#c71cecb的对手！"},
			{ action_type = 1 , entity_face_id = 0, jq_str = "#c71cecb蚩尤，受死吧！"},
			{ action_type = 1 , entity_face_id = 2000, jq_str = "#c71cecb哼，轩辕剑灵你先别得意，本魔君会阻止你重铸，我若得魂身重聚，便是你魂飞魄散之时，那时，神州也会覆灭！哈哈哈……"},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb我如今没有轩辕剑体寄托，难以发挥出力量，阻止不了蚩尤残魂逃跑，之后他必定会阻止轩辕剑重铸，#c00FF00@player#c71cecb，我们须得赶紧返回天元城寻找芷云。"},
		},
	},
	-- 5:姥魔动画
	[5] = {
		-- 创建实体
		entity = { 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			{ entity_body_id = 5030,entity_name = "小倩",pos_x = 450,pos_y = 240 ,dir = 1,entity_type = 1,entity_tag=1}, 
			{ entity_body_id = 5029,entity_name = "采臣",pos_x = 400,pos_y = 190 ,dir = 1,entity_type = 1,entity_tag=2}, 
			{ entity_body_id = 9,entity_name = "赤霞",pos_x = 420,pos_y = 90 ,dir = 1,entity_type = 1,entity_tag=3}, 
			{ entity_body_id = 38,entity_name = "姥魔",pos_x = 650,pos_y = 140 ,dir = 6,entity_type = 1,entity_tag=4}, 
		},
		-- 动画的每一步
		step = {
					-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 13, jq_str = "#c71cecb姥姥，求求你放过我跟采臣好吗？"},
			{ action_type = 1 , entity_face_id = 2001, jq_str = "#c71cecb赤霞，你看到了没？你真是没用，自己守着的女人居然被这么一个迂腐的书生给拐了，哈哈哈，这比我亲手杀了你还解恨！" },
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb我感觉到了我的轩辕剑气息，在那个小倩身上。" },
			{ action_type = 1 , entity_face_id = 2001, jq_str = "#c71cecb哼，想打轩辕剑体的主意？我要将它献给复苏的蚩尤大人，谁想要的都得死！" },
			{ action_type = 2 , entity_tag = 4,move_x = 400},
			{ action_type = 1 , entity_face_id = 8, jq_str = "#c71cecb姥魔，你给我站住！！！" },
			{ action_type = 2 , entity_tag = 3,move_x = 500},
		},
	},
	-- 6 击杀姥魔后动画
	[6] = {
		-- 创建实体
		entity = { 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			{ entity_body_id = 5030,entity_name = "小倩",pos_x = 550,pos_y =  290,dir = 6,entity_type = 1,entity_tag=1}, 
			{ entity_body_id = 5029,entity_name = "采臣",pos_x = 600,pos_y =  140,dir = 6,entity_type = 1,entity_tag=2}, 
			{ entity_body_id = 9,entity_name = "赤霞",pos_x = 600,pos_y =  240,dir = 6,entity_type = 1,entity_tag=3}, 
			{ entity_body_id = 5000,entity_name = "轩辕剑",pos_x = 650,pos_y = 230 ,dir = 6,entity_type = 1,entity_tag=4}, 
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 8, jq_str = "#c71cecb此轩辕剑本是你们之物，如今算是物归原主，拿去吧，重铸轩辕剑，让九州早日脱离魔劫。"},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb轩辕剑离体，小倩的封印解除，会恢复之前的记忆，赤霞，那时你该如何面对？"},
			{ action_type = 1 , entity_face_id = 13, jq_str = "#c71cecb两个人的痛苦为何要你一个人承担，赤霞，我想起来了，我想起以前的一切了！"},
			{ action_type = 1 , entity_face_id = 8, jq_str = "#c71cecb曾经的一切，就随风去吧，此间事已了，就此别过！"},
			{ action_type = 2 , entity_tag = 3, move_x = 400},
			{ action_type = 1 , entity_face_id = 13, jq_str = "#c71cecb赤霞——"},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb问世间情是何物，反正跟我们无关，#c00FF00@player#c71cecb，我们也走吧。"},
		},
	},
	-- 7 灵根
	[7] = {
		-- 创建实体
		entity = { 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 1, jq_str = "#c71cecb灵根乃修仙者之根本，灵根开窍，修行便可一日千里，不过须得#c00ff00打坐#c71cecb吸纳大量的天地#c00ff00灵气#c71cecb方能激发灵根所蕴含的潜力。"},
			{ action_type = 1 , entity_face_id = 0, jq_str = "#c71cecb不知芷云姑娘所说的灵根该如何开窍？"},
			{ action_type = 1 , entity_face_id = 1, jq_str = "#c00ff00@player#c71cecb，如今你的修为已足够开启灵根，#c00ff00打开功能菜单界面#c71cecb，选择#c00ff00【灵根】#c71cecb，若打坐吸纳的天地灵气足够，便可激活灵根。"},
		},
	},
	-- 8 冰宫
	[8] = {
		-- 创建实体
		entity = {
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			-- 云霄
			{ entity_body_id = 47,entity_name = "云霄",pos_x = 650,pos_y =  290,dir = 6 ,entity_type = 1,entity_tag =1}, 
			-- 蝴蝶
			{ entity_body_id = 39,entity_name = "冰女",pos_x = 570,pos_y =  290,dir = 6 ,entity_type = 1,entity_tag =2},
			-- 万年冰魄
			{ entity_body_id = 18,entity_name = "万年冰魄",pos_x = 520,pos_y =  290,dir = 6 ,entity_type = 1,entity_tag =3},
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 2002, jq_str = "#c71cecb住手！！！我愿意交出万年寒魄，求求你别伤害云霄。"},
			{ action_type = 1 , entity_face_id = 8, jq_str = "#c71cecb冰儿，交出寒魄你会死的的！快回去，有我在，他们伤害不了你！"},
			{ action_type = 1 , entity_face_id = 0, jq_str = "#c71cecb云霄？！你就是失踪的云霄？！你师父张天师甚是想念你……"},
			{ action_type = 1 , entity_face_id = 8, jq_str = "#c71cecb师父……为何会这样？！冰儿如此善良，不曾害过一个人，没有了万年寒魄，她难以活命，你们为何如此苦苦相逼？！"},
			{ action_type = 1 , entity_face_id = 2002, jq_str = "#c71cecb就算他们不来取，也自有别人来取，这是宿命。既然如此，不如让他们取去，至少是为了苍生。"},
			{ action_type = 1 , entity_face_id = 8, jq_str = "#c71cecb罢了，你们走吧。冰儿，我会一直陪在你身边。麻烦你们告诉师父，就当云霄已死……"},
		},
	},
	-- 9 炎炉幻境
	[9] = {
		-- 创建实体
		entity = {
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			-- 炎帝怨念
			{ entity_body_id = 17,entity_name = "炎帝怨念",pos_x = 650,pos_y =  140,dir = 6 ,entity_type = 1,entity_tag = 1}, 
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 14, jq_str = "#c71cecb萱儿，我可怜的孩子，我最得意的杰作，是你吗？你终于回来了。"},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb炎父，是我，我好想你。"},
			{ action_type = 1 , entity_face_id = 14, jq_str = "#c71cecb哼，黄帝之息！萱儿，你还是选择跟他在一起，他害你还害的不够吗？"},
			{ action_type = 1 , entity_face_id = -1, jq_str = "#c71cecb或许，这一切都是宿命。"},
			{ action_type = 1 , entity_face_id = 14, jq_str = "#c71cecb宿命，又是该死的宿命，这冥冥天道到底是谁主宰？！也罢，蚩尤即将魂归，苍生为重，我便不计较，萱儿，若是他能经得起我的考验，我便重铸轩辕剑。"},
		},
	},
	-- 10 炎帝挂后
	[10] = {
		-- 创建实体
		entity = {
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			-- 轩辕剑
			{ entity_body_id = 14,entity_name = "轩辕剑",pos_x = 360,pos_y =  220,dir = 1 ,entity_type = 1,entity_tag = 1}, 
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 14, jq_str = "#c71cecb萱儿，很欣慰你变得比上古更加强大，也欣慰#c00FF00@player#c71cecb与他还是有所不同。我要走了，最后帮你重塑身体，但是仅仅如此还不够，你还需要千年之泪和黑龙之魂，方可完全复苏轩辕剑。"},
		},	
	},
	-- 11 南诏王
	[11] = {
		-- 创建实体
		entity = {
			-- -- 青儿
			-- [1] = { entity_body_id = 40,entity_name = "青儿",pos_x = -200,pos_y =  -50,dir = 1 ,entity_type = 2},
			-- -- 南诏王 
			-- [2] = { entity_body_id = 41,entity_name = "南诏王",pos_x = 20,pos_y =  -50,dir = 6 ,entity_type = 2}, 
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			-- -- 拜月
			{ entity_body_id = 42,entity_name = "拜月",pos_x = 500,pos_y =  190,dir = 6 ,entity_type = 2,entity_tag = 1}, 
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},			
			{ action_type = 1 , entity_face_id = 42, jq_str = "#c71cecb王上，妖女作乱起洪灾，你的子民流离失所，你都看见了吗？"},
			{ action_type = 1 , entity_face_id = 41, jq_str = "#c71cecb青儿，你能告诉我，这一切都是为什么吗？"},
			{ action_type = 1 , entity_face_id = 40, jq_str = "#c71cecb王上，我……"},
			{ action_type = 3 , entity_body_id = 39,entity_name = "素贞",pos_x = 250,pos_y =  190,dir = 1,entity_type = 2,entity_tag = 2},
			{ action_type = 1 , entity_face_id = 39,jq_str = "#c71cecb青儿，姐姐在此，无人能伤你！南诏王，你受拜月蛊惑，可知青儿并非蛇族，而是女娲后人？而拜月百般想置之死地是为了其身上的女娲神血？"},
			{ action_type = 1 , entity_face_id = 42,jq_str = "#c71cecb妖女，你休得胡言！"},
			{ action_type = 1 , entity_face_id = 39,jq_str = "#c71cecb哈哈哈，拜月，你机关算尽，可曾知道水灵珠乃女娲之物，虽可助你与水魔怪结合，却也因此将你的阴谋败露？"},
			{ action_type = 4 , show_type = 1},
			{ action_type = 6,jq_str = "素贞忽然诵念古怪的咒语，只见拜月的身体起了令人想不到的变化……" },
			{ action_type = 5 ,entity_tag = 1},
			-- 屏幕恢复
			{ action_type = 4, show_type = 2 },
			{ action_type = 3 ,entity_body_id = 64,entity_name = "水魔怪·拜月",pos_x = 500,pos_y =  290,dir = 6,entity_type = 1,entity_tag = 3},
			{ action_type = 1 ,entity_face_id = 39,jq_str = "#c71cecb拜月，你装啊，你继续装清高装世外高人啊？料不到这丑陋模样无法复原，是不是泪流满面？"},
			{ action_type = 1 ,entity_face_id = 42,jq_str = "#c71cecb啊！！！素贞、#c00FF00@player#c71cecb，你们竟坏我好事，待我与水神兽完全融合，必定让雷夏泽生灵尽灭！"},
		},			
	},
	-- 12 黑龙之魂
	[12] = {
		-- 创建实体
		entity = {
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0},
			-- 小龙女
			{ entity_body_id = 45,entity_name = "小龙女",pos_x = 600,pos_y =  210,dir = 1 ,entity_type = 2,entity_tag =1},
			-- 黑龙之魂 
			{ entity_body_id = 46,entity_name = "黑龙之魂",pos_x = 400,pos_y =  290,dir = 1 ,entity_type = 2,entity_tag =2}, 			
		},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},	
			{ action_type = 1 , entity_face_id = 45, jq_str = "#c71cecb你徘徊世间不肯飞升天阙，亦不肯返回祖庭，可曾知道，远古时你一怒乱翼州为的那个她如今在哪吗？"},			
			{ action_type = 1 , entity_face_id = 46, jq_str = "#c71cecb她?你有怜星的消息？快告诉我她在哪，否则即使同为龙族，也不会饶过你！"},
			{ action_type = 1 , entity_face_id = 45, jq_str = "#c71cecb她听闻你为了她祸乱翼州被女娲斩杀，便等待你的魂魄归去与她一起轮回，不料你却在徘徊世间寻她的转世，两两守望，真是冤孽！"},
			{ action_type = 1 , entity_face_id = 46, jq_str = "#c71cecb怜星，苦了你了！也罢，世间我已了无牵挂，我这道残魂便往那轮回台去了。"},
		},		
	},

----------------------------------------------------------------------------------------------------------
---------------从这里开始是新的新手指引流程---------------------------------------------------------------
	--13 出生副本1
	[13] = {
		-- 创建实体
		entity = {},
		-- 动画的每一步
		step = {
			-- 显示剧情框
			{ action_type = 11,show_type = 1,show_panel_type = 2,is_ani = false },
			-- 屏幕变暗
			{ action_type = 4, show_type = 1 },
			-- 显示文字
			{ action_type = 6, jq_str = "#cfff000天宇茫茫，愁涛惊天；仙魔两立天下寒，独决战千年。 #r#r#r#cfff000恒断擎天，魂殇漠影；万载姻缘轮回续，挥敬轩辕剑。" },
			-- 显示文字
			{ action_type = 6, jq_str = "#cfff000太古仙魔之战，共工倾倒不周山；混沌魔气入侵凡界，九黎魔君蚩尤为祸人间；黄帝集天下之气，铸轩辕剑，斩蚩尤于涿鹿之战，换来世间昌平安泰。千年之后，混沌魔气重现世间，而我们的故事亦从此开始……" },
		},
	},
	--14 出生副本2
	[14] = {
		-- 创建实体
		entity = {
			[1] = { entity_body_id = 19,entity_name = "天兵甲",pos_x = 400,pos_y = 240 ,dir = 1,entity_type = 1,entity_tag = 1}, 
			[2] = { entity_body_id = 19,entity_name = "天兵乙",pos_x = 450,pos_y = 290 ,dir = 6,entity_type = 1,entity_tag = 2}, 
			[3] = { entity_body_id = 19,entity_name = "天兵丙",pos_x = 450,pos_y = 190 ,dir = 6,entity_type = 1,entity_tag = 3}, 
		},
		-- 动画的每一步
		step = {
			-- 小兵聊天
			{ action_type = 8,entity_tag = 1,jq_str = "界王神大人让我兄弟三人守护此处，定要多加小心。" ,delay_time = 2 },
			{ action_type = 8,entity_tag = 2,jq_str = "大哥说的是，我等绝不能辜负界王神大人的信任。" ,delay_time = 2 },
			{ action_type = 8,entity_tag = 3,jq_str = "二位哥哥何须担心，就凭下界的渣滓，难道还能进我玉宫不成？" ,delay_time = 2 },
			{ action_type = 2,entity_tag = 1,move_x = -50,delay_time = 0.5 },
			{ action_type = 8,entity_tag = 1,jq_str = "谁，谁在那里？？" ,delay_time = 2 },
			-- 移动镜头
			{ action_type = 12,move_x = -200},
			-- 出现黑洞
			{ action_type = 7, pos_x = 100,pos_y = 240 ,effect_id = 9002 ,effect_type = 3 ,delay_time = 0.5},		
			-- 创建主角
			{ action_type = 3,entity_body_id = 0,entity_tag = 0,pos_x = 100,pos_y =  240,dir = 1,entity_type = 0,delay_time = 1},
			-- 主角跃向三个天兵
			{ action_type = 9,entity_tag = 0,action_id = 2,pos_x = 525,pos_y = 0,height = 200 ,delay_time = 0.2 ,jump_time = 0.5},
			-- -- 攻击
			-- { action_type = 9,entity_tag = 0,action_id = 1 },
			-- 播放特效
			{ action_type = 7, pos_x = 625,pos_y = 240 ,effect_id = 5301 ,effect_type = 3 ,delay_time = 0.5},		
			-- 3个小兵被击飞
			{ action_type = 9,entity_tag = 1,action_id = 2,pos_x = -100,pos_y = 0,height = 0 ,delay_time = 0,jump_time = 0.2 },
			{ action_type = 9,entity_tag = 2,action_id = 2,pos_x = 100,pos_y = 0,height = 0 ,delay_time = 0 ,jump_time = 0.2},
			{ action_type = 9,entity_tag = 3,action_id = 2,pos_x = 100,pos_y = 0,height = 0 ,delay_time = 0.5 ,jump_time = 0.2},
			{ action_type = 5,entity_tag = 1,die_type = 2,delay_time = 0},
			{ action_type = 5,entity_tag = 2,die_type = 2,delay_time = 0},
			{ action_type = 5,entity_tag = 3,die_type = 2,delay_time = 0.5},
			-- 主角泡泡字体
			{ action_type = 8,entity_tag = 0,jq_str = "就这点能耐！- -!!" ,delay_time = 2 },
			-- 屏幕中间显示字体
			{ action_type = 13,jq_str = "虚空中传来令人心悸的波动",delay_time = 2 },
			-- 显示剧情框
			{ action_type = 11,show_type = 1,show_panel_type = 2},
			-- 显示文字
			{ action_type = 1, entity_face_id = 2000, jq_str = "#c71cecb本王百余年一直在寻找汝等踪迹。" },
			-- 移动镜头
			{ action_type = 12,move_x = 200},
			-- 创建界王神
			{ action_type = 3,entity_body_id = 75,entity_tag = 4,entity_name = "界王神",pos_x = 600,pos_y = 240 ,dir = 6,entity_type = 1,delay_time = 1,create_type = 2},
			-- 显示文字
			{ action_type = 1, entity_face_id = 2000, jq_str = "#c71cecb没想到汝竟敢出现在本王面前，简直是自寻死路！" },
			-- 显示文字
			{ action_type = 1, entity_face_id = 0, jq_str = "#c71cecb废话少说，你这狗贼,你这人前正派慈悲的界王神，竟然想盗我师门至宝，呸，这次本大仙定要灭了你！" },
			-- 显示文字
			{ action_type = 1, entity_face_id = 2000, jq_str = "#c71cecb凡界渣滓，交出轩辕剑身，本王还能饶你一条生路！" },
			-- 显示文字
			{ action_type = 1, entity_face_id = 0, jq_str = "#c71cecb那就看看你有没有这个本事了！" },
			-- 显示文字
			{ action_type = 1, entity_face_id = 2000, jq_str = "#c71cecb大言不惭，汝等下界的渣滓，杀汝简直是脏了本王的手！天将，给本王出来，送这不知天高地厚的渣滓前往不归路！" },
			-- 显示文字
			{ action_type = 1, entity_face_id = 2001, jq_str = "#c71cecb是！" },
								
		},
	},

	-- 15出生副本3
	[15] = {
		-- 创建实体
		entity = {
			[1] = { entity_body_id = 75,entity_name = "界王神",pos_x = 600,pos_y = 240 ,dir = 6,entity_type = 1,entity_tag = 1}, 
		}, 
		-- 动画的每一步
		step = {
			-- 创建主角
			{ action_type = 3,entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0,delay_time = 1},
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 2000, jq_str = "#c71cecb凭这几招就想闯我玉宫？天真！众侍从，布下浑天阵！可不要让本王失望！"},											
			-- 创建4个天兵
			{ action_type = 3 ,entity_body_id = 19,entity_name = "天兵",pos_x = 200,pos_y = 320 ,dir = 1,entity_type = 1,entity_tag = 2}, 
			{ action_type = 3 ,entity_body_id = 19,entity_name = "天兵",pos_x = 200,pos_y = 160 ,dir = 1,entity_type = 1,entity_tag = 3}, 
			{ action_type = 3 ,entity_body_id = 19,entity_name = "天兵",pos_x = 600,pos_y = 320 ,dir = 6,entity_type = 1,entity_tag = 4}, 			
			{ action_type = 3 ,entity_body_id = 19,entity_name = "天兵",pos_x = 600,pos_y = 160 ,dir = 6,entity_type = 1,entity_tag = 5}, 					
			{ action_type = 1 ,entity_face_id = 2001, jq_str = "#c71cecb受死吧！"},											
			{ action_type = 1 ,entity_face_id = 0, jq_str = "#c71cecb老虎不发猫，你当我病危啊！给你们点厉害瞧瞧！！看我必杀技!"},											
		},
	},
	-- 16 出生副本4
	[16] = {
		-- 创建实体
		entity = {
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0,delay_time = 1},
		}, 
		-- 动画的每一步
		step = {
			-- 主角先移动
			-- { action_type = 2 , entity_tag = 0, move_x = 250,delay_time = 2 },	
			-- 移动镜头
			-- { action_type = 12,move_x = 200},
			-- 创建界王神
			{ entity_body_id = 75,entity_name = "界王神",pos_x = 600,pos_y = 240 ,dir = 6,entity_type = 1,entity_tag = 1}, 								
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			{ action_type = 1 , entity_face_id = 2000, jq_str = "#c71cecb不曾想到汝竟能杀吾天兵天将。"},						
			{ action_type = 1 , entity_face_id = 0, jq_str = "#c71cecb就这些小喽啰，那还不够看！"},				
			{ action_type = 1 , entity_face_id = 2000, jq_str = "#c71cecb哼！不知死活！看来还得吾亲自动手毁灭你！"},			
		},
	},
	-- 17 出生副本5
	[17] = {
		-- 创建实体
		entity = {
			{ entity_body_id = 0,entity_tag = 0,pos_x = 400,pos_y =  240,dir = 1,entity_type = 0,delay_time = 1},
			{ entity_body_id = 75,entity_name = "界王神",pos_x = 600,pos_y = 240 ,dir = 6,entity_type = 1,entity_tag = 1}, 
		}, 
		-- 动画的每一步
		step = {
			-- boss 添加金光特效
			{ action_type = 7, entity_tag = 1, effect_id = 9003,effect_type = 2 ,delay_time = 0},
			-- 界王泡泡框文字
			{ action_type = 8 , entity_tag = 1,jq_str = "哼哼哼！看本王天雷！" ,delay_time = 2},					
			-- 添加场景特效闪电			
			{ action_type = 7 , pos_x = 400,pos_y = 240 , effect_id = 3501 ,effect_type = 3 },				
			-- 主角往后瞬移,躲避闪电
			{ action_type = 10 , entity_tag = 0, move_x = -70 ,delay_time = 1.5,need_shadow = 1},	
			-- 添加场景特效闪电			
			{ action_type = 7 , pos_x = 330,pos_y = 240 , effect_id = 3501 ,effect_type = 3 },				
			-- 主角往后瞬移,躲避闪电
			{ action_type = 10 , entity_tag = 0, move_x = -70 ,delay_time = 1.5,need_shadow = 1},	
			-- 添加场景特效闪电			
			{ action_type = 7 , pos_x = 260,pos_y = 240 , effect_id = 3501 ,effect_type = 3 ,delay_time = 0.5},				
			-- -- 主角往后瞬移,躲避闪电
			-- { action_type = 10 , entity_tag = 0, move_x = -70 ,delay_time = 1.5,need_shadow = 1},
			-- 删除原来的主角
			{ action_type = 5, entity_tag = 0 };
			-- 创建跪着的主角	
			{ action_type = 3, entity_body_id = 0, entity_tag = 0,entity_name = "@player",pos_x = 260,pos_y =  240,dir = 1,entity_type = 2 };	
			-- 显示剧情框
			{ action_type = 11, show_type = 1, show_panel_type = 2},
			-- 界王剧情对话
			{ action_type = 1 , entity_face_id = 2000,jq_str = "汝亦不过如此！这招便送汝前去投胎！" },	
			-- 师傅说话
			{ action_type = 1 , entity_face_id = 8,jq_str = "休得伤我徒儿！" },	
			-- 创建实体师傅
			{ action_type = 3 , entity_body_id = 47,entity_name = "黄老邪",pos_x = 0,pos_y =  390,dir = 1,entity_type = 1,entity_tag = 2,delay_time = 1},						
			-- 师傅瞬移
			{ action_type = 10 , entity_tag = 2, move_x = 550,move_y = 150 ,delay_time = 0.7,need_shadow = 1},				
			-- 师傅攻击
			{ action_type = 9,entity_tag = 2,action_id = 1,delay_time = 0.5},
			-- 播放特效
			{ action_type = 7 , entity_tag = 1, effect_id = 99999 ,effect_type = 1 ,delay_time = 0.5},
			-- 屏幕震动
			-- 界王神和师傅都后退
			{ action_type = 10 , entity_tag = 2, move_x = -150,move_y = 0 ,delay_time = 0},	
			{ action_type = 10 , entity_tag = 1, move_x = 150,move_y = 0 ,delay_time = 0.7},	

			{ action_type = 1 , entity_face_id = 2000,jq_str = "黄老邪！汝多次坏本王大事！此番如若还不交出轩辕剑身！本王必让你师徒二人葬身于此！" },	
			{ action_type = 1 , entity_face_id = 8,jq_str = "界王神你自诩正义之士，行事却阴险歹毒，如若轩辕剑身落入你之手，世间岂得安宁。我黄老邪虽则无正无邪，但亦见不得这天下生灵涂炭。看招！" },	
			{ action_type = 1 , entity_face_id = 2000,jq_str = "找死！" },	
			-- 关闭剧情框
			{ action_type = 11,show_type = 2},
			-- 师傅攻击动作
			{ action_type = 9,entity_tag = 2,action_id = 1,delay_time = 0.5},
			-- 师傅发射一个技能
			{ action_type = 7,entity_tag = 2,target_tag = 1,effect_id = 1103,effect_type = 4,delay_time = 0.5},
			-- 界王被技能打中
			{ action_type = 7,entity_tag = 1,effect_id = 401,effect_type = 1,delay_time = 1},			
			-- 界王泡泡字体
			{ action_type = 8 , entity_tag = 1,jq_str = "汝不过这点本事，安敢坏我玉宫大事！本王这就让汝等师徒二人地下相见！" ,delay_time = 2},
			-- 界王添加特效
			{ action_type = 7 , entity_tag = 1, effect_id = 1104 ,effect_type = 1 ,delay_time = 0.5},
			-- 界王攻击
			{ action_type = 9 , entity_tag = 1, action_id = 1 ,delay_time = 0.5},	
			-- 师傅身上添加特效
			{ action_type = 7 , entity_tag = 2, effect_id = 3501 ,effect_type = 1 ,delay_time = 0.5},			
			-- 师傅被击退
			{ action_type = 10 , entity_tag = 2, move_x = -50,move_y = 0 ,delay_time = 0.5},

			-- 师傅说话
			{ action_type = 8 , entity_tag = 2, jq_str = "不会让你伤害我徒弟！",delay_time = 2},					
			-- 主角说话
			{ action_type = 8 , entity_tag = 0, jq_str = "不！师傅！！！",delay_time = 2},
			{ action_type = 8 , entity_tag = 2, jq_str = "嗬呀！",delay_time = 1},
			{ action_type = 8 , entity_tag = 1, jq_str = "哼！",delay_time = 1},
			-- 界王攻击
			{ action_type = 9 , entity_tag = 1, action_id = 1 ,delay_time = 0},		
			-- 师傅攻击动作
			{ action_type = 9,entity_tag = 2,action_id = 1,delay_time = 0.5},		
			-- -- 蓝屏+特效
			-- { action_type = 14},
			-- 画面震动
			-- 添加场景特效闪电			
			{ action_type = 7 , pos_x = 350,pos_y = 370 , effect_id = 11023 ,effect_type = 3,delay_time = 0 ,effect_time = 4000 },							
			{ action_type = 7 , pos_x = 550,pos_y = 370 , effect_id = 11023 ,effect_type = 3,delay_time = 0 ,effect_time = 4000 },
			{ action_type = 7 , pos_x = 550,pos_y = 360 , effect_id = 30002 ,effect_type = 3,delay_time = 4 ,effect_time = 2500 },					
			-- 界王泡泡框文字
			{ action_type = 8 , entity_tag = 1,jq_str = "看来本王也要拿点真本事给汝等渣滓看看！九天之力，渡劫神雷！" ,delay_time = 2},		
			-- 界王攻击
			{ action_type = 9 , entity_tag = 1, action_id = 1 ,delay_time = 0},
			-- 师傅被打飞
			{ action_type = 7 , pos_x = 300,pos_y = 240 , effect_id = 55 ,effect_type = 3,delay_time = 0.5  },				
			{ action_type = 10 , entity_tag = 2, move_x = -400,move_y = 0 ,delay_time = 0.5},
			-- 界王泡泡框文字
			{ action_type = 8 , entity_tag = 1,jq_str = "今日汝等师徒二人一个也跑不了！让本王送汝等渣滓去死！" ,delay_time = 2},		
			-- 创建实体芷云
			{ action_type = 3 , entity_body_id = 5007 ,entity_name = "芷云",pos_x = 200,pos_y =  240,dir = 6,entity_type = 2,entity_tag = 3,create_type = 1 },			
			-- 芷云说话
			{ action_type = 8 , entity_tag = 3, jq_str = "双龙锁魂",delay_time = 1},
			-- 界王神身上出现被锁住的特效，芷云出现在主角旁边
			{ action_type = 7 , entity_tag = 1, effect_id = 79 ,effect_type = 2 ,delay_time = 0.5},
			-- 界王泡泡框文字
			{ action_type = 8 , entity_tag = 1,jq_str = "谁！谁竟敢阻挡本王！" ,delay_time = 2},		
			-- 芷云说话
			{ action_type = 8 , entity_tag = 3, jq_str = "走！",delay_time = 4},
			-- 主角与芷云位置出现黑洞显示，主角与芷云消失。
			{ action_type = 7 , entity_tag = 0, effect_id = 9002 ,effect_type = 1 ,delay_time = 0},				
			{ action_type = 7 , entity_tag = 3, effect_id = 9002 ,effect_type = 1 ,delay_time = 0.5},		
			-- 主角与芷云			
			{ action_type = 5 , entity_tag = 3},
			{ action_type = 5 , entity_tag = 0},
			-- 对话
			{ action_type = 8 , entity_tag = 1, jq_str = "#c71cecb拒让让汝等渣滓跑掉，气煞吾辈！",delay_time = 3},
		},
	},

}