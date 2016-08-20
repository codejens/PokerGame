--动画特效的声音
pet_attack_effect ={
	--宠物攻击声音，暂时没有按技能做音效，全部统一一个
	[0]  = 'sound/Effect/01000.wav',
}
sound_effect ={
   
}

--一般音乐
music_config = 
{
	-- 登录
	login = 'sound/Sounds/denglu.mp3',
	-- 动画
	intro = 'sound/Sounds/denglu.mp3',
}

--动作声效，如果攻击没有特效id，就会使用action，比如跳起下打的动作
action_sounds =
{
	[9] = 'sound/Game/30021.wav'
}

--界面声音
ui_sounds = 
{
	-- 穿戴装备
	wear_item = 'sound/Game/30001.wav',

	-- 卸下装备、物品丢弃
	drop_item = 'sound/Game/30002.wav',

	-- 购买
	buy_item = 'sound/Game/30004.wav',

	-- 接受任务
	accept_task = 'sound/Game/30005.wav',

	-- 完成任务
	finish_task = 'sound/Game/30006.wav',

	-- 人物升级
	level_up = 'sound/Game/30007.wav',

	-- 强化成功
	strength_ok = 'sound/Game/30008.wav',

	-- 强化失败
	strength_fail = 'sound/Game/30009.wav',

	-- 怒气积满
	anger_full = 'sound/Game/30010.wav',

	-- 打开界面
	open_win = 'sound/Game/30011.wav',

	-- 关闭界面
	close_win = 'sound/Game/30012.wav',

	-- 私聊消息
	private_chat = 'sound/Game/30013.wav',

	-- 提示按钮提醒音
	tip_btn = 'sound/Game/30014.wav',

	-- 点击普通按钮
	common_btn = 'sound/Game/00071.wav',

	-- 传送
	transmit = 'sound/Game/30015.wav',

	-- 上坐骑
	mounts_up = 'sound/Game/30018.wav',

	-- 下坐骑
	mounts_down = 'sound/Game/30023.wav',

	-- 变身
	transfer = 'sound/Game/30019.wav',

	-- 跳跃
	jump = 'sound/Game/30021.wav',

	-- 分身
	clone = 'sound/Game/30022.wav',

	-- 喝药
	medicine = 'sound/Game/30016.wav',

	--成就弹框
	achieve = "sound/Game/30024.wav"
}



--场景音乐，根据场景id来填写，如果没有默认default
scene_music =
{
	default = 'sound/Sounds/yewaiqingxin.mp3',
	[0] = 'sound/Sounds/yewaiqingxin.mp3',
	[1] = "sound/Sounds/yewaiqingxin.mp3",
	[2] = "sound/Sounds/yewaiqingxin.mp3",
	[3] = "sound/Sounds/zhucheng.mp3",
	[4] = "sound/Sounds/yewaiqingxin.mp3",
	[5] = "sound/Sounds/yewaiqingxin.mp3",
	[6] = "sound/Sounds/yewaiqingxin.mp3",
	[7] = "sound/Sounds/yewaiqingxin.mp3",
	[8] = "sound/Sounds/yewaiqingxin.mp3",
	[9] = "sound/Sounds/fubenyinsen.mp3",
	[10] = "sound/Sounds/yewaiqingxin.mp3",
	[11] = "sound/Sounds/fubenyinsen.mp3",
	[12] = "sound/Sounds/yewaiqingxin.mp3",
	[13] = "sound/Sounds/yewaiqingxin.mp3",
	[14] = "sound/Sounds/yewaiqingxin.mp3",
	[15] = "sound/Sounds/yewaiqingxin.mp3",
	[16] = "sound/Sounds/fubenyinsen.mp3",
	[17] = "sound/Sounds/fubenyinsen.mp3",
	[18] = "sound/Sounds/fubenyinsen.mp3",
	[19] = "sound/Sounds/fubenyinsen.mp3",
	[20] = "sound/Sounds/fubenyinsen.mp3",--野外场景

	[27]=	'sound/Sounds/fubenyinsen.mp3',
	[1001]=	'sound/Sounds/fubenyinsen.mp3',
    [1002]=	'sound/Sounds/fubenyinsen.mp3',
    [1003]=	'sound/Sounds/fubenyinsen.mp3',
    [1004]=	'sound/Sounds/fubenyinsen.mp3',
    [1005]=	'sound/Sounds/fubenyinsen.mp3',
    [1006]=	'sound/Sounds/fubenyinsen.mp3',
    [1007]=	'sound/Sounds/fubenyinsen.mp3',
    [1008]=	'sound/Sounds/fubenyinsen.mp3',
    [1009]=	'sound/Sounds/fubenyinsen.mp3',
    [1010]=	'sound/Sounds/fubenyinsen.mp3',
    [1011]=	'sound/Sounds/fubenyinsen.mp3',
    [1012]=	'sound/Sounds/fubenyinsen.mp3',
    [1013]=	'sound/Sounds/fubenyinsen.mp3',
    [1014]=	'sound/Sounds/fubenyinsen.mp3',
    [1015]=	'sound/Sounds/fubenyinsen.mp3',
    [1016]=	'sound/Sounds/fubenyinsen.mp3',
    [1017]=	'sound/Sounds/fubenyinsen.mp3',
	[1018]=	'sound/Sounds/fubenyinsen.mp3',
	[1019]=	'sound/Sounds/fubenyinsen.mp3',
	[1020]=	'sound/Sounds/fubenyinsen.mp3',
	[1021]=	'sound/Sounds/fubenyinsen.mp3',
	[1022]=	'sound/Sounds/fubenyinsen.mp3',
	[1023]=	'sound/Sounds/fubenyinsen.mp3',
	[1024]=	'sound/Sounds/fubenyinsen.mp3',
	[1025]=	'sound/Sounds/fubenyinsen.mp3',
	[1026]=	'sound/Sounds/fubenyinsen.mp3',
	[1027]=	'sound/Sounds/fubenyinsen.mp3',
	[1028]=	'sound/Sounds/fubenyinsen.mp3',
	[1029]=	'sound/Sounds/fubenyinsen.mp3',
	[1030]=	'sound/Sounds/fubenyinsen.mp3',
	[1031]=	'sound/Sounds/fubenyinsen.mp3',
	[1032]=	'sound/Sounds/fubenyinsen.mp3',
	[1033]=	'sound/Sounds/fubenyinsen.mp3',
	[1034]=	'sound/Sounds/fubenyinsen.mp3',
	[1035]=	'sound/Sounds/fubenyinsen.mp3',
	[1036]=	'sound/Sounds/fubenyinsen.mp3',
	[1037]=	'sound/Sounds/fubenyinsen.mp3',
	[1038]=	'sound/Sounds/fubenyinsen.mp3',
	[1039]=	'sound/Sounds/fubenyinsen.mp3',
	[1040]=	'sound/Sounds/fubenyinsen.mp3',
	[1041]=	'sound/Sounds/fubenyinsen.mp3',
	[1042]=	'sound/Sounds/fubenyinsen.mp3',
	[1043]=	'sound/Sounds/fubenyinsen.mp3',
	[1044]=	'sound/Sounds/fubenyinsen.mp3',
	[1045]=	'sound/Sounds/fubenyinsen.mp3',--忍者考试
	
	[1046]=	'sound/Sounds/zhucheng.mp3',
	[1047]=	'sound/Sounds/fubenyinsen.mp3',
	[1048]=	'sound/Sounds/fubenyinsen.mp3',
	[1049]=	'sound/Sounds/fubenyinsen.mp3',
	[1050]=	'sound/Sounds/fubenyinsen.mp3',
	[1051]=	'sound/Sounds/fubenyinsen.mp3',
	[1052]=	'sound/Sounds/fubenyinsen.mp3',
	[1053]=	'sound/Sounds/fubenyinsen.mp3',
	[1054]=	'sound/Sounds/fubenyinsen.mp3',
	[1055]=	'sound/Sounds/fubenyinsen.mp3',
	[1056]=	'sound/Sounds/fubenyinsen.mp3',
	[1057]=	'sound/Sounds/fubenyinsen.mp3',
	[1058]=	'sound/Sounds/fubenyinsen.mp3',
	
	[1059]=	'sound/Sounds/fubenyinsen.mp3',
	[1060]=	'sound/Sounds/fubenyinsen.mp3',
	[1061]=	'sound/Sounds/fubenyinsen.mp3',
	[1062]=	'sound/Sounds/fubenyinsen.mp3',
	[1063]=	'sound/Sounds/fubenyinsen.mp3',
	[1064]=	'sound/Sounds/fubenyinsen.mp3',--心魔幻境（1-6）
	
	[1065]=	'sound/Sounds/fubenyinsen.mp3',--大乱斗
	[1066]=	'sound/Sounds/fubenyinsen.mp3',--守护木叶（1-4）
	[1067]=	'sound/Sounds/fubenyinsen.mp3',
	[1068]=	'sound/Sounds/fubenyinsen.mp3',
	[1069]=	'sound/Sounds/fubenyinsen.mp3',
	[1070]=	'sound/Sounds/fubenyinsen.mp3',
	[1071]=	'sound/Sounds/fubenyinsen.mp3',
	[1072]=	'sound/Sounds/fubenyinsen.mp3',
	[1073]=	'sound/Sounds/fubenyinsen.mp3',
	[1074]=	'sound/Sounds/fubenyinsen.mp3',
	[1075]=	'sound/Sounds/fubenyinsen.mp3',
	[1076]=	'sound/Sounds/fubenyinsen.mp3',
	[1079]=	'sound/Sounds/fubenyinsen.mp3',	--心魔幻境（8-18）
	
	[1077]=	'sound/Sounds/yewaiqingxin.mp3',--温泉
	[1078]=	'sound/Sounds/fubenyinsen.mp3',--演武场

	[1080]=	'sound/Sounds/fubenyinsen.mp3',
	[1081]=	'sound/Sounds/fubenyinsen.mp3',
	[1082]=	'sound/Sounds/fubenyinsen.mp3',
	[1083]=	'sound/Sounds/fubenyinsen.mp3',
	[1084]=	'sound/Sounds/fubenyinsen.mp3',
	[1085]=	'sound/Sounds/fubenyinsen.mp3',
	[1086]=	'sound/Sounds/fubenyinsen.mp3',
	[1087]=	'sound/Sounds/fubenyinsen.mp3',
	[1088]=	'sound/Sounds/fubenyinsen.mp3',
	[1089]=	'sound/Sounds/fubenyinsen.mp3',
	[1090]=	'sound/Sounds/fubenyinsen.mp3',
	[1091]=	'sound/Sounds/fubenyinsen.mp3',
	[1092]=	'sound/Sounds/fubenyinsen.mp3',
	[1093]=	'sound/Sounds/fubenyinsen.mp3',
	[1094]=	'sound/Sounds/fubenyinsen.mp3',
	[1095]=	'sound/Sounds/fubenyinsen.mp3',
	[1096]=	'sound/Sounds/fubenyinsen.mp3',
	[1097]=	'sound/Sounds/fubenyinsen.mp3',
	[1098]=	'sound/Sounds/fubenyinsen.mp3',
	[1099]=	'sound/Sounds/fubenyinsen.mp3',
	[1100]=	'sound/Sounds/fubenyinsen.mp3',
	[1101]=	'sound/Sounds/fubenyinsen.mp3',
	[1102]=	'sound/Sounds/fubenyinsen.mp3',
	[1103]=	'sound/Sounds/fubenyinsen.mp3',
	[1104]=	'sound/Sounds/fubenyinsen.mp3',
	[1105]=	'sound/Sounds/fubenyinsen.mp3',
	[1106]=	'sound/Sounds/fubenyinsen.mp3',
	[1107]=	'sound/Sounds/fubenyinsen.mp3',
	[1108]=	'sound/Sounds/fubenyinsen.mp3',
	[1109]=	'sound/Sounds/fubenyinsen.mp3',
	[1110]=	'sound/Sounds/fubenyinsen.mp3',
	[1111]=	'sound/Sounds/fubenyinsen.mp3',
	[1112]=	'sound/Sounds/fubenyinsen.mp3',
	[1113]=	'sound/Sounds/fubenyinsen.mp3',
	[1114]=	'sound/Sounds/fubenyinsen.mp3',
	[1115]=	'sound/Sounds/fubenyinsen.mp3',
	[1116]=	'sound/Sounds/fubenyinsen.mp3',
	[1117]=	'sound/Sounds/fubenyinsen.mp3',
	[1118]=	'sound/Sounds/fubenyinsen.mp3',
	[1119]=	'sound/Sounds/fubenyinsen.mp3',
	[1120]=	'sound/Sounds/fubenyinsen.mp3',
	[1121]=	'sound/Sounds/fubenyinsen.mp3',
	[1122]=	'sound/Sounds/fubenyinsen.mp3',
	[1123]=	'sound/Sounds/fubenyinsen.mp3',
	[1124]=	'sound/Sounds/fubenyinsen.mp3',
	[1125]=	'sound/Sounds/fubenyinsen.mp3',
	[1126]=	'sound/Sounds/fubenyinsen.mp3',
	[1127]=	'sound/Sounds/fubenyinsen.mp3',
	[1128]=	'sound/Sounds/fubenyinsen.mp3',
	[1129]=	'sound/Sounds/fubenyinsen.mp3',
	[1130]=	'sound/Sounds/fubenyinsen.mp3',
	[1131]=	'sound/Sounds/fubenyinsen.mp3',
	[1132]=	'sound/Sounds/fubenyinsen.mp3',
	[1133]=	'sound/Sounds/fubenyinsen.mp3',
	[1134]=	'sound/Sounds/fubenyinsen.mp3',
	[1135]=	'sound/Sounds/fubenyinsen.mp3',
	[1136]=	'sound/Sounds/fubenyinsen.mp3',
	[1137]=	'sound/Sounds/fubenyinsen.mp3',
	[1138]=	'sound/Sounds/fubenyinsen.mp3',
		
		
	[1141]=	'sound/Sounds/fubenyinsen.mp3',
	[1142]=	'sound/Sounds/fubenyinsen.mp3',
	[1143]=	'sound/Sounds/fubenyinsen.mp3',
	[1144]=	'sound/Sounds/fubenyinsen.mp3',
	[1145]=	'sound/Sounds/fubenyinsen.mp3',
	[1146]=	'sound/Sounds/fubenyinsen.mp3',
		
	[1147]=	'sound/Sounds/fubenyinsen.mp3',
	[1148]=	'sound/Sounds/fubenyinsen.mp3',
	[1149]=	'sound/Sounds/fubenyinsen.mp3',
	[1150]=	'sound/Sounds/fubenyinsen.mp3',
	[1188]=	'sound/Sounds/fubenyinsen.mp3',
		
		
	[1190]=	'sound/Sounds/fubenyinsen.mp3',
	[1191]=	'sound/Sounds/fubenyinsen.mp3',
	[1192]=	'sound/Sounds/fubenyinsen.mp3',
	[1193]=	'sound/Sounds/fubenyinsen.mp3',

	
}