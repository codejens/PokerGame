-- TheHelpWin.lua  
-- created by xiehande on 2014-12-31
-- 游戏助手页
super_class.TheHelperWin(NormalStyleWindow)

local window_width = 450
local window_height = 300

local function go_to_teleport( scene_name,npc_name,notice_content )
    local function func_1(  )    -- 自动前往回调
        require "GlobalFunc"
        GlobalFunc:ask_npc_by_scene_name( scene_name, npc_name )
        AlertWin:close_alert(  )
    end
    local function func_2(  )    -- 速传回调
        require "GlobalFunc"
        GlobalFunc:teleport_by_name( scene_name, npc_name )
        AlertWin:close_alert(  )
    end
    local confirmWin2_temp = ConfirmWin2:show( 6, nil, notice_content,  func_1, nil, nil )
    confirmWin2_temp:set_yes_but_func_2( func_2 )
end

local function func_1(  )
    require "config/GuildConfig"
    local guild_scene_name, guild_npc_name = GuildConfig:get_guild_manor(  )
    go_to_teleport(guild_scene_name,guild_npc_name,"是否立即前往军团管理员。")
end

local function  func_2( )
    go_to_teleport("雁门关",Lang.secretary[25],"是否立即前往接受银两任务？")
end

local function func_3(  )
    go_to_teleport("雁门关","护送镖车","是否立即前往护送镖车？")
end



--按钮入口对应配置
local btn_config = {
    [1] = {{img = UILH_THEHELPER.exp_list_1,win_name = "benefit_win", page_num=4},
            {img = UILH_THEHELPER.exp_list_2,win_name = "activity_Win",page_num=1, jian=true, need_type=ActivityWin.EXPERIENCE},
            {img = UILH_THEHELPER.exp_list_3,win_name = "activity_Win",page_num=2},
            {img = UILH_THEHELPER.exp_list_4,win_name = "zycm_win"},
            {img = UILH_THEHELPER.exp_list_5, func = func_1},
            {img = UILH_THEHELPER.exp_list_6, win_name = "pao_huan_win"}},

    [2] = {{img = UILH_THEHELPER.money_list_1,win_name = "zhaocai_win"},
            {img = UILH_THEHELPER.money_list_2,func = func_2,jian=true},
            {img = UILH_THEHELPER.money_list_3,func = func_3},
            {img = UILH_THEHELPER.money_list_4,win_name = "activity_Win",page_num=1},
            {img = UILH_THEHELPER.money_list_5,win_name = "doufatai_win",sys_id = GameSysModel.JJC},
            {img = UILH_THEHELPER.money_list_6,win_name = "activity_Win",page_num=2}},

    [3] = {{img = UILH_THEHELPER.fight_list_1,win_name = "user_skill_win"},
            {img = UILH_THEHELPER.fight_list_2,win_name = "dujie_win",jian=true,sys_id =GameSysModel.DJ},
            {img = UILH_THEHELPER.fight_list_3,win_name = "linggen_win",sys_id = GameSysModel.ROOTS},
            {img = UILH_THEHELPER.fight_list_4,win_name = "wing_win",sys_id = GameSysModel.WING },
            {img = UILH_THEHELPER.fight_list_5,win_name = "forge_win",sys_id = GameSysModel.ENHANCED},
            {img = UILH_THEHELPER.fight_list_6,win_name = "mounts_win_new",sys_id=GameSysModel.MOUNT }},
}

local title_config = {UILH_THEHELPER.need_exp_title,UILH_THEHELPER.need_money_title,UILH_THEHELPER.need_fight_title}


local gas_x = 122
local gas_y =100
local begin_x = 35
local begin_y = 102



function TheHelperWin:__init( window_name, window_info )
    local panel = self.view
    local bgPanel = CCBasePanel:panelWithFile( 10, 12, window_width-20, window_height-70, UILH_THEHELPER.frame_bg2, 500, 500 )
    panel:addChild(bgPanel)
    self.current_index = 1
    self.chest_btns = {}
    self:create_main_panel(panel)
end


--创建一个按钮入口
function  TheHelperWin:create_one_item(panel,x,y,w,h,index)
    --点击入口图标
    local function open_window(eventType,arg,msgid,selfitem)
            if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                return
            end
            if  eventType == TOUCH_BEGAN then
                return true;
            elseif eventType == TOUCH_CLICK then

                if btn_config[self.current_index][index].func then
                    btn_config[self.current_index][index].func()
                else
                    if btn_config[self.current_index][index].win_name =="activity_Win" then
                        ActivityWin:win_change_page( btn_config[self.current_index][index].page_num, btn_config[self.current_index][index].need_type )
                    elseif btn_config[self.current_index][index].win_name =="benefit_win" then
                        local win = UIManager:show_window("benefit_win")
                        if win and btn_config[self.current_index][index].page_num then
                            win:change_page(btn_config[self.current_index][index].page_num)
                        end
                    else
                       if btn_config[self.current_index][index].sys_id then --有系统开启限制
                            if GameSysModel:isSysEnabled( btn_config[self.current_index][index].sys_id, true )  then
                               UIManager:toggle_window(btn_config[self.current_index][index].win_name)
                            end
                       else
                           --征伐榜没有系统等级限制 
                           local player = EntityManager:get_player_avatar()     -- 拿到主角
                           if btn_config[self.current_index][index].win_name =="zycm_win"  then
                                local wxd_num = ItemModel:get_item_count_by_id(48222);
                                --or player.level>=22
                                if wxd_num ==0  then
                                    NormalDialog:show(Lang.zycm[32]..Lang.gamesys[2],nil,2); 
                                else
                                    -- 直接使用物品
                                    if player.level > 27 then
                                        local zycmb_info = ItemModel:get_item_info_by_id( 48222 );
                                        if ( zycmb_info ) then
                                            ItemModel:use_a_item( zycmb_info.series, 0 );
                                        end
                                    else
                                        GlobalFunc:create_screen_notic("需要达到28级，才能使用")

                                    end
                                end
                                return
                           end
                           UIManager:toggle_window(btn_config[self.current_index][index].win_name)
                       end
                      
                    end
                end
                return true;
            end
            return true;

    end

    self.chest_btns[index] =  MUtils:create_btn(panel,UILH_MOUNT.btn_yellow,UILH_MOUNT.btn_yellow,open_window,x, y, w, h) 
    -- self.chest_btns[index]:setScale(1.2) 
    local txt = CCZXImage:imageWithFile( 14, 39, -1, -1, btn_config[self.current_index][index].img )
    self.chest_btns[index]:addChild(txt)
    local btn_size =  self.chest_btns[index]:getSize()
    local  txt_size = txt:getSize()
    txt:setPosition(btn_size.width/2-txt_size.width/2,btn_size.height/2 - txt_size.height/2)

    if btn_config[self.current_index][index].jian then
        local jian = CCZXImage:imageWithFile( 52, 64, -1, -1, UILH_THEHELPER.jian )
        self.chest_btns[index]:addChild(jian)
    end

end


--我要经验
function TheHelperWin:need_exp_func()
        self.current_index = 1
        --更改标题
        self.window_title:setTexture(title_config[self.current_index])
        if #self.chest_btns~=0 then
            for i=1,#self.chest_btns do
                self.chest_btns[i]:removeFromParentAndCleanup(true);
                self.chest_btns[i]= nil
            end   
            self.chest_btns = {}
        end

        for i=1,#btn_config[self.current_index] do
            row = math.floor((i-1)/3)  
            local column = math.ceil((i-1)%3)   
            self:create_one_item(self.button_bg,begin_x+column*gas_x,begin_y-row*gas_y,100,100,i)
        end

      self:hide_btns()
--       --关闭其他的所有页面
    UIManager:close_otherwise_window("theHelper_Win")
       
    end


 --我要金钱
function TheHelperWin:need_money_func( )
        self.current_index = 2
        self.window_title:setTexture(title_config[self.current_index])

        if #self.chest_btns~=0 then
            for i=1,#self.chest_btns do
                self.chest_btns[i]:removeFromParentAndCleanup(true);
                self.chest_btns[i]= nil
            end   
           self.chest_btns = {}
        end

        for i=1,#btn_config[self.current_index] do
            row = math.floor((i-1)/3)  -- 从0开始
            local column = math.ceil((i-1)%3)   -- 从0开始
            self:create_one_item(self.button_bg,begin_x+column*gas_x,begin_y-row*gas_y,100,100,i)
        end
      self:hide_btns()
--       --关闭其他的所有页面
    UIManager:close_otherwise_window("theHelper_Win")
    end

    --我要战力
 function TheHelperWin:need_fight_func( )
       self.current_index = 3
        self.window_title:setTexture(title_config[self.current_index])

        if #self.chest_btns~=0 then
            for i=1,#self.chest_btns do
                self.chest_btns[i]:removeFromParentAndCleanup(true);
                self.chest_btns[i]= nil
            end   
            self.chest_btns = {}
        end
        for i=1,#btn_config[self.current_index] do
            -- self:create_one_item(self.button_bg,1,1,-1,-1,i)
               row = math.floor((i-1)/3)  -- 从0开始
            local column = math.ceil((i-1)%3)   -- 从0开始
            self:create_one_item(self.button_bg,begin_x+column*gas_x,begin_y-row*gas_y,100,100,i)
        end
      self:hide_btns()
--       --关闭其他的所有页面
    UIManager:close_otherwise_window("theHelper_Win")
    end


--创建三个按钮
function TheHelperWin:create_main_panel( panel )
    self.button_bg = CCBasePanel:panelWithFile( 21, 23, window_width-40, window_height-100, "", 500, 500 )
    panel:addChild( self.button_bg )

    --我要经验
    local function func_exp()
        self:need_exp_func()
    end

    --我要金钱
    local function func_money()
        self:need_money_func()
    end
    
    --我要战力
    local function func_fight()
        self:need_fight_func()
    end

    self.need_exp_btn  = UIButton:create_button_with_name( 11, 53, -1, -1, UILH_THEHELPER.btn_bg, UILH_THEHELPER.btn_bg, nil, "",func_exp )
    local txt_1 = CCZXImage:imageWithFile( 33, 30, -1, -1, UILH_THEHELPER.need_exp )
    self.need_exp_btn.view:addChild(txt_1)
    self.button_bg:addChild(self.need_exp_btn.view)
  

    --我要金钱
    self.need_money_btn  = UIButton:create_button_with_name( 146, 53, -1, -1, UILH_THEHELPER.btn_bg, UILH_THEHELPER.btn_bg, nil, "",func_money )
    local txt_2 = CCZXImage:imageWithFile( 33, 30, -1, -1, UILH_THEHELPER.need_money )
    self.need_money_btn.view:addChild(txt_2)
    self.button_bg:addChild(self.need_money_btn.view)

    --我要战力
    self.need_fight_btn   = UIButton:create_button_with_name( 284, 53, -1, -1, UILH_THEHELPER.btn_bg, UILH_THEHELPER.btn_bg, nil, "",func_fight )
    local txt_3 = CCZXImage:imageWithFile( 33, 30, -1, -1, UILH_THEHELPER.need_fight )
    self.need_fight_btn.view:addChild(txt_3)
    self.button_bg:addChild(self.need_fight_btn.view)
end


function TheHelperWin:hide_btns( )
            --隐藏三大入口按钮
    self.need_exp_btn.view:setIsVisible(false)
    self.need_money_btn.view:setIsVisible(false)
    self.need_fight_btn.view:setIsVisible(false)
end

-- 更新数据 
function TheHelperWin:update( update_type )
end

function TheHelperWin:destroy()
	Window.destroy(self)
end
