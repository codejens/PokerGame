-- TianyuanBuffTipView.lua 
-- createed by fangjiehua on 2013-5-12
-- 天元之主，真龙之魂buff tip

 
super_class.TianyuanBuffTipView(Window)

function TianyuanBuffTipView:__init(  )
	local item_config = ItemConfig:get_item_by_id(self.model_data.item_id);
	
	-- icon
	local icon = MUtils:create_slot_item2(self.view, UILH_NORMAL.item_bg2, 25, 400-70, 60,60,self.model_data.item_id,nil,9.5);
	icon:set_color_frame(nil);
	-- item 名字
	local item_name = UILabel:create_lable_2( "#cfff000"..item_config.name, 25+75, 400-70+22, 16, ALIGN_LEFT );
	self.view:addChild(item_name);

	-- 到期时间
	local deadline_text = Lang.tip[1];	-- [1] = "（提取道具后可查看真龙之魂到期时间）"
	if self.model_data.deadline ~= nil then
		local time_str = Utils:get_custom_format_time(LangGameString[431] ,self.model_data.deadline ); -- [431]="%Y年%m月%d日 %H时%M分"
		deadline_text = LangGameString[2023]..time_str; -- [2023]="#c38ff33到期时间:#r"
	end
	local deadline = MUtils:create_ccdialogEx(self.view, deadline_text, 25, 400-70-55, 300,40,2,16);

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,400-70-55-5,325,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	-- 属性加成
	local attri_add_lab = UILabel:create_lable_2( LangGameString[2024], 25, 400-70-55-5-20-5, 16, ALIGN_LEFT ); -- [2024]="#cfff000基础属性"
	self.view:addChild(attri_add_lab);

	local attri_text = "";
	local item_static_attri = ItemConfig:get_staitc_attrs_by_id( self.model_data.item_id );
	for i,v in ipairs(item_static_attri) do
		print("真龙之魂的加成",i, v.type, staticAttriTypeList[v.type], v.value);
		local space_text = "   ";
		if v.type == 27 or v.type == 17 then
			space_text = "       "
		end
		attri_text = attri_text.."#cffffff"..staticAttriTypeList[v.type]..space_text.."#c38ff33+"..v.value.."#r";

	end
	local attri_add = MUtils:create_ccdialogEx(self.view, attri_text, 25, 400-70-55-5-20-5-80-5, 250,80,4,16);
	--提示
	local tip_text = LangGameString[2025] -- [2025]="#cff66cc不可出售#r不可存入仓库#r不可交易#r不可销毁"
	local tip_msg = MUtils:create_ccdialogEx(self.view, tip_text, 25, 400-70-55-5-20-5-80-5-80-5, 250,80,4,16);

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,400-70-55-5-20-5-80-5-80-5-5,325,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	-- 描述
	local item_desc = MUtils:create_ccdialogEx(self.view, item_config.desc, 25, 400-70-55-5-20-5-80-5-80-5-5-60-7, 300,60,10,16);

end


function TianyuanBuffTipView:create( model_data )
	
	self.model_data = model_data;
	local temp_info = { texture = "", x = 0, y = 0, width = 280, height = 400 }
	return TianyuanBuffTipView("TianyuanBuffTipView", "", true, 280, 400);

end
