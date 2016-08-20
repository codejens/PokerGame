-- ResurrectionDialog.lua
-- created by hcl on 2013/1/8
-- 复活窗口

super_class.ResurrectionDialog(Window)

local panel = nil; 

local l_m,b_m = 235,140;

local _isUseFuhuoshi = true;

local start_time = 0;
local end_time = 0;

function ResurrectionDialog:show(killer_name)
    -- 创建复活窗口
   local win =  UIManager:show_window("resurrection_dialog");
   if ( win ) then
        if killer_name ~= nil then
   		   win.kill_title:setText(Lang.resurrection.model[1]..killer_name..Lang.resurrection.model[2]); -- [1813]="#cfff000您已经被#cff0000" -- [1814]="#cfff000杀死"
        end
   		win.time:setText(Lang.resurrection.model[3]); -- [1815]="#cff00002分0秒#cfff000后将自动在复活点复活"
        if win._timer then
            win._timer:stop()
        end
        win._timer = timer();
        start_time = math.floor(os.clock());
        end_time = start_time + 120;
        local function dismiss()
            local _time = end_time - math.floor(os.clock())
            win:update_time( _time );
            if ( _time <= 0 ) then
                -- 似乎不用发协议，服务器自动帮你复活了
                --MiscCC:req_relive(1)
                UIManager:hide_window("resurrection_dialog");
            end
           -- print("dismiss,_time ",_time);
        end
        win._timer:start(1,dismiss)

        local is_use_fuhuoshi = SetSystemModel:get_date_value_by_key( SetSystemModel.COST_RELIVE );
        _isUseFuhuoshi = is_use_fuhuoshi;
       -- print("is_use_fuhuoshi == ",is_use_fuhuoshi);
        win.use_fuhuoshi.set_state(is_use_fuhuoshi)
   end
end
-- 228,124,330,226 
function ResurrectionDialog:__init(window_name, texture_name, is_grid, width, height,title_text)
	panel = self.view;
   -- local spr_bg = CCZXImage:imageWithFile( 0, 0, 440, 300, UILH_COMMON.bg_04,500,500 );
   -- panel:addChild(spr_bg)
    -- 复活提示框外框
    --panel:addChild( CCZXImage:imageWithFile( 0, 0, 440, 300, UILH_COMMON.bg_03, 500, 500 ) );
    
    -- 复活提示框内层阴影框
   panel:addChild( CCZXImage:imageWithFile( panel:getSize().width/2 - 410/2, 72, 410, 190, UILH_COMMON.bottom_bg, 500, 500 ) )

  --标题背景
    local title_bg = ZImage:create( panel, UIPIC_COMMOM_title_bg, 0, 0, -1, 60 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( panel:getSize().width - title_bg_size.width ) / 2, panel:getSize().height - title_bg_size.height/2-14)
    

    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    local window_title = ZImage:create(title_bg, UILH_NORMAL.title_tips , t_width/2,  t_height-27, -1,-1,999 );
    window_title.view:setAnchorPoint(0.5,0.5)

    -- 文字1，你被xxx杀死
    self.kill_title = MUtils:create_zxfont(panel,Lang.resurrection.model[4],0,207,2,16); -- [1816]="您已经被(xxx)击杀"
    local kill_width =  self.kill_title:getSize().width
    self.kill_title:setPosition(440/2 -kill_width/2+60,207)
    self.time = MUtils:create_zxfont(panel,"",0,165,2,16);
    local time_width = self.time:getSize().width
    self.time:setPosition(440/2-time_width/2,173)

    -- 是否使用保护珠
    local function use_fuhuoshi_fun( if_selected )
        _isUseFuhuoshi = if_selected;
      --  print("_isUseFuhuoshi",_isUseFuhuoshi);
        SetSystemModel:set_one_date( SetSystemModel.COST_RELIVE, _isUseFuhuoshi )
    end

    --是否使用还原丹按钮
    self.use_fuhuoshi = UIButton:create_switch_button(60,105, 300,50, UILH_COMMON.dg_sel_1,UILH_COMMON.dg_sel_2,Lang.resurrection.model[5], 32, 16, nil, nil, nil, nil, use_fuhuoshi_fun ) -- [1817]="没有还原丹使用10元宝替换"
    self.use_fuhuoshi.words:setPosition(37,10)
    self.view:addChild(self.use_fuhuoshi.view,5);
    -- local function btn_ok_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
    local function btn_ok_fun()
        UIManager:hide_window("resurrection_dialog");
        require "control/MiscCC"
        local money_type = MallModel:get_only_use_yb() and 3 or 2
        MiscCC:req_relive(1, money_type)
        return true
    end

-- 121, 53
    -- self.btn1 = MUtils:create_btn(panel,UILH_COMMON.btn4_nor, UILH_COMMON.btn4_nor,btn_ok_fun, 50, 15,-1,-1);
    -- local btn1_width = self.btn1:getSize().width
    -- local btn1_height = self.btn1:getSize().height
    -- -- 复活点复活
    -- local btn1_content = UILabel:create_lable_2( Lang.resurrection.model[11], 20, 22, 16, ALIGN_CENTER )
    -- local content_width =  btn1_content:getSize().width
    -- local content_height = btn1_content:getSize().height
    -- print("-------------content_height:", content_height)
    -- btn1_content:setPosition(btn1_width*0.5, (btn1_height-content_height)*0.5)
    -- self.btn1:addChild( btn1_content )
    --MUtils:create_sprite(self.btn1,UIResourcePath.FileLocate.other .. "res_t2.png",65.5,21)
    self.btn1 = ZTextButton:create( panel, LH_COLOR[2] ..Lang.resurrection.model[11], UILH_COMMON.lh_button_4_r, btn_ok_fun, 50, 15, -1, -1, 1)

    -- local function btn_cancel_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    local function btn_cancel_fun()
         MallModel:set_only_use_yb( true )    --更改为优先使用元宝

        local fuhuoshi_count = ItemModel:get_item_count_by_id( 18600 );
        if ( fuhuoshi_count > 0) then  --有还原丹
            require "control/MiscCC"
           -- local money_type = MallModel:get_only_use_yb() and 3 or 2
            local money_type = MallModel:get_only_use_yb() and 3 or 2
            MiscCC:req_relive(2, money_type)
            UIManager:hide_window("resurrection_dialog");
        else    --没有还原丹
            -- print("_isUseFuhuoshi == ",_isUseFuhuoshi);
            if ( _isUseFuhuoshi ) then
                -- TODO如果元宝不够要弹提示框元宝不够
                -- if ( PlayerAvatar:check_is_enough_money(4,10)) then
                --     MiscCC:req_relive(3);
                -- else
                --     return ;
                -- end
                local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
                local price = 10
                local param = {3, money_type}
                local relive_func = function( param )
                    MiscCC:req_relive(param[1], param[2])
                    UIManager:hide_window("resurrection_dialog");
                end
                MallModel:handle_auto_buy( price, relive_func, param )
                -- UIManager:hide_window("resurrection_dialog");
            else
                BuyKeyboardWin:show(18600,nil,1);
            end
        end
    
        return true
    end
    --xiehande UI_ResurrectionWin_001 ->UIPIC_COMMOM_002
    -- self.btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button_4_r,UILH_COMMON.lh_button_4_r,btn_cancel_fun,280,15,-1,-1);
    self.btn2 = ZTextButton:create( panel, LH_COLOR[2] .. Lang.resurrection.model[6], UILH_COMMON.lh_button_4_r, btn_cancel_fun, 280, 15, -1, -1, 1)

    -- 原地复活
    -- local btn2_content = UILabel:create_lable_2( Lang.resurrection.model[6], 20, 22, 16, ALIGN_CENTER )
    -- local content_height = btn2_content:getSize().height
    -- btn2_content:setPosition(121*0.5, (btn1_height-content_height)*0.5)
    -- self.btn2:addChild( btn2_content )
--    MUtils:create_sprite(self.btn2,UIResourcePath.FileLocate.other .. "res_t1.png",65.5,21)


end

function ResurrectionDialog:update_time( _time )
	local result_time = self:get_time_by_second(_time);
	self.time:setText(result_time..Lang.resurrection.model[7]); -- [1818]="#cfff000后将自动在复活点复活"
end

function ResurrectionDialog:get_time_by_second(second_num)
	local second = second_num%60;
	local min = math.floor(second_num/60);
	min = min%60;
	--hour = hour%24;
	--print("day = " .. day .. "hour = " .. hour .. "min = " .. min .. "second = " .. second);
	local time_str = "#cff0000";
	time_str = time_str .. min..Lang.resurrection.model[9]; -- [874]="分"
	time_str = time_str .. second..Lang.resurrection.model[10]; -- [875]="秒"
	return time_str;
end

function ResurrectionDialog:active( show )
    if ( show == false ) then
        self._timer:stop();
    end
end


function ResurrectionDialog:destroy()
    if self._timer then
        self._timer:stop();
    end
    Window.destroy(self);
end