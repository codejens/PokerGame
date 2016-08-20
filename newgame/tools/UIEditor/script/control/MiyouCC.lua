-- MiyouOlfriend.lua  
-- created by MiyouCC on 2013-9-3
-- 游戏助手页 中的 每行的基类。  


super_class.MiyouCC()

function MiyouCC:do_miyou_remain_Time(pack)--剩余时间  服务器 主动下发
	local dayIndex = pack:readInt()
	local remain_Time = pack:readInt()
	local has_send = pack:readChar()
	local has_15th_login = pack:readChar()
	MiyouModel:setOthersData(dayIndex,remain_Time,has_send,has_15th_login)
	GameStateManager:set_total_seconds_zero()  --先清0
end

-----  请求获取奖励列表
function MiyouCC:req_miyou_gift(  )--请求奖励列表
	OnlineAwardCC:request_miyou()
end

function MiyouCC:do_miyou_gift_List(pack)--下发奖励列表

	self:setListData(pack)  --接受各种数据
	local window = UIManager:find_window("miyou_win");
	if window ~= nil then
		window:add_Win_UI()--得到数据才创建其他UI
	end
end

--------------------------------  请求赠送礼物
function MiyouCC:req_miyou_sendGift(index,roleid)
	if roleid > 0 then
		MiyouModel:setUpdateIndex(index)
		OnlineAwardCC:request_miyou_sendGift(index,roleid)
	end
end


function MiyouCC:do_miyou_sendGift_Result(pack)--赠送礼物结果
    local rowIndex   =  pack:readInt() --第几个奖励
    local send_result  =  pack:readInt()  -- 赠送结果
    if send_result == 0 then
	    MiyouModel:setListSubData(true,rowIndex,MiyouModel.ITEM_STATE,2)

	    local window = UIManager:find_window("miyou_win");
		if window ~= nil then
			window:set_SendBtn_state(rowIndex)
			window:updateRow()
		end
	end	
end

--------------------------------  请求领取信息
function MiyouCC:req_miyou_get(index)
	MiyouModel:setUpdateIndex(index)  --表示这一行需要更新
	OnlineAwardCC:request_miyou_get(index)
end

function MiyouCC:do_miyou_getGift_result(pack)--领取礼物结果
    local rowIndex   =  pack:readInt() --第几个奖励
    local get_result  =  pack:readInt()  -- 领取结果
    if get_result == 0 then
	    MiyouModel:setListSubData(false,rowIndex,MiyouModel.ITEM_STATE,2)
	    
	    local window = UIManager:find_window("miyou_win");
		if window ~= nil then
			window:set_GetBtn_state(rowIndex)
			window:updateRow();
		end
	end	
end

function MiyouCC:setListData( pack )--下发

	local day  = pack:readInt() --连续的天数
--------------
    local miyouRow_send_Data = {} 
    local sendCount     = pack:readInt()  -- 赠送个数
    for i=1,sendCount do
        miyouRow_send_Data[i] = {}
        miyouRow_send_Data[i].itemID = pack:readInt()
        miyouRow_send_Data[i].num    = pack:readInt()
        miyouRow_send_Data[i].state  = pack:readByte()
    end
---------------
    local miyouRow_get_Data = {} 
    local getCount     = pack:readInt()  -- 领取个数
    for i=1,getCount do
        miyouRow_get_Data[i] = {}
        miyouRow_get_Data[i].itemID  =  pack:readInt()
        miyouRow_get_Data[i].num     =  pack:readInt()
        miyouRow_get_Data[i].state   =  pack:readByte()
    end
---------------
	MiyouModel:set_continue_day(day)
    MiyouModel:setListData(miyouRow_send_Data,miyouRow_get_Data)

end

-- function MiyouCC:setGetGiftData( pack )  

-- end


-- function MiyouCC:setSendGiftData( pack )  

-- end