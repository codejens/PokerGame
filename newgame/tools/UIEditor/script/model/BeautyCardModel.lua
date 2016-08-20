-- BeautyCardModel.lua
-- create by chj on 2015-4-7
-- 美人图谱抽卡Model

BeautyCardModel = {}

-- 活动id 
BeautyCardModel.ACT_ID = 18

-- 宝箱类型
BeautyCardModel.BOX_LINGPAI = 1
BeautyCardModel.BOX_GOLD = 2
BeautyCardModel.BOX_MYSTERY = 3

-- 抽1次，十连抽类型
BeautyCardModel.DRAW_ONE = 1
BeautyCardModel.DRAW_TEN = 10

-- 不是1个就是10个
BeautyCardModel.data = {
    -- 主界面数据
    num_card = 2,                       --默认是两个，(+神秘=3)
    cd_times = {},                      -- cd为0，表示有免费次数

    -- 是否有免费次数（黄金宝箱-第二个）
    -- num_free_draw_2 = 1,

    -- 开启结果数据
    result_info = {
        draw_type = BeautyCardModel.DRAW_TEN,
        result_items = {},  -- 抽取结果

        result_cost_num = 0,
        result_cost_type = 1,
    },
}

function BeautyCardModel:fini( ... )
	-- print("BeautyCardModel:fini( ... )")
end

-- 获取活动时间
function BeautyCardModel:get_actvity_time( )
        local t_remainTime = SmallOperationModel:get_act_time(BeautyCardModel.ACT_ID)
        return t_remainTime
end

-- 获取活动id
function BeautyCardModel:get_act_id( )
    return self.ACT_ID
end

-- 获取主界面数据(卡牌数和免费cd)
function BeautyCardModel:set_main_info( num_card, cd_times)
    self.data.num_card = num_card
    self.data.cd_times = cd_times

    local win = UIManager:find_visible_window("beauty_card_win")
    if win then
        win:update("create")
    end
end

function BeautyCardModel:get_card_num( )
    return self.data.num_card
end

function BeautyCardModel:get_cd_times()
    return self.data.cd_times
end


-- 返回item数据，item个数，连抽类型

-- 设置抽奖结果
function BeautyCardModel:set_result_info(c_type, c_cost, items) 
    self.data.result_info.result_cost_type = c_type
    self.data.result_info.result_cost_num = c_cost
    self.data.result_info.result_items = items
    if #items == BeautyCardModel.DRAW_ONE then
        self.data.result_info.draw_type = BeautyCardModel.DRAW_ONE
    else
        self.data.result_info.draw_type = BeautyCardModel.DRAW_TEN
    end

    local win = UIManager:find_visible_window("beauty_card_win")
    if win then
        win:update("result")
    end

    local win_rlt = UIManager:find_visible_window("beauty_card_result_win")
    if win_rlt then
        win_rlt:update("re_draw")
    end
end

function BeautyCardModel:get_result_info( )
    return self.data.result_info
end

-- 更新黄金宝箱 免费时间
function BeautyCardModel:set_gf_time( gf_time)
    self.data.cd_times[2] = gf_time
    local win = UIManager:find_visible_window("beauty_card_win")
    if win then
        win:update("gf_time")
    end
end
function BeautyCardModel:get_gf_time()
    return self.data.cd_times[2]
end