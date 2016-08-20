-- mountIconCell.lua
-- created by mwy on 2014-5-3
-- refactored by guozhinan on 2014-9-26
-- 坐骑显示单个icon

super_class.mountIconCell(  )


function mountIconCell:__init( modelId, x, y, width, height, call_back)
    local pos_x = x or 0
    local pos_y = y or 0
    self.width = width or 100
    self.height = height or 100
    self.mount_id = modelId

    self.view = CCBasePanel:panelWithFile( pos_x, pos_y, self.width, self.height, UILH_COMMON.slot_bg2, 500, 500 )
    self.is_selecting = false

    -- 匹配按钮
    local path = string.format("icon/mounts/%05d.pd",self.mount_id);
    self.match_btn = MUtils:create_btn( self.view,path,path,nil,5,5,self.width-10,self.height-10);

    -- 匹配函数
    local function match_btn_click( eventType, args, msgid )
        if TOUCH_CLICK == eventType then
            if call_back and self.lock_icon == nil then
                if self.is_selecting == true and self.mount_id > 100 then
                    local click_pos = Utils:Split(args, ":")
                    local world_pos = self.match_btn:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                    self:show_mounts_tip(world_pos.x, world_pos.y);
                end
                call_back()
            -- else
            --     local mounts_win_new = UIManager:find_window("mounts_win_new")
            --     if mounts_win_new then
            --         local huaxingWin = mounts_win_new:getPage( "huaxing" );
            --         if huaxingWin then
            --             huaxingWin:change_mounts_avatar(self.mount_id);
            --         end
            --     end
            end
        end
        return true;
    end
    self.match_btn:registerScriptHandler(match_btn_click);

    self.select_bg = CCZXImage:imageWithFile(self.width/2, self.height/2, self.width, self.height, UILH_COMMON.slot_focus)
    self.select_bg:setAnchorPoint(0.5,0.5)
    self.select_bg:setIsVisible(false);
    self.view:addChild(self.select_bg, 10)

   return self.view
end

function mountIconCell:set_lock( if_lock )
    if if_lock then
        if self.lock_icon == nil then
            self.lock_icon = CCZXImage:imageWithFile(self.width/2, self.height/2, self.width, self.height,UILH_BAG_AND_CANGKU.wkq)
            self.lock_icon:setAnchorPoint(0.5,0.5)
            self.view:addChild(self.lock_icon, 99)
            self.match_btn:setCurState(CLICK_STATE_DISABLE)
        end
    else
        if self.lock_icon ~= nil then
            self.view:removeChild(self.lock_icon, true)
            self.lock_icon = nil
            self.match_btn:setCurState(CLICK_STATE_UP)
        end
    end
end

function mountIconCell:set_selected( is_selected )
    if is_selected == self.is_selecting then
        return;
    end

    if is_selected then
        self.is_selecting = true
        self.select_bg:setIsVisible(true);
    else
        self.is_selecting = false
        self.select_bg:setIsVisible(false);
    end
end

function mountIconCell:show_mounts_tip(x,y)
    local stagesOther_config = MountsConfig:get_stagesOther_config()
    local cfg = stagesOther_config[self.mount_id-100]
    local mount_id = cfg.modelId
    local color = "#c"..ItemConfig:get_item_color(cfg.nameColor)
    local name_str = cfg.name
    --生命、攻击、法防、物防、暴击
    local attrs = { { type = 17,value = cfg.base[1], },
                        { type = 27,value = cfg.base[2], },
                        { type = 33,value = cfg.base[3], },
                        { type = 23,value = cfg.base[4], },
                        { type = 35,value = cfg.base[5], }, }
    local has_act = false --是否激活
    local dead_line = 0 --到期时间
    for i=1,#MountsModel:get_mounts_info().spc_mounts do
        if MountsModel:get_mounts_info().spc_mounts[i].id ==  mount_id then
            has_act = true
            dead_line = MountsModel:get_mounts_info().spc_mounts[i].dead_line
            break
        end
    end
    -- print("到期时间",dead_line)
    local time_des = Lang.mounts.special_mount[1]--"#cFF0000该坐骑未激活，无法获得该部分属性加成"
    if has_act then
        -- 按策划要求，超过2019年12月17日11时00分的坐骑当成永久坐骑处理，不显示截止时间（策划为了不显示截止时间故意填了截止期很长的时间）
        local time_line = 314276430;    -- MINI_DATE_TIME_BASE加上这个值为2019年12月17日11时00分的时间戳，用这个当标杆线。
        if time_line < dead_line then
            -- 到期时间超过2019年，就显示永久有效
            time_des = Lang.mounts.special_mount[5]; -- [5] = "永久有效！",
        else
            -- "#c00FF00到期时间: ","%Y年%m月%d日 %H时%M分"
            time_des = Lang.mounts.special_mount[2]..Utils:get_custom_format_time(Lang.mounts.special_mount[3] ,dead_line )
        end
    end
    local tip_str = color..name_str.."#r"
                    ..Utils:gen_attr_str(attrs[1]).."#r"
                    ..Utils:gen_attr_str(attrs[2]).."#r"
                    ..Utils:gen_attr_str(attrs[3]).."#r"
                    ..Utils:gen_attr_str(attrs[4]).."#r"
                    ..Lang.mounts.special_mount[4]..cfg.getTips .."#r"  --"获取说明: "
                    ..time_des
    local _data = {}
    _data.str = tip_str
    TipsModel:show_special_mount_tip( x, y, _data )
end