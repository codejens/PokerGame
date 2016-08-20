-- PetInfoPage.lua
-- create by hcl on 2012-12-10
-- refactored by guozhinan on 2014-10-27
-- 宠物信息

super_class.PetInfoPage()


local font_size = 16

local node_pet_info = nil;

----------------------------按钮function--------------------------
local function btn_change_name_fun(eventType,x,y)
    local function fun( str_name )
        local p_s = PetWin:get_current_pet_info();
        local pet_id = p_s.tab_attr[1];
        if ChatModel:safe_check_sharp(str_name) == false then
            PetCC:req_change_pet_name(pet_id ,str_name );
        else
            GlobalFunc:create_screen_notic(Lang.pet.pet_info_page[1]) -- [1351]="输入了非法字符"
        end
    end
    local p_s = PetWin:get_current_pet_info();
    if ( p_s ) then
        InputDialog:show(fun, UILH_PET.gaiming, Lang.pet.pet_info_page[25]);
    end
end
local function btn_free_fun(eventType,x,y)
    -- 如果是最后一只宠物不能放生
    if ( PetModel:get_pet_info().curr_num == 1 ) then
        GlobalFunc:create_screen_notic( Lang.pet.pet_info_page[2] ); -- [1676]="这是你最后的宠物，无法放生。"
    else
        local function fun(  )
            local p_s = PetWin:get_current_pet_info();
            local _pet_id = p_s.tab_attr[1];
            PetCC:req_delete_pet(_pet_id);
        end
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            NormalDialog:show(Lang.pet.pet_info_page[3],fun); -- [1677]="是否放生?"
        end
    end
end
local function btn_feed_fun(eventType,x,y)
    if eventType == TOUCH_CLICK then
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            local _pet_id = p_s.tab_attr[1];   
            PetCC:req_add_live_play_feed(_pet_id,3);
        end
    end
end
local function btn_add_live_fun(eventType,x,y)
    local p_s = PetWin:get_current_pet_info();
    if ( p_s ) then
        local _pet_id = p_s.tab_attr[1];   
        PetCC:req_add_live_play_feed(_pet_id,1);
    end
 end
local function btn_play_fun(eventType,x,y) 
    local p_s = PetWin:get_current_pet_info();
    if ( p_s ) then
        local _pet_id = p_s.tab_attr[1];   
        PetCC:req_add_live_play_feed(_pet_id,2);
    end
end
local function btn_set_fight_fun(eventType,x,y)
    -- 如果不在灵泉仙浴中...
    if ( XianYuModel:get_status(  ) == false ) then 
        --
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            local _pet_id = p_s.tab_attr[1];   

            -- 默认是出战
            local do_type = 1;
            -- 如果当前选中的宠物是正在出战的宠物
            if(_pet_id == PetModel:get_current_pet_id() ) then
                   -- 如果当前出战的宠物 出战状态
                if( PetModel:get_current_pet_is_fight()) then
                    -- 出战宠物休息
                    do_type = 0
                else
                    -- 宠物是否在死亡cd中
                    if ( PetModel:get_current_fight_pet_cd(  ) ~= 0 ) then
                        GlobalFunc:create_screen_notic( Lang.pet.pet_info_page[21] ); -- [1466]="您的宠物现在需要休息！"
                        return ;
                    end
                end
            end
            Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
            PetCC:req_fight( _pet_id,do_type );
        end
        -- 新手指引，宠物指引任务
        if ( XSZYManager:get_state() == XSZYConfig.CHONG_WU_ZY ) then
            -- 关闭窗口
            PetWin:show();
        end
        
        Instruction:handleUIComponentClick(instruct_comps.PET_WIN_REST_FIGHT_BTN)
    else
        GlobalFunc:create_screen_notic( Lang.pet.pet_info_page[22] ) -- [1467]="灵泉仙浴中宠物不能出战"
    end
end
local function btn_physical_attack_fun(eventType,x,y)
    local function fun (item_id)
        local p_s = PetWin:get_current_pet_info();
        local _pet_id = p_s.tab_attr[1];   
        PetCC:req_attack_type(_pet_id);
    end
    local p_s = PetWin:get_current_pet_info();
    if ( p_s ) then

        local p_s = PetWin:get_current_pet_info();
        local pet_name = p_s.pet_name;
        local item_id = PetConfig:get_xsd_item_id();
        local attack_str = Lang.pet.pet_info_page[26]; -- [1678]="#c35c3f7物攻#cfff000"
        --2物攻，1法攻
        if ( p_s.tab_attr[14] == 2 ) then
            attack_str = Lang.pet.pet_info_page[27] -- [1679]="#c35c3f7法攻#cfff000"
        end
        local str = string.format(Lang.pet.pet_info_page[6],pet_name,attack_str); -- [1680]="#cfff000转换%s#cfff000的攻击类型为%s吗?"
        -- "你确认转换"..pet_name .."的攻击类型吗?"
        UseItemDialog:show(item_id,fun,2,str,UILH_PET.xisui);
    end
end

-- 炫耀函数
local function xy_fun(eventType,x,y)
    local pet_info = PetWin:get_current_pet_info();
    local monster_id = pet_info.tab_attr[2] ;
    local pet_name = MonsterConfig:get_monster_by_id( monster_id ).name
    print("---------- 炫耀宠物monster_id,pet_name",monster_id,pet_name)
    local pet_color = MUtils:get_pet_name_color( pet_info );
    pet_name = pet_color .. pet_name
    pet_name = string.sub(pet_name,3);
    local pet_id = pet_info.tab_attr[1];
    local actor_id = EntityManager:get_player_avatar().id;
    local temp_info = string.format( "%s%d%s%d%s%s%s%s%s,%d,%d,%d,%s",
        ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET,
        ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
        ChatConfig.ChatAdditionInfo.TYPE_PET, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
        pet_name, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
        Hyperlink:get_first_function_target(), Hyperlink:get_third_open_sys_win_target(),43,
        actor_id,pet_id,
        ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)

    ChatCC:send_chat(ChatModel:get_cur_chanel_select(), 0, temp_info)
end

----------------------------按钮function--------------------------

function PetInfoPage:__init()

    ------下面是保存了要更新信息的控件
    self.tab_petinfo_view = {};

    node_pet_info = CCBasePanel:panelWithFile(250,8,630,508,nil,0,0);
    self.view = node_pet_info;

    -- 中部背景
    local mid_bg = CCZXImage:imageWithFile( 0, 10, 335, 495, UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(mid_bg)

    -- 右边背景
    local right_bg = CCZXImage:imageWithFile( 335, 10, 298, 495, UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(right_bg)

    -- 延寿
    -- ZTextButton:create(node_pet_info,LangGameString[1684],{UIResourcePath.FileLocate.common .. "button2_bg.png",UIResourcePath.FileLocate.common .. "button2_bg.png"},btn_add_live_fun,217,45,61,32); -- [1684]="延寿"

    -- 喂养
    -- MUtils:create_common_btn(node_pet_info,Lang.pet.pet_info_page[9],btn_feed_fun,530,33); -- [1683]="喂养" 

    self:create_pet_display_panel(0,205,335,300,nil)
    self:create_skill_panel(0, 4, 335, 210, nil)
    self:create_pet_progress_panel(335,315,300,190,nil)
    self:create_pet_attr_panel(328,0,315,350,nil)

    self:update(1,{PetModel:get_pet_info().tab[1]});

    return self;
end

function PetInfoPage:create_pet_attr_panel(x, y, width, height,texture_path)
    self.pet_attr_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.pet_attr_panel)

    local function wuxing_tisheng_fun()
        -- 跳转到悟性提升分页
        local win = UIManager:find_visible_window("pet_win");
        if (win) then
            win:change_page(2);
        end
    end

    local function chengzhang_tisheng_fun()
        -- 跳转到悟性提升分页
        local win = UIManager:find_visible_window("pet_win");
        if (win) then
            win:change_page(3);
        end
    end

    -- 悟性提升
    local btn_wuxingtisheng = ZButton:create(self.pet_attr_panel,UILH_COMMON.button4,wuxing_tisheng_fun,178,280,-1,-1)
    MUtils:create_zxfont(btn_wuxingtisheng,Lang.pet.pet_info_page[24],77/2,14,2,16);     -- [8]="提升"
    -- 成长提升
    local btn_wuxingtisheng = ZButton:create(self.pet_attr_panel,UILH_COMMON.button4,chengzhang_tisheng_fun,178,235,-1,-1)
    MUtils:create_zxfont(btn_wuxingtisheng,Lang.pet.pet_info_page[24],77/2,14,2,16);     -- [8]="提升"

    local start_x = 0 
    local start_y = 230
    -- 悟性文字
    ZLabel:create(self.pet_attr_panel,Lang.pet.pet_info_page[19],start_x+17,start_y+65,15,1);
    -- 悟性值
    self.label_wuxing_value = ZLabel:create(self.pet_attr_panel,"",start_x+100,start_y+65,15,1);
    -- 成长文字
    ZLabel:create(self.pet_attr_panel,Lang.pet.pet_info_page[20],start_x+17,start_y+20,15,1);
    -- 成长值
    self.label_chengzhang_value = ZLabel:create(self.pet_attr_panel,"",start_x+100,start_y+20,15,1);
  
    local space = 5
    local ccdialogex1 = ZDialog:create(self.pet_attr_panel, Lang.pet.pet_info_page.left_info,start_x+18,start_y+5,75+20,150, 15)
    ccdialogex1.view:setAnchorPoint(0,1.0)
    ccdialogex1.view:setLineEmptySpace(space)
    ccdialogex1:setText(Lang.pet.pet_info_page.left_info)
    self.dialog_left_attr_value = ZDialog:create(self.pet_attr_panel,"",start_x+100,start_y+5,55,150,15);
    self.dialog_left_attr_value:setAnchorPoint(0,1.0)
    self.dialog_left_attr_value.view:setLineEmptySpace(space)

    local ccdialogex2 = ZDialog:create(self.pet_attr_panel,Lang.pet.pet_info_page.right_info,start_x+161,start_y+5,95,0,15);
    ccdialogex2:setAnchorPoint(0,1.0)
    ccdialogex2.view:setLineEmptySpace(space)
    ccdialogex2:setText(Lang.pet.pet_info_page.right_info)
    -- 攻击资质，防御资质，灵巧资质，身法资质 要更新
    self.dialog_right_attr_value = ZDialog:create(self.pet_attr_panel,"",start_x+242,start_y+5,75,0,15);
    self.dialog_right_attr_value:setAnchorPoint(0,1.0)
    self.dialog_right_attr_value.view:setLineEmptySpace(space)
end

function PetInfoPage:create_pet_progress_panel(x, y, width, height,texture_path)
    self.pet_progress_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.pet_progress_panel)

    -- 经验,生命,寿命,快乐 
    self.progress_height = 13
    self.progress_width = 212
    local font_size = 14 
    local x = 62;
    for i=0,2 do
        local y = 160 - i* 35;
        -- 进度条
        ZImage:create(self.pet_progress_panel,UILH_NORMAL.progress_bg2, x-2 ,  y-2 ,self.progress_width+4,17,10,500,500);
        if ( i == 0 ) then
            self.progress_exp_bg = ZImage:create(self.pet_progress_panel,UILH_NORMAL.progress_bar_orange, x , y,  self.progress_width,self.progress_height,10,500,500);
            ZLabel:create(self.progress_exp_bg.view,Lang.pet.pet_info_page[12], -52, 1, font_size+2,1); -- [1686]="#c66ff66经验:" 
            self.label_exp_progress = ZLabel:create(self.progress_exp_bg.view,"", 111, 1, font_size,2);--
        elseif (i == 1) then
            self.progress_hp_bg = ZImage:create(self.pet_progress_panel,UILH_NORMAL.progress_bar_green2, x , y,  self.progress_width,self.progress_height,10,500,500);
            ZLabel:create(self.progress_hp_bg.view,Lang.pet.pet_info_page[13],-52,1, font_size+2,1); -- [1687]="#c66ff66生命:"
            self.label_hp_progress = ZLabel:create(self.progress_hp_bg.view,"",111,1, font_size,2);--
        -- elseif ( i == 2 ) then
        --     self.tab_petinfo_view[24] = ZImage:create(self.pet_progress_panel,UIResourcePath.FileLocate.common .. "progress_green.png", x , y,  157,12,10,500,500);
        --     ZLabel:create(self.tab_petinfo_view[24].view,LangGameString[1688],-48,1,14,1); -- [1688]="#c66ff66寿命:"
        --     self.tab_petinfo_view[38] = ZLabel:create(self.tab_petinfo_view[24].view,"" ,78.5,1,14,2);--
        elseif ( i == 2 ) then
            self.progress_loyalty_bg = ZImage:create(self.pet_progress_panel,UILH_NORMAL.progress_bar_blue2, x , y, self.progress_width,self.progress_height,10,500,500);  
            ZLabel:create(self.progress_loyalty_bg.view,Lang.pet.pet_info_page[15],-52,1, font_size+2,1); -- [1689]="#c66ff66快乐:"
            self.label_loyalty_progress = ZLabel:create(self.progress_loyalty_bg.view,"" ,111,1, font_size,2);--
        end
    end

    -- 放生
    local btn_fangsheng = ZButton:create(self.pet_progress_panel,UILH_COMMON.button4,btn_free_fun,15,25,-1,-1)
    MUtils:create_zxfont(btn_fangsheng,Lang.pet.pet_info_page[8],77/2,14,2,16);     -- [8]="驱逐"
    -- "玩耍",现在叫赏赐。提升的叫忠诚，不叫快乐了
    local btn_shangci = ZButton:create(self.pet_progress_panel,UILH_COMMON.button4,btn_play_fun,105,25,-1,-1)
    MUtils:create_zxfont(btn_shangci,Lang.pet.pet_info_page[11],77/2,14,2,16);     -- [11] = 赏赐
    -- 改名
    local btn_gaiming = ZButton:create(self.pet_progress_panel,UILH_COMMON.button4,btn_change_name_fun,195,25,-1,-1)
    MUtils:create_zxfont(btn_gaiming,Lang.pet.pet_info_page[7],77/2,14,2,16);     -- [7] = 改名

    -- 分割线
    local line = CCZXImage:imageWithFile( 5, 10, width-18, 3, UILH_COMMON.split_line)
    self.pet_progress_panel:addChild(line)
end

function PetInfoPage:create_skill_panel(x, y, width, height,texture_path)
    self.skill_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.skill_panel)

    --宠物名字和等级的标题
    local title_panel = CCBasePanel:panelWithFile( 6, height-39, width-12, 35, UILH_NORMAL.title_bg4, 500, 500 )
    self.skill_panel:addChild(title_panel)
    MUtils:create_zxfont(title_panel,Lang.pet.pet_info_page[23],(width-12)/2,11,2,16);

    -- 宠物技能 
    self.pet_skill_items = {}
    local y = 98;
    for i=0,7 do
        if(i == 4) then
            y = 18;
        end
        local function slot_fun( obj, eventType, arg,msgid)
            local click_pos = Utils:Split(arg, ":")
            local end_x = click_pos[1];
            local end_y = click_pos[2];
            local world_pos = self.pet_skill_items[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )

            local p_s = PetWin:get_current_pet_info();
            if ( i < p_s.pet_skill_num ) then
                TipsModel:show_pet_skill_tip( world_pos.x,world_pos.y,p_s.tab_pet_skill_info[i+1] );
            elseif (  i >= p_s.tab_attr[34]  ) then
                GlobalFunc:create_screen_notic( Lang.pet.pet_info_page[17] ) -- [1691]="悟性达到12、24,成长到达13、26分别增加一个技能槽"
            end
        end
        self.pet_skill_items[i] = MUtils:create_slot_item2(self.skill_panel,UILH_NORMAL.item_bg2, 17 + (i % 4) * 80 ,y,64,64,nil,slot_fun,8)
    end
end

function PetInfoPage:create_pet_display_panel(x, y, width, height,texture_path)
    self.pet_display_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.pet_display_panel)

    --宠物名字和等级的标题
    local title_panel = CCBasePanel:panelWithFile( -9, 256, 356, 49, UILH_NORMAL.title_bg3, 0, 0)
    self.pet_display_panel:addChild(title_panel)
    self.label_name_and_level = MUtils:create_zxfont(title_panel,"",356/2,18,2,16);
    -- 名字和等级字符串
    self.str_pet_name = ""
    self.str_pet_level = ""

    -- 宠物背景
    local pet_bg = CCZXImage:imageWithFile( 5, 0, -1, -1, UILH_PET.pet_ronghe_bg,500,500)
    self.pet_display_panel:addChild(pet_bg)

    -- 宠物阶级背景
    self.jieji_bg = CCZXImage:imageWithFile( 6, 198, -1, -1, UILH_PET.ball1)
    self.jieji_bg:setIsVisible(false)
    self.pet_display_panel:addChild(self.jieji_bg)

    -- 宠物将级背景
    self.jiangji_bg = CCZXImage:imageWithFile( 260, 198, -1, -1, UILH_PET.ball3)
    self.jiangji_bg:setIsVisible(false)
    self.pet_display_panel:addChild(self.jiangji_bg)

    -- 战斗力标题
    ZImage:create(self.pet_display_panel, UILH_ROLE.text_zhandouli, 95, height-60)

    -- 战斗力数字
    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number1_%d.png",one_num);
    end
    self.fight_value_label = ImageNumberEx:create(0,get_num_ima,15)
    self.pet_display_panel:addChild( self.fight_value_label.view )
    self.fight_value_label.view:setPosition(CCPointMake(185,height-50))

    -- 炫耀
    self.btn_xuanyao = ZButton:create(self.pet_display_panel,{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s},xy_fun,11,12,-1,-1);
    self.btn_xuanyao:addImage(CLICK_STATE_DISABLE,UILH_COMMON.lh_button2_disable)
    self.btn_xuanyao.view:setCurState(CLICK_STATE_UP)
    MUtils:create_zxfont(self.btn_xuanyao,Lang.pet.pet_info_page[18],99/2,19,2,18);     -- [1692]="炫耀"
    -- 攻击类型按钮
    local btn_attack_type = ZButton:create(self.pet_display_panel,{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s},btn_physical_attack_fun,225,12,-1,-1);
    self.label_attack_type = MUtils:create_zxfont(btn_attack_type,Lang.pet.pet_info_page[4],99/2,19,2,18);

    -- 出战按钮
    local cz_btn = ZButton:create(self.pet_display_panel,UILH_ROLE.role_button1,btn_set_fight_fun,131, 5, -1, -1);   
    -- 出战按钮文字：出战，休息;
    self.label_xiuxi = ZCCSprite:create(cz_btn.view,UILH_PET.xiuxi,41, 38);
    self.label_chuzhan = ZCCSprite:create(cz_btn.view,UILH_PET.chuzhan,41, 38);
    self.label_chuzhan.view:setIsVisible(false);

    -- 宠物动画在update时创建
end

function PetInfoPage:update(type,tab_arg)

	if ( type == 1 ) then
        self:update_all(tab_arg[1]);
    elseif ( type == 2 ) then
    	self:update_attr(tab_arg[1],tab_arg[2],tab_arg[3]);
    elseif ( type == 3 ) then
    	self:cb_fight(tab_arg[1]);
    elseif ( type == 4 ) then
        self:cb_change_name(tab_arg[1],tab_arg[2]);
    elseif ( type == 5 ) then
    elseif ( type == 6 ) then
    elseif ( type == 7 ) then
    end

end

--
function PetInfoPage:update_all(p_s)

    if (p_s == nil) then
        return;
    end

	local pet_attrs = p_s.tab_attr;
    -- 判断是出战还是休息
    if ( pet_attrs[1] == PetModel:get_current_pet_id()  ) then
        if( PetModel:get_current_pet_is_fight()) then 
            -- 显示出战图片
            self.label_xiuxi.view:setIsVisible(true);
            self.label_chuzhan.view:setIsVisible(false);
            self.btn_xuanyao.view:setCurState(CLICK_STATE_UP)
        else
            self.label_chuzhan.view:setIsVisible(true);
            self.label_xiuxi.view:setIsVisible(false);
            self.btn_xuanyao.view:setCurState(CLICK_STATE_DISABLE)
        end
    else
        self.label_chuzhan.view:setIsVisible(true);
        self.label_xiuxi.view:setIsVisible(false);
        self.btn_xuanyao.view:setCurState(CLICK_STATE_DISABLE)
    end

    if ( self.fight_value_label ) then
        self.fight_value_label:set_number(pet_attrs[33])
    end

    self.str_pet_name = p_s.pet_name
    self.str_pet_level = pet_attrs[6]
    self.label_name_and_level:setText(self.str_pet_name.." Lv:"..self.str_pet_level)

    -- 经验生命寿命快乐进度条上的文字
    self.label_exp_progress:setText("#cffffff"..pet_attrs[9] .. "/" .. PetConfig:get_exp_by_lv(pet_attrs[6]));
    self.label_hp_progress:setText("#cffffff"..pet_attrs[3] .."/".. pet_attrs[17]);
    -- self.tab_petinfo_view[38]:setText("#cffffff"..pet_attrs[4] .."/26000");
    self.label_loyalty_progress:setText("#cffffff".. pet_attrs[5] .."/100");
    -- 经验生命寿命快乐进度条
    self.progress_exp_bg:setSize( math.min(pet_attrs[9]/PetConfig:get_exp_by_lv(pet_attrs[6]),1)  * self.progress_width,self.progress_height);
    self.progress_hp_bg:setSize( math.min(pet_attrs[3]/pet_attrs[17],1) * self.progress_width,self.progress_height);
    -- self.tab_petinfo_view[24]:setSize( math.min(pet_attrs[4]/26000,1) * 157,15);
    self.progress_loyalty_bg:setSize( math.min(pet_attrs[5]/100,1) * self.progress_width,self.progress_height);

    local str = pet_attrs[18] .. "#r" .. pet_attrs[20] .. "#r" .. pet_attrs[20] .. "#r" .. pet_attrs[21] .. "#r" .. pet_attrs[22] .. "#r" .. pet_attrs[23] .. "#r" .. pet_attrs[24] .. "#r" .. pet_attrs[17] ;
    -- 宠物属性
    self.dialog_left_attr_value:setText(str);
    str = pet_attrs[25] .. "#r" .. pet_attrs[26] .. "#r" .. pet_attrs[27] .. "#r" .. pet_attrs[28] ;
    -- 宠物资质
    self.dialog_right_attr_value:setText(str);
    -- 宠物悟性成长
    self.label_wuxing_value:setText("#cffffff" .. p_s.curr_wx); -- [1693]="悟性:#cffffff"
    self.label_chengzhang_value:setText("#cffffff" .. p_s.curr_grow ); -- [1694]="成长:#cffffff"
    -- 更新 宠物 宠阶 兽阶
    if (  self.tab_petinfo_view[10]  ) then 
        self.tab_petinfo_view[10]:removeFromParentAndCleanup(true);
        self.tab_petinfo_view[10] = nil;
        self.jieji_bg:setIsVisible(false)
    end
    if (  self.tab_petinfo_view[11]  ) then 
        self.tab_petinfo_view[11]:removeFromParentAndCleanup(true);
        self.tab_petinfo_view[11] = nil;
    end
    if (  self.tab_petinfo_view[12]  ) then 
        self.tab_petinfo_view[12]:removeFromParentAndCleanup(true);
        self.tab_petinfo_view[12] = nil;
        self.jiangji_bg:setIsVisible(false)
    end
    if (  self.tab_petinfo_view[13]  ) then 
        self.tab_petinfo_view[13]:removeFromParentAndCleanup(true);
        self.tab_petinfo_view[13] = nil;
    end
    if ( pet_attrs[15]~= 0 ) then 
        -- 宠阶
        self.jieji_bg:setIsVisible(true)
        self.tab_petinfo_view[10] = MUtils:create_sprite(self.jieji_bg,UIResourcePath.FileLocate.lh_pet .. "pet_jieji".. pet_attrs[15] ..".png",33, 32);
    end
    if( pet_attrs[16] ~=0 ) then
        -- 兽阶
        self.jiangji_bg:setIsVisible(true)
        self.tab_petinfo_view[12] = MUtils:create_sprite(self.jiangji_bg,UIResourcePath.FileLocate.lh_pet .. "pet_jiangji".. pet_attrs[16] ..".png",33, 32);
    end

    -- 2物攻，1法攻
    if ( p_s.tab_attr[14] == 2) then
        self.label_attack_type:setText(Lang.pet.pet_info_page[4])
        --self.zz_ccdialogex1:setText(Lang.pet.pet_info_page.left_info)
    else
        self.label_attack_type:setText(Lang.pet.pet_info_page[5])
        --self.zz_ccdialogex1:setText(Lang.pet.pet_info_page.left_info2)
    end

    -- 宠物技能 
    local y = 104 ;
    for i=0,7 do
 
        if(i == 4) then
            y = 44;
        end
        -- 设置技能背景
        local skill_kong = p_s.tab_attr[34];
        -- if ( i >= skill_kong ) then
        --     self.pet_skill_items[i]:set_icon_bg_texture( UIResourcePath.FileLocate.normal .. "item_bg02.png", -7, -7, 62, 62 )
        -- end

        -- 设置技能图标
        if ( i  < p_s.pet_skill_num) then 
            local path =  SkillConfig:get_skill_icon_path(p_s.tab_pet_skill_info[i+1].skill_id , p_s.tab_pet_skill_info[i+1].skill_lv);
            self.pet_skill_items[i]:set_icon_texture( path )
            self.pet_skill_items[i]:set_icon_bg_texture(UILH_NORMAL.item_bg2) 
        elseif i < skill_kong then
            self.pet_skill_items[i]:set_icon_texture( "" );
            self.pet_skill_items[i]:set_icon_bg_texture(UILH_NORMAL.item_bg2) 
        else
            self.pet_skill_items[i]:set_icon_texture( "" );
            self.pet_skill_items[i]:set_icon_bg_texture(UILH_NORMAL.lock)   
        end  

    end

    -- 更新宠物
    if ( self.spr == nil ) then
        local pet_file = string.format("scene/monster/%d",p_s.tab_attr[2]);
        local action = {0,0,9,0.2};
        self.spr = MUtils:create_animation(137.5+35,211+175-75-20,pet_file,action )
        node_pet_info:addChild( self.spr,1 );
    else
        self.spr:removeFromParentAndCleanup(true);
        local pet_file = string.format("scene/monster/%d",p_s.tab_attr[2]);
        local action = {0,0,9,0.2};
        self.spr = MUtils:create_animation(137.5+35,211+175-75-20,pet_file,action )
        node_pet_info:addChild( self.spr,1 );
    end
  
end

function PetInfoPage:update_attr( attr_id,attr_value,attr_value2 )
	 
    -- 延寿
    if ( attr_id == 4) then
        -- self.tab_petinfo_view[38]:setText("#cffffff"..attr_value .."/26000");
        -- self.tab_petinfo_view[24]:setSize(math.min(attr_value/26000,1) * 157,15);
    -- 玩耍
    elseif ( attr_id == 5 ) then
        self.label_loyalty_progress:setText("#cffffff".. attr_value .."/100");
        self.progress_loyalty_bg:setSize(math.min(attr_value/100,1) * self.progress_width,self.progress_height);
    -- 喂食
    elseif ( attr_id == 3 ) then
        self.label_hp_progress:setText("#cffffff"..attr_value .."/".. attr_value2);
        self.progress_hp_bg:setSize(math.min( attr_value/attr_value2,1 ) * self.progress_width,self.progress_height);
    -- 攻击类型 13
    elseif ( attr_id == 14 ) then
        -- 2物攻，1法攻
        if ( attr_value == 2) then
            self.label_attack_type:setText(Lang.pet.pet_info_page[4])
            --self.zz_ccdialogex1:setText(Lang.pet.pet_info_page.left_info)
        else
            self.label_attack_type:setText(Lang.pet.pet_info_page[5])
            --self.zz_ccdialogex1:setText(Lang.pet.pet_info_page.left_info2)
        end
    elseif ( attr_id == 9 ) then
        self.progress_exp_bg:setSize( math.min( attr_value/attr_value2,1)*self.progress_width,self.progress_height );
        self.label_exp_progress:setText("#cffffff"..attr_value .."/".. attr_value2);
    end
end

function PetInfoPage:cb_fight(pet_do_type)
	if(pet_do_type == 1) then
        -- 出战图标显示
        self.label_xiuxi.view:setIsVisible(true);
        -- 出战图标隐藏
        self.label_chuzhan.view:setIsVisible(false);
        self.btn_xuanyao.view:setCurState(CLICK_STATE_UP)
    else
        self.label_xiuxi.view:setIsVisible(false);
        self.label_chuzhan.view:setIsVisible(true);
        self.btn_xuanyao.view:setCurState(CLICK_STATE_DISABLE)
    end
end

function PetInfoPage:cb_change_name(pet_id,str_name)
    -- local temp_info = ChatModel:safe_check_sharp( str_name )
    -- print("temp_info", str_name, temp_info)
    self.str_pet_name = str_name;
    self.label_name_and_level:setText(LH_COLOR[1]..self.str_pet_name.." Lv:"..self.str_pet_level)
end

function PetInfoPage:on_active()
    -- LuaEffectManager:stop_view_effect( 10012,node_pet_info);
    -- LuaEffectManager:stop_view_effect( 10013,node_pet_info);
    -- -- 播放魔法阵特效
    -- LuaEffectManager:play_view_effect( 10012,142 ,215,node_pet_info,true ,0);
    -- LuaEffectManager:play_view_effect( 10013,142 ,215,node_pet_info,true ,2);

end
