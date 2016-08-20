-- BaguadigongWin.lua
-- created by fjh on 2013-7-9
-- 八卦地宫传送窗口

super_class.BaguadigongWin(NormalStyleWindow)

function BaguadigongWin:__init(  )
	
	
	-- local self_size = self:getSize()
    local self_size = {width = 833, height = 507}

	-- -- 标题
	-- local activity_title_sp = CCZXImage:imageWithFile(self_size.width/2-230/2,self_size.height-45,226,46, UIResourcePath.FileLocate.common.."win_title1.png");
	-- self:addChild(activity_title_sp);
	-- self.activity_title = CCZXImage:imageWithFile(self_size.width/2-107/2-5,self_size.height-30/2+3,107,30, UIResourcePath.FileLocate.activity.."baguadigong_title.png");
	-- self:addChild(self.activity_title);
    -- local bg = Image:create( nil, 0, 0, 708, 439, UIResourcePath.FileLocate.other .. "tyzz_bg.png", 600, 600 )
    -- self:addChild(bg.view)
    -- self.view:addChild(CCBasePanel:panelWithFile(30,20,844+12,500+26,"",500,500));
    local bg = CCBasePanel:panelWithFile(41,28,833, 507,"",500,500)
    self.view:addChild(bg);

    local bottom_bg = CCBasePanel:panelWithFile(25,40,845, 505,UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(bottom_bg,-1);

	-- 关闭按钮
	-- local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.flower.."send_flower_close_normal.png")
	-- local close_btn_size = close_btn:getSize()
	-- close_btn:setPosition( self_size.width - close_btn_size.width-60, self_size.height - close_btn_size.height-10 )
 --  	close_btn:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.flower.."send_flower_close_select.png")
  	
 --  	local function close_fun( eventType,x,y )
	-- 	--关闭事件
	-- 	if eventType == TOUCH_CLICK then
	-- 		UIManager:hide_window("baguadigong_win");
	-- 	end
	-- 	return true;
	-- end
	-- close_btn:registerScriptHandler(close_fun) 
 --    self:addChild(close_btn,99);
	
    --
    self.map_panel = CCBasePanel:panelWithFile(self_size.width/2 - 10,self_size.height/2 + 10, -1, -1,"nopack/MiniMap/qhdg.jpg");
    self.map_panel:setAnchorPoint(0.5, 0.5)
    local size = self.map_panel:getSize()
    local scale = (self_size.width/size.width) > (self_size.height/size.height) and (self_size.height/size.height) or (self_size.width/size.width)
    -- print("========size: ", size.width, size.height)
    -- print("===========scale: ", scale)
    self.map_panel:setScale(scale)
    bg:addChild(self.map_panel);

    scale = 1.0

    --场景配置
    local scene_config = SceneConfig:get_scene_by_id( SceneManager:get_cur_scene() );
    local dg_config = FubenConfig:get_baguadigong_config( )

    --复活区 {120, 89},
    local refresh_area = dg_config.refresh_area
    local point = MUtils:create_zximg(self.map_panel, 
        refresh_area.point_img, 
        refresh_area.x*scale, refresh_area.y*scale, 
        -1, -1);
    point:setAnchorPoint(0.5, 0.5)

	local point = MUtils:create_zximg(self.map_panel, 
        refresh_area.label_img, 
        refresh_area.x*scale, refresh_area.y*scale+45, 
        -1, -1);
    point:setAnchorPoint(0.5, 0.5)
    
    -- local pos_dict = {
    --     {55, 180},
    --     {89-15, 289},
    --     {256, 332},
    --     {396-15, 274},
    --     {428, 190},
    --     {394, 87},
    --     {247, 53},
    -- 	{186, 253},
    --     {294,186}
    -- };
    -- local monster = {
    --     LangGameString[653], -- [653]="仙草[1级]"
    --     LangGameString[654], -- [654]="幽魂[40级]"
    --     LangGameString[655], -- [655]="绿妖[40级]"
    --     LangGameString[656], -- [656]="魔刃[50级]"
    --     LangGameString[655], -- [655]="绿妖[40级]"
    --     LangGameString[654], -- [654]="幽魂[40级]"
    --     LangGameString[653], -- [653]="仙草[1级]"
    --     LangGameString[657], -- [657]="傀儡[50级]"
    --     LangGameString[657], -- [657]="傀儡[50级]"
    --     LangGameString[657], -- [657]="傀儡[50级]"
    -- };

    local monster = dg_config.monsters

    for i=1,#monster do
    	local text_btn = TextButton:create(nil, 
            monster[i].x*scale+16, 
            monster[i].y*scale, 
            50, 30, 
            monster[i].name, nil);
    	text_btn:setFontSize(14);
    	local function click_text_btn(  )
            BaguadigongModel:teleport_to_position( monster[i].tile_x, monster[i].tile_y )
            UIManager:hide_window("baguadigong_win");
    	end
    	text_btn:setTouchClickFun(click_text_btn);
    	self.map_panel:addChild(text_btn.view);
    	
        local function click_point_btn( eventType )
            if eventType == TOUCH_CLICK then
                BaguadigongModel:teleport_to_position( monster[i].tile_x, monster[i].tile_y )
                UIManager:hide_window("baguadigong_win");
            end
        end
        MUtils:create_btn(self.map_panel, 
            monster[i].point_img,
            monster[i].point_img,
            click_point_btn,
            monster[i].x*scale, 
            monster[i].y*scale, 
            15, 15);
    end

    --boss点
    local boss = dg_config.boss
    local point = MUtils:create_zximg(self.map_panel, 
        boss.point_img, 
        boss.x*scale, boss.y*scale, 30, 31);
    -- point:setAnchorPoint(0.5, 0.5)

   	local point = MUtils:create_zximg(self.map_panel, boss.label_img, boss.x*scale-35, boss.y*scale-17, 105, 26);
    -- point:setAnchorPoint(0.5, 0.5)


end
