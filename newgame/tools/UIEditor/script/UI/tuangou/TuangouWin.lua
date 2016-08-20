-- TuangouWin.lua  
-- created by hcl on 2014-1-16
-- 团购主窗口 


super_class.TuangouWin(NormalStyleWindow)

local _SLOTITEM_POS = {126,278,96,226,156,226,395,251,453,25}

function TuangouWin:__init( window_name, texture_name )
	-- 左上的3个展示道具
	for i=1,5 do
		local _slot_item = MUtils:create_slot_item(self.view, UILH_COMMON.slot_bg,
			_SLOTITEM_POS[(i-1)*2+1],_SLOTITEM_POS[(i-1)*2+2],62,62,1100);
		local _size = 45
		if i > 3 then
			_size = 48;
		end
		_slot_item.view:setScale(_size/62);
	end

	for i=1,2 do
		local function qg_fun( event_type )
			if event_type == TOUCH_CLICK then
				
			end
			return true;
		end
		-- 抢购按钮
		MUtils:create_btn(self.view, UILH_MAINACTIVITY.tg_czlb, UILH_MAINACTIVITY.tg_shlb, qg_fun,110 + (i-1)*273,110,-1,-1);
	end

	-- 

end

-- 更新
function TuangouWin:update( update_type )

end

-- 激活
function TuangouWin:active( if_active )
	
end

-- 销毁
function TuangouWin:destroy(  )
    Window.destroy(self)
end

