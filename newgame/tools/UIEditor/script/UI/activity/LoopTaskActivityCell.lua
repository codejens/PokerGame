-- LoopTaskActivityCell.lua
-- created by MWY 2014-8-15
-- 跑环奖励单元格

super_class.LoopTaskActivityCell()


function LoopTaskActivityCell:__init(x, y, w, h, data,ndata ,index)
	self.width=w
	self.height=h
	self.slot_t={}
	self.cdata=data
	self.ndata=ndata
	self.view = CCBasePanel:panelWithFile(x,y,w,h,nil)
	self:initializeUI(index)
end

function LoopTaskActivityCell:initializeUI(index)
	-- 分隔线
	MUtils:create_zximg(self.view,UIPIC_Benefit_024,10,0,self.width-15,1,500,500)
	--背景框
	local huan_bg= MUtils:create_zximg(self.view,UIPIC_LoopTask_0013,10,13,-1,-1,500,500)
	
	--环数图标
	local  file_path='ui/paohuan/huan_'..index..'.png'
	self.huanshu_img= MUtils:create_zximg(huan_bg,file_path,38,40,-1,-1,500,500)
	--
	--可领取图标
	MUtils:create_zximg(huan_bg,UIPIC_LoopTask_0015,32,15,-1,-1,500,500)

	 --已领取图标
	self.yet_get_img= MUtils:create_zximg(huan_bg,UIPIC_LoopTask_0014,28,14,-1,-1,500,500)

	if self.ndata and self.ndata.state==2 then
		self.yet_get_img:setIsVisible(true)
	else
		self.yet_get_img:setIsVisible(false)	
	end

	--------------------------创建slot-------------------------
	local  data_num = #self.cdata
	for i=1,5 do
		local award = self.cdata[i]
		local slot  = SlotItem(64, 64) 
		slot:set_icon_bg_texture( UIPIC_ITEMSLOT , -4, -4, 72, 72 )		
		slot:set_icon_size( 46, 46 )	
		slot:set_lock( false )

		if award then
			slot:set_icon_ex( award.id )
			slot:set_color_frame( award.id, -2, -2, 68, 68 )    -- 边框颜色
			slot:set_item_count(award.count)
			if award.effect==1 then
				--播放特效
		        local _effect =slot:play_activity_effect(award.effectId)
		        _effect:setScale(1.2)
		        _effect:setPosition(32,32)
			end
			if ( award.bind == 1 ) then
	            slot:set_lock( true )
		    else
	            slot:set_lock( false )
		    end
		end

		local function fun()
			if award and award.id  then
				TipsModel:show_shop_tip( 400, 240, award.id )
			end
		end
		slot:set_click_event( fun )
		self.view:addChild(slot.view)
		slot:setPosition( 80*(i-1)+155, 15+4 )
		self.slot_t[i]=slot
	end
end
--cdata是配置表的数据，ndata是服务器下发数据
function LoopTaskActivityCell:update(cdata,index,ndata)
	local  file_path='ui/paohuan/huan_'..index..'.png'
	self.huanshu_img:setTexture(file_path)	
	if cdata then
		self.cdata=cdata
		for i=1,5 do	
			local award = self.cdata[i]
			local slot  = self.slot_t[i]	
			slot:remove_activity_effect()	

			slot:set_lock( false )

			if award then
				slot:update(award.id,award.count,nil)	
				if ( award.bind == 1 ) then
		            slot:set_lock( true )
			    else
		            slot:set_lock( false )
			    end
		    
				if award.effect==1 then
					--播放特效
			        local _effect =slot:play_activity_effect(award.effectId)
			        _effect:setScale(1.2)
			        _effect:setPosition(32,32)
				end
			else
				slot:set_icon_bg_texture( "" , -4, -4, 72, 72 )		
				slot:set_icon_texture('')
			end	
			--重新绑定一次slot的id,因为刷新后id改变了,坑还是那个坑，拉屎的人换了
			local function fun()
				if award and award.id  then
					TipsModel:show_shop_tip( 400, 240, award.id )
				end
			end
			slot:set_click_event( fun )
		end
	end
	if ndata then
		self.ndata=ndata
		if self.ndata.state==2 then
			self.yet_get_img:setIsVisible(true)
		else
			self.yet_get_img:setIsVisible(false)	
		end
	end	
end