-- MicroMapView.lua
-- create by fjh 2013-4-10
-- 主屏幕上的小地图

super_class.MicroMapView()

-- 更新AOI内的entity
function MicroMapView:update_AOI_entity( status, handler, entity )
	if status == 1 then

		local p_x = entity.model.m_x * self.scene_scale;
		--从大地图的左上角原点 转化为 小地图的左下角原点
		local p_y = self.mini_map_info.height - entity.model.m_y * self.scene_scale;
	
		local img_str = "ui2/minimap/map_cr.png";
		if EntityConfig.ENTITY_TYPE[entity.type] == "NPC" then
			img_str = "ui2/minimap/map_cy.png";
		end

		local entity_point = MUtils:create_zximg(self.map, img_str, p_x, p_y,4,4);
		if self.entity_point_tab then

			self.entity_point_tab[handler] = entity_point;
		end
	elseif status == 0 then 

		if self.entity_point_tab then 
			local entity_point = self.entity_point_tab[handler];
			if entity_point then
				entity_point:removeFromParentAndCleanup(true);
			end
		end
	end

end

-- 加载小地图
function MicroMapView:update_map(  )

    local scene_id = SceneManager:get_cur_scene();
    local scene = SceneConfig:get_scene_by_id( scene_id );
    
    --小地图配置
    self.mini_map_info = SceneConfig:get_mini_map_info( scene.mapfilename );
    
    -- 获取npc数据  
    -- if #scene.npc ~= 0 then
    --     self.npc_dict = scene.npc;
    -- end
    -- --获取怪物数据
    -- self.monster_dict = scene.refresh; 
    -- --获取传送阵数据
    -- if #scene.teleport ~= 0 then
    --     self.teleport_dict = scene.teleport;
    -- end

    --获取场景的大小
    self.scene_size = {width = scene.sceneWidth * 32, height = scene.sceneHeight * 32};
    -- 计算真实场景与小地图的比例
    self.scene_scale = self.mini_map_info.width / self.scene_size.width;


	if self.map_bg == nil then 
	    --地图裁剪背景图
	    self.map_bg = CCBasePanelIrrCut:panelWithFile( 0,0,139,138,"ui/main/m_mini_map.png");
	    self.map_bg:setIrrCutImage("ui/main/m_mini_map_bg.png");
	    self.view:addChild(self.map_bg);
    end

    if self.map then
        self.map:removeFromParentAndCleanup(true);
    end
    -- 小地图
    -- self.map = CCMinMap:initWithFile( 0, 0, 139, 138,"nopack/MiniMap/"..scene.mapfilename..".jpg")
    -- self.map:setMapSize(self.mini_map_info.width, self.mini_map_info.height)
    self.map = CCBasePanel:panelWithFile(0, 0, self.mini_map_info.width, self.mini_map_info.height, "nopack/MiniMap/"..scene.mapfilename..".jpg");
    self.map_bg:addChild(self.map);
    -- 4个边距
    self.left_mgr = 139/2;
    self.down_mgr = 138/2;
    self.right_mgr = self.mini_map_info.width - 139/2;
    self.up_mgr = self.mini_map_info.height - 138/2;

    -- 角色点
    local player = EntityManager:get_player_avatar( )
    self.user_point = MUtils:create_zximg(self.map_bg,"ui2/minimap/map_cb.png",139/2-2,138/2-2,4,4);
    if player then
    	self:sync_avatar_point(player.x, player.y);
	end
    -- 创建其他实体点
    -- self:create_entity_point();
end

-- 创建地图上的实体点
function MicroMapView:create_entity_point(  )
	
	--怪物点
	if self.monster_dict ~= nil then
		for i,monster in ipairs(self.monster_dict) do

			local p_x = ( monster.mapx2 * 32 - 32/2 ) * self.scene_scale;
			--从大地图的左上角原点 转化为 小地图的左下角原点
			local p_y = self.mini_map_info.height - ( monster.mapy2 * 32 - 32/2 ) * self.scene_scale;
			local monster_point = MUtils:create_zximg(self.map, "ui2/minimap/map_cr.png", p_x, p_y,4,4);
		end
	end

	--npc点
	if self.npc_dict ~= nil then
		for i,npc in ipairs(self.npc_dict) do

			local p_x = ( npc.posx * 32 - 32/2 ) * self.scene_scale;
			--从大地图的左上角原点 转化为 小地图的左下角原点
			local p_y = self.mini_map_info.height - ( npc.posy * 32 - 32/2 ) * self.scene_scale;
			local npc_point = MUtils:create_zximg(self.map, "ui2/minimap/map_cy.png", p_x, p_y,4,4);
		end
	end

	--传送阵点
	if self.teleport_dict ~= nil then 
		for i,teleport in ipairs(self.teleport_dict) do
			local p_x = ( teleport.posx * 32 - 32/2 ) * self.scene_scale;
			--从大地图的左上角原点 转化为 小地图的左下角原点
			local p_y = self.mini_map_info.height - ( teleport.posy * 32 - 32/2 ) * self.scene_scale;

			local teleport_point = MUtils:create_zximg(self.map, "ui2/minimap/map_cr.png", p_x, p_y,4,4);
		end
	end

end

-- 同步角色坐标
function MicroMapView:sync_avatar_point( w_pos_x, w_pos_y )
	
	if self.w_pos_x  == w_pos_x and self.w_pos_y == w_pos_y then
		-- 如果坐标相同，不处理
		return;
	end

	self.w_pos_x = w_pos_x;
	self.w_pos_y = w_pos_y;

	local pos_x = w_pos_x * self.scene_scale;
		--y轴翻转
	local pos_y = self.mini_map_info.height - w_pos_y * self.scene_scale;

	--不靠近边缘
	if pos_x > self.left_mgr and pos_y > self.down_mgr
		 and pos_x < self.right_mgr and pos_y < self.up_mgr then 
		 -- print("不靠近边缘")
		self.user_point:setPosition( 139/2-2, 138/2-2);
		self.map:setPosition(139/2 - pos_x, 138/2 - pos_y);

	else
		-- 角色靠近地图边缘，地图的移动进行特殊处理
		local map_temp_x;
		local map_temp_y;
		if pos_x <= self.left_mgr then
			-- print("靠近地图左边缘");
			--靠近地图左边缘
			
			--计算角色点坐标的偏移
			local off_x = 139/2 - pos_x;
			self.user_point:setPosition( 139/2-2-off_x, self.user_point:getPositionS().y);
			-- 固定地图x坐标，因为已经靠近左边缘
			map_temp_x = 0;
		elseif pos_x >= self.right_mgr then
			-- 靠近地图右边缘
			-- print("靠近地图右边缘");
			-- 计算角色点坐标的偏移
			local off_x = 139/2 - (self.mini_map_info.width - pos_x);
			self.user_point:setPosition( 139/2-2 + off_x, self.user_point:getPositionS().y);

			-- 固定地图x坐标，因为已经靠近右边缘
			map_temp_x = -(self.mini_map_info.width - 139);
		else 
			map_temp_x = 139/2 - pos_x;
			self.user_point:setPosition( 139/2-2, self.user_point:getPositionS().y);
		end	

		if pos_y <= self.down_mgr then
			--靠近地下边缘	
			-- print("靠近地图下边缘");
			-- 计算角色点的偏移
			local off_y = 138/2 - pos_y;
			self.user_point:setPosition( self.user_point:getPositionS().x, 138/2-2 - off_y);
		
			-- 固定地图y坐标，因为已经靠近下边缘
			map_temp_y = 0;
		elseif pos_y >= self.up_mgr then

			--靠近地图上边缘	
			-- print("靠近地图上边缘");
			local off_y = 138/2 - (self.mini_map_info.height - pos_y);
			self.user_point:setPosition( self.user_point:getPositionS().x, 138/2-2 + off_y);
			--固定地图y坐标，因为已经靠近上边缘
			map_temp_y = -(self.mini_map_info.height - 138);
		else 
			map_temp_y = 138/2 - pos_y;
			self.user_point:setPosition( self.user_point:getPositionS().x, 138/2-2);
		end

		self.map:setPosition(map_temp_x, map_temp_y );
	end

end

function MicroMapView:__init(  )
 	
	self.view  = CCBasePanel:panelWithFile(0,0,139,138,nil);

	-- AOI内的实体列表
	self.entity_point_tab = {};

	-- 小地图框
    local function open_mini_map(eventType)
    	if eventType == TOUCH_CLICK then
    		UIManager:show_window("mini_map_win");
    	end
    	return true;
    end
    local map_frame = MUtils:create_btn(self.view,"ui/main/m_mini_map.png","ui/main/m_mini_map.png",
    	open_mini_map,0,0,139,138);
    
    self:update_map();

 end 