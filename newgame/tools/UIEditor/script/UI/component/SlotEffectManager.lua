-- SlotEffectManager.lua
-- created by hcl on 2013-3-13
-- 管理slotItem的选中特效

SlotEffectManager = {} 
--module(..., package.seeall)

local playing_effect_slot_item = nil;

function SlotEffectManager.play_effect_by_slot_item( slot_item )
	-- 如果上一个slot_item在播放选中特效 则取消上一个
	if ( playing_effect_slot_item ) then
		-- 取消上一个slot_item的选中特效
		local effect_node = playing_effect_slot_item.view:getChildByTag(10007);
		if ( effect_node ) then
			effect_node:removeFromParentAndCleanup(true);
		end
		safe_release(playing_effect_slot_item.view)
	end
	safe_retain(slot_item.view)
	playing_effect_slot_item = slot_item;
	-- 播放特效
	return LuaEffectManager:play_view_effect( 10007,nil,nil,slot_item.view ,true);
end

function SlotEffectManager.release_slot_effect()
	if playing_effect_slot_item then
		safe_release(playing_effect_slot_item.view)
	end
	playing_effect_slot_item = nil
end

function SlotEffectManager.stop_current_effect()
	if ( playing_effect_slot_item ) then 
		local effect_node = playing_effect_slot_item.view:getChildByTag( 10007 );
		if ( effect_node ) then
			effect_node:removeFromParentAndCleanup(true);
		end
	end
end