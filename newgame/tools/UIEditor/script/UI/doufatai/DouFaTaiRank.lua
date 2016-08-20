-- DouFaTaiRank.lua
-- created by guozhinan on 2015/4/30
-- 显示斗法台弹出的排行榜

super_class.DouFaTaiRank(Window)


function DouFaTaiRank:show(rank_data)
    -- 阻止连续打开行为
    local win = UIManager:find_visible_window("doufatai_rank")
    if win then
        return;
    end

    local win = UIManager:show_window("doufatai_rank",true);
    if win then
        win:update(rank_data)
    end
end

-- 
function DouFaTaiRank:__init( window_name, texture_name, is_grid, width, height,title_text )
    local panel = self.view;

    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height, -1,500,500 )
    
    local bg = CCBasePanel:panelWithFile(12, 60, width-24, 255,UILH_COMMON.bottom_bg,500,500);
    self.view:addChild(bg)

    -- 榜单标题
    local title_bg = MUtils:create_zximg(bg,UILH_NORMAL.title_bg4,0 ,215,width-24,35, 500, 500);
    MUtils:create_zxfont(title_bg,Lang.doufatai[1],53,10,2,16); -- [864]="#cfff000排名"
    MUtils:create_zxfont(title_bg,Lang.doufatai[2],191,10,2,16); -- [865]="#cfff000玩家名字"
    MUtils:create_zxfont(title_bg,Lang.doufatai[3],325,10,2,16); -- [866]="#cfff000战斗力"
    MUtils:create_zxfont(title_bg,Lang.doufatai[4],448,10,2,16); -- [866]="#cfff000军团"

    -- 创建榜单滚动条
    self.rank_scroll = CCScroll:scrollWithFile(0,17,485,190,0,nil,TYPE_HORIZONTAL,500,500);   
    
    --设滚动条
    self.rank_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 470 )
    self.rank_scroll:setScrollLumpPos( 494 )
    local arrow_up = CCZXImage:imageWithFile(494 , 207, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(494, 6, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    bg:addChild(arrow_up,1)
    bg:addChild(arrow_down,1)
    bg:addChild(self.rank_scroll);

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local row = temparg[1] +1             -- 行

            -- 每行的背景panel
            local panel = CCBasePanel:panelWithFile(0,500 - row * 40,485,40,nil,0,0);
            self.rank_scroll:addItem(panel);
            local struct = self.top_tab[row];
            MUtils:create_zxfont(panel,LH_COLOR[2]..struct.top,50,15,2,16);
            MUtils:create_zxfont(panel,LH_COLOR[2]..struct.name,190,15,2,16);
            MUtils:create_zxfont(panel,LH_COLOR[2]..struct.fight_value,325,15,2,16);
            MUtils:create_zxfont(panel,LH_COLOR[2]..MUtils:get_zhenying_name(struct.clan),450,15,2,16);     

            -- 分割线
            MUtils:create_zximg(panel,UILH_COMMON.split_line,20,0,485,3,0,0)
            -- 点击panel弹出右键菜单
            local function panel_fun( eventType,args,msg_id )
                if eventType == TOUCH_CLICK then
                    local tempdata = { roleId = struct.dft_id, roleName = struct.name, qqvip = struct.qqVip, level = struct.lv, camp = struct.clan, job = struct.job, sex = struct.sex }
                    local player_avatar = EntityManager:get_player_avatar();
                    if ( player_avatar.id == struct.dft_id ) then
                        GlobalFunc:create_screen_notic(LangGameString[871]); -- [871]="不能对自己进行操作"
                    else
                        LeftClickMenuMgr:show_left_menu("chat_other_list_menu", tempdata)
                    end
                end
                return true
            end
            panel:registerScriptHandler(panel_fun);

            self.rank_scroll:refresh();
            return false
        end
    end
    self.rank_scroll:registerScriptHandler(scrollfun);
    self.rank_scroll:refresh();

    local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
           UIManager:destroy_window("doufatai_rank");
        end
        return true
    end
    self.btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_cancel_fun,(width-99)/2,6,-1,-1)
    MUtils:create_zxfont(self.btn2, Lang.common.confirm[0], 99/2, 20, 2, 18)   --[0]=确定

    --关闭按钮
    -- local function _close_btn_fun()
    --     UIManager:destroy_window(window_name)
    -- end

    -- local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }
    -- self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    -- local exit_btn_size = self._exit_btn:getSize()
    -- self._exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height)
end

function DouFaTaiRank:update(rank_data)
    if rank_data ~= nil then
        self.top_tab = rank_data
        self.rank_scroll:clear();
        self.rank_scroll:setMaxNum(#self.top_tab);
        self.rank_scroll:refresh(); 
    end
end

function DouFaTaiRank:active( show )

end

function DouFaTaiRank:destroy(  )
    Window.destroy(self)
end