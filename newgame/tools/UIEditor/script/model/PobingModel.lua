-- filename: PobingModel.lua
-- author: created by xiehande on 2012-12-12.
-- function: 破冰活动 逻辑层

PobingModel = {}
local pobingValue = {}
-- 发送整理仓库的请求
function PobingModel:request_chongzhi_value(  )
    OnlineAwardCC:request_chongzhi_value()   
end

-- 请求仓库数据
function PobingModel:request_lignqu( index )
    OnlineAwardCC:request_lignqu(index)
end

function PobingModel:rechieve_chongzhi_value( object )
    self:set_Pobing_value(object)
    local win = UIManager:find_visible_window("po_bing_win")
    if win then
    	win:update()
    end
end

function PobingModel:set_Pobing_value( object )
    pobingValue = object
end

function PobingModel:get_Pobing_value(  )
     return pobingValue 
end

