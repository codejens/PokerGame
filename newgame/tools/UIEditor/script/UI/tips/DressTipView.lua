-- DressTipView.lua 
-- createed by fangjiehua on 2013-1-24
-- DressTipView 面板
 
super_class.DressTipView(Window)

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
		return date..LangGameString[1424]; -- [1424]="天"

	else
		return os.date(format_str,(time+MINI_DATE_TIME_BASE));
	end
	
end


function DressTipView:__init( textureName  )
	
	local item_config = ItemConfig:get_item_by_id(self.model_data.item_id);
	-- self.model_data.deadline = nil;

	--到期的时间
	local deadline_height = 0;
	local dead_time;
	
	if self.model_data.deadline ~= nil  and self.model_data.deadline > 0 then
		local time_str = get_deadline_text(LangGameString[431],self.model_data.deadline); -- [431]="%Y年%m月%d日 %H时%M分"
		local dead_time_text = c3_blue..LangGameString[1957]..time_str; -- [1957]="到期时间：#r"
		dead_time = CCDialogEx:dialogWithFile(12, 140,300, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		dead_time:setAnchorPoint(0,1);
		dead_time:setFontSize(15);
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
	if item_config.type == ItemConfig.ITEM_TYPE_FASHION_DRESS then
		--基础属性:
		atrri_lab = CCZXLabel:labelWithText(30,3-deadline_height,c3_yellow..LangGameString[1958],16,ALIGN_LEFT); -- [1958]="基础属性:"
	 
		local attris_text ="";
		--print("show dress tips self.model_data.item_id",self.model_data.item_id)
		local attris = ItemConfig:get_staitc_attrs_by_id(self.model_data.item_id);
		for k,v in pairs(attris) do
			local _type = staticAttriTypeList[v.type];
			attris_text = attris_text..c3_white.._type..": +"..tostring(v.value).."#r";
		end
		attris_desc = CCDialogEx:dialogWithFile(25, 15-deadline_height,UI_TOOLTIPS_RECT_WIDTH-30, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		attris_desc:setAnchorPoint(0,1);
		attris_desc:setFontSize(16);
		attris_desc:setText(attris_text);
		---------------------------昏割线
		dress_split_img = CCZXImage:imageWithFile(10,239-215-deadline_height-dress_height,UI_TOOLTIPS_RECT_WIDTH-20,3,UILH_COMMON.split_line);
		
		--动态高度
		dress_height = attris_desc:getInfoSize().height+35;
	end

	-- 道具描述
	
	local dress_desc_text = c3_blue..item_config.desc;
	local dress_desc = CCDialogEx:dialogWithFile(23, 0,UI_TOOLTIPS_RECT_WIDTH-30, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
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
	local icon_bg = CCZXImage:imageWithFile(13,contentHeight,81,81,UIPIC_ITEMSLOT);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	
	local icon = CCZXImage:imageWithFile(81/2,81/2,64,64,ItemConfig:get_item_icon(self.model_data.item_id));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--是否绑定
	local isbangding = LangGameString[1959]; -- [1959]="未绑定"
	if self.model_data.flag==1 then
		isbangding = LangGameString[1960]; -- [1960]="已绑定"
	end
	local bangding_lab = CCZXLabel:labelWithText(280,contentHeight-37+5,c3_yellow..isbangding,15,ALIGN_RIGHT);
	self.view:addChild(bangding_lab);

	--道具名字
	local dress_name = CCZXLabel:labelWithText(96,contentHeight-37+5,c3_yellow..item_config.name,15,ALIGN_LEFT);
	self.view:addChild(dress_name);

	--需要等级:
	local cond_text ;
	local cond = (item_config.conds)[1];
	if cond ~= nil then
		cond_text = c3_white..LangGameString[1961]..c3_yellow..tostring(cond.value); -- [1961]="需要等级： "
	end
	local dress_cond = CCDialogEx:dialogWithFile(96, contentHeight-46,150, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	dress_cond:setAnchorPoint(0,1);
	dress_cond:setFontSize(15);
	dress_cond:setText(cond_text);
	self.view:addChild(dress_cond);

	--到期的时间,如果deadline为nil，则说这个tip是来自商店的tip
	if dead_time ~= nil and self.model_data.deadline ~= nil then
		dead_time:setPosition(17, contentHeight-79);
		self.view:addChild(dead_time);
	else
		local text;
		if item_config.time == 0 then
			text = c3_white..LangGameString[1962]; -- [1962]="使用时间: 永久"
		else 
			print("时装的使用周期",item_config.time);
			text = c3_white.."使用时间:"..get_deadline_text("%d", item_config.time,true);
		end
		
		local dead_lab = CCZXLabel:labelWithText(80,contentHeight-95, text, 16, ALIGN_LEFT);
		self.view:addChild(dead_lab);
	end
	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,contentHeight-82-deadline_height,UI_TOOLTIPS_RECT_WIDTH-20,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	--人物动画
	local dress_avatar_height = 0;
	local dress_sprite = self:get_dress_animate_sprite(137,contentHeight-187-deadline_height,item_config);
	if dress_sprite then
		dress_avatar_height = 120;
		self.view:addChild(dress_sprite);
		---------------------------昏割线
		local split_img = CCZXImage:imageWithFile(10,contentHeight-201-deadline_height,UI_TOOLTIPS_RECT_WIDTH-20,3,UILH_COMMON.split_line);
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


function DressTipView:get_dress_animate_sprite(x, y, item_config )
	
	local player = EntityManager:get_player_avatar();
	local index = player.job * 2;
	local job_dress = {item_config.shape[index-1],item_config.shape[index]};
	local dress_id = job_dress[player.sex+1];
	print(" 武器时装 ", dress_id);
	if dress_id == 0 then
		return nil;
	else
		if item_config.type == ItemConfig.ITEM_TYPE_FASHION_DRESS then	
			local path = EntityFrameConfig:get_human_path( dress_id );
			ZXLog('-----------DressTipView:get_dress_animate_sprite------------------')
			local action = {0,0,4,0.2};
			return MUtils:create_animation(x,y,path,action );

		elseif item_config.type == ItemConfig.ITEM_TYPE_WEAPON_SHOW then
			print(" 武器时装 ", item_config.type, dress_id);
			local avatar = ShowAvatar:create_wing_panel_avatar( x, y );
			avatar:update_weapon(dress_id);

			return avatar.avatar;
		end
	end
	
end

function DressTipView:create( model_data )
	
	self.model_data = model_data;
	local temp_info = { texture = "", x = 0, y = 25, width = 280, height = 239 }
	return DressTipView("DressTipView", "", true, 280, 239);

end
