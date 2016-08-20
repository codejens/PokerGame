-- FabaoWin.lua
-- created by fangjiehua on 2013-5-20
-- 法宝系统窗口

super_class.FabaoWin(NormalStyleWindow)

-- +44,-67
local fabao_name_list = {Lang.lingqi.lq_name[1],Lang.lingqi.lq_name[2],Lang.lingqi.lq_name[3],Lang.lingqi.lq_name[4],Lang.lingqi.lq_name[5]}; -- [96]="炼妖归元葫" -- [97]="璇玑金光镜" -- [98]="凰劫明心莲" -- [99]="璃炎幽剑阵" -- [100]="昊天玲珑塔"
local _is_other_fabao = false;
local _other_fabao_data = nil;

-- 提示法宝升级有可操作
local faBao_upgrade_tip = nil

-- 创建镶嵌的器魂
function FabaoWin:init_xianhun_loop( view )
    
    for i=1,8 do
        local x = 50;
        local y = 176
        if i == 1 then
            x = x - 5;
        elseif i == 2 then
            x = x + 70 - 2;
            y = y + 30;
        elseif i == 3 then
            x = x + 70 + 82 + 2;
            y = y + 30;
        elseif i == 4 then
            x = x+220+5;
        elseif i == 5 then
            x = x+220+5;
            y = y - 80 + 5;
        elseif i == 6 then
            x = x + 70 + 82 + 2;
            y = y + 53 - 182 + 5;
        elseif i == 7 then
            x = x + 70 - 2;
            y = y + 53 - 182 + 5;
        elseif i == 8 then
            x = x - 5;
            y = y - 80 + 5;
        end
        local loop_cell = XianhunCell:create_for_loop( x, y,54, 54);
        loop_cell.view:setAnchorPoint(0.5,0.5);
        loop_cell:set_win_name("fabao_win");
        view:addChild(loop_cell.view);
        
        self.xianhun_list[i] = loop_cell;

        local function xianhun_tip( )
            -- 显示tip
            local xianhun_data;
            if _is_other_fabao then
                
                xianhun_data = FabaoModel:fabao_xianhuns_format(_other_fabao_data);
                
            else
                xianhun_data = FabaoModel:get_fabao_xianhun(  )
            end

            if xianhun_data.xianhuns[i] then

                TipsModel:show_fabao_xianhun( 0,0, xianhun_data.xianhuns[i], TipsModel.LAYOUT_RIGHT );
            end

            if loop_cell.seal_icon_visible then
                local alert_text = string.format(LangGameString[954],((i-4)*10+1));  -- [954]="法宝达到%d级可解除此封印 "
                GlobalFunc:create_screen_notic(alert_text);
            end
        end
        loop_cell:set_click_event(xianhun_tip);
        
        local function unequip_xianhun(  )
            -- 双击卸载
            --卸下器魂
            self:unequip_xianhun( i );
        end
        loop_cell:set_double_click_event(unequip_xianhun);

        local function drag_in_event( cur_cell, other_slot )
            if cur_cell.seal_icon_visible then
                -- 锁住了
                local alert_text = string.format(LangGameString[954],((i-4)*10+1));  -- [954]="法宝达到%d级可解除此封印 "
                GlobalFunc:create_screen_notic(alert_text);
            else 
                FabaoModel:xiahun_swallow_logic( cur_cell, other_slot );
            end
        end
        loop_cell:set_drag_in( drag_in_event );

    end
    

end


-- 初始化
function FabaoWin:__init( )
    --
    local base_bg = CCBasePanel:panelWithFile(40,10,340,380,UIPIC_GRID_nine_grid_bg3,500,500);
    self:addChild(base_bg);
    -- MUtils:create_zximg(base_bg,"ui/wing/person_diwen.png",330/2-316/2,380/2-238/2,316,238)

	-- -- 标题
	-- local title_sp = CCZXImage:imageWithFile(389/2-230/2+18,429-45,226,46,UIResourcePath.FileLocate.common .. "win_title1.png");
	-- self:addChild(title_sp);
	-- local title = CCZXImage:imageWithFile(226/2-107/2+20,46/2-30/2+4,51,28,UIResourcePath.FileLocate.faBao .. "title.png");
	-- title_sp:addChild(title);

	-- 关闭按钮
	-- local close_btn = CCNGBtnMulTex:buttonWithFile(344, 370, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png")
 --    local exit_btn_size = close_btn:getSize()
 --    local spr_bg_size = self:getSize()
 --    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
 --  	close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "close_btn_s.png")
 --  	--注册关闭事件
 --  	local function close_fun( eventType )
 --  		if eventType == TOUCH_CLICK then
	-- 		  UIManager:hide_window("fabao_win");
	-- 	  end
	-- 	  return true
 --  	end
	-- close_btn:registerScriptHandler(close_fun) 
 --    self:addChild(close_btn,99)

    faBao_upgrade_tip = ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"exclamation_mark.png"),32,267,24,25,2)
    faBao_upgrade_tip.view:setIsVisible(false)

    ------------------------------------------------------------------------------------------------------------------
    -- tab 按钮
    self.radio_btn_dict = {};
  	self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(9, 145, 48, 240,nil);
    self:addChild(self.raido_btn_group);
    local img = {UIResourcePath.FileLocate.faBao .. "tab_equip.png",UIResourcePath.FileLocate.faBao .. "tab_uplevel.png",UIResourcePath.FileLocate.faBao .. "tab_intro.png"};
    for i=1,3 do
        local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
               self:selected_tab_button(i);
            end
            return true;
        end
        local x = 0;
        local y = 240 - i * 90;
        local btn = MUtils:create_radio_button(self.raido_btn_group,UIResourcePath.FileLocate.common .. "xxk-1.png",UIResourcePath.FileLocate.common .. "xxk-2.png",btn_fun,x,y,35,83,false);
    	-- MUtils:create_sprite(btn,img[i],24,69);
        self.radio_btn_dict[i] = btn;
        MUtils:create_zximg(btn,img[i],6,0,-1,-1);
    end
    ------------------------------------------------------------------------------------------------------------------


     -- 法宝形象底色
    local fab_bg = CCZXImage:imageWithFile(136,190,-1,-1,UIResourcePath.FileLocate.faBao.."fabao_bg.png")
    self:addChild(fab_bg)

    --------- 法宝显示panel
    self.fabao_panel = CCBasePanel:panelWithFile(43,126,330,257,"",500,500);
    self:addChild(self.fabao_panel);
    
    -- 创建镶嵌的器魂
    self.xianhun_list = {};
    self:init_xianhun_loop( self.fabao_panel );

    -- 法宝名字
    local name_bg = MUtils:create_zximg(self.fabao_panel,UIResourcePath.FileLocate.common .. "test_bg.png",330/2-190/2-4, 232,-1,-1);
    self.fabao_name = UILabel:create_lable_2( LangGameString[955], 190/2, 5, 16, ALIGN_CENTER ); -- [955]="#cfff000炼妖归元葫"
    name_bg:addChild( self.fabao_name );

    -- 法宝形象
    local action = {0,0,16,0.1};
    self.fabao_animate = MUtils:create_animation(162+39,160-18-80,"frame/gem/00001",action );
    self.fabao_panel:addChild(self.fabao_animate);

    -- 法宝战斗力
    local fightValue_lab = CCZXImage:imageWithFile(330/2-120+50,80,-1,-1,UIResourcePath.FileLocate.normal .. "common_tip_fight2.png");
    self.fabao_panel:addChild(fightValue_lab);

    -- 法宝形象底色
    local fazhanli_bg = CCZXImage:imageWithFile(-5,-3,160,20,UIResourcePath.FileLocate.common.."bluecmae_bg.png")
    fightValue_lab:addChild(fazhanli_bg)
    
    self.fabao_fight = ZXLabelAtlas:createWithString("888",UIResourcePath.FileLocate.normal .. "number");
    self.fabao_fight:setPosition(CCPointMake(350/2,88-8));
    self.fabao_panel:addChild(self.fabao_fight);

    -- 等级
    local level_lab = UILabel:create_lable_2( LangGameString[945], 8, 5, 14, ALIGN_LEFT ); -- [945]="#c38ff33等    级:"
    self.fabao_panel:addChild( level_lab );

    self.level = UILabel:create_lable_2( "10", 83, 5, 14, ALIGN_LEFT );
    self.fabao_panel:addChild( self.level );

    -- 进度条
    local progress_lab = UILabel:create_lable_2( LangGameString[946], 125, 5, 14, ALIGN_LEFT ); -- [946]="#c38ff33经    验:"
    self.fabao_panel:addChild(progress_lab);

    -- self.progress_bar = ZXProgress:createWithValue(0,140,125,17,true);
    -- self.progress_bar:setPosition(CCPointMake(85+115,3));
    -- self.fabao_panel:addChild(self.progress_bar);

    self.progress_bar = ZXProgress:createWithValueEx( 0,140,125,17,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar, true );
    self.progress_bar:setPosition(CCPointMake(85+115,3));
    self:addChild(self.progress_bar);


    -- 提升等级按钮
    self.uplevel_btn = TextButton:create(nil, 262, 25, 65, 30, LangGameString[956], UIResourcePath.FileLocate.common .. "button2.png"); -- [956]="提升"
    local function show_uplevel_win(  )
        -- 显示法宝升级窗口
        UIManager:show_window("fabao_uplevel_win");
        self:set_uplevel_panel_visiable(true);
        self.raido_btn_group:selectItem(1);
    end
    self.uplevel_btn:setTouchClickFun(show_uplevel_win);
    self.fabao_panel:addChild(self.uplevel_btn.view);

    -- 展示按钮
    self.show_btn = TextButton:create(nil, 305, 15, 65, 30, LangGameString[957], "ui/common/button2.png"); -- [957]="展示"
    local function show_fabao_func(  )
        FabaoModel:xuanyao_fabao(  );
    end
    self.show_btn:setTouchClickFun(show_fabao_func);
    self:addChild(self.show_btn);


    -- 法宝详细信息按钮
    self.detail_btn = TextButton:create(nil, 5, 25, 65, 30, LangGameString[958], UIResourcePath.FileLocate.common .. "button2.png"); -- [958]="详细"
    local function show_detail_win(  )
        -- 显示法宝详细窗口
        UIManager:show_window("fabao_detail_win");
    end
    self.detail_btn:setTouchClickFun(show_detail_win);
    self.fabao_panel:addChild(self.detail_btn.view);

    --------  法宝形态预览panel
    self.uplevel_panel = CCBasePanel:panelWithFile(36,116,330,257,"",500,500);
    self:addChild(self.uplevel_panel);
    self.uplevel_panel:setIsVisible(false);

    --形态预览
    local preview_lab = ZImageImage:create(self.uplevel_panel,UIResourcePath.FileLocate.normal .."about_xingxiang.png" ,UIResourcePath.FileLocate.common .. "quan_bg.png",8,241,333,-1,500,500); -- [959]="#cfff000形态预览"

    --法宝预览名字
    local pre_name_bg = MUtils:create_zximg(self.uplevel_panel,UIResourcePath.FileLocate.common .. "test_bg.png",330/2-190/2, 208,-1,-1);
    self.preview_name = UILabel:create_lable_2( LangGameString[960], 190/2, 4, 16, ALIGN_CENTER ); -- [960]="1-10级:炼妖归元葫"
    pre_name_bg:addChild(self.preview_name);

    -- 左右翻选按钮
    local function page_btn_event( index )
        print("法宝预览当前index ",index);
        self:update_fabao_preview(index);
    end
    self.page_btn = MUtils:create_page_btn( self.uplevel_panel, 30, 86, 278, 120, 5, page_btn_event );

    -- 法宝形象预览
    local action = {0,0,16,0.1};
    self.fabao_preview_animate = MUtils:create_animation( 162+44,160-70,"frame/gem/00001",action );
    self.uplevel_panel:addChild( self.fabao_preview_animate );

    -- 法宝战斗力
    local fightValue_lab = CCZXImage:imageWithFile(330/2-120+55,58,-1,-1,UIResourcePath.FileLocate.normal .. "common_tip_fight2.png");
    self.uplevel_panel:addChild(fightValue_lab);

    -- 法宝形象底色
    local fazhanli_bg = CCZXImage:imageWithFile(-5,-3,160,20,UIResourcePath.FileLocate.common.."bluecmae_bg.png")
    fightValue_lab:addChild(fazhanli_bg)
    
    self.fabao_fight_lv = ZXLabelAtlas:createWithString("88888",UIResourcePath.FileLocate.normal .. "number");
    self.fabao_fight_lv:setPosition(CCPointMake(360/2,58));
    self.uplevel_panel:addChild(self.fabao_fight_lv);

    -- 升级说明
    local text = LangGameString[961]; -- [961]="#c00c0ff每升10级,法宝会进化新的形态#r属性大增,并解除一个器魂封印"
    MUtils:create_ccdialogEx(self.uplevel_panel, text, 55,20,230,40,4,14);

    -- 分割线
    local split_img = ZImageImage:create(self.view,UIResourcePath.FileLocate.faBao .. "renwu_up.png",UIResourcePath.FileLocate.common .. "quan_bg.png",44,100,333,-1,500,500);

    --------- 法宝属性panel
    local attri_panel = CCBasePanel:panelWithFile(43,20,320,100,"",500,500);
    self:addChild(attri_panel);
    --local attri_lab = UILabel:create_lable_2( LangGameString[962], 0, 100-20, 14, ALIGN_LEFT ) -- [962]="#cfff000增加人物属性"
    --attri_panel:addChild(attri_lab);

    self.at_attri = MUtils:create_attrs_bar( attri_panel, 10, 100-45, LangGameString[963], 50 ); -- [963]="攻    击:"
    
    self.wd_attri = MUtils:create_attrs_bar( attri_panel, 10, 100-45-25, LangGameString[964], 50 ); -- [964]="物理防御:"

    self.bj_attri = MUtils:create_attrs_bar( attri_panel, 10, 100-45-50, LangGameString[965], 50 ); -- [965]="抗 暴 击:"

    self.hp_attri = MUtils:create_attrs_bar( attri_panel, 165, 100-45, LangGameString[966], 50 ); -- [966]="生    命:"
    
    self.md_attri = MUtils:create_attrs_bar( attri_panel, 165, 100-45-25, LangGameString[967], 50 );   -- [967]="法术防御:"


 
end



----------------------操作逻辑----------------------
-- 选择了那个tab
function FabaoWin:selected_tab_button( index )
    if index == 1 then
        if not _is_other_fabao then
            UIManager:show_window("lianhun_win");
            self:set_uplevel_panel_visiable(false);
        end
    elseif index == 2 then
        UIManager:show_window("fabao_uplevel_win");
        self:set_uplevel_panel_visiable(true);

    elseif index == 3 then
        UIManager:show_window("fabao_intro_win");
        self:set_uplevel_panel_visiable(false);
    end
    self.raido_btn_group:selectItem(index-1);
end

-- 设置升级面板的可见性
function FabaoWin:set_uplevel_panel_visiable( bool )
    self.uplevel_panel:setIsVisible(bool)
    self.fabao_panel:setIsVisible(not bool);
end


-- 卸下器魂
function FabaoWin:unequip_xianhun( index )
    
    local xianhun_data = FabaoModel:get_fabao_xianhun(  )
    local count = xianhun_data.count;
    local xianhuns = xianhun_data.xianhuns;

    if index <= count then

        if FabaoModel:get_lianhun_bag_is_full(  ) then
            
            GlobalFunc:create_screen_notic(LangGameString[968]); -- [968]="炼魂背包已满，无法卸下器魂"

        else 
            local xianhun = xianhuns[index];
            FabaoModel:unequip_a_xianhun( xianhun.id );
        end
    end

end



----------------------界面更新----------------------
function FabaoWin:update_fabao_upgrade_tip( )
    --         print("打开法宝窗口，打印法宝等级.......................",FabaoModel:get_fabao_info().level)

    -- local temp_count = 0
    -- temp_count = ItemModel:get_item_count_by_id(18603)
    -- if temp_count <= 0 then
    --     temp_count = ItemModel:get_item_count_by_id(18604)
    -- end
    -- if temp_count <= 0 then
    --     temp_count = ItemModel:get_item_count_by_id(18605)
    -- end
    -- if (temp_count > 0)  and 1 then
    if FabaoModel:if_can_upgrade( ) then 
        faBao_upgrade_tip.view:setIsVisible(true)
    else
        faBao_upgrade_tip.view:setIsVisible(false)
    end
end
function FabaoWin:active( show )
    if show then    
        if _is_other_fabao then
            self.radio_btn_dict[2]:setIsVisible(false);
            self.radio_btn_dict[3]:setIsVisible(false);

            self.uplevel_btn.view:setIsVisible(false);
            self.show_btn.view:setIsVisible(false);
            self.detail_btn.view:setIsVisible(false);
        else
            UIManager:show_window("lianhun_win");
            FabaoModel:req_fabao_info( );
            FabaoModel:req_fabao_xianhun_info();    
            self.raido_btn_group:selectItem(0);
            self:selected_tab_button( 1 );

            self.uplevel_btn.view:setIsVisible(true);
            self.show_btn.view:setIsVisible(true);
            self.detail_btn.view:setIsVisible(true);

            self.radio_btn_dict[2]:setIsVisible(true);
            self.radio_btn_dict[3]:setIsVisible(true);
        end
        self:update_fabao_upgrade_tip()

    else
        
        _is_other_fabao = false;
        _other_fabao_data = nil;

        UIManager:hide_window("lianhun_win");
        UIManager:hide_window("fabao_detail_win");
        UIManager:hide_window("fabao_uplevel_win");
        UIManager:hide_window("fabao_intro_win");
    end
end

-- 总体的更新
function FabaoWin:update(  )
    
end

-- 更新法宝信息
function FabaoWin:update_fabao_info(  )
    
    local stage=1;
    local level=1;
    local exp=1;
    local fight=1;
    if _is_other_fabao then
        -- 他人法宝
        if _other_fabao_data then
            local fabao_info = FabaoModel:fabao_info_format(_other_fabao_data)
            stage = fabao_info.jingjie;
            level = fabao_info.level + (stage-1)*10;

            exp = fabao_info.exp;
            fight = fabao_info.fight;
        end
    else
        local fabao_info = FabaoModel:get_fabao_info( )
        stage = fabao_info.jingjie;
        level = fabao_info.level;
        exp = fabao_info.exp;
        fight = fabao_info.fight;
    end

    -- 更新法宝属性
     
    local fabao_config = FabaoConfig:get_fabao( stage, level - (stage-1)*10 );
    print("更新法宝属性",stage, level,level + (stage-1)*10);
    -- 法宝名字
    self.fabao_name:setText( fabao_config.name );
    -- 法宝等级
    self.level:setText(""..level);
    --法宝经验
    self.progress_bar:setProgressValue( exp, fabao_config.baseAttrs.upExp );
    --法宝战斗力
    self.fabao_fight:init( fight );

    self.fabao_fight_lv:init( fight );

    if self.at_attri then
        
        -- 攻击属性
        self.at_attri.update_data(fabao_config.baseAttrs.baseAttrs[1]);
        -- 生命属性
        self.hp_attri.update_data(fabao_config.baseAttrs.baseAttrs[2])
        -- 物理防御属性
        self.wd_attri.update_data(fabao_config.baseAttrs.baseAttrs[3])
        -- 法术防御属性
        self.md_attri.update_data(fabao_config.baseAttrs.baseAttrs[4])
        -- 暴击防御属性
        self.bj_attri.update_data(fabao_config.baseAttrs.baseAttrs[5]);

    end

end

-- 更新战斗力
function FabaoWin:update_fight_value( fight_value )

    if not _is_other_fabao then
        --打开自己的法宝界面才刷新这个战斗力
        self.fabao_fight:init( ""..fight_value );
        self.fabao_fight_lv:init(""..fight_value);
    end
end


-- 更新镶嵌的器魂环
function FabaoWin:update_xianhun_loop(  )
    local count,xianhuns;
    if _is_other_fabao then
        -- 他人法宝
        local xianhun_data = FabaoModel:fabao_xianhuns_format(_other_fabao_data);
        count = xianhun_data.count;
        xianhuns = xianhun_data.xianhuns;
        
    else
        local xianhun_data = FabaoModel:get_fabao_xianhun(  )
        count = xianhun_data.count;
        xianhuns = xianhun_data.xianhuns;
    end
    -- print("更新镶嵌的器魂环", xianhun_data.xianhuns);
    if xianhuns == nil then
        return ;
    end

    for i,xianhun_item in ipairs( self.xianhun_list) do
        
        if i > count then
            print(i,count);
            xianhun_item:set_seal_visible(true);
        else 
            xianhun_item:set_seal_visible(false);
        end

        if xianhuns[i] then
            
            xianhun_item:update_loop_cell(xianhuns[i]);
        else
            xianhun_item:clear_loop_cell();
        end

    end
end

-- 更新当前法宝形象
function FabaoWin:update_current_fabao_avatar( jingjie )
    if self.fabao_animate then
        self.fabao_animate:removeFromParentAndCleanup(true);
    end

    local frame_str = string.format("frame/gem/%05d",jingjie);
    local action = {0,0,15,0.1};
    self.fabao_animate = MUtils:create_animation( 162+39,160-20-67,frame_str,action );
    self.fabao_panel:addChild( self.fabao_animate );

    print("法宝预览至",jingjie);

    self.page_btn.update_index( jingjie );
    
end

-- 更新法宝形象预览
function FabaoWin:update_fabao_preview( index )
    -- 更新法宝形象
    if self.fabao_preview_animate then
        
        self.fabao_preview_animate:removeFromParentAndCleanup(true);

    end
    local frame_str = string.format("frame/gem/%05d",index);
    local action = {0,0,15,0.1};
    self.fabao_preview_animate = MUtils:create_animation( 162+44,160-67-10,frame_str,action );
    self.uplevel_panel:addChild( self.fabao_preview_animate );

    -- 更新法宝名字预览
    if self.preview_name then
        
        local lv_1 = (index-1)*10 + 1;
        local lv_2 = index * 10;
        local name = string.format(LangGameString[969],lv_1,lv_2,fabao_name_list[index]); -- [969]="%d-%d级:%s"
        self.preview_name:setText(name);
        
    end
end


--查看他人法宝
function FabaoWin:show_other_fabao( other_fabao )
    
     UIManager:hide_window("fabao_win");

    _is_other_fabao = true;
    _other_fabao_data = other_fabao;

    local win = UIManager:show_window("fabao_win");
    win:update_fabao_info();
    win:update_xianhun_loop();

    local fabao_info = FabaoModel:fabao_info_format( _other_fabao_data )
    win:update_current_fabao_avatar( fabao_info.jingjie )

end

