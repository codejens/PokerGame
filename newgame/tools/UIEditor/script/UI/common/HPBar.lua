-- HPBar.lua
-- created by hcl on 2013-5-8
-- 血条蓝条控件

super_class.HPBar();

HPBar.STATE_NONE = 0;
HPBar.STATE_ADD_HP = 1;
HPBar.STATE_SUB_HP = 2;

-- hp_type 1,左右的血条2,上下的血条
function HPBar:__init( parent,path,change_hp_path,pos_x,pos_y ,width,height,fun,hp_type)
	self.hp_width = width;
	self.hp_height = height;
	self.hp_type = hp_type;
	local bg_panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, "", 500, 500 );
	parent:addChild(bg_panel,50);

	if ( fun ) then
		-- print("-----------------------------------------------------血条注册点击事件...........................................")
		bg_panel:registerScriptHandler(fun);
	end

	self.hp_change_timer = timer();
	self.curr_change_hp = 0;

	-- 减血条
	self.delete_hp_img = MUtils:create_sprite(bg_panel,change_hp_path,0,0);
	self.delete_hp_img:setIsVisible(false);
	-- 当前血条
	self.hp_img = MUtils:create_sprite(bg_panel,path,0,0);
	if hp_type == 1 then
		self.hp_img:setAnchorPoint(CCPoint(0,0.5));
		self.delete_hp_img:setAnchorPoint(CCPoint(0,0.5));
		self.hp_img:setPosition(0,self.hp_height/2);
		self.delete_hp_img:setPosition(0,self.hp_height/2);
	elseif hp_type == 2 then
		self.hp_img:setAnchorPoint(CCPoint(0.5,0));
		self.delete_hp_img:setAnchorPoint(CCPoint(0.5,0));
		self.hp_img:setPosition(self.hp_width/2,0);
		self.delete_hp_img:setPosition(self.hp_width/2,0);
	end
	-- 当前血条的血量
	self.curr_hp = 0;
	self.old_hp = 0;
	self.view = bg_panel;
	return self;
end

function HPBar:set_hp( hp,max_hp )
	-- local hp_rate = math.max(hp/max_hp,0.01);
	-- hp_rate = math.min(hp_rate,1);
	if max_hp~= 0 then 
		local hp_rate = self:cal_hp_rate( hp,max_hp )
		self:set_hp_img_texturerect( self.hp_img,hp_rate )
		self.curr_hp = hp;
		self.old_hp = hp;
		self.max_hp = max_hp;
	end
end

function HPBar:destroy()
	self.hp_change_timer:stop();
end



function HPBar:update_hp( change_hp,hp,max_hp )
	-- 保证hp不小于0
	hp = math.max( hp,0 );
	-- print("change_hp = ",change_hp,"hp = ",hp,"max_hp = ",max_hp,"self.old_hp",self.old_hp);
	-- 如果当前没有掉血或加血
	if ( self.delete_hp_img:getIsVisible() == false and change_hp < 0 and (-change_hp) > 0.05 * max_hp) then
		--print("开始播放减血动画")
		self.old_hp = self.curr_hp;
		self.curr_hp = hp;
		self.delete_hp_img:setIsVisible(true);
		local function update_hp_timer()
			-- print("播放见血动画")
			-- 每0.1秒减少5%血
			
		-- 	-- local result_rate = math.max((self.old_hp-self.curr_hp)/self.max_hp,0.01);
		-- 	local result_rate = self:cal_hp_rate( self.old_hp-self.curr_hp,self.max_hp )
		-- 	-- self.delete_hp_img:setTextureRect(CCRect(0,0, result_rate*80,12));
		-- 	self:set_hp_img_texturerect( self.delete_hp_img,result_rate )
		-- 	if ( self.old_hp <= self.curr_hp ) then
		-- --		print("停止播放减血动画")
		-- 		self.delete_hp_img:setIsVisible(false);
		-- 		self.hp_change_timer:stop();
		-- 	end
			self.old_hp = self.old_hp - self.max_hp*0.01;
			local result_rate = self:cal_hp_rate( self.old_hp,self.max_hp )
			self:set_hp_img_texturerect( self.delete_hp_img,result_rate )
			if ( self.old_hp <= self.curr_hp ) then
				self.delete_hp_img:setIsVisible(false);
				self.hp_change_timer:stop();
			end
		end
		-- 每一帧调用
		self.hp_change_timer:start(0,update_hp_timer);
	else
		self.curr_hp = hp;
		-- 特殊处理，某些场景，玩家会增加 最大生命值或者减少最大生命值
		-- （由于现在血条动画没了，一剑灭天的下面四行应对仙道會的血条处理代码也先注释掉，如果以后有人做血条动画，可以考虑一下这段代码是否应该加上。 note by guozhinan）
		-- if ( hp == max_hp ) then
		-- 	self.delete_hp_img:setIsVisible(false);
		-- 	self.hp_change_timer:stop();
		-- end
	end
	-- 更新当前血条
	self.max_hp = max_hp;
	-- local hp_rate = math.max(hp/max_hp,0.01);
	-- hp_rate = math.min(hp_rate,1);
	local hp_rate = self:cal_hp_rate( hp,max_hp )
	-- self.hp_img:setTextureRect( CCRect(0,0,hp_rate*80,12) );
	self:set_hp_img_texturerect( self.hp_img,hp_rate )
	-- 更新掉血条
	-- if ( self.delete_hp_img:getIsVisible() ) then
	-- 	if self.hp_type == 1 then
	-- 		self.delete_hp_img:setPosition( self.hp_width*hp_rate,self.hp_height/2 )
	-- 	else
	-- 		self.delete_hp_img:setPosition( self.hp_width/2,self.hp_height*hp_rate )
	-- 	end
	-- end
end

function HPBar:set_hp_img_texturerect( img,hp_rate )
	if self.hp_type == 1 then
		img:setTextureRect(CCRect(0,0,self.hp_width*hp_rate,self.hp_height));
	else
		img:setTextureRect(CCRect(0,self.hp_height-self.hp_height*hp_rate,self.hp_width,self.hp_height*hp_rate))
	end
end

function HPBar:cal_hp_rate( curr_hp,max_hp )
	local hp_rate = math.max(curr_hp/max_hp,0.01);
	hp_rate = math.min(hp_rate,1);
	return hp_rate
end