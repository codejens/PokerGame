-- HSXNWin.lua
-- create by hcl on 2013-4-8
-- 护送仙女界面


require "UI/component/NormalStyleWindow"
super_class.HSXNWin(NormalStyleWindow)
require "utils/MUtils"

-- 左边距
local l_m = 19;
-- 下边距
local b_m = 39;

--镖车等级
local level_bg_array = {
    UILH_HSBC.bc_level_1,
    UILH_HSBC.bc_level_2,
    UILH_HSBC.bc_level_3,
    UILH_HSBC.bc_level_4,
    UILH_HSBC.bc_level_5,

}

--镖车数组
local bc_array = {
    UILH_HSBC.bc_1,
    UILH_HSBC.bc_2,
    UILH_HSBC.bc_3,
    UILH_HSBC.bc_4,
    UILH_HSBC.bc_5,
}
-- 1npc名字,2刷星任务类型(1,斩妖除魔,2护送仙女)，3刷星任务适用等级段，
-- 4当前刷星任务星级，5被抽选到的任务id，
-- 6任务状态(0,未接,2已接,1,完成)，7任务剩余次数,8剩余免费刷星次数
function HSXNWin:show(param)
    local win = UIManager:toggle_window("hsxn_win");
    if ( win ) then
        local str_table = Utils:Split(param, ",") 
        -- 任务剩余次数
        win.today_hsxn_count = tonumber(str_table[7]);
        -- 刷星任务类型
        win.star_quest_type = tonumber(str_table[2]);
        -- 任务状态
        win.star_quest_state = tonumber(str_table[6]);
        -- 当前抽选到的任务id
        win.star_quest_id = tonumber( str_table[5] );
        -- 当前任务星级
        win.star_lv = tonumber(str_table[4]);
        win.free_refresh_count = tonumber(str_table[8]);
        -- 刷新界面
        win:update_view();
    end  
end
-- star_quest_type,刷星任务类型 1斩妖除魔,2护送仙女
--level, 等级段
--star_lv, 星级
--quest_id,任务id
--left_refresh_star_count,剩余免费刷星次数
function HSXNWin:on_refresh_quest_star( star_quest_type,level,star_lv,quest_id,left_refresh_star_count )
    self.star_lv = star_lv;
    self.star_quest_id = quest_id;
    self:update_view();
    -- 播放刷星特效
    -- LuaEffectManager:play_view_effect( 26,15,28,self.meizi_head_tab[star_lv] ,false);
end

local hs_award = { 4400,150000,5720,195000,7040,240000,8800,300000,11000,375000 };

function HSXNWin:__init()
    -- 最外层底框
    self.view:addChild( CCZXImage:imageWithFile( 5, 5, 890, 570, UILH_COMMON.normal_bg_v2, 500, 500 ) )

    local offset_y = 37
    -- 上背景框、左下背景框、右下背景框
    self.view:addChild( CCZXImage:imageWithFile( 17, 207+offset_y, 865, 320, "", 500, 500 ) )
    self.view:addChild( CCZXImage:imageWithFile( 17, 83+10, 865, 159-10, UILH_COMMON.bottom_bg, 500, 500 ) )

    -- 仙女头像，护送成功得到的银两经验 
    self.meizi_head_tab = {};
    self.award_view = {};
    self.meizi_head_bg = {}
    for i=1,5 do

            -- 背景框
    local meizi_bg = CCBasePanel:panelWithFile( 20 + (i-1) * 172,245, 170, 315,UILH_COMMON.bg_10, 500, 500 )
    self.view:addChild( meizi_bg )
    
    local title_bg =  CCBasePanel:panelWithFile(-1 ,277, 170 , 31, UILH_NORMAL.title_bg4, 500, 500 )
    meizi_bg:addChild(title_bg)
    MUtils:create_zximg(title_bg,level_bg_array[i],30,3,-1,-1)

        -- self.meizi_head_bg[i] = MUtils:create_zximg(meizi_bg,UIResourcePath.FileLocate.hsxn .. "bg3.png",0, 58,-1,-1,500,500);
        -- self.meizi_head_bg[i]:setIsVisible(false)
        -- 美女选中框
        self.meizi_head_bg[i] = MUtils:create_zximg(meizi_bg,UILH_COMMON.slot_focus,0, 78,170,200,500,500);
        self.meizi_head_bg[i]:setIsVisible(false)
        
        --妹子头像/镖车
        self.meizi_head_tab[i] = MUtils:create_zximg(meizi_bg,bc_array[i],14,77,-1,-1,500,500);
        

        --分割线
        ZImage:create(meizi_bg, UI_WELFARE.split_line, 6, 85, 155,3)


        --银两
        self.award_view[(i-1)*2+1] = MUtils:create_zxfont(self.view,Lang.hsbc[1]..hs_award[(i-1)*2+2],40+ (i-1) * 172,295,1,16); -- [1910]="#cfff000银两:#cffffff"
 

        --经验
        self.award_view[(i-1)*2+2] = MUtils:create_zxfont(self.view,Lang.hsbc[2]..hs_award[(i-1)*2+1],40+ (i-1) * 172,264,1,16); -- [1911]="#cfff000经验:#cffffff"
    end


    -- 钦点按钮
    local function btn_qd_fun(eventType,args,msg_id)
        if ( eventType == TOUCH_CLICK ) then
            -- 参数2,是否满级，1是0否
            self:create_dialog( true )
        end
        return true
    end
    local qd_bg = MUtils:create_btn(self.view,UILH_ROLE.role_button1,UILH_ROLE.role_button1,btn_qd_fun,755,332,-1,-1);
    MUtils:create_btn(qd_bg,UILH_HSBC.btn_qd,UILH_HSBC.btn_qd,btn_qd_fun,20,28,-1,-1);
 


    -- 护送说明-------------------------------
    MUtils:create_zxfont(self.view,LH_COLOR[1]..Lang.hsbc[3],31,214,1,16); -- [1912]="#cfff000护送说明:"
    -- local temp_dialog = MUtils:create_ccdialogEx(self.view,Lang.hsbc[4]
    -- -- [1913]="1、刷新消耗#cfff0003元宝#cffffff或一个#cfff000天仙令#r#cffffff2、#cfff00020元宝#cffffff可直接钦点天仙#r3、每天#cfff00015:30~16:30#cffffff护送仙女可获得#cfff0001.5倍#cffffff奖励#r4、护送任务需要在20分钟内完成"
    --     ,31,202,350,0,25,16);
    -- temp_dialog:setAnchorPoint(0, 1)
    --create_ccdialogEx 多颜色不能正常适用
    local gas_y = 26
    local begin_y = 190
    local txt_2 = UILabel:create_lable_2( LH_COLOR[2]..Lang.hsbc[15], 31, begin_y, 14, ALIGN_LEFT )
    begin_y = begin_y - gas_y
    local txt_3 = UILabel:create_lable_2( LH_COLOR[2]..Lang.hsbc[16], 31,begin_y, 14, ALIGN_LEFT )
     begin_y = begin_y - gas_y
    local txt_4 = UILabel:create_lable_2( LH_COLOR[2]..Lang.hsbc[17], 31, begin_y, 14, ALIGN_LEFT )
     begin_y = begin_y - gas_y

    local txt_5 = UILabel:create_lable_2( LH_COLOR[2]..Lang.hsbc[18], 31, begin_y, 14, ALIGN_LEFT )
    
    self.view:addChild(txt_2)
    self.view:addChild(txt_3)
    self.view:addChild(txt_4)
    self.view:addChild(txt_5)
    --最长护送时间
     MUtils:create_zxfont(self.view,LH_COLOR[1]..Lang.hsbc[5],472,208,1,16)
    -- 护送剩余次数
    self.view_today_hsxn_count = MUtils:create_zxfont(self.view,LH_COLOR[2]..Lang.hsbc[8],491,20,1,16); -- [1914]="护送剩余次数:"
    local txt_label =  MUtils:create_zxfont(self.view,LH_COLOR[1]..Lang.hsbc[6],473,167,1,16); -- [1915]="当前护送奖励:"
    self.view_award = MUtils:create_zxfont(self.view,"",603,167,1,16); -- [1915]="当前护送奖励:"
    self.view_award2 = MUtils:create_zxfont(self.view,"",603,137,1,16);

    self.view_left_txl = MUtils:create_zxfont(self.view,LH_COLOR[2]..Lang.hsbc[10],260,21,1,16); -- [1916]="背包剩余天仙令:"


    --分割线
    ZImage:create(self.view, UILH_COMMON.split_line_v, 447, 84+17, 3,156-25)

    -- 刷新按钮
    local function btn_refresh_star_fun(eventType,args,msg_id)
        if ( eventType == TOUCH_CLICK ) then
            if (  self.txl_count > 0 or self.free_refresh_count > 0 ) then
                -- 参数2,是否满级，1是0否
                local money_type = MallModel:get_only_use_yb() and 3 or 2
                MiscCC:req_refresh_quest_star(self.star_quest_type,0, money_type)
            else
                self:create_dialog( false )
            end
        end
        return true
    end
    self.refresh_star = MUtils:create_btn(self.view,UILH_COMMON.btn4_nor, UILH_COMMON.btn4_nor,btn_refresh_star_fun, 270, 24+13,-1,-1);
    -- 按钮中的文字“刷新”
    local refresh_star_lab = UILabel:create_lable_2( LH_COLOR[2]..Lang.hsbc[13], 24, 21, 16, ALIGN_LEFT )
    local btn_size = self.refresh_star:getSize()
    local txt_size = refresh_star_lab:getSize()
    refresh_star_lab:setPosition(btn_size.width/2- txt_size.width/2,btn_size.height/2 - txt_size.height/2+3)
    self.refresh_star:addChild( refresh_star_lab )

  
    -- 开始护送
    local function btn_hs_fun(eventType,args,msg_id)
        if ( eventType == TOUCH_CLICK ) then
            MiscCC:req_receive_quest( self.star_quest_type );
            UIManager:hide_window("hsxn_win");
            MountsModel:dismount(  )
        end
        return true
    end
    self.hs = MUtils:create_btn(self.view,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_nor,btn_hs_fun,508,24+13,-1,-1);
    local hs_text = UILabel:create_lable_2( LH_COLOR[2]..Lang.hsbc[14], 24, 21, 16, ALIGN_LEFT )

    local btn_size = self.hs:getSize()
    local txt_size = hs_text:getSize()
    hs_text:setPosition(btn_size.width/2- txt_size.width/2,btn_size.height/2 - txt_size.height/2+3)


    self.hs:addChild(hs_text)

end



function HSXNWin:update_view()

    --今日护送次数
    self.view_today_hsxn_count:setText(LH_COLOR[2]..Lang.hsbc[9]..self.today_hsxn_count.."/".."3"); -- [1917]="护送剩余次数:#cfff000" -- [618]="次"
   
   --当前护送奖励
    -- self.view_award:setText(LH_COLOR[2]..Lang.hsbc[6]..LH_COLOR[15]..Lang.normal[1]..hs_award[(self.star_lv-1)*2+2]..Lang.normal[6]..hs_award[(self.star_lv-1)*2+1]); -- [1918]="当前护送奖励:#cfff000" -- [412]="银两" -- [1919]=" 经验"
    self.view_award:setText(LH_COLOR[15]..Lang.normal[1].."  "..hs_award[(self.star_lv-1)*2+2]);
    self.view_award2:setText(LH_COLOR[15]..Lang.normal[6].."  "..hs_award[(self.star_lv-1)*2+1]) -- [1918]="当前护送奖励:#cfff000" -- [412]="银两" -- [1919]=" 经验"
    self.txl_count = ItemModel:get_item_count_by_id(18621);
    self.view_left_txl:setText(LH_COLOR[2]..Lang.hsbc[7]..self.txl_count); -- [1920]="背包剩余天仙令:#cfff000"
   
    -- 更新妹子头像
    for i=1,5 do
        if ( self.star_lv == i ) then
            self.meizi_head_tab[i]:setCurState( CLICK_STATE_UP );
            self.meizi_head_bg[i]:setIsVisible(true)
        else
            self.meizi_head_tab[i]:setCurState( CLICK_STATE_DISABLE );
            self.meizi_head_bg[i]:setIsVisible(false)
        end
    end
    -- 如果当前护送次数完了就不能再次护送
    if ( self.today_hsxn_count <= 0 ) then
        self.hs:setCurState( CLICK_STATE_DISABLE );
    end

end

--
function HSXNWin:active( show )
    if ( show ) then
        -- 根据玩家当前的等级更新奖励的数量
        hs_award = RefreshQuestConfig:get_refresh_award_by_user_level( EntityManager:get_player_avatar().level ,2);
        for i=1,5 do
            local index = (i-1)*2;
            self.award_view[index + 1]:setText(Lang.hsbc[1]..hs_award[index+2]); -- [1910]="#cfff000银两:#cffffff"
            self.award_view[index + 2]:setText(Lang.hsbc[2]..hs_award[index+1]); -- [1911]="#cfff000经验:#cffffff"
        end
    else
        
    end
end

function HSXNWin:create_dialog( is_max_star )
    local yuanbao = 3;
    local str = Lang.hsbc[19]; -- [1921]="元宝#c66ff66刷星"
    if ( is_max_star ) then
        yuanbao = 20;
        str =Lang.hsbc[20]; -- [1922]="元宝#c66ff66满星"
        -- if ( PlayerAvatar:check_is_enough_money(4,20) == false) then
        --     return;
        -- end
    else
        if ( self.txl_count == 0  ) then
            -- if ( PlayerAvatar:check_is_enough_money(4,3) == false) then
            --     return;
            -- end
            yuanbao = 3
        end
    end

    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local param = {self.star_quest_type, (is_max_star and 1 or 0), money_type}
    local function quest_star( param )
        MiscCC:req_refresh_quest_star(param[1], param[2], param[3]);
    end

    local function cb_fun()
        -- if ( is_max_star ) then
        --     MiscCC:req_refresh_quest_star(self.star_quest_type,1 );
        -- else
        --     MiscCC:req_refresh_quest_star(self.star_quest_type,0 );
        -- end
        MallModel:handle_auto_buy( yuanbao, quest_star, param )
    end
    str = string.format(str, yuanbao) -- [876]="#c66ff66是否消费#cfff000"
    SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_QUEST_REFRESH_STAR ,cb_fun,str )
end
