-- HuanLeDouModel.lua
-- create by hcl on 2013-9-25
-- 欢乐斗model

HuanLeDouModel = {}

HuanLeDouModel.STATE_FREE = 1;
HuanLeDouModel.STATE_SHUSHEN_FREE = 2;
HuanLeDouModel.STATE_DIZHU = 3;
HuanLeDouModel.STATE_KUGONG = 4;

HuanLeDouModel.MSG_START_COLOR = "#cff8c00";

HuanLeDouModel.slaveMakeExp = { --苦工每秒钟产生的经验
	-- {-1, 	0,		0.00000146667 },
	{1, 	10,		0.00000366667 },
	{11,	50,		0.00000330000 },
	{51,	100,	0.00000293333 },
	{101,	200,	0.00000256667 },
	{201,	500,	0.00000220000 },
	{501,	1000,	0.00000183333 },
	-- 其它按上面配置
}

HuanLeDouModel.MSG_STR = {
	[1001] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[250],1}, -- [250]="【抓捕】#cffffff你抓捕xx成功了，TA变成了你的苦工。"
	[1002] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[251],1}, -- [251]="【抓捕】#cffffff你抓捕xx失败了，TA没有成为你的苦工。"
	[1003] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[252],1}, -- [252]="【抓捕】#cffffffxx抓捕你成功了，你变成了TA的苦工。"
	[1004] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[253],1}, -- [253]="【抓捕】#cffffffxx抓捕你失败了，你没有成为TA的苦工。"

	[2001] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[254],1,2}, -- [254]="【掠夺】#cffffff你掠夺xx成功了，获得了TA的苦工xx。"
	[2002] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[255],1}, -- [255]="【掠夺】#cffffff你掠夺xx失败了，没有获得TA的苦工。"
	[2003] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[256],1,2}, -- [256]="【掠夺】#cffffffxx掠夺你成功了，TA获得了你的苦工xx。"
	[2004] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[257],1}, -- [257]="【掠夺】#cffffffxx掠夺你失败了，TA没有获得你的苦工。"

	[3001] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[258],1}, -- [258]="【释放】#cffffff你大赦天下，释放了苦工xx，TA变成了自由身。"
	[3002] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[259],1}, -- [259]="【释放】#cffffffxx大赦天下，把你释放了，你重获自由。"
	[3003] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[260],1}, -- [260]="【释放】#cffffff你的竞技场排名在1000以外，不能再当仙主了，你的仙仆xx被释放了。"
	[3004] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[261],1}, -- [261]="【释放】#cffffff你的仙主xx竞技场排名在1000以外，不能再当仙主了，你被释放了。"

	[4101] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[262],1}, -- [262]="【互动】#cffffff你大发慈悲请xx到城里最好的酒馆吃烛光晚餐，点了二尺龙虾，喝了上好的女儿红，你们喝得醉醺醺之后，趴在桌上睡着了。"
	[4102] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[263],1,1}, -- [263]="【互动】#cffffff你带着xx看皮影戏，xx感觉回到了小时候，感动的满眼泪花。"
	[4103] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[264],1}, -- [264]="【互动】#cffffff你给xx讲故事，说有一个石猴爱上了观音菩萨，为了引起观音的注意而大闹天宫，结果被情敌压在了大山下。"
	[4104] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[265],1}, -- [265]="【互动】#cffffff你带着xx去游山玩水，处处风景如画鸟语花香，令人心旷神怡！"
	[4105] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[266],1}, -- [266]="【互动】#cffffff你带着xx去泡温泉，情多处，热如火，你侬我侬，忒煞情多。"
	[4106] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[267],1}, -- [267]="【互动】#cffffff你对xx张开双臂，含情脉脉：“可以给我一个幸福的拥抱么？”"

	[4107] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[268],1}, -- [268]="【互动】#cffffff你让xx清扫厕所，还要他把大粪挑出来做农家肥料，把他恶心地狂吐不止。"
	[4108] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[269],1}, -- [269]="【互动】#cffffff你让xx到村里的广场去裸奔，村口的大黄也来凑热闹，围着他汪汪直叫，引得众人围观，好丢脸。"
	[4109] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[270],1}, -- [270]="【互动】#cffffff你听说饥饿可以减肥，决定让xx做小白鼠，饿他三天三夜。"
	[4110] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[271],1}, -- [271]="【互动】#cffffff你突然想练拳击术，让xx去找个沙包，他没有找到，最后你把他捆吊起来，说他就是最合适的沙包。"
	[4111] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[272],1}, -- [272]="【互动】#cffffff你突然想看钢管舞，让xx穿上比基尼，在你面前跳钢管舞，跳得不好就抽他。"
	[4112] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[273],1}, -- [273]="【互动】#cffffff你最近比较缺钱，为了给白富美买生日礼物，你让xx去砖窑里去搬砖一天"

	[4201] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[274],1}, -- [274]="【互动】#cffffffxx对你一阵猛夸：主人，您长得真有创意，活得真有勇气!"
	[4202] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[275],1}, -- [275]="【互动】#cffffffxx对着你前迈左腿，左手扶膝，右手下垂，右腿半跪，高喊“您老吉祥”。"
	[4203] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[276],1}, -- [276]="【互动】#cffffffxx端起你的小细腿边揉边端详，“二师兄，现在您的肉比师父的都贵了”。"
	[4204] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[277],1}, -- [277]="【互动】#cffffffxx清了清嗓子，给你唱起那段耳熟能详的歌：起来，饥寒交迫的奴隶..."
	[4205] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[278],1}, -- [278]="【互动】#cffffffxx气运丹田，开始给你表演印度名舞《我的肚子》。"
	[4206] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[279],1}, -- [279]="【互动】#cffffffxx含情脉脉地在你脖子上咬了一个心形红印，害羞地撒腿就跑。"

	[4207] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[280],1}, -- [280]="【互动】#cffffffxx耸耸肩，无比鄙视地抛你一个白眼。"
	[4208] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[281],1}, -- [281]="【互动】#cffffffxx提着书法作品给你欣赏，宣纸上苍劲有力写着：2B不只是铅笔 还有你。"
	[4209] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[282],1}, -- [282]="【互动】#cffffffxx仔细端详着您，称赞道：主人你一出门，千山鸟飞绝，万径人踪灭！"
	[4210] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[283],1}, -- [283]="【互动】#cffffffxx鼓起勇气对你说：你最好快点放了我！我爸是李铁刚！"
	[4211] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[284],1}, -- [284]="【互动】#cffffffxx对你说：主人，大家都说你不是随便的人，但是随便起来不是人，你果然不是一般人啊！"
	[4212] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[285],1}, -- [285]="【互动】#cffffffxx拿着《人权宣言》向你说：古有淮阴侯受胯下之辱，继而灭齐，当今有人卧薪尝胆为明日一战。说完一脸严肃看着你。"

	[4301] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[286],1}, -- [286]="【互动】#cffffff你对xx一阵猛夸：主人，您长得真有创意，活得真有勇气!"
	[4302] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[287],1}, -- [287]="【互动】#cffffff你对着xx前迈左腿，左手扶膝，右手下垂，右腿半跪，高喊“您老吉祥”。"
	[4303] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[288],1}, -- [288]="【互动】#cffffff你端起xx的小细腿边揉边端详，“二师兄，现在您的肉比师父的都贵了”。"
	[4304] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[289],1}, -- [289]="【互动】#cffffff你清了清嗓子，给xx唱起那段耳熟能详的歌：起来，饥寒交迫的奴隶..."
	[4305] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[290],1}, -- [290]="【互动】#cffffff你气运丹田，开始给xx表演印度名舞《我的肚子》。"
	[4306] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[291],1}, -- [291]="【互动】#cffffff你含情脉脉地在xx脖子上咬了一个心形红印，害羞地撒腿就跑。"

	[4307] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[292],1}, -- [292]="【互动】#cffffff你耸耸肩，无比鄙视地向xx抛白眼。"
	[4308] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[293],1}, -- [293]="【互动】#cffffff你提着精心制作的书法给xx欣赏，宣纸上苍劲有力写着：2B不只是铅笔 还有你。"
	[4309] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[294],1}, -- [294]="【互动】#cffffff你仔细端详着xx，称赞道：主人你一出门，千山鸟飞绝，万径人踪灭！"
	[4310] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[295],1}, -- [295]="【互动】#cffffff你鼓起勇气对xx说：你最好快点放了我！我爸是李铁刚！"
	[4311] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[296],1}, -- [296]="【互动】#cffffff你对xx说：主人，大家都说你不是随便的人，但是随便起来不是人，你果然不是一般人啊！"
	[4312] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[297],1}, -- [297]="【互动】#cffffff你拿着《人权宣言》向你说：古有淮阴侯受胯下之辱，继而灭齐，今有人卧薪尝胆为明日一战。说完一脸严肃看着xx。"

	[4401] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[298],1}, -- [298]="【互动】#cffffffxx大发慈悲请你到城里最好的酒馆吃烛光晚餐，点了二尺龙虾，喝了上好的女儿红，你们喝得醉醺醺之后，趴在桌上睡着了。"
	[4402] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[299],1}, -- [299]="【互动】#cffffffxx带着你看皮影戏，你感觉回到了小时候，感动的满眼泪花。"
	[4403] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[300],1}, -- [300]="【互动】#cffffffxx给你讲故事，说有一个石猴爱上了观音菩萨，为了引起观音的注意而大闹天宫，结果被情敌压在了大山下。"
	[4404] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[301],1}, -- [301]="【互动】#cffffffxx带着你去游山玩水，处处风景如画鸟语花香，令人心旷神怡！"
	[4405] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[302],1}, -- [302]="【互动】#cffffffxx带着你去泡温泉，情多处，热如火，你侬我侬，忒煞情多。"
	[4406] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[303],1}, -- [303]="【互动】#cffffffxx对你张开双臂，含情脉脉：“可以给我一个幸福的拥抱么？”"

	[4407] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[304],1}, -- [304]="【互动】#cffffffxx让你去清扫厕所，还要你把大粪挑出来做农家肥料，把你恶心地狂吐不止。"
	[4408] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[305],1}, -- [305]="【互动】#cffffffxx让你到村里的广场去裸奔，村口的大黄也来凑热闹，围着你汪汪直叫，引得众人围观，好丢脸。"
	[4409] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[306],1}, -- [306]="【互动】#cffffffxx听说饥饿可以减肥，决定让你做小白鼠，饿你三天三夜。"
	[4410] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[307],1,1}, -- [307]="【互动】#cffffffxx突然想练拳击术，让你去找个沙包，你去哪找这玩意啊，最后xx把你捆吊起来，说你就是最合适的沙包。"
	[4411] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[308],1,1}, -- [308]="【互动】#cffffffxx突然想看钢管舞，让你穿上比基尼，在xx面前跳钢管舞，跳得不好就抽你。"
	[4412] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[309],1}, -- [309]="【互动】#cffffffxx最近比较缺钱，他为了给白富美买生日礼物，让你去砖窑里去搬砖一天。"

	[5001] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[310],1}, -- [310]="【解救】#cffffff你解救xx成功了，使TA重获自由身。"
	[5002] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[311],1}, -- [311]="【解救】#cffffff你解救xx失败了，TA还是一名苦工。"
	[5003] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[312],1}, -- [312]="【解救】#cffffff你被xx解救了，重获自由身。"
	[5004] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[313],1}, -- [313]="【解救】#cffffffxx解救你失败了，你还是一名苦工。"
	[5005] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[314],1,2}, -- [314]="【解救】#cffffffxx解救你了的苦工xx。"
	[5006] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[315],1}, -- [315]="【解救】#cffffffxx试图解救你的苦工xx，被你一举击败。"

	[6001] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[316],1}, -- [316]="【反抗】#cffffff你反抗xx成功了，重获自由身。"
	[6002] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[317],1}, -- [317]="【反抗】#cffffff你反抗xx失败了，还是他的苦工。"
	[6003] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[318],1}, -- [318]="【反抗】#cffffffxx反抗你成功了，成为了自由身。"
	[6004] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[319],1}, -- [319]="【反抗】#cffffffxx反抗你失败了，还是你的苦工。"

	[7001] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[320],1}, -- [320]="【赎身】#cffffff你赎身成功了，重获自由身。"
	[7002] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[321],1}, -- [321]="【赎身】#cffffffxx赎身成功了，重获自由身。"

	[8001] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[322],1}, -- [322]="【求救】#cffffff你向xx发起求救。"
	[8002] = {HuanLeDouModel.MSG_START_COLOR..LangModelString[323],1}, -- [323]="【求救】#cffffffxx向你发起求救。"

	--其他消息
	[9001] = {LangModelString[324],1,2,2}, -- [324]="xx已经是xx的仙仆！确定要把TA从xx那里抢过来？。"
	[9002] = {LangModelString[325],1,2,2}, -- [325]="xx抢先一步，将xx收为仙仆！xx没能成为你的仙仆。"

}


local my_hld_info = {};

function HuanLeDouModel:set_my_hld_info( _info )
	my_hld_info = _info;
end

function HuanLeDouModel:get_my_hld_info()
	return my_hld_info;
end

local msgTips={1003, 2003, 3002, 3003, 3004, 5003, 5005, 6003, 7002, 8002}

function HuanLeDouModel:parse_msg_id( msg_id )
	-- 8002代表某人向你求救，这个时候弹MiniBtn
	for i=1,#msgTips do
		if msgTips[i] == msg_id then 
			local function cb_fun()
				UIManager:show_window("hld_main_win")
			end
			MiniBtnWin:show( 5 , cb_fun  )
		end
	end
	-- 判断欢乐斗记录界面是否打开，如果打开就更新界面
	-- local hld_jl_win = UIManager:find_visible_window("hld_hudongjilu");
	-- if hld_jl_win then
	-- 	hld_jl_win
	-- end
end
