--SlotEffectManager.lua
--管理slotItem选中特效

SlotEffectManager = {} 

local playing_effect_slot_item = nil

function SlotEffectManager.play_effect_by_slot_item(slot_item)
	if playing_effect_slot_item == slot_item then
		return
	end
	SlotEffectManager.stop_current_effect()
	safe_retain(slot_item.view)
	playing_effect_slot_item = slot_item
	local slot_size = slot_item.view:getSize()
	local sprite = CCBasePanel:panelWithFile(slot_size.width/2, slot_size.height/2, -1, -1, "sui/common/bag_slot_select.png", 500, 500)
	sprite:setAnchorPoint(0.5, 0.5)
    slot_item.view:addChild(sprite, 999, 10007)
    -- print( slot_item.view)

    local scaleTo1 = CCScaleTo:actionWithDuration(0.4, 0.9)
    local scaleTo2 = CCScaleTo:actionWithDuration(0.4, 1.0)
	local array = CCArray:array()
	array:addObject(scaleTo1)
	array:addObject(scaleTo2)
	local seq = CCSequence:actionsWithArray(array)
	local rep = CCRepeatForever:actionWithAction(seq)
    sprite:runAction(rep)

	return sprite
end

function SlotEffectManager.release_slot_effect()
	if playing_effect_slot_item then
		safe_release(playing_effect_slot_item.view)
	end
	playing_effect_slot_item = nil
end

function SlotEffectManager.stop_current_effect()
	if playing_effect_slot_item then 
		local effect_node = playing_effect_slot_item.view:getChildByTag(10007)
		if effect_node then
			effect_node:removeFromParentAndCleanup(true)
		end
		SlotEffectManager.release_slot_effect()
	end
end

function SlotEffectManager.delect_effect_by_slot_item(slot_item)
	local effect_node = slot_item.view:getChildByTag(10007)
	if effect_node then
		effect_node:removeFromParentAndCleanup(true)
	end
	if playing_effect_slot_item == slot_item then
		SlotEffectManager.release_slot_effect()
	end
end

function SlotEffectManager:play_effect_for_sld( panel, x, y, scale)

	-- 生成
	local sprite = CCBasePanel:panelWithFile(x, y, -1, -1, "sui/common/bag_slot_select.png", 500, 500)
	sprite:setAnchorPoint(0.5, 0.5)
    panel:addChild(sprite, 999, 10007)
    if scale then
    	sprite:setScale( scale)
    end

    -- 动作
    local scaleTo1 = CCScaleTo:actionWithDuration(0.4, 0.9)
    local scaleTo2 = CCScaleTo:actionWithDuration(0.4, 1.0)
	local array = CCArray:array()
	array:addObject(scaleTo1)
	array:addObject(scaleTo2)
	local seq = CCSequence:actionsWithArray(array)
	local rep = CCRepeatForever:actionWithAction(seq)
    sprite:runAction(rep)

	return sprite
end

function SlotEffectManager:start_action( sprite)
    -- 动作
    local scaleTo1 = CCScaleTo:actionWithDuration(0.4, 0.9)
    local scaleTo2 = CCScaleTo:actionWithDuration(0.4, 1.0)
	local array = CCArray:array()
	array:addObject(scaleTo1)
	array:addObject(scaleTo2)
	local seq = CCSequence:actionsWithArray(array)
	local rep = CCRepeatForever:actionWithAction(seq)
    sprite:runAction(rep)

	return sprite
end
