-- MiyouModel.lua
-- created by liuguowang on 2013-9-2


-- super_class.MiyouModel()
MiyouModel = {}

MiyouModel.ITEM_ID = 0		-- 物品ID
MiyouModel.ITEM_NUM = 1		-- 物品数量
MiyouModel.ITEM_STATE = 2	-- 赠送、领取状态
MiyouModel.ITEM_ROLEID = 3	-- 物品要送给的角色ID

function MiyouModel:get_continue_day()
    return self.continue_day
end

function MiyouModel:set_continue_day(day)
     self.continue_day = day
end

--------------------------------  
function MiyouModel:getUpdateIndex()
	return self.updateIndex 
end

function MiyouModel:setUpdateIndex(index)	--保存选择的哪一行， 用于更新哪一行
	self.updateIndex = index
end
--------------------------------  

function MiyouModel:setOthersData(dayIndex,remain_Time,has_send,has_15th_login)	
	self.dayIndex =dayIndex
	self.remain_Time = remain_Time
	self.has_send = has_send
	self.has_15th_login =has_15th_login
end

function MiyouModel:getListData()	
	return self._miyouRow_send_Data,self._miyouRow_get_Data 
end

function MiyouModel:setListData(miyouRow_send_Data,miyouRow_get_Data)	
	self._miyouRow_send_Data = miyouRow_send_Data
	self._miyouRow_get_Data = miyouRow_get_Data
end

function MiyouModel:setListSubData(bSend,rowIndex,subItem,Value)
	if bSend == true then
		if subItem == MiyouModel.ITEM_ID then
			self._miyouRow_send_Data[rowIndex].itemID = Value
		elseif subItem == MiyouModel.ITEM_NUM then
			self._miyouRow_send_Data[rowIndex].num = Value
		elseif subItem == MiyouModel.ITEM_STATE then
			self._miyouRow_send_Data[rowIndex].state = Value
		elseif subItem == MiyouModel.ITEM_ROLEID then
			self._miyouRow_send_Data[rowIndex].roleID = Value
		end
	elseif bSend == false then
		if subItem == MiyouModel.ITEM_ID then
			self._miyouRow_get_Data[rowIndex].itemID = Value
		elseif subItem == MiyouModel.ITEM_NUM then
			self._miyouRow_get_Data[rowIndex].num = Value
		elseif subItem == MiyouModel.ITEM_STATE then
			self._miyouRow_get_Data[rowIndex].state = Value
		end
	end
end


function MiyouModel:get_miyou_15th()--第15天 或 15天登陆过
	if self.dayIndex == 15 or self.has_15th_login >0 then
		return true
	end
	return false
end

function MiyouModel:get_miyou_remain_Time()--获得剩余时间
	if self.remain_Time == nil then 
		return 0 
	end

	local now_time = self.remain_Time -  GameStateManager:get_total_seconds(  ) ;
	if now_time < 0 then
		now_time = 0
	end
	return now_time
end



