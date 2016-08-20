-- MarriageYunchePage.lua
-- create by fjh 2013-8-15
-- 结婚系统的云车巡游分页

super_class.MarriageYunchePage()



function MarriageYunchePage:__init( x, y, w, h )
	
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	local img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."yunche_lab_1.png", 28, 306, 324, 85 );

	-- 分割线
    local split_img = CCZXImage:imageWithFile( 30, 304, 334, 2, UIResourcePath.FileLocate.marriage.."line.png" );
    self.view:addChild(split_img);

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
        local panel = CCBasePanel:panelWithFile( 45, 235-(i-1)*70, 320, 70, "" );
        panel:registerScriptHandler(selected_panel);
        self.view:addChild(panel);

    	local img = MUtils:create_zximg( panel, UIResourcePath.FileLocate.marriage..icon_dict[i], 0, 0, 64, 64 );
 
    	local lab = UILabel:create_lable_2( desc_dict[i][1], 70, 45, 14, ALIGN_LEFT );
    	panel:addChild(lab);
    	local lab = UILabel:create_lable_2( desc_dict[i][2], 70, 25, 14, ALIGN_LEFT );
    	panel:addChild(lab);
    	local lab = UILabel:create_lable_2( desc_dict[i][3], 70, 5, 14, ALIGN_LEFT );
    	panel:addChild(lab);
    end
    self.selected_index = 1;
     -- 选中框
    self.select_frame = MUtils:create_zximg(self.view, "nopack/ani_corner.png", 35, 230, 320, 75, 3, 3);
    self.select_frame:setIsVisible(false);

    -- 分割线
    local split_img = CCZXImage:imageWithFile( 20, 304-215, 334, 2, UIResourcePath.FileLocate.marriage.."line.png" );
    self.view:addChild(split_img);
    -- 我要巡游
    local xunyou_btn = TextButton:create( nil, 150, 49, 87, 34, LangGameString[1542], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1542]="#cfafed0我要巡游"
	self.view:addChild( xunyou_btn.view );
    local function begin_xunyou(  )
        
        if self.xunyou_status then

            MarriageModel:req_yunche_xunyou( self.selected_index );

        else
            local function func_1( )
                GlobalFunc:ask_npc( 3, Lang.marriage[5]  ); -- [1543]="仙缘月老"
                UIManager:hide_window("marriage_win");
            end
            local function func_2(  )
               GlobalFunc:teleport( 3, Lang.marriage[5] ); -- [1543]="仙缘月老"
               UIManager:hide_window("marriage_win");
            end
            local confirmWin2_temp = ConfirmWin2:show( 6, nil, Lang.marriage[6],  func_1, nil, nil ) -- [1544]="是否确定前往天元城仙缘月老处开启巡游?"
            confirmWin2_temp:set_yes_but_func_2( func_2 )
        end
    end
    xunyou_btn:setTouchClickFun(begin_xunyou);
	-- 提示
	local lab = UILabel:create_lable_2( LangGameString[1545], 193,27, 14, ALIGN_CENTER ); -- [1545]="#cfff000(每天仅1次,3选1)"
    self.view:addChild(lab);

    -- 是否具备举办云车巡游功能
    self.xunyou_status = false;
end

-------------------------界面更新

function MarriageYunchePage:active( show )
    if show then
    else
       self:set_xunyou_enable( false ); 
    end
end

-- 选择云车巡游类型
function MarriageYunchePage:selected_panel( index )

    if self.xunyou_status then

        local move_to = CCMoveTo:actionWithDuration(0.3, CCPointMake(35,230-(index-1)*70));

        local act_easa = CCEaseExponentialOut:actionWithAction(move_to);

        self.select_frame:runAction(act_easa);

        self.selected_index = index;
    else

    end

end

-- 激活云车巡游功能
function MarriageYunchePage:set_xunyou_enable( bool )
    
    self.select_frame:setIsVisible(bool);
    self.xunyou_status = bool;

end
