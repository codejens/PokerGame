-- LingqiLeft.lua
-- created by xiehande on 2014-10-29
-- 灵器系统左页面
super_class.LingqiLeft(Window)

local _is_other_fabao = false;
local _other_fabao_data = nil;

-- 提示法宝升级有可操作
local faBao_upgrade_tip = nil

--对应阶的美人图谱
local beauty_img_array = {
    UILH_LINGQI.beauty1,
    UILH_LINGQI.beauty2,
    UILH_LINGQI.beauty3,
    UILH_LINGQI.beauty4,
    UILH_LINGQI.beauty5,
}

--对应的美人背景  --牌
local beauty_bg_array = {
    UILH_LINGQI.pai1,
    UILH_LINGQI.pai2,
    UILH_LINGQI.pai3,
    UILH_LINGQI.pai4,
    UILH_LINGQI.pai5,
}

--对应的美人名字
local lingqi_name_list = {
    UILH_LINGQI.name_t_1,
    UILH_LINGQI.name_t_2,
    UILH_LINGQI.name_t_3,
    UILH_LINGQI.name_t_4,
    UILH_LINGQI.name_t_5,
}

--创建方法
function  LingqiLeft:create(width, height, texture_name)
    return LingqiLeft( "LingqiLeft", texture_name, true, width, height)
end

--初始化
function  LingqiLeft:__init( window_name, texture_name, is_grid, width, height )
   -- local panel_bg = CCBasePanel:panelWithFile(pos_x,pos_y,width,height,texture_name);
   -- self.view = panel_bg
    local  bg_panel = self.view
    
    --背景底图
    -- local base_bg = CCBasePanel:panelWithFile(0,0,width,500,"",500,500);
    -- self:addChild(base_bg);
   --灵器底板的圆背景
 -- 	local bg = CCZXImage:imageWithFile( -15, 0, 540,350 , "")
	-- local bg_left = CCZXImage:imageWithFile( 14, 0, -1, -1, UILH_LINGQI.lingqi_bg_left )
	-- local bg_right = CCZXImage:imageWithFile( 220, 0, -1, -1, UILH_LINGQI.lingqi_bg_left )
	-- bg_right:setFlipX(true)
	-- bg:addChild(bg_left,-1)
	-- bg:addChild(bg_right,-1)
	-- panel_bg:addChild(bg)

   self:draw_panel(self.view)
   self:active(true)
end

--绘制页面
function  LingqiLeft:draw_panel(panel_bg)
    
    --灵器名称
    -- local title_bg = CCZXImage:imageWithFile( 3, 461, 417, 35, UILH_COMMON.title_bg2, 500, 500 )
    -- self.fabao_name =  UILabel:create_lable_2(LH_COLOR[5]..lingqi_name_list[1], 154, 10, font_size, ALIGN_LEFT ) 
    -- title_bg:addChild( self.fabao_name)
    -- panel_bg:addChild(title_bg)


   --  faBao_upgrade_tip = ZImage:create(panel_bg, UI_DAILYACTIVITY.exclamation_mark,32,267,24,25,2)
   -- faBao_upgrade_tip.view:setIsVisible(false)


      --战斗力
    local fightValue_lab = CCZXImage:imageWithFile(24,453,-1,-1,UILH_LINGQI.common_tip_fight2);
    panel_bg:addChild(fightValue_lab);

    self.fabao_fight = ZXLabelAtlas:createWithString("888",UIResourcePath.FileLocate.lh_other .. "number1_");
    self.fabao_fight:setPosition(26,430);
    panel_bg:addChild(self.fabao_fight);



     -- 法宝形象底色
    -- local fab_bg = CCZXImage:imageWithFile(121,138,-1,-1,UILH_LINGQI.lingqi_bg)
    -- panel_bg:addChild(fab_bg)

    --------- 法宝显示panel
    self.fabao_panel = CCBasePanel:panelWithFile(2,43,420,450,"",500,500);
    panel_bg:addChild(self.fabao_panel);

    --美人图谱
    local meiren_x = 131
    local meiren_y = 230
        -- 创建镶嵌的器魂
    self.xianhun_list = {};

    --初始化器魂的位置
    self:init_xianhun_loop( self.fabao_panel );

    -- 法宝形象
    --默认显示一下一级的法宝
    -- local action = {0,0,16,0.1};
    -- self.fabao_animate = MUtils:create_animation(10,200,"frame/gem/00001",action );
    -- panel_bg:addChild(self.fabao_animate);
    --动画改美人
    self.beauty = CCZXImage:imageWithFile(meiren_x,meiren_y,-1,-1,UILH_LINGQI.beauty1)
    self.pai    = CCZXImage:imageWithFile(-4,-7,-1,-1,UILH_LINGQI.pai1)
    self.fabao_name = CCZXImage:imageWithFile(55,221,-1,- 1,UILH_LINGQI.name_t_1)
    self.beauty:addChild(self.pai)
    self.pai:addChild(self.fabao_name)
    panel_bg:addChild(self.beauty)
    -- self.fabao_name =  UILabel:create_lable_2(LH_COLOR[5]..lingqi_name_list[1], 36, 221, font_size, ALIGN_LEFT ) 
    -- self.beauty:addChild(self.fabao_name) 

   
   --按钮的Ｙ轴位置
    local but_pos_y = 4

    -- 展示按钮  炫耀  
    local function show_fabao_func(  )
        FabaoModel:xuanyao_fabao(  );
    end
    self.show_btn = TextButton:create( nil, 36, but_pos_y, -1, -1, LH_COLOR[2]..Lang.lingqi.info[1], UILH_COMMON.btn4_nor ) 
    self.show_btn:setTouchClickFun(show_fabao_func)
    self.show_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.btn4_nor)
    panel_bg:addChild(self.show_btn.view)


    --器魂一览
    local function show_qihun(  )
        local win = UIManager:find_visible_window("lingqi_win")
        if win then
        	win:change_page(4)
        end
    end
    self.yilang_btn = TextButton:create( nil, 265, but_pos_y, -1, -1, LH_COLOR[2]..Lang.lingqi.info[2], UILH_COMMON.btn4_nor ) 
    self.yilang_btn:setTouchClickFun(show_qihun)
    self.yilang_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.btn4_nor)
    panel_bg:addChild(self.yilang_btn.view)




    -- 法宝详细信息按钮
    -- self.detail_btn = TextButton:create(nil, 5, 25, 65, 30, LangGameString[958], UIResourcePath.FileLocate.common .. "button2.png"); -- [958]="详细"
    -- local function show_detail_win(  )
    --     -- 显示法宝详细窗口
    --     UIManager:show_window("fabao_detail_win");
    -- end
    -- self.detail_btn:setTouchClickFun(show_detail_win);
    -- self.fabao_panel:addChild(self.detail_btn.view);
    
    -- self.fabao_fight_lv = ZXLabelAtlas:createWithString("88888",UIResourcePath.FileLocate.normal .. "number");
    -- self.fabao_fight_lv:setPosition(CCPointMake(360/2,58));
    -- self.fabao_panel:addChild(self.fabao_fight_lv);

    -- -- 升级说明
    -- local text = LangGameString[961]; -- [961]="#c00c0ff每升10级,法宝会进化新的形态#r属性大增,并解除一个器魂封印"
    -- MUtils:create_ccdialogEx(self.uplevel_panel, text, 55,20,230,40,4,14);

end


function LingqiLeft:init_xianhun_loop(view)
	-- 八个器魂位置
	for i=1,8 do
	        -- local x = 70;
	        -- local y = 200
	        -- if i == 1 then
	        --     x = 218;
	        --     y = 335;
	        -- elseif i == 2 then
         --        x = 336-4;
	        --     y = y + 103-4;
	        -- elseif i == 3 then
	        --     x = 366;
	        -- elseif i == 4 then
	        --     x = 336;
	        --     y =84+4;
	        -- elseif i == 5 then
	        --     x = 218;
	        --     y = 48;
	        -- elseif i == 6 then
	        --     x = x + 31;
	        --     y =84+4;
	        -- elseif i == 7 then
	        --      x = x-5;
	        -- elseif i == 8 then
	        --     x = x + 31+4;
	        --     y = y + 103-4;
         --    end
            
            --位置1
            local x1 = 80;
            local y1 = 60;
            --位置2
            local y2 =140 
            local gas_x = 88
            local sum = 0 

            if i == 1 then
                x = x1;
                y = y2;
            elseif i == 2 then
                x = x+gas_x;
                y = y2;
            elseif i == 3 then
                x = x+gas_x;
                y = y2;
            elseif i == 4 then
                x = x+gas_x;
                y =y2;
            elseif i == 5 then
                x = x1;
                y = y1;
            elseif i == 6 then
                x = x+gas_x;
                y =y1;
            elseif i == 7 then
                 x = x+gas_x;
                 y = y1
            elseif i == 8 then
                x = x+gas_x;
                y = y1;
            end

        local loop_cell =  XianhunCell:create_for_loop( x, y,87, 85);
        loop_cell.view:setAnchorPoint(0.5,0.5);
        loop_cell:set_win_name("lq_left_win");
        view:addChild(loop_cell.view);
        --保存器魂信息
        self.xianhun_list[i] = loop_cell;

        --点击弹出tip
        local function xianhun_tip( )
            -- 显示tip
            local xianhun_data;
            if _is_other_fabao then
                xianhun_data = FabaoModel:fabao_xianhuns_format(_other_fabao_data);
            else
                xianhun_data = FabaoModel:get_fabao_xianhun(  )
            end
            if xianhun_data.xianhuns then 
	            if xianhun_data.xianhuns[i] then

	                TipsModel:show_fabao_xianhun( 0,0, xianhun_data.xianhuns[i], TipsModel.LAYOUT_RIGHT );
	            end

	            if loop_cell.seal_icon_visible then
	                local alert_text = string.format(LH_COLOR[2]..Lang.lingqi[8],((i-4)*10+1));  -- [954]="法宝达到%d级可解除此封印 "
	                GlobalFunc:create_screen_notic(alert_text,16,270,190);
	            end
	        end
        end
        loop_cell:set_click_event(xianhun_tip);


    --双击卸载
	    local function unequip_xianhun(  )
	        -- 双击卸下器魂
	        self:unequip_xianhun( i );
	    end
	    loop_cell:set_double_click_event(unequip_xianhun);


      local function drag_in_event( cur_cell, other_slot )
            if cur_cell.seal_icon_visible then
                -- 锁住了
                local alert_text = string.format(LH_COLOR[2]..Lang.lingqi[8],((i-4)*10+1));  -- [954]="法宝达到%d级可解除此封印 "
                GlobalFunc:create_screen_notic(alert_text,16,270,190);
            else 
                FabaoModel:xiahun_swallow_logic( cur_cell, other_slot );
            end
        end
        loop_cell:set_drag_in( drag_in_event );
    end

end


--卸下器魂
function LingqiLeft:unequip_xianhun( index )
    --器魂
    local xianhun_data = FabaoModel:get_fabao_xianhun(  )
    local count = xianhun_data.count;
    local xianhuns = xianhun_data.xianhuns;
    
    --炼魂 查看是否炼魂背包已满
    local lianhun_xianhun_data =  FabaoModel:get_lianhun_xianhun_list(  ) 
    local lianhun_count = lianhun_xianhun_data.count
    local lianhun_xianhun_list = lianhun_xianhun_data.xianhun_list

    if index <= count then
        --已开启的背包格子数已放满 或者 达到20格子
       if ( lianhun_count ==#lianhun_xianhun_list) or FabaoModel:get_lianhun_bag_is_full(  ) then
            GlobalFunc:create_screen_notic(LH_COLOR[2]..Lang.lingqi[6],16,270,190); -- [968]="炼魂背包已满，无法卸下器魂"
        else 
            local xianhun = xianhuns[index];
            FabaoModel:unequip_a_xianhun( xianhun.id );
        end
    end
end

function LingqiLeft:update_fabao_upgrade_tip( )
	--判断是否可以升级
    -- if FabaoModel:if_can_upgrade( ) then 
    --     faBao_upgrade_tip.view:setIsVisible(true)
    -- else
    --     faBao_upgrade_tip.view:setIsVisible(false)
    -- end
end

--页面刷新
function  LingqiLeft:active( show)
   if show then
      self:update()
   end
end

--总体的刷新
function LingqiLeft:update( )
       	  --如果是他人的法宝
      if _is_other_fabao then
            self.show_btn.view:setIsVisible(false);
            self.yilang_btn.view:setIsVisible(false)
      else
      	            --器魂数据
            FabaoModel:req_fabao_xianhun_info();   

            --法宝数据
            FabaoModel:req_fabao_info( );
 
            self.show_btn.view:setIsVisible(true);
            _is_other_fabao = false;
            _other_fabao_data = nil;
           
      end

    -- self:update_fabao_upgrade_tip() 
    -- --更新法宝信息
    -- self:update_fabao_info();
    -- --更新器魂信息
    -- self:update_xianhun_loop();
    
    -- local fabao_info = FabaoModel:fabao_info_format( _other_fabao_data )
    -- --更新法宝形象
    -- self:update_current_fabao_avatar( fabao_info.jingjie )
    -- self:update_fight_value()

end




-- 更新法宝信息
function LingqiLeft:update_fabao_info(  )
    local stage=1;
    local level=1;
    -- local exp=1;
    local fight=1;
    if _is_other_fabao then
        --如果是别人的法宝
        if _other_fabao_data then
            local fabao_info = FabaoModel:fabao_info_format(_other_fabao_data)
            stage = fabao_info.jingjie;
            level = fabao_info.level + (stage-1)*10;

            -- exp = fabao_info.exp;
            fight = fabao_info.fight;
        end
    else  --自己的法宝
        local fabao_info = FabaoModel:get_fabao_info( )
        stage = fabao_info.jingjie;
        level = fabao_info.level;
        -- exp = fabao_info.exp;
        fight = fabao_info.fight;
    end

    -- 更新法宝属性
    local fabao_config = FabaoConfig:get_fabao( stage, level - (stage-1)*10 );

    -- 法宝名字
    --不需要
    -- self.fabao_name:setText( LH_COLOR[5]..fabao_config.name );
    self.fabao_name:setTexture(lingqi_name_list[stage])
    --法宝战斗力
    self.fabao_fight:init( fight );

   
end


-- 更新战斗力
function LingqiLeft:update_fight_value( fight_value )
    if not _is_other_fabao then
        --打开自己的法宝界面才刷新这个战斗力
        self.fabao_fight:init( ""..fight_value );
       -- self.fabao_fight_lv:init(""..fight_value);
    end
end


-- 更新镶嵌的器魂环
function LingqiLeft:update_xianhun_loop(  )
	-- print("  更新镶嵌的器魂环   LingqiLeft:update_xianhun_loop")
    local count,xianhuns;
    if _is_other_fabao then
        -- 他人法宝
        local xianhun_data = FabaoModel:fabao_xianhuns_format(_other_fabao_data);
        count = xianhun_data.count;
        xianhuns = xianhun_data.xianhuns;

    else --自己的法宝
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


--更新当前法宝形象   
function LingqiLeft:update_current_fabao_avatar( jingjie )
	-- print("==  更新当前法宝形象 ======  ,jingjie= ",jingjie)

--     if self.fabao_animate then
--         self.fabao_animate:removeFromParentAndCleanup(true);
--     end

--     local frame_str = string.format("frame/gem/%05d",jingjie);
--     local action = {0,0,15,0.1};
--     self.fabao_animate = MUtils:create_animation( 220,200,frame_str,action );
--     self.fabao_panel:addChild( self.fabao_animate );
self.beauty:setTexture(beauty_img_array[jingjie])   
self.pai:setTexture(beauty_bg_array[jingjie])

end


--查看他人法宝  从他人的排行榜 和 个人信息入口进入
function LingqiLeft:show_other_fabao( other_fabao )
    
     -- UIManager:hide_window("lingqi_win");
   
	    _is_other_fabao = true;
	    _other_fabao_data = other_fabao;

   -- local win = UIManager:show_window("lingqi_win");

       --更新器魂信息
    self:update_xianhun_loop();

    --更新法宝信息
    self:update_fabao_info();
    

    self.show_btn.view:setIsVisible(false);
    self.yilang_btn.view:setIsVisible(false)

    
    local fabao_info = FabaoModel:fabao_info_format( _other_fabao_data )
    --更新法宝形象
    self:update_current_fabao_avatar( fabao_info.jingjie )


end