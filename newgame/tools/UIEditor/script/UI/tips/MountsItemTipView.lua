--MountsItemTipView 特殊坐骑的道具tip

 
super_class.MountsItemTipView(Window)

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";
local c3_purple = "#cff66cc";

--获取到期时间
local function get_deadline_text(format_str ,deadline, is_config_time )
	--[1] = 54443, [3] = 44851, [4] = 44852 为使用后计时，[2] = 34878,为下发即计时
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


function MountsItemTipView:__init(  )
	local item_config = ItemConfig:get_item_by_id(self.model_data.item_id);
	--到期的时间
	local deadline_height = 0
	local dead_time;
	-- 判定开始计时方式
	-- local time_type_cfg = MountsConfig:get_config().timeType --openItemId道具获取后不计时  getItmeId道具获取后立即倒计时
	-- local time_type = 0 --1=道具获取后不计时 2=道具获取后立即倒计时
	-- for i,v in ipairs(time_type_cfg.openItemId) do
	-- 	if v == self.model_data.item_id then
	-- 		time_type = 1
	-- 		break
	-- 	end
	-- end
	-- for j,e in ipairs(time_type_cfg.getItmeId) do
	-- 	if e == self.model_data.item_id then
	-- 		time_type = 2
	-- 		break
	-- 	end
	-- end
	local time_type = 1;

	--有时限时装
	if self.model_data.deadline ~= nil and self.model_data.deadline > 0 then
		local dead_time_text = nil

		if time_type == 2 then
			local time_str = get_deadline_text(LangGameString[431],self.model_data.deadline); -- [431]="%Y年%m月%d日 %H时%M分"
			dead_time_text = c3_blue..LangGameString[1957]..time_str; -- [1957]="到期时间：#r"
		else
			local count_days = ItemConfig:get_item_by_id(self.model_data.item_id).time/3600/24
			dead_time_text = c3_blue.."到期时间："..c3_white..string.format("使用后%d天",count_days)
		end

		dead_time = CCDialogEx:dialogWithFile(12, 134,300, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		dead_time:setAnchorPoint(0,1);
		dead_time:setFontSize(15);
		dead_time:setText(dead_time_text);

		deadline_height = 42;
	end
	--如果deadline为nil，则说这个tip是来自商店的tip
	if self.model_data.deadline == nil or self.model_data.deadline == 0 then
		deadline_height = 42;
	end

	-- 描述
	local dress_desc_text = c3_blue..item_config.desc;
	local dress_desc = CCDialogEx:dialogWithFile(18, 0-79,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	dress_desc:setAnchorPoint(0,1);
	dress_desc:setFontSize(16);
	dress_desc:setText(dress_desc_text);
	local desc_height = dress_desc:getInfoSize().height;
	dress_desc:setPosition(18, desc_height);
	self.view:addChild(dress_desc);

	--属性描述
	local cfg   = MountsModel:get_spe_mounts_info_by_item_id(self.model_data.item_id)
	local attrs = {	{ type = 17,value = cfg.base[1], },
					{ type = 27,value = cfg.base[2], },
					{ type = 33,value = cfg.base[3], },
					{ type = 23,value = cfg.base[4], },
					{ type = 35,value = cfg.base[5], },	}
	local attrs_str = Utils:gen_attr_str(attrs[1]).."#r"
					..Utils:gen_attr_str(attrs[2]).."#r"
					..Utils:gen_attr_str(attrs[3]).."#r"
					..Utils:gen_attr_str(attrs[4])
	local attrs_dia = CCDialogEx:dialogWithFile(18, desc_height,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	attrs_dia:setAnchorPoint(0,1);
	attrs_dia:setFontSize(16);
	attrs_dia:setText(attrs_str);
	local attrs_height = attrs_dia:getInfoSize().height;
	attrs_dia:setPosition(18, desc_height + attrs_height + 20);
	self.view:addChild(attrs_dia);

	--计算动态高度
	local contentHeight = 250+deadline_height+desc_height + attrs_height
	self.view:setSize(280,contentHeight);
	self.view:setPosition(0,239-contentHeight+25);

	-------------图标icon
	local icon_bg = CCZXImage:imageWithFile(10,contentHeight-5,72,72,UILH_NORMAL.item_bg2);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	
	local icon = CCZXImage:imageWithFile(72/2,72/2,60,60,ItemConfig:get_item_icon(self.model_data.item_id));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--是否绑定
	local isbangding = LangGameString[1959]; -- [1959]="未绑定"
	if self.model_data.flag==1 then
		isbangding = LangGameString[1960]; -- [1960]="已绑定"
	end
	local bangding_lab = CCZXLabel:labelWithText(300,contentHeight-45,c3_yellow..isbangding,15,ALIGN_RIGHT);
	self.view:addChild(bangding_lab);

	--道具名字
	local name_str = nil
	name_str = c3_yellow..item_config.name
	local dress_name = CCZXLabel:labelWithText(85,contentHeight-45,name_str,15,ALIGN_LEFT);
	self.view:addChild(dress_name);


	--到期的时间,如果deadline为nil，则说这个tip是来自商店的tip
	if dead_time ~= nil and self.model_data.deadline ~= nil then
		dead_time:setPosition(17, contentHeight-85);
		self.view:addChild(dead_time);
	else
		local text;
		if item_config.time == 0 then
			text = c3_white..LangGameString[1962]; -- [1962]="使用时间: 永久"
		else 
			text = c3_white..LangGameString[1963]..get_deadline_text("%d", item_config.time,true);
		end
		
		local dead_lab = CCZXLabel:labelWithText(80,contentHeight-95, text, 16, ALIGN_LEFT);
		self.view:addChild(dead_lab);
	end

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(4,contentHeight-82-deadline_height,280,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);
	
	--动画
	local dress_avatar_height = 120
	local mounts_model_id = MountsModel:get_spe_mounts_model_id_by_item_id( self.model_data.item_id )
	local mount_file = string.format("frame/mount/%d",mounts_model_id)
	local action = {0,0,4,0.2}
	local mounts_avatar =  MUtils:create_animation(132,contentHeight - 223,mount_file,action )
	mounts_avatar:setScale(0.7)
	mounts_avatar:setAnchorPoint(0.5,0.5)
	self.view:addChild(mounts_avatar)

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(4,contentHeight-181-45-deadline_height,280,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

end


function MountsItemTipView:get_dress_animate_sprite(x, y, item_config )
	
	local player = EntityManager:get_player_avatar();
	local index = player.job * 2;
	local job_dress = {item_config.shape[index-1],item_config.shape[index]};
	local dress_id = job_dress[player.sex+1];
	-- print(" 武器时装 ", dress_id);
	if dress_id == 0 then
		return nil;
	else
		if item_config.type == ItemConfig.ITEM_TYPE_FASHION_DRESS then	
			local path = EntityFrameConfig:get_human_path( dress_id );
			local action = {0,0,4,0.2};
			return MUtils:create_animation(x,y,path,action );

		elseif item_config.type == ItemConfig.ITEM_TYPE_WEAPON_SHOW then
			-- print(" 武器时装 ", item_config.type, dress_id);
			local avatar = ShowAvatar:create_wing_panel_avatar( x, y );
			avatar:update_weapon(dress_id);

			return avatar.avatar;
		end
	end
	
end

function MountsItemTipView:create( model_data )
	
	self.model_data = model_data;
	return MountsItemTipView("MountsItemTipView","",0,25,280,239);
end
