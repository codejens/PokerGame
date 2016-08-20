baguadigong = {

	-- 箴机奇图说明规则 add by chj 20160122
	rule_text = {
		{"1.","活动时间：每天#cd88a3e13:30~14:30#cd88a3e#c654016、#cd88a3e20:30~21:30#cd88a3e",},
		{"2.","箴机奇图共有#cd88a3e9块区域#cd88a3e#c654016，分别包含不同机遇等您去探索！",},
		{"3.","每次活动会抽取#cd88a3e6个目标#c654016，完成目标就可领取相应奖励！",},
		{"4.","活动目标可在每天#cd88a3e2个活动时间段#c654016内累计计算。",},
		{"5.","每天#cd88a3e24点清空#c654016所有活动目标的完成进度。",},
	},

	-- map_npc_name = "地宫传送",
	-- 安全区域(复活区)
	-- refresh_area = 
	-- 	{
	-- 		x = 365, y = 300, 
	-- 		point_img = "ui/lh_other/dg_relive_point.png", 
	-- 		label_img = "ui/lh_other/dg_lab2.png",
	-- 	},
	boss = 
		{
			-- x = 2400, y = 1304,
			name = "国师·刘歆",
			point_img = "sui/minimap/target.png",
			label_img = "sui/minimap/target.png",
			is_boss = true, -- 不选的，表示boss
			tile_x = 75, tile_y = 40,
		},
	npc = 
		{
			name = "传送使者",
			point_img = "sui/minimap/target.png",
			tile_x = 18, tile_y = 79,
		},
	monsters = 
		{
			[1] = 
				{
					name = "坎土玄虎",--1403
					point_img = "sui/minimap/target.png",
					tile_x = 127, tile_y = 76,
				},
			[2] = 
				{
					name = "汉风锦",--1407
					point_img = "sui/minimap/target.png",
					tile_x = 124, tile_y = 48,
				},
			[3] = 
				{
					name = "离水冰狼",--1401
					point_img = "sui/minimap/target.png",
					tile_x = 16, tile_y = 38,
				},
			[4] = 
				{
					name = "秦韵简",--1408
					point_img = "sui/minimap/target.png",
					tile_x = 112, tile_y = 19,
				},
			[5] = 
				{
					name = "龙蟒旗",--1406
					point_img = "sui/minimap/target.png",
					
					tile_x = 67, tile_y = 74,
				},
			[6] = 
				{
					name = "御觞奇兵",--1402
					point_img = "sui/minimap/target.png",
					
					tile_x = 72, tile_y = 7,
				},
			[7] = 
				{
					name = "玄麟旗",--1405
					point_img = "sui/minimap/target.png",
					
					tile_x = 20, tile_y = 11,
				},
			[8] = 
				{
					name = "苍阑术士",--1404
					point_img = "sui/minimap/target.png",
					tile_x = 118, tile_y = 8,
				},
		},
}

-- 配置调试可配置完按F9刷新查看
-- monsters的 tile_x, tile_y 
-- 参考地图编辑器
-- 是以左上角为(0,0),右下角为(n,n)的坐标系, 坐标也是传送坐标, 
