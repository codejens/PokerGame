
super_class.UserBuffTips(Window)

local _scroll_info = {}
local buff_time_table = {}
--销毁当前的窗口
local function hideTipWin(eventType,x,y )
    for i, timer_lab in ipairs(buff_time_table or {}) do
        if timer_lab then
            timer_lab:destroy();
            timer_lab = nil
        end
    end
	if eventType == TOUCH_CLICK then
		UIManager:destroy_window("user_buff_tips");
	end
	return true;
end


function UserBuffTips:scroll_create_fun(index)
    local panel_height = 50*#_scroll_info - 3
	local base_panel = ZBasePanel:create( nil, nil, 0, 0, 210, panel_height )
    local cur_y = panel_height-50
    for i, cur_info in ipairs(_scroll_info) do
        local icon_path = string.format("icon/buff/%05d.jd",cur_info.buff_type)
        local buff_bg = ZImage:create(base_panel, UILH_MAIN.buff_bg, 11, cur_y+8, 38, 38)
        local buff_img = ZImage:create(buff_bg, icon_path, 3, 3, 32, 32)
        local desc_info = UserBuffTips:get_desc( cur_info.buff_type, cur_info.buff_value ,cur_info.buff_name,cur_info.buff_group)
        -- local buff_desc = ZLabel:create(base_panel, "", 53, panel_height-50*i+32, 12)
        local buff_desc = CCDialogEx:dialogWithFile(53, cur_y+49, 155, 0, 8,"",TYPE_VERTICAL,ADD_LIST_DIR_UP);
        base_panel:addChild(buff_desc)
        buff_desc:setFontSize(12);
        buff_desc:setAnchorPoint(0.0, 1.0)
        buff_desc:setText(desc_info)
        local sz = buff_desc:getSize()
        buff_desc:setSize(sz.width, sz.height)
        local dy = 0
        -- 有2行的特殊处理,因无法获取有多少行,这里不精确处理偏移y值, 15为每行的高,根据fontsize变化
        if sz.height >= 30 then
            local count = math.floor(sz.height/15)
            dy = sz.height*(count-1) / count
            cur_y = cur_y - dy
            buff_bg:setPosition(11, cur_y + 8 + dy/2)
        end
        local line = ZImage:create(base_panel, UILH_COMMON.split_line, 12, cur_y, 196, 2, nil, 500)
        local time_info = cur_info.alive_time - BuffModel:get_past_time(cur_info.buff_type, cur_info.buff_group)
        if time_info > 0 then
            local timer_lab = TimerLabel:create_label(base_panel, 53, cur_y+12, 12, time_info, "#c0edc09", nil,nil);
            buff_time_table[#buff_time_table + 1] = timer_lab
        end
        cur_y = cur_y - 50
    end
	return base_panel
end

function UserBuffTips:getIncText( buff_type, value,buff_group)

    -- 天将雄师，以下是秘籍产生的buff，需要特殊处理为相反数（对部分秘籍buff进行相反数据处理，服务器有时候会下发相反数，真是坑爹） add by gzn
    if( buff_group ~= nil) then
        if (buff_group == 80 and buff_type == 49) or (buff_group == 80 and buff_type == 51) or (buff_group == 80 and buff_type == 47) then
            if ( value < 0 ) then
                return "+"
            else
                return "-"
            end
        end
    end

    if ( buff_type == 15 or buff_type == 16 or buff_type == 21 or buff_type == 22 or buff_type == 31 or buff_type == 32 or buff_type == 27 or buff_type == 28) then
        if ( value < 0 ) then
            return "-"
        else
            return "+"
        end
    else
        if ( value < 0 ) then
            return "-"
        else
            return "+"
        end
    end
end

function UserBuffTips:get_desc( buff_type, value ,name,buff_group)
    local buff_str = BuffConfig:get_buff_desc_by_buff_id( buff_type )

    -- 应该先计算符号再取绝对值 modified by gzn
    local inc_str = self:getIncText( buff_type, value,buff_group)

    value = math.abs(value)

    -- print('>>>', buff_type,  inc_str,  buff_str)
    buff_str = string.gsub( buff_str,"#inc#",inc_str );
   -- print(">>>", buff_str);
    buff_str = string.gsub( buff_str,"<BR>"," " );
   -- print(">>>", buff_str);

    -- 秘籍系统。对于增加攻速系列的buff，服务器发过来的大于1的数又要转为百分数，所以只能除以100特殊处理为百分数。 add by gzn
    if( buff_group ~= nil) then
        -- 增加攻速的buff
        if (buff_group == 80 and buff_type == 47) then
            value = value/100
        end
    end

    -- 小于1的数字都变成百分比形式
    if ( value < 1 ) then
        -- 小于1%的数值，则额外再去取两位小数 add by gzn
        local tmp_value = math.floor( value * 100 )
        if tmp_value <= 0 then
            value = (math.floor( value * 10000 )/100) .. "%%";
        else
            value = math.floor( value * 100 ) .. "%%";
        end
    end

    buff_str = string.gsub( "#cfff000"..buff_str,"#value#","#cffffff"..value );
   -- print(">>>", buff_str);
    return buff_str;
end

function UserBuffTips:__init(window_name)
    local tips_panel = CCBasePanel:panelWithFile(70, 360, 238, 180, UILH_COMMON.bg_04, 500, 500)
	self.view:addChild(tips_panel)
    buff_view_table = {}
	self.scroll = ZScroll:create(nil, nil, 11, 15, 210, 147, 1, TYPE_HORIZONTAL)
	self.scroll:setScrollCreatFunction( self.scroll_create_fun )
 --    self.scroll = CCScroll:scrollWithFile( 11, 15, 180, 147, 1, "", TYPE_HORIZONTAL )
	--     local function scrollfun(eventType, args, msg_id)
 --        if eventType == nil or args == nil or msg_id == nil then 
 --            return
 --        end
 --        if eventType == TOUCH_BEGAN then
 --            return true
 --        elseif eventType == TOUCH_MOVED then
 --            return true
 --        elseif eventType == TOUCH_ENDED then
 --            return true
 --        elseif eventType == SCROLL_CREATE_ITEM then
 --            -- local temparg = Utils:Split(args,":")
 --            -- local row = temparg[1] +1             -- 行
 --            -- 每行的背景panel
 --            self.scroll_item_panel = CCBasePanel:panelWithFile(0, 0, 180, 50,"", 600, 600);
 --            self.scroll:addItem(self.scroll_item_panel);
 --            self.scroll:refresh();
 --            return false
 --        end
 --    end
 --    self.scroll:registerScriptHandler(scrollfun);
 --    self.scroll:refresh()
 --    self.scroll_item_panel:setAnchorPoint( 0, 1 )

	tips_panel:addChild( self.scroll.view )
	self.view:registerScriptHandler(hideTipWin)
end

function UserBuffTips:update(info)
	_scroll_info = info
    for i, timer_lab in ipairs(buff_time_table or {}) do
        if timer_lab then
            timer_lab:destroy();
            timer_lab = nil
        end
    end
	self.scroll:clear()
    if #_scroll_info > 0 then
	   self.scroll:refresh()
    end
end

function UserBuffTips:destroy(  )
	Window.destroy(self)
	_scroll_info = {}
end