-- MiJiItemTipView.lua 
-- createed by tjh on 2014-6-4
-- MiJiItemTipView 面板
 
super_class.MiJiItemTipView(Window)


--秘籍配置里面品质是字符串 下发的数据是数值
local _pingzhi_string = {
	"green","blue","purple","orange","red",
}
--数字转换文字
local _num_tex = {
	"一重·","二重·","三重·","四重·","五重·","六重·","七重·","八重·","九重·",
}
--秘籍类型 是否是顶级秘籍
local IS_DIJI_MIJI = true
function MiJiItemTipView:__init( window_name, textureName )


	--item的静态数据
	local item_data = ItemConfig:get_item_by_id(self.model_data.item_id);
	-------------图标icon
	local  item_height = 235
	--local item_text_height = 150


	--秘籍描述
	local desc_str = item_data.desc
	local chong = self.model_data.void_bytes_tab[2] + 1 --重
	local ceng =  self.model_data.void_bytes_tab[7]  --层
	ceng = SkillMiJiModel:xiulian_value_to_ceng( chong,ceng )
	local curexp = self.model_data.void_bytes_tab[3]
	local pz = _pingzhi_string[self.model_data.quality]
	local level,maxexp = MijiConfig:get_miji_level( curexp,pz )

	local value_table,att_type,attr_value,basics_attr_type = MijiConfig:get_miji_dest_value_by_id( self.model_data.item_id,level,chong,ceng)
	 if #value_table <=2 then --非顶级
	 	desc_str = MiJiItemTipView:comminute_dest(not IS_DIJI_MIJI,desc_str)
	 	desc_str = desc_str..value_table[1]
	 else
	 	local str_table = MiJiItemTipView:comminute_dest(IS_DIJI_MIJI,desc_str,att_type)
	 	desc_str  =""
	 	for i=1,#str_table do
	 		desc_str = desc_str..str_table[i]
	 		if value_table[i] and i < (#str_table) then
	 			desc_str = desc_str..value_table[i]
	 		end
	 	end
	 end
	if self.model_data.quality == 4 then
	--修炼值
		item_height = 255
	end

	-- 如果不是从背包里打开的tip，不需要显示“使用”按钮，那么高度缩一点
	local dialog_fix_height = 65
	if self.model_data.open_from_skill_page and self.model_data.open_from_skill_page == true then
		dialog_fix_height = 15
		item_height = item_height - 50
	end

	
	local suit_dialog = CCDialogEx:dialogWithFile(25,125,250, 250, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	suit_dialog:setAnchorPoint(0,1);
	suit_dialog:setFontSize(16);
	suit_dialog:setText(desc_str);
	self.view:addChild(suit_dialog);
	local dialog_higt = suit_dialog:getInfoSize().height;
	suit_dialog:setPosition(15,dialog_higt+dialog_fix_height)

	item_height = item_height +dialog_higt
	self.view:setSize(280,item_height);
	

	local icon_bg = CCZXImage:imageWithFile(15,item_height-15,60,60,UILH_NORMAL.item_bg2);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	
	local icon = CCZXImage:imageWithFile(60/2,60/2,50,50,ItemConfig:get_item_icon(self.model_data.item_id));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--item 名字
	local name_color = "#c"..ItemConfig:get_item_color(item_data.color+1);
	local item_name_str = ""
	if self.model_data.quality == 4 then
		item_name_str =name_color.. _num_tex[chong] .. item_data["name"]
	else
		item_name_str =name_color..item_data["name"]
	end
	
	local item_name = CCZXLabel:labelWithTextS(CCPointMake(85,item_height-52),item_name_str,15,ALIGN_LEFT);--tostring(item_data["name"])
	self.view:addChild(item_name);

	-- ---战力
	-- local fight_bg = CCZXImage:imageWithFile(150,item_height-65,200,31,nil,5,15);--ui/common/ng_gradient2.png
	-- fight_bg:setAnchorPoint(0.5,1);
	-- self.view:addChild(fight_bg);
	
	-- --战斗力文字图片
	-- local fight_icon = CCZXImage:imageWithFile(200/2-30,31/2,154,56,UIResourcePath.FileLocate.normal .. "common_tip_fight.png");
	-- fight_icon:setAnchorPoint(0.5,0.5);
	-- fight_bg:addChild(fight_icon);

	-- --战斗力数字
	-- local fight_value = MijiConfig:get_miji_fight( self.model_data.item_id,level)
	-- --print("value_table[1]",fight_value,value_table[1],basics_attr_type,EquipValueConfig:get_calculate_factor( basics_attr_type ) )
	-- if basics_attr_type then
	-- 	local factor = EquipValueConfig:get_calculate_factor( basics_attr_type ) or 0
	-- 	fight_value = fight_value + math.abs(value_table[1]*factor)
	-- end
	-- if self.model_data.quality == 4 then
	-- 	local xianlian_value = attr_value * EquipValueConfig:get_calculate_factor( att_type ) 
	-- 	--print("--战斗力数字",attr_value,att_type,EquipValueConfig:get_calculate_factor( att_type ) ,xianlian_value)
	-- 	fight_value = fight_value + xianlian_value
	-- 	local orange_vale = MijiConfig:get_orange_miji_fight( self.model_data.item_id,self.model_data.void_bytes_tab[7])
	-- 	fight_value = fight_value +orange_vale
	-- end
	-- fight_value = math.floor(fight_value)
	-- local fight_lab = ZXLabelAtlas:createWithString(tostring(fight_value),UIResourcePath.FileLocate.normal .. "num");
	-- fight_lab:setPosition(CCPointMake(108+44,25/2+2));
	-- fight_lab:setAnchorPoint(CCPointMake(0.5,0.5))
	-- -- fight_lab:setScale(0.8);
	-- fight_bg:addChild(fight_lab);

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,item_height-80,260,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	--等级

	local item_level = CCZXLabel:labelWithTextS(CCPointMake(15,item_height-100),"等级：LV."..level,15,ALIGN_LEFT);--tostring(item_data["name"])
	self.view:addChild(item_level);
	--经验
	local exp_str = string.format("秘籍经验: %d/%d",curexp,maxexp)
	local item_exp = CCZXLabel:labelWithTextS(CCPointMake(15,item_height-120),exp_str,15,ALIGN_LEFT);--tostring(item_data["name"])
	self.view:addChild(item_exp);

	--职业
	require "config/StaticAttriType"
	local conds = item_data.conds
	local miji_job =""
	for k,v in pairs(conds) do
		if v.cond == 3 then
			--什么职业的秘籍
			miji_job = jobTypeList[v.value];
		end
	end

	local jop_lab = UILabel:create_lable_2( "职业："..miji_job, 15,item_height-140, 15, ALIGN_LEFT )
	self.view:addChild(jop_lab)

	--对应技能
	local skill_id = MijiConfig:get_skill_id_by_miji_id( self.model_data.item_id )
	local skill_name = SkillConfig:get_skill_name_by_id( skill_id )
	local jop_lab = UILabel:create_lable_2( "对应技能："..skill_name, 15,item_height-160, 15, ALIGN_LEFT )
	self.view:addChild(jop_lab)
	if self.model_data.quality == 4 then
		local exp_str = string.format("修炼值: %d/%d",ceng,chong)
		local item_exp = CCZXLabel:labelWithTextS(CCPointMake(15,item_height-180),exp_str,15,ALIGN_LEFT);--tostring(item_data["name"])
		self.view:addChild(item_exp);
	end

end

function MiJiItemTipView:create( model_data )

	self.model_data = model_data;
	return MiJiItemTipView("MiJiItemTipView","",0,25,280,239);--31

end

-- "秘籍效果：将本秘籍附带在离炎引技能上，
-- 将使离炎引技能的伤害提高$valueB0$%，并额外附加$valueB1$点。
-- #r#cffff00仙炼属性：$multiAttrs$#r#cffff00特殊效果：
-- 对于处于眩晕，减速，定身，沉默的目标，造成额外伤害$valueS0$%。", 

local split = {
	"valueB0","valueB1","multiAttrs","valueS0","valueS1","valueS2",
}

function MiJiItemTipView:comminute_dest(miji_type,desc_str,att_type)
	
	if miji_type  == IS_DIJI_MIJI then

		local str_dest_table = {}
		local str_table = {}
		for i=1,#split do

			str_table = Utils:Split_old(desc_str, split[i])
			if str_table[2] then
				if split[i] == "multiAttrs" then
				--修炼属性
					local attr_name = staticAttriTypeList[att_type]
					str_table[1] = str_table[1]..attr_name.." +"
				end
				table.insert( str_dest_table, str_table[1] )
				desc_str =  str_table[2] 

			else
				desc_str = str_table[1]
			end

		end
		if str_table[2] then
			table.insert( str_dest_table, str_table[2] )
		else
			table.insert( str_dest_table, str_table[1] )
		end
		-- for i=1,#str_dest_table do
		-- 	print(str_dest_table[i])
		-- end
		return str_dest_table
	else --非顶级秘籍
		local str_table = Utils:Split_old(desc_str, "valueB0") 
		return str_table[1]
	end
end