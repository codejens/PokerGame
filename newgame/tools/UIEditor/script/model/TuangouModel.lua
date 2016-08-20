-- TuangouModel.lua
-- created by lyl on 2012-12-27
-- 团购 

TuangouModel = {}

TuangouModel.activity_id = 33

TuangouModel.TUANTOU_TYPE_YUANBAO = 1   -- 返还元宝界面
TuangouModel.TUANTOU_TYPE_TUANGOU = 2   -- 团购界面


local _had_get_back_yuanbao_total = 0   -- 累计领取的返还元宝数

local _tuangou_items_list = {}          -- 团购物品列表 

function TuangouModel:fini(  ) 
    _had_get_back_yuanbao_total = 0
    _tuangou_items_list = {}
end

function TuangouModel:init(  ) 
    SmallOperationModel:add_remain_time_listen( TuangouModel )
end



