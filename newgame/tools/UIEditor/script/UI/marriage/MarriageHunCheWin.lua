-- MarriageHunCheWin.lua
-- create by guozhinan 2015-2-4
-- 结婚系统的第三个分页（云车巡游）的左半边，单独提出来作为一个半屏幕页面

super_class.MarriageHunCheWin(Window)

function MarriageHunCheWin:__init( window_name, texture_name, is_grid, width, height,title_text )

    -- 大背景
    local bg = ZImage:create( self.view, UILH_MARRIAGE.bg1, 0, 0, width, height - 25, -1,500,500 )

    --标题背景
    local title_bg = ZImage:create( self.view,nil, 0, 0, -1, -1 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
    -- 标题
    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    self.window_title = ZImage:create(title_bg, title_text , t_width/2,  t_height-27, -1,-1,999 );
    self.window_title.view:setAnchorPoint(0.5,0.5)

    -- 花纹装饰
    local left_decoration = CCZXImage:imageWithFile( -16, 87, -1, -1, UILH_MARRIAGE.decoration2 );
    self.view:addChild(left_decoration)
    local right_decoration = CCZXImage:imageWithFile( 305, 87, -1, -1, UILH_MARRIAGE.decoration2 );
    right_decoration:setFlipX(true);
    self.view:addChild(right_decoration)

    ZImage:create( self.view, UILH_MARRIAGE.bg2, 15, 15, width -30, height - 90, -1,500,500 )

    --标题背景
    local title_bg = ZImage:create( self.view,nil, 0, 0, -1, -1 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
    -- 标题
    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    self.window_title = ZImage:create(title_bg, title_text , t_width/2,  t_height-27, -1,-1,999 );
    self.window_title.view:setAnchorPoint(0.5,0.5)

	local img = MUtils:create_zximg( self.view, UILH_MARRIAGE.subtitle3_1, 76, 490, -1, -1 );

    --巡游规则
    local desc_dict = {{LangGameString[1533],LangGameString[1534],LangGameString[1535]}, -- [1533]="1、#c66ff66普通巡游#cffffff获得1500点情意;" -- [1534]="2、需要花费21314仙币开启;" -- [1535]="3、普通巡游云车无喜糖可撒。"
    					{LangGameString[1536],LangGameString[1537],LangGameString[1538]}, -- [1536]="1、#c66ff66浪漫巡游#cffffff获得3500点情意;" -- [1537]="2、需要花费58元宝开启;" -- [1538]="3、浪漫云车会自动撒1次喜糖。"
    					{LangGameString[1539],LangGameString[1540],LangGameString[1541]},}; -- [1539]="1、#c66ff66豪华巡游#cffffff获得10000点情意;" -- [1540]="2、需要花费258元宝开启;" -- [1541]="3、豪华云车会自动撒3次喜糖。"
    local icon_dict = {"pt_xy.png","lm_xy.png","hh_xy.png"};
    for i=1,3 do

        local function selected_panel( eventType,x,y )
            if eventType == TOUCH_CLICK then
                self:selected_panel(i);
            end
            return true;
        end
        local panel = CCBasePanel:panelWithFile( 30, 370-(i-1)*105, 410, 90, "" );
        panel:registerScriptHandler(selected_panel);
        self.view:addChild(panel);

        MUtils:create_zximg( panel, UILH_MARRIAGE.item_bg, 19, 21, 72, 72 );
    	local img = MUtils:create_zximg( panel, UIResourcePath.FileLocate.lh_marriage..icon_dict[i], 20, 22, 70, 70 );
 
    	local lab = UILabel:create_lable_2( desc_dict[i][1], 110, 75, 16, ALIGN_LEFT );
    	panel:addChild(lab);
    	local lab = UILabel:create_lable_2( desc_dict[i][2], 110, 50, 16, ALIGN_LEFT );
    	panel:addChild(lab);
    	local lab = UILabel:create_lable_2( desc_dict[i][3], 110, 25, 16, ALIGN_LEFT );
    	panel:addChild(lab);

        local split_img = CCZXImage:imageWithFile( 0, 0, 380, 2, UILH_MARRIAGE.split_line_h );
        panel:addChild(split_img);
    end
    self.selected_index = 1;
     -- 选中框
    self.select_frame = MUtils:create_zximg(self.view, UILH_MARRIAGE.select_focus, 30, 370, 385, 105, 500, 500);

    -- 我要巡游
    local function begin_xunyou(  )
        
        if self.xunyou_status then

            MarriageModel:req_yunche_xunyou( self.selected_index );

        else
            local function func_1( )
                GlobalFunc:ask_npc( 3, Lang.marriage[5]  ); -- [1543]="仙缘月老"
                UIManager:hide_window("marriage_hunche_win");
            end
            local function func_2(  )
               GlobalFunc:teleport( 3, Lang.marriage[5] ); -- [1543]="仙缘月老"
               UIManager:hide_window("marriage_hunche_win");
            end
            local confirmWin2_temp = ConfirmWin2:show( 6, nil, Lang.marriage[6],  func_1, nil, nil ) -- [1544]="是否确定前往天元城仙缘月老处开启巡游?"
            confirmWin2_temp:set_yes_but_func_2( func_2 )
        end
    end
    ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.woyaoxunyou,begin_xunyou,150, 69);
    -- local xunyou_btn = TextButton:create( nil, 150, 49, 87, 34, LangGameString[1542], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1542]="#cfafed0我要巡游"
    -- self.view:addChild( xunyou_btn.view );
    -- xunyou_btn:setTouchClickFun(begin_xunyou);
	-- 提示
	local lab = UILabel:create_lable_2( LangGameString[1545], 211,47, 16, ALIGN_CENTER ); -- [1545]="#cfff000(每天仅1次,3选1)"
    self.view:addChild(lab);

    -- 是否具备举办云车巡游功能
    self.xunyou_status = true;

    --关闭按钮
    local function _close_btn_fun()
        Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
        UIManager:hide_window(window_name)
    end
    local _exit_btn_info = { img = UILH_MARRIAGE.close_btn_big, z = 1000, width = 80, height = 80 }
    self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    local exit_btn_size = self._exit_btn:getSize()
    self._exit_btn:setPosition( width - exit_btn_size.width , height - exit_btn_size.height-20)
end

-------------------------界面更新

function MarriageHunCheWin:active( show )
    if show then
    else
       
    end
end

-- 选择云车巡游类型
function MarriageHunCheWin:selected_panel( index )

    if self.xunyou_status then

        local move_to = CCMoveTo:actionWithDuration(0.3, CCPointMake(30,370-(index-1)*105));

        local act_easa = CCEaseExponentialOut:actionWithAction(move_to);

        self.select_frame:runAction(act_easa);

        self.selected_index = index;
    else

    end

end