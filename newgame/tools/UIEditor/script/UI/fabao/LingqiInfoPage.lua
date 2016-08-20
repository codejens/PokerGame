-- LingqiInfoPage.lua
-- created by xiehande on 2014-10-29
-- 灵器系统右页面 信息页面
super_class.LingqiInfoPage(Window)
local font_size = 16
local color_type = LH_COLOR[2]

local _is_other_fabao = false;
local _other_fabao_data = nil;


--对应阶的美人图谱
local beauty_img_array = {
    UILH_LINGQI.beauty1,
    UILH_LINGQI.beauty2,
    UILH_LINGQI.beauty3,
    UILH_LINGQI.beauty4,
    UILH_LINGQI.beauty5,
}

--对应的灰化的美人图
local beauty_img_array_d = {
    UILH_LINGQI.beauty1_d,
    UILH_LINGQI.beauty2_d,
    UILH_LINGQI.beauty3_d,
    UILH_LINGQI.beauty4_d,
    UILH_LINGQI.beauty5_d,
}


--对应的美人背景  --牌
local beauty_bg_array = {
    UILH_LINGQI.pai1,
    UILH_LINGQI.pai2,
    UILH_LINGQI.pai3,
    UILH_LINGQI.pai4,
    UILH_LINGQI.pai5,
}

local lingqi_name_list = {
    UILH_LINGQI.name_t_1,
    UILH_LINGQI.name_t_2,
    UILH_LINGQI.name_t_3,
    UILH_LINGQI.name_t_4,
    UILH_LINGQI.name_t_5,
}

--等级开放
local  lingqi_level_open = {
    [2] = UILH_LINGQI.later_11,
    [3] = UILH_LINGQI.later_21,
    [4] = UILH_LINGQI.later_31,
    [5] = UILH_LINGQI.later_41,
}

local beauty_array = {}


--创建方法
function  LingqiInfoPage:create( )
	return LingqiInfoPage( "LingqiInfoPage", "", true, 880, 500)
end

--初始化
function  LingqiInfoPage:__init(window_name, texture_name, is_grid, width, height)
	local  bg_panel = self.view
    
    --背景底图
    local base_bg = CCBasePanel:panelWithFile(8,0,865,500,"",500,500);
    self:addChild(base_bg);
    
	self:create_panel(base_bg)
	self.xianhuns = {}
	self.count = 0

    _is_other_fabao = false
end


function  LingqiInfoPage:create_one_beauty( panel_bg,x,y,width,height,index,can_light)
    local one_beauty = {}

    local  img_bg  = CCBasePanel:panelWithFile(x, y, width, height, UILH_COMMON.bg_02, 500, 500)
    one_beauty.view =  img_bg
    local  b_img = nil
    if can_light then
        b_img = beauty_img_array[index]
    else
        b_img = beauty_img_array_d[index]
    end
    one_beauty.b_img = b_img
    local beauty = CCZXImage:imageWithFile(1,69+3+20,-1,-1,b_img)
    one_beauty.beauty = beauty
    local pai    = CCZXImage:imageWithFile(-4,-7,-1,-1,beauty_bg_array[index])
    one_beauty.pai = pai
    local name   = CCZXImage:imageWithFile(55,221,-1,-1,lingqi_name_list[index])
    one_beauty.name = name
    local attrs  = CCZXImage:imageWithFile(5,3,-1,-1,UILH_NORMAL.item_bg2)
    img_bg:addChild(attrs)
    local level_bg = nil
    local level_open = nil 
   level_bg   = CCZXImage:imageWithFile(36,15,-1,-1,UILH_NORMAL.level_bg)
   level_open = CCZXImage:imageWithFile(12,11,-1,-1,lingqi_level_open[index])
   level_bg:addChild(level_open)
   one_beauty.beauty:addChild(level_bg)
    require "../data/client/meiren_config"
        --技能icon
    local icon   = CCZXImage:imageWithFile(12,12,-1,-1,meiren_config[index].icon)
    img_bg:addChild(icon)
    one_beauty.icon = icon
    local attrs_txt = UILabel:create_lable_2(meiren_config[index].color..meiren_config[index].attrs[1][1],93, 43, 14,  ALIGN_LEFT )
    img_bg:addChild(attrs_txt)

    local attrs_value = UILabel:create_lable_2(meiren_config[index].color.."+"..meiren_config[index].attrs[1][2],97, 20, 14,  ALIGN_LEFT )
    img_bg:addChild(attrs_value)
    one_beauty.level_open = level_open
    
   local function temp_func( eventType,arg,msgid,selfitem )
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
             return
        end

        if  eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
     end

    local function change_func( eventType,arg,msgid,selfitem )
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
             return
        end
    
        if  eventType == TOUCH_BEGAN then
             local win = UIManager:find_visible_window("lingqi_win")
             if win then
                win:change_page(2)
             end
            return true;
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end 

    --切换人物
    one_beauty.change_img_func = function(index,can_light,can_open)
            local max_level = FabaoConfig:get_fabao_max_level() 
            if(tonumber(index) <= max_level/10+1) then
             if can_light then
                         require "../data/client/meiren_config"
                    one_beauty.beauty:setTexture(beauty_img_array[index])
                    one_beauty.icon:setTexture(meiren_config[index].icon)
                    --如果是点亮的美人 可以点击跳转
                if not _is_other_fabao then
                    one_beauty.view:registerScriptHandler(change_func)
                else
                    one_beauty.view:registerScriptHandler(temp_func)

                end

            else
                one_beauty.beauty:setTexture(beauty_img_array_d[index])
                one_beauty.icon:setTexture(meiren_config[index].icon_d)
            end

             if level_bg ~= nil then
                level_open:setTexture(lingqi_level_open[index])
                if can_open then
                    level_bg:setIsVisible(true)
                else
                    level_bg:setIsVisible(false)
                end
             end
        end
    end
    one_beauty.beauty:addChild(pai)
    pai:addChild(name)
    img_bg:addChild(one_beauty.beauty)
    panel_bg:addChild(one_beauty.view)
    table.insert(beauty_array,one_beauty)
end

--更新美女图
function LingqiInfoPage:change_img( index)
    local flag = true
    for i=1,#beauty_array do
          if i>index then
            flag = true
          else
            flag = false
          end
          if index<=i then
            beauty_array[i].change_img_func(i,not flag,flag)
          else
            beauty_array[i].change_img_func(i,not flag,flag)
          end
    end
end

--创建上下面板
function LingqiInfoPage:create_panel(bg_panel)
   	--灵器总属性
	local up_panel = CCBasePanel:panelWithFile(1, 179, 865, 320, "", 500, 500)
    bg_panel:addChild(up_panel)
    
    local x =0
    local y = 153  
    local gas_x = 1
    local width = 172
    local height = 342
    for i=1,5 do
        self:create_one_beauty(bg_panel,x+(i-1)*(width+gas_x),y,width,height,i,true)
    end


    --美人信息页下页
    local down_panel = CCBasePanel:panelWithFile(1, 1, 864, 147, UILH_COMMON.bottom_bg, 500, 500)
    bg_panel:addChild(down_panel)
    
    --美人总属性
    local beauty_z_bg  = CCZXImage:imageWithFile(4,151,-1,-1,UILH_BENEFIT.month_bg)
    beauty_z_bg:setRotation(90)
    local beauty_attr_z = CCZXImage:imageWithFile(97,5,-1,-1,UILH_LINGQI.attribute_z);
    down_panel:addChild(beauty_z_bg)
    beauty_attr_z:setRotation(-90)
    beauty_z_bg:addChild(beauty_attr_z);
    
    local begin_y = 124
    local gas_y = 28

    self.at_attri = MUtils:create_attrs_bar( down_panel, 71, begin_y, LH_COLOR[2]..Lang.lingqi.upgrade[5], 50 ); -- [963]="攻    击:"
    
    self.wd_attri = MUtils:create_attrs_bar( down_panel, 71, begin_y-gas_y, LH_COLOR[2]..Lang.lingqi.upgrade[7], 50 ); -- [964]="物理防御:"

    self.bj_attri = MUtils:create_attrs_bar( down_panel, 71,  begin_y-2*gas_y, LH_COLOR[2]..Lang.lingqi.upgrade[9], 50 ); -- [965]="抗 暴 击:"

    self.hp_attri = MUtils:create_attrs_bar( down_panel, 71,  begin_y-3*gas_y, LH_COLOR[2]..Lang.lingqi.upgrade[6], 50 ); -- [966]="生    命:"
    
    self.md_attri = MUtils:create_attrs_bar( down_panel, 71,  begin_y-4*gas_y, LH_COLOR[2]..Lang.lingqi.upgrade[8], 50 );   -- [967]="法术防御:"

    -- self.lv_attri =  MUtils:create_attrs_bar( down_panel, 71,  begin_y-5*gas_y,LH_COLOR[2]..Lang.lingqi.upgrade[17], 50 );   --灵器等级


    --分割线
	MUtils:create_zximg(down_panel,UILH_COMMON.split_line_v,291,3,3,140,0,0)

    --美人属性
    local beauty_bg  = CCZXImage:imageWithFile(295,19,-1,-1,UILH_LINGQI.title_bg)
    local beauty_attr = CCZXImage:imageWithFile(5,54,-1,-1,UILH_LINGQI.attribute);
    down_panel:addChild(beauty_bg)
    beauty_bg:addChild(beauty_attr);

        --分割线
    MUtils:create_zximg(down_panel,UILH_COMMON.split_line_v,622,3,3,140,0,0)

    --战斗力
    local fightValue_lab = CCZXImage:imageWithFile(648,102,-1,-1,UILH_MOUNT.zhandouli);
    down_panel:addChild(fightValue_lab);

    self.fabao_fight = ZXLabelAtlas:createWithString("888",UIResourcePath.FileLocate.lh_other .. "number2_");
    self.fabao_fight:setPosition(740,105);
    down_panel:addChild(self.fabao_fight);


    --跳转 美人添香
    local function show_lianhun(  )
        local win = UIManager:find_visible_window("lingqi_win")
        if win then
        	win:change_page(3)
        end
    end

    self.lianhun_btn = TextButton:create( nil, 778, 12, -1, -1, "", UILH_MOUNT.btn_yellow ) 
    local add =  CCZXImage:imageWithFile(20,29,-1,-1,UILH_LINGQI.add)
    self.lianhun_btn.view:addChild(add)
    self.lianhun_btn:setTouchClickFun(show_lianhun)
    -- self.lianhun_btn.view:addChild(show_lianhun)

    self.lianhun_btn:setTouchClickFun(show_lianhun)
    self.lianhun_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_MOUNT.btn_yellow)
    down_panel:addChild(self.lianhun_btn.view)


    -- 跳转美人升级
    local function show_uplevel(  )
        local win = UIManager:find_visible_window("lingqi_win")
        if win then
            win:change_page(2)
        end
    end
    self.uplevel_btn = TextButton:create( nil, 701, 12, -1, -1, "", UILH_MOUNT.btn_yellow ) 
    local upgrade =  CCZXImage:imageWithFile(20,29,-1,-1,UILH_LINGQI.upgrade)
    self.uplevel_btn.view:addChild(upgrade)
    self.uplevel_btn:setTouchClickFun(show_uplevel)
    self.uplevel_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_MOUNT.btn_yellow)
    down_panel:addChild(self.uplevel_btn.view)


    --炫耀
    local function show_fabao_func(  )
        FabaoModel:xuanyao_fabao(  );
    end
    self.show_btn = TextButton:create( nil, 623, 12, -1, -1, "", UILH_MOUNT.btn_yellow ) 
    self.show_btn:setTouchClickFun(show_fabao_func)

    local show =  CCZXImage:imageWithFile(20,29,-1,-1,UILH_LINGQI.show)
    self.show_btn.view:addChild(show)
    self.show_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_MOUNT.btn_yellow)
    down_panel:addChild(self.show_btn.view)


    self.level_lab = UILabel:create_lable_2(LH_COLOR[2].."等   级", 649, 58, 20, ALIGN_LEFT ); -- [945]="#c38ff33等    级:"
    down_panel:addChild(self.level_lab)

    self.level = UILabel:create_lable_2( "1", 743, 58, 20, ALIGN_LEFT );
    down_panel:addChild(self.level);
    self.level_lab:setIsVisible(false)
    self.level:setIsVisible(false)
    return bg_panel
end


function LingqiInfoPage:update_fight_value( fight_value )
    if not _is_other_fabao then
        self.fabao_fight:init( ""..fight_value );
    end
end



--创建右下侧的器魂属性面板
function  LingqiInfoPage:create_scroll_panel( )
	--获得器魂的数据
	local count,xianhuns;
    
    if _is_other_fabao then
    	--他人法宝显示器魂属性
    	if _other_fabao_data then
        local xianhun_data = FabaoModel:fabao_xianhuns_format(_other_fabao_data);
        count = xianhun_data.count;
        xianhuns = xianhun_data.xianhuns;
        
        --他人的战斗力
        local fabao_info = FabaoModel:fabao_info_format(_other_fabao_data)
        stage = fabao_info.jingjie;
        level = fabao_info.level + (stage-1)*10;
        fight = fabao_info.fight;
        end

    else --自己的法宝
        local xianhun_data = FabaoModel:get_fabao_xianhun(  )
        --具有的器魂
        count = xianhun_data.count;
        --器魂的列表
        --id  type  quality 品质属性 level 等级 value 
        xianhuns = xianhun_data.xianhuns;
        
        --自己的战斗力
        local fabao_info = FabaoModel:get_fabao_info( )
        if fabao_info then
            fight = fabao_info.fight;
        else
            fight = 0
        end
    end
    
    --更新战斗力
    self.fabao_fight:init( fight );


    if xianhuns == nil then
        return ;
    end
    
    self.xianhuns = xianhuns
    self.count = count

    --创建或者刷新下拉框
	if (self.attr_scroll) then 
		self.attr_scroll:clear() --存在需要清空数据
		self.attr_scroll:setMaxNum(#self.xianhuns)
		self.attr_scroll:refresh()
	else

       self.attr_scroll = CCScroll:scrollWithFile(341,4,290,135,#self.xianhuns,nil,TYPE_HORIZONTAL,500,500);	
       --设滚动条
	   self.attr_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 600 )
       self.attr_scroll:setScrollLumpPos( 417 -140)

	   local arrow_up = CCZXImage:imageWithFile(417-140 , 126, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	   local arrow_down = CCZXImage:imageWithFile(417-140, 0, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
	   self.attr_scroll:addChild(arrow_up,1)
	   self.attr_scroll:addChild(arrow_down,1)
	   self.view:addChild(self.attr_scroll);
  
        --下拉事件
	    local function scrollfun(eventType, args, msg_id)

            if eventType == nil or args == nil or msg_id == nil then 
                 return
            end
	    
	            local temparg = Utils:Split(args,":")
	            local row = temparg[1] +1             -- 行	
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
                -- 每行的背景panel
                local panel = CCBasePanel:panelWithFile(0,300 - row * 25,270,25,nil,0,0);
                self.attr_scroll:addItem(panel);
               
	            local struct = self.xianhuns[row];
         
               if struct then   
               
	           	-- 器魂的配置
	            local xianhun_config = FabaoConfig:get_xianhun( struct.quality, struct.type, struct.level );
                
	             -- 器魂的颜色
	            local xianhun_color = FabaoConfig:get_xianhun_color_by_quality( struct.quality );

	            --器魂的名字
	            local str_name = LH_COLOR[2]..xianhun_config.name;
	    
			      -- 器魂的等级
			     -- local xianhun_level ="lv."..struct.level;

			   	local detail_str =xianhun_color..staticAttriTypeList[xianhun_config.attrs.type].."+"..math.abs(xianhun_config.attrs.value); 
                
                --攻击
                local  gongji = 0
                --生命
                local  Life = 0
                --外功防御
                local  wgfang = 0
                --内功防御
                local ngfang  = 0
                --抗暴击
                local kangbaoji = 0
    
                --计算总属性
                 if xianhun_config.attrs.type ==25 then --抗暴
			    	kangbaoji =kangbaoji+math.abs(xianhun_config.attrs.value)
			    elseif xianhun_config.attrs.type ==17 then --生命
			    	Life =Life+math.abs(xianhun_config.attrs.value)
			    elseif xianhun_config.attrs.type ==37 then --闪避
			    	wgfang=wgfang+math.abs(xianhun_config.attrs.value)
			    elseif xianhun_config.attrs.type ==49 then  --精神免伤
			    	ngfang =ngfang+math.abs(xianhun_config.attrs.value)
			    elseif xianhun_config.attrs.type ==39 then  --命中
			    elseif xianhun_config.attrs.type ==35 then  --暴击
			    	gongji=gongji+math.abs(xianhun_config.attrs.value)
			    end

                self:update_all_attr(kangbaoji,Life,wgfang,ngfang,gongji)
			    --经验
			    -- local exp_str = LH_COLOR[2]..Lang.lingqi.lianhun[9]..struct.value.."/"..xianhun_config.upExp; -- [979]="#c38ff33经验: #cffffff"

		        MUtils:create_zxfont(panel,str_name,55,10,2,14);
	            -- MUtils:create_zxfont(panel,xianhun_level,120,10,2,14);
				MUtils:create_zxfont(panel,detail_str,205,10,2,14);

                end
		
	            self.attr_scroll:refresh();
	            return false
	        end
	    end
	    	self.attr_scroll:registerScriptHandler(scrollfun);
            self.attr_scroll:refresh();

    end

end



-- 更新法宝信息
function LingqiInfoPage:update_fabao_info(  )
    -- print("  ================  function LingqiInfoPage:update_fabao_info(  )  ========")
    local stage=1;
    local level=1;
    local exp=1;
    -- local count,xianhuns;
    -- local fight=1;
    --这里需要考虑是自己的法宝还是别人的法宝
    if _is_other_fabao then
        -- 他人法宝
        --升级按钮隐藏
        self.uplevel_btn.view:setIsVisible(false)
        self.show_btn.view:setIsVisible(false)
        self.lianhun_btn.view:setIsVisible(false)


        if _other_fabao_data then
            local fabao_info = FabaoModel:fabao_info_format(_other_fabao_data)
            stage = fabao_info.jingjie;
            level = fabao_info.level + (stage-1)*10;

            exp = fabao_info.exp;
            -- fight = fabao_info.fight;
            self.level_lab:setIsVisible(true)
            self.level:setIsVisible(true)
            self.level:setString(level)
            self:change_img(fabao_info.jingjie)

        end
    else
    	--自己的灵器
        local fabao_info = FabaoModel:get_fabao_info( )
        if fabao_info then
	        stage = fabao_info.jingjie;
	        level = fabao_info.level;
	        exp = fabao_info.exp;
	        -- fight = fabao_info.fight
            self:change_img(fabao_info.jingjie)

        else
        	stage = 1
        	level = 1
        	exp = 1
        end

        self.uplevel_btn.view:setIsVisible(true);
        self.show_btn.view:setIsVisible(true)
        self.lianhun_btn.view:setIsVisible(true)
        self.level_lab:setIsVisible(false)
        self.level:setIsVisible(false)

    end

     --灵器等级
     -- self.lv_attri.update_data(level)
end

--需要算出总属性
function LingqiInfoPage:update_all_attr( kangbaoji,Life,wgfang,ngfang,gongji)
 
       if _is_other_fabao then
        -- 他人法宝
        if _other_fabao_data then
            local fabao_info = FabaoModel:fabao_info_format(_other_fabao_data)
            stage = fabao_info.jingjie;
            level = fabao_info.level + (stage-1)*10;
        end
    else
    	--自己的灵器
        local fabao_info = FabaoModel:get_fabao_info( )
        if fabao_info then
	        stage = fabao_info.jingjie;
	        level = fabao_info.level;
        end
    end
    local fabao_config = FabaoConfig:get_fabao( stage, level - (stage-1)*10 );
    
     gongji = gongji+fabao_config.baseAttrs.baseAttrs[1]
    --生命
     Life =Life+ fabao_config.baseAttrs.baseAttrs[2]
    --外功防御
    wgfang = wgfang+fabao_config.baseAttrs.baseAttrs[3]
    --内功防御
    ngfang  = ngfang+fabao_config.baseAttrs.baseAttrs[4]
    --抗暴击
    kangbaoji = kangbaoji+fabao_config.baseAttrs.baseAttrs[5]
    
     if self.at_attri then
        -- 攻击属性
        self.at_attri.update_data(gongji);
        -- 生命属性
        self.hp_attri.update_data(Life)
        -- 物理防御属性
        self.wd_attri.update_data(wgfang)
        -- 法术防御属性
        self.md_attri.update_data(ngfang)
        -- 暴击防御属性
        self.bj_attri.update_data(kangbaoji);
    end

end

--刷新方法
function  LingqiInfoPage:update( update_type )
    if update_type == "all" then
        self:update_all()
    elseif update_type == "up_page_info" then
        self:update_up()
    elseif update_type == "down_page_info" then
        self:update_down()
    end
end

function  LingqiInfoPage:active( show)
   -- print("=======  =LingqiInfoPage:active( show)   ==============")
   if show then
   	  --如果是他人的法宝
      if _is_other_fabao then
            self.uplevel_btn.view:setIsVisible(false);
            self.show_btn.view:setIsVisible(false)
            self.lianhun_btn.view:setIsVisible(false)

       else
                --器魂数据
                FabaoModel:req_fabao_xianhun_info();   
                --法宝数据
                FabaoModel:req_fabao_info( );
         
                self.uplevel_btn.view:setIsVisible(true);
                self.show_btn.view:setIsVisible(true)
                self.lianhun_btn.view:setIsVisible(true)
                self.level_lab:setIsVisible(false)
                self.level:setIsVisible(false)
      end
    else
        
        _is_other_fabao = false;
        _other_fabao_data = nil;

        -- UIManager:hide_window("lianhun_win");
        -- UIManager:hide_window("fabao_detail_win");
        -- UIManager:hide_window("fabao_uplevel_win");
        -- UIManager:hide_window("fabao_intro_win");
   end
end

--刷新上部分
function LingqiInfoPage:update_up()
   self:update_fabao_info()
end

--刷新下部分
function LingqiInfoPage:update_down()
  self:create_scroll_panel()
end

function LingqiInfoPage:update_all()
	self:update_down()
	self:update_up()
end


--查看的是他人法宝属性
function LingqiInfoPage:show_other_fabao( other_fabao )
    _is_other_fabao = true;
    print("_is_other_fabao11111111111111",_is_other_fabao)
    _other_fabao_data = other_fabao;
    self:create_scroll_panel()
    self:update_fabao_info();
        
    --如何是他人的法宝则隐藏
    if _is_other_fabao then
        self.lianhun_btn.view:setIsVisible(false)
    end
    
end


function LingqiInfoPage:destroy(  )
    beauty_array = {}
    Window.destroy(self);

end
