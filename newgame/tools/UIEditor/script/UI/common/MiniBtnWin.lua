-- MiniBtnWin.lua
-- created by hcl on 2013/2/20
-- 屏幕中间弹出的小按钮，例如:别人向你发送双修邀请时，会从左往右飘出一个修字

require "UI/component/Window"
require "utils/MUtils"
super_class.MiniBtnWin(Window)

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _winShowY = {205, 125}

local btn_table = {};
local btn_text_table = {};

local animation_time = 1;

--是否回调自动删除按钮  added by xiehande 2015-2-9
--为了处理 几个不同协议相同请求出现网络数据返回有先后的延时问题
--如遇到这种情况，只需设置 该字段为false 如 天将雄师版本的福字按钮下发
--不过使用之后 remove按钮动作需要主动触发并还原标志位为true
local auto_remove_flag = true

function MiniBtnWin:set_aoto_remove_flag( flag)
    auto_remove_flag = flag
end


function MiniBtnWin:get_aoto_remove_flag( )
    return  auto_remove_flag;
end

--local screen_icon_timer = timer();

-- btn_text_type 是字的type,1友2贺3斗4花5欢6技7聊8灵9骑10修11药12易13宗14信15队16征19离20福23装
-- cb 就是回调 如果没有cb会根据btn_text_type调用默认的回调
-- param 是参数 按钮右下角的数字,一般不用填
-- 
function MiniBtnWin:show( btn_text_type , cb_fun ,param )
    -- 玩家在新手体验副本中时,不弹出提示按钮
    local curSceneId = SceneManager:get_cur_scene()
    if curSceneId == 27 then
        return
    end
    --暂时屏蔽'福'字按钮
    if btn_text_type == 20 then
        --return
    end
    -- 创建通用购买面板
    local win = UIManager:show_window("mini_btn_win");
    if ( win ) then
        win:create_btn( btn_text_type , cb_fun ,param );
    end
end

-- 根据菜单是否显示调整窗口位置
function MiniBtnWin:miniBtnWinRepos( is_menus_show )
    local win = UIManager:show_window("mini_btn_win")
    if ( win ) then
        if is_menus_show then
            local p = CCPointMake(_refWidth(0.5),_winShowY[1])
            win.view:runAction(CCMoveTo:actionWithDuration(0.3,p))   
        else
            local p = CCPointMake(_refWidth(0.5),_winShowY[2])
            win.view:runAction(CCMoveTo:actionWithDuration(0.3,p))    
        end
    end
end

function MiniBtnWin:__init()

    -- local function panel_fun(eventType,x,y)
    --     return false
    -- end
    -- self.view:registerScriptHandler(panel_fun);
    self.view:setDefaultMessageReturn(false)
    self.dissmiss_callback = callback:new()
end

function MiniBtnWin:create_btn( btn_text_type , cb_fun ,param )

    local is_already_exist,index = MiniBtnWin:is_already_exist( btn_text_type );

    if ( is_already_exist ) then
        if ( param and btn_text_table[index] ) then 
            btn_text_table[index]:setText(tostring(param));
        end
    else

        if ( cb_fun == nil ) then
            cb_fun = self:get_cb_fun_by_btn_text_type( btn_text_type )
        end

        local btn_index = 1;
        -- print("btn_index",btn_index,btn_text_type)
        local function btn_fun( eventType,arg,msg_id )
            if  eventType == TOUCH_BEGAN then
                return true;
            elseif eventType == TOUCH_CLICK then
                if ( cb_fun ) then
                    cb_fun();
                end
                -- 去掉按钮然后重新布局
                if self:get_aoto_remove_flag() then
                   self:remove_btn_and_layout( tostring(btn_text_type) );
                end

                return false;  
            end
            return true
        end

        local btn =  MUtils:create_btn(self.view,UILH_COMMON.b_bg_n,UILH_COMMON.b_bg_n,btn_fun,0,0,63,62);
        table.insert(btn_table,1,btn)
        btn:setDataInfo(tostring(btn_text_type));
        MUtils:create_sprite(btn,UILH_MINIBTN[tonumber(btn_text_type)],63/2,62/2);
        if ( param ) then
           local text =  MUtils:create_zxfont(btn,tostring(param),45,5,2,15);
           table.insert(btn_text_table,1,text);
        else
           local text =  MUtils:create_zxfont(btn,"",30,5,2,14);
           table.insert(btn_text_table,1,text);
        end

        -- 移动动画
        self:move_btn()
    end
    
end

-- 如果没有传cb进来会有一个默认的cb
function MiniBtnWin:get_cb_fun_by_btn_text_type( btn_text_type )
    if ( btn_text_type == 1 ) then
    elseif ( btn_text_type == 2 ) then
    elseif ( btn_text_type == 3 ) then
    elseif ( btn_text_type == 4 ) then
    end
end
-- 字从左到右的Action
function MiniBtnWin:move_btn()
    -- local pos_x = 0;
    -- if ( #btn_table == 1 ) then
    --     pos_x = 177.5;
    -- else
    --     pos_x = btn_table[#btn_table-1]:getPosition() ;
    --     print("pos_x = ",pos_x);
    --     pos_x = pos_x - 55;
    -- end

    local pos_x = MiniBtnWin:calculate_pos();
    -- print("=====pos_x========", pos_x)
    local action = CCMoveTo:actionWithDuration(animation_time,CCPoint(pos_x,0));
    btn_table[1]:setPosition(0,0);
    btn_table[1]:runAction(action);

    self.dissmiss_callback:cancel()


    -- 三秒后消失
    local function cb( dt )
         -- 重新布局 
        self:layout();
    end
    self.dissmiss_callback:start(animation_time+0.1, cb)

end

-- 去掉按钮然后重新布局
function MiniBtnWin:remove_btn_and_layout( btn_data_info )
    local btn_index = -1;
    for i=1,#btn_table do
        if ( tonumber(btn_table[i]:getDataInfo()) == tonumber(btn_data_info) ) then
            btn_index = i;
            break;
        end
    end

    if ( btn_index ~= -1 ) then
        -- print("MiniBtnWin:remove_btn_and_layout( btn_data_info )",btn_data_info,btn_index)
        btn_table[btn_index]:removeFromParentAndCleanup(true);
        table.remove(btn_table,btn_index);
        table.remove(btn_text_table,btn_index);
        if ( #btn_table > 0) then
            self:layout();
        end 
    end
    -- 如果没有按钮就hide_window
    if ( #btn_table <= 0 ) then
        UIManager:hide_window("mini_btn_win");
    end

end

function MiniBtnWin:layout()
    -- 是否是偶数
    local is_even = #btn_table %2 
    -- print("is_even = ",is_even,#btn_table)
    if ( is_even == 0 ) then
        local half_len = #btn_table/2;
        for i=1,#btn_table do
            local pos_x = (i-half_len)*70 -  27.5 + 177.5-15
            -- print("pos_x = ",pos_x,btn_table[i]:getDataInfo(),btn_table[i])
            btn_table[i]:setPosition( pos_x,0);
        end
    else
        local half_len = math.floor(#btn_table/2 + 0.5);
        for i=1,#btn_table do
            btn_table[i]:setPosition( (i-half_len)*70 + 177.5 -15,0);
        end
    end
end

function MiniBtnWin:calculate_pos()
    local len = #btn_table;
    if ( len == 1 ) then
        return 177.5-15
    elseif ( len == 2 ) then
        return 150-15
    elseif ( len == 3 ) then
        return 122.5-15
    elseif ( len == 4 ) then
        return 95-15
    elseif ( len == 5 ) then
        return 67.5-15
    elseif ( len == 6 ) then
        return 40-15
    elseif (len > 6 ) then
        return (40-27.5*(len-6))-15
    end

end

function MiniBtnWin:is_already_exist( btn_text_type )
    for i=1,#btn_table do
        if ( btn_table[i]:getDataInfo() == tostring( btn_text_type ) ) then
            -- print("btn_table[i]:getDataInfo()",btn_table[i]:getDataInfo(),tostring( btn_text_type ),i)
            return true,i;
        end
    end
    return false;
end

function MiniBtnWin:destroy()

    Window.destroy(self);
    btn_table = {};
    btn_text_table = {};
end

-- function MiniBtnWin:flash_icon(target_item)
--     -------------------------
--     if target_item == nil then
--         return
--     end
--     -------------------------
--     if target_item:getIsVisible() == true then
--         target_item:setIsVisible(false)
--     else
--         target_item:setisVisible(true)
--     end
-- end

-- function MiniBtnWin:flash_begin_timer_fun()
--     screen_icon_timer:star(t_screen_icon,flash_icon)
-- end

-- function MiniBtnWin:flash_end_timer_fun()
--     screen_icon_timer:stop()
-- end