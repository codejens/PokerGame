-- FBChallengeWin.lua  
-- created by LittleWhite on 2014-7-4
-- 挑战副本窗口

super_class.FBChallengeWin(Window)

--节点副本图片
node_pic_path = {
	UIPIC_ACTIVITY_010,
	UIPIC_ACTIVITY_011,
	UIPIC_ACTIVITY_012,
	UIPIC_ACTIVITY_013,
	UIPIC_ACTIVITY_014,
	UIPIC_ACTIVITY_015,
	UIPIC_ACTIVITY_016,
	UIPIC_ACTIVITY_017,
}

--窗口标题图片
title_pic_path = {
    UIPIC_ACTIVITY_031,
    UIPIC_ACTIVITY_032,
    UIPIC_ACTIVITY_033,
    UIPIC_ACTIVITY_034,
    UIPIC_ACTIVITY_035,
    UIPIC_ACTIVITY_036,
    UIPIC_ACTIVITY_037,
    UIPIC_ACTIVITY_038,
}

-- 增加挑战次数是否不再提示
local show_tip = true;

function FBChallengeWin:__init( window_name, texture_name, is_grid, width, height )

	-- 所有节点数据
	self.node_tab = {}

	basePanel = self.view

	--背景
    local panel = CCBasePanel:panelWithFile( 25, 20, 857,592, UIPIC_ACTIVITY_018, 500, 500);  --方形区域
    basePanel:addChild( panel )

    -- 左边
    left_panel = CCBasePanel:panelWithFile( 41,31,540,570, UIPIC_ACTIVITY_019, 500, 500);  --方形区域
    basePanel:addChild( left_panel )

    -- 右边
    right_panel = CCBasePanel:panelWithFile( 41+540+5,31,857-(540+5)-11*2,570, UIPIC_ACTIVITY_019, 500, 500);  --方形区域
    basePanel:addChild( right_panel )

    self:create_left_panel()
    self:create_right_panel()
end

function FBChallengeWin:create_left_panel()

	--背景图
	local fb_bg = Image:create( nil, 0,1, -1, -1, UIPIC_ACTIVITY_020, 500, 500)
	left_panel:addChild(fb_bg.view)
	
	local pos_tab = {
		[1] = {x=20,y=50},
		[2] = {x=280,y=20},
		[3] = {x=380,y=200},
		[4] = {x=180,y=220},
		[5] = {x=50,y=380},
		[6] = {x=320,y=450},
		}

    local node_width = 100
    local node_height = 100

	for i=1,#pos_tab do
		self:create_fuben_node(pos_tab[i].x,pos_tab[i].y,node_width,node_height,i)
	end

    self.line_tab ={}

    for i=1,#pos_tab-1 do
        local p1 = CCPoint(pos_tab[i].x + node_width/2 ,pos_tab[i].y + node_height/2)
        local p2 = CCPoint(pos_tab[i+1].x + node_width/2,pos_tab[i+1].y + node_height/2)

        local lenght,angle = calculate_angle_and_lenght(p1,p2);
        local p = calculate_ccp_by_radius_and_angle(p1,p2,50,angle);

        self.line_tab[i] = MUtils:create_sprite(left_panel,UIPIC_ACTIVITY_039,p.x,p.y);
        self.line_tab[i]:setScaleX(lenght/210);
        self.line_tab[i]:setAnchorPoint(CCPoint(0,0.5));
        self.line_tab[i]:setRotation(angle);
    end
end

-- 根据给出的两个点计算两个点之间的长度和角度
function calculate_angle_and_lenght(p1,p2)
    local v1 = (p1.x - p2.x) * (p1.x - p2.x) + (p1.y-p2.y) * (p1.y-p2.y);
    --print(v1);
    local lenght = math.sqrt(v1);
    --local v = (math.abs(p1.x - p2.x)) / lenght;
    local v = (-(p1.x - p2.x)) / lenght;
    local angle = math.deg(math.acos(v));
    
    if( p2.y > p1.y) then
        angle = 360 - angle;
    end
    --print("lenght = ".. lenght .. "  angle = ".. angle);
    -- 因为p1,p2，是两个圆的中心点，lenght是两个中心点的长度，然后需求是求两个圆边角连线的长度，所以要减去圆的半径乘于2
    -- 圆的半径9
    lenght = lenght - 50 * 2;
    return lenght,angle;
end

-- 根据圆的中心点坐标，半径，和角度，计算圆边线上的坐标
function calculate_ccp_by_radius_and_angle(p1,p2,radius,angle)

    local result_x,result_y = 0
    if( angle <= 90) then
        -- 角度转弧度
        local rad = math.rad(angle);
        -- 半径12.5
        result_x = math.cos(rad) * radius;
        result_y = math.sin(rad) * radius;
        result_y = - result_y;

    elseif ( angle <= 180) then 
        angle = angle - 90;
        -- 角度转弧度
        local rad = math.rad(angle);
        result_y = math.cos(rad) * radius;
        result_x = math.sin(rad) * radius;
        result_y = - result_y;
        result_x = - result_x;

    elseif (angle <= 270) then
        angle = angle - 180;
        -- 角度转弧度
        local rad = math.rad(angle);
        result_x = math.cos(rad) * radius;
        result_y = math.sin(rad) * radius;
        result_x = - result_x;

    elseif (angle <= 360) then
        angle = 360 - angle;
        -- 角度转弧度
        local rad = math.rad(angle);
        result_x = math.cos(rad) * radius;
        result_y = math.sin(rad) * radius;
    end

    --print("result_x = ".. result_x.."  result_y= "..result_y);
    local result_p1 = CCPoint(p1.x + result_x,p1.y + result_y);
    -- result_x = math.cos(360-90-angle) * radius;
    -- result_y = math.sin(360-90-angle) * radius;
    -- local result_p2 = CCPoint(p2.x + result_x)
    return result_p1;
end

-- 创建一选择节点  参数：坐标   宽高   标识序列号（数字） 节点的数据
function FBChallengeWin:create_fuben_node( pos_x, pos_y, width, height, index)

	local node = {} --保存生成的节点

	local node_panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, "")
	left_panel:addChild(node_panel)

	local function btn_node_fun(eventType,x,y)

        -- print("btn_fun(eventType)",eventType)
        if  eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then
            print("btn_fun,eventType == TOUCH_CLICK")
            self:update_selected(index)
            self:update_introduce(index)
            return true
        end
        return true       
    end

	local btn_node = ZImageButton:create(node_panel, "", UIPIC_ACTIVITY_028, btn_node_fun, 0, 0, width, height)
    btn_node.view:registerScriptHandler(btn_node_fun)
    btn_node.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_ACTIVITY_029)

   	local selected_frame = ZImageButton:create(node_panel, "", UIPIC_ACTIVITY_030, nil, -13, -13, 127, 127)
   	selected_frame.view:setIsVisible(false)

   	--子副本名称
   	local node_name = Image:create( nil, 12,64, -1, -1, UIPIC_ACTIVITY_016, 500, 500)
   	node_panel:addChild(node_name.view)

   	--层数
   	local layer_text = UILabel:create_lable_2(Lang.activity.fuben[24], 52, 46, 18, ALIGN_CENTER );
	node_panel:addChild(layer_text);

	--次数
	local remain_text = UILabel:create_lable_2(string.format(Lang.activity.fuben[18], 3,3), 9, 23, 18, ALIGN_LEFT );
	node_panel:addChild(remain_text);

    node.index = index
    node.node_panel = node_panel
	node.btn_node = btn_node
    node.selected_frame = selected_frame
    node.node_name = node_name
    node.layer_text = layer_text
    node.remain_text = remain_text
    -- node.node_data = node_data
  
    table.insert(self.node_tab,node)
    return node
end

function FBChallengeWin:create_right_panel()
	-- 副本信息标题
    local right_panel_tile = CCBasePanel:panelWithFile( 0, 537, 120,30, UIPIC_ACTIVITY_021, 500, 500);  --方形区域
    right_panel:addChild( right_panel_tile )
    -- 标题文字
    local title_text = Image:create( nil, 26,6, -1, -1, UIPIC_ACTIVITY_022, 500, 500 )
	right_panel_tile:addChild(title_text.view)

	-- 目标副本
    -- Land.activity.fuben[12] = "#cfff000目标副本:"
	local fuben_label = UILabel:create_lable_2(Land.activity.fuben[12], 13, 484, 18, ALIGN_LEFT );
	right_panel:addChild(fuben_label);

    -- Land.activity.fuben[14] = "心魔幻境(1-3层)"
	self.fuben_text= UILabel:create_lable_2(Land.activity.fuben[14], 110, 484, 18, ALIGN_LEFT );
	right_panel:addChild(self.fuben_text)

	--剩余次数
    -- Land.activity.fuben[13] = "#cfff000目标副本:"
	local remain_label = UILabel:create_lable_2(Land.activity.fuben[13], 13, 425, 18, ALIGN_LEFT );
	right_panel:addChild(remain_label);

	self.remain_text= UILabel:create_lable_2( "0/3", 110, 425, 18, ALIGN_LEFT );
	right_panel:addChild(self.remain_text)

	--增加次数按钮
	local function btn_increase_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	self:show_increase_dialog()
        end
        return true
    end

    self.btn_increase = MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UIPIC_COMMOM_002,btn_increase_fun,78,297,-1,-1)
    MUtils:create_zxfont(self.btn_increase,Land.activity.fuben[15],126/2,15+5,2,16)
	self.btn_increase:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

	--增加消耗
	self.increase_text = UILabel:create_lable_2(Land.activity.fuben[16], 141, 275, 18, ALIGN_LEFT );
    self.increase_text:setAnchorPoint(CCPoint(0.5,0))
	right_panel:addChild(self.increase_text)

    --增加条件
    self.increase_desc_text = UILabel:create_lable_2(Land.activity.fuben[17], 141, 275, 18, ALIGN_LEFT );
    self.increase_desc_text:setAnchorPoint(CCPoint(0.5,0))
    right_panel:addChild(self.increase_desc_text)

	--挑战副本按钮
	local function btn_challenge_fun(eventType,x,y)
        	print("btn_challenge_fun")
       		-- NormalDialog:show(str_msg,req_sprite) 
            -- Instruction:handleUIComponentClick(instruct_comps.FBCHALLENGE_WIN_OK_BTN )

            if self.selected_fbid then
                local  str = string.format("OnEnterFubenFunc,%d",self.selected_fbid)
                -- print("str",str)
                GameLogicCC:req_talk_to_npc( 0, str)
                UIManager:destroy_window("fb_challenge_win")
                UIManager:destroy_window("activity_Win")
            end 
        return true
    end

    self.btn_challenge = ZImageButton:create(right_panel,UIPIC_ACTIVITY_025,UIPIC_ACTIVITY_027,btn_challenge_fun,35,89,220,-1)
	self.btn_challenge.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

end

-- 显示增加次数对话框
function FBChallengeWin:show_increase_dialog()
    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local param = { [1]=self.fbListId ,[2] = money_type}

    local increase_func = function( param )
        MiscCC:req_add_fuben_count(param[1],param[2])
    end

    print("param[1],param[2]",param[1],param[2])

    if ( show_tip ) then
        local function fun( _show_tip )
            MallModel:handle_auto_buy( self.cost, increase_func, param )
        end
        local function swith_but_func ( _show_tip )
            show_tip = not _show_tip;
        end
        local str = string.format(Land.activity.fuben[10],self.cost,self.fuben_name)    --[10] = "是否消耗%d元宝/绑元增加1次%s副本的挑战?"
        ConfirmWin2:show( 5, nil, str, fun, swith_but_func ) 
    else
        MallModel:handle_auto_buy( self.cost, increase_func, param )
    end
end

-- 提供外部静态调用的更新窗口方法
function FBChallengeWin:update_win( fuben_info )
    local win = UIManager:find_visible_window("fb_challenge_win")
    if not win then
       win = UIManager:show_window("fb_challenge_win")  
    end
    win:update(fuben_info)
end

-- 根据副本数据更新窗口
function FBChallengeWin:update( fuben_info )
    print("FBChallengeWin:update( fuben_info.progress )",fuben_info.progress)
    if fuben_info then
       self.fbListId = fuben_info.fbListId
       for i=1,fuben_info.count do
            self.node_tab[i].remainCount = fuben_info.sub[i].remainCount
            self.node_tab[i].totalCount = fuben_info.sub[i].totalCount
            --[18] = "#cfff000次数:%d/%d"
            local str = string.format(Land.activity.fuben[18],self.node_tab[i].remainCount,self.node_tab[i].totalCount)
            self.node_tab[i].remain_text:setText(str)

            if i <= fuben_info.progress + 1 then
                self.node_tab[i].btn_node:setCurState(CLICK_STATE_UP)
            else
                self.node_tab[i].btn_node:setCurState(CLICK_STATE_DISABLE)
            end 
       end
    end
    self:update_selected(self.selected_index)
    self:update_introduce(self.selected_index)
end

-- 提供外部静态调用的更新增加挑战次数
function FBChallengeWin:update_sub_fuben(fubenId,remainCount,totalCount)
    local win = UIManager:find_visible_window("fb_challenge_win")
    if not win then
       win = UIManager:show_window("fb_challenge_win")  
    end
    win:update_add_fuben_count(fubenId,remainCount,totalCount)
   
end

function FBChallengeWin:update_add_fuben_count(fubenId,remainCount,totalCount)
    print("FBChallengeWin:update_add_fuben_count(self.selected_fbid,fubenId)",self.selected_fbid,fubenId)
    if self.selected_fbid == fubenId then
        self.selected_node.remainCount = remainCount
        self.selected_node.totalCount = totalCount
        --[18] = "#cfff000次数:%d/%d"
        local str = string.format(Land.activity.fuben[18],remainCount,totalCount)
        self.selected_node.remain_text:setText(str)
        self.remain_text:setText(remainCount.."/"..totalCount)
    end
end

-- 更新右面板说明
function FBChallengeWin:update_introduce( selected_index )
    for key,value in ipairs(self.node_tab) do
        if self.node_tab[key].index == selected_index then

            local node_data = self.node_tab[key].node_data

            self.fuben_name = node_data.fbname

            self.fuben_text:setText(self.fuben_name.."("..node_data.fbDesc..")")

            self.remain_text:setText( self.node_tab[key].remainCount.."/"..self.node_tab[key].totalCount)

            print("self.selected_fbid",self.selected_fbid)
            self.cost = FubenConfig:get_cost_by_listId(self.fbListId)
            --[16] = "#cfff000%d元宝/绑元"
            local str = string.format(Land.activity.fuben[16],self.cost)

            self.increase_text:setText(str)

            local vip_info = VIPModel:get_vip_info()

            if vip_info.level >= 3 then
                self.btn_increase:setCurState(CLICK_STATE_UP)
                self.increase_text:setIsVisible(true)
                self.increase_desc_text:setIsVisible(false)
            else
                self.btn_increase:setCurState(CLICK_STATE_DISABLE)
                self.increase_text:setIsVisible(false)
                self.increase_desc_text:setIsVisible(true)
            end 
        end
    end
end

-- 更新选择状态
function FBChallengeWin:update_selected(selected_index)
    for key,value in ipairs(self.node_tab) do
        if self.node_tab[key].index == selected_index then
            self.selected_index = selected_index
            self.selected_fbid = self.node_tab[key].node_data.fbid
            self.selected_node = self.node_tab[key]
            self.node_tab[key].selected_frame.view:setIsVisible(true)
        else
            self.node_tab[key].selected_frame.view:setIsVisible(false)
        end
    end
end

-- 读配置初始化数据
function FBChallengeWin:initialize_by_fubenid( fatherid )
   print("FBChallengeWin:initialize_by_fubenid( fatherid )",fatherid)
   require "config/FubenConfig"
   if fatherid then
      self.fatherid = fatherid
      -- self.window_title:setTexture(title_pic_path[fatherid])

      self.sublist = FubenConfig:get_subfubenlist_by_fatherid(fatherid)
      -- for i=1,#self.sublist do
      --         print(i,self.sublist[i])
      --         -- self.sublist[i].
      -- end

      for i=1,#self.node_tab do
          if self.sublist[i] then
            self.node_tab[i].node_panel:setIsVisible(true)
            local node_data = FubenConfig:get_fuben_info_by_id(self.sublist[i])
            self.node_tab[i].node_data =node_data

            self.node_tab[i].node_name.view:setTexture(node_pic_path[fatherid])
            self.node_tab[i].layer_text:setText(node_data.fbDesc)
            self.node_tab[i].fbid = node_data.fbid
          else
            self.node_tab[i].node_panel:setIsVisible(false)
          end
      end

      for i=1,#self.line_tab do
            if self.sublist[i+1] then
                self.line_tab[i]:setIsVisible(true)
            else
                self.line_tab[i]:setIsVisible(false)
            end
      end

      self.selected_index = 1 
   end
end

function FBChallengeWin:destroy()
	Window.destroy(self)
end