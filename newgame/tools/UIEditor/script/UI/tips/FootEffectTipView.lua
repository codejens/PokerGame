-- DressTipView.lua 
-- createed by fangjiehua on 2013-1-24
-- DressTipView 面板
 
super_class.FootEffectTipView(Window)

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";
local c3_purple = "#cff66cc";

--获取到期时间
local function get_deadline_text(format_str ,deadline, is_config_time )
    -- 1296000  这个数值， 是衣服下发的到期时间默认值。 当下发这个的时候。表示未开始计时。
	if deadline - 1296000 == 0 then 
        return "还未开始计时"
    end
 
	local time;
	if deadline > 0x80000000 then
		time = deadline-2147483648;
	else
		time = deadline;
	end
	-- print("30天,秒数",time+MINI_DATE_TIME_BASE);
	if is_config_time then

		local date = os.date(format_str,(time+MINI_DATE_TIME_BASE-86400));
		local date = tonumber(date);
		return date.."天";

	else
		return os.date(format_str,(time+MINI_DATE_TIME_BASE));
	end
	
end


function FootEffectTipView:__init( textureName  )
	
	local item_config = ItemConfig:get_item_by_id(self.model_data.item_id);
	-- self.model_data.deadline = nil;

	--到期的时间
	local deadline_height = 0;
	local dead_time;
	
	if self.model_data.deadline ~= nil  and self.model_data.deadline > 0 then
		local time_str = get_deadline_text("%Y年%m月%d日 %H时%M分",self.model_data.deadline);
		local dead_time_text = c3_blue.."到期时间：#r"..time_str;
		dead_time = CCDialogEx:dialogWithFile(12, 239-80-15,300, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		dead_time:setAnchorPoint(0,1);
		dead_time:setFontSize(13);
		dead_time:setText(dead_time_text);

		deadline_height = 42;
	end
	--如果deadline为nil，则说这个tip是来自商店的tip
	if self.model_data.deadline == nil or self.model_data.deadline == 0 then
		deadline_height = 20;
	end

	--如果是衣服时装，则附加属性
	local dress_height = 0;
	local attris_desc;
	local atrri_lab;
	local dress_split_img;
	if item_config.type == ItemConfig.ITEM_TYPE_ZUJI then
		--基础属性:
		atrri_lab = CCZXLabel:labelWithText(30,239-236-deadline_height,c3_yellow.."基础属性:",16,ALIGN_LEFT);
	 
		local attris_text ="";
		print("show dress tips self.model_data.item_id",self.model_data.item_id)
		local attris = ItemConfig:get_staitc_attrs_by_id(self.model_data.item_id);
		for i = 1, #attris do
			local v = attris[i]
		--for k,v in pairs(attris) do
			local _type = staticAttriTypeList[v.type];
			if v.type == 28 or v.type == 24 or v.type == 34 or v.type == 18 then
				attris_text = attris_text..c3_white.._type..": +"..tostring(v.value * 100) .. "%" .."#r";
			else
				attris_text = attris_text..c3_white.._type..": +"..tostring(v.value).."#r";
			end
		end
		attris_desc = CCDialogEx:dialogWithFile(25, 239-224-deadline_height,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		attris_desc:setAnchorPoint(0,1);
		attris_desc:setFontSize(16);
		attris_desc:setText(attris_text);
		---------------------------昏割线
		dress_split_img = CCZXImage:imageWithFile(4,239-215-deadline_height-dress_height,280,2,UIResourcePath.FileLocate.common .. "fenge_bg.png");
		
		--动态高度
		dress_height = attris_desc:getInfoSize().height+35;
	end

	-- 道具描述
	
	local dress_desc_text = c3_blue..item_config.desc;
	local dress_desc = CCDialogEx:dialogWithFile(23, 0,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	dress_desc:setAnchorPoint(0,1);
	dress_desc:setFontSize(16);
	dress_desc:setText(dress_desc_text);
	local desc_height = dress_desc:getInfoSize().height;

-- 

	--计算动态高度
	local contentHeight = 215+deadline_height+dress_height+desc_height;
	self.view:setSize(280,contentHeight);
	self.view:setPosition(0,239-contentHeight+25);

	-------------图标icon
	local icon_bg = CCZXImage:imageWithFile(20,contentHeight-5,72,72,UIPIC_ITEMSLOT);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	
	local icon = CCZXImage:imageWithFile(72/2,72/2,58,58,ItemConfig:get_item_icon(self.model_data.item_id));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--是否绑定
	local isbangding = "未绑定";
	if self.model_data.flag==1 then
		isbangding = "已绑定";
	end
	local bangding_lab = CCZXLabel:labelWithText(280-20,contentHeight-37+5,c3_yellow..isbangding,15,ALIGN_RIGHT);
	self.view:addChild(bangding_lab);

	--道具名字
	local dress_name = CCZXLabel:labelWithText(80,contentHeight-37+5,c3_yellow..item_config.name,15,ALIGN_LEFT);
	self.view:addChild(dress_name);

	--需要等级:
	local cond_text ;
	local cond = (item_config.conds)[1];
	if cond ~= nil then
		cond_text = c3_white.."需要等级： "..c3_yellow..tostring(cond.value);
	end
	local dress_cond = CCDialogEx:dialogWithFile(80, contentHeight-46,150, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	dress_cond:setAnchorPoint(0,1);
	dress_cond:setFontSize(16);
	dress_cond:setText(cond_text);
	self.view:addChild(dress_cond);

	--到期的时间,如果deadline为nil，则说这个tip是来自商店的tip
	if dead_time ~= nil and self.model_data.deadline ~= nil then
		dead_time:setPosition(17, contentHeight-75);
		self.view:addChild(dead_time);
	else
		local text;
		if item_config.time == 0 then
			text = c3_white.."使用时间: 永久";
		else 
			print("时装的使用周期",item_config.time);
			text = c3_white.."使用时间:"..get_deadline_text("%d", item_config.time,true);
		end
		
		local dead_lab = CCZXLabel:labelWithText(80,contentHeight-95, text, 16, ALIGN_LEFT);
		self.view:addChild(dead_lab);
	end
	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(4,contentHeight-82-deadline_height,280,2,UIResourcePath.FileLocate.common .. "fenge_bg.png");
	self.view:addChild(split_img);

	--人物动画
	local dress_avatar_height = 0;
	local dress_sprite = self:get_dress_animate_sprite(137,contentHeight-187-deadline_height,item_config);
	if dress_sprite then
		dress_avatar_height = 120;
		self.view:addChild(dress_sprite);
		---------------------------昏割线
		local split_img = CCZXImage:imageWithFile(4,contentHeight-201-deadline_height,280,2,UIResourcePath.FileLocate.common .. "fenge_bg.png");
		self.view:addChild(split_img);
	end
	

	--如果是衣服时装，则附加属性
	if attris_desc ~= nil then
		atrri_lab:setPosition(24,contentHeight-106-deadline_height-dress_avatar_height);
		self.view:addChild(atrri_lab);	

		attris_desc:setPosition(33, contentHeight-94-deadline_height-dress_avatar_height-15);
		self.view:addChild(attris_desc);

		dress_split_img:setPosition(4,contentHeight-85-deadline_height-dress_height-dress_avatar_height)
		self.view:addChild(dress_split_img);
	end

	--时装描述
	dress_desc:setPosition(18, contentHeight-76-deadline_height-dress_height-dress_avatar_height-15);
	self.view:addChild(dress_desc);

end


function FootEffectTipView:get_dress_animate_sprite(x, y, item_config )
	
	local player = EntityManager:get_player_avatar();
	local index = player.job * 2;
	local job_dress = {item_config.shape[index-1],item_config.shape[index]};
	local dress_id = job_dress[player.sex+1];
	print(" 武器时装 ", dress_id);
	if item_config.type ~= ItemConfig.ITEM_TYPE_ZUJI then
		return nil;
	else
		local temp_id = effect_config:id_to_effect_file_id(item_config.id)
		local file = string.format("%s%d","frame/footsteps/",temp_id)
		print("file", file)
		local icon = ZXAnimation:createWithFileName(file)
		icon:replaceZXAnimationAction(0, 0, 15, 0.12)
		icon:setDefaultAction(0)
		--local fistframe = string.format("%s%s", file, "/00000.png")
		local foot_effect = ZXAnimateSprite:createWithFileAndAnimation("", icon)
		tempnode = CCNode:node()
		tempnode:addChild(foot_effect)
		tempnode:setPosition(CCPointMake(x,y + 40))
		return tempnode
	end	
end

function FootEffectTipView:create( model_data )
	
	self.model_data = model_data;

	return FootEffectTipView("DressTipView","", true, 280, 239);

end