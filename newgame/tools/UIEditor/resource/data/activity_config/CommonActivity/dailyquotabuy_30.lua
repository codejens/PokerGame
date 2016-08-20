-- region dailyquotabuy_new_param.lua    --新服服每日限购活动配置参数
-- Author : 肖进超
-- Date   : 2014/10/27
WorkDailyQuotaBuyParam = {
    --活动说明
    desc = "在活动期间，放出下列超级限购物品！先买先得！",
}
--前端根据后端发来的标签选择相应的标签
--如果找到某天的数值，默认使用第一天的数值
--配置标签 1（法宝）
WorkDailyQuotaBuyParam[1] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 71011, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 71011, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 71011, oldPrice = 1532, newPrice = 988, },
            [2] = { itemId = 71011, oldPrice = 1500, newPrice = 1288, },
        },
    },
}

--配置标签 2
WorkDailyQuotaBuyParam[2] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 71011, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 71011, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 71011, oldPrice = 1532, newPrice = 988, },
            [2] = { itemId = 71011, oldPrice = 640, newPrice = 518, },
        },
    },
}

--配置标签 3
WorkDailyQuotaBuyParam[3] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 71011, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 71011, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 71011, oldPrice = 2650, newPrice = 888, },
            [2] = { itemId = 71011,oldPrice = 2683,newPrice = 888, },
        },
    },
}

--配置标签 4
WorkDailyQuotaBuyParam[4] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 71011, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 71011, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 71011, oldPrice = 1532, newPrice = 988, },
            [2] = { itemId = 71011, oldPrice = 999, newPrice = 588, },
        },
    },
}
--配置标签 5
WorkDailyQuotaBuyParam[5] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 60077, oldPrice = 720, newPrice = 368, },
            [2] = { itemId = 60083, oldPrice = 500, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 18615, oldPrice = 200, newPrice = 88, },
            [2] = { itemId = 18611, oldPrice = 999, newPrice = 588, },
        },
    },
    [2] = {
        [1] = {
            [1] = { itemId = 60077, oldPrice = 720, newPrice = 368, },
            [2] = { itemId = 60083, oldPrice = 500, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 18615, oldPrice = 200, newPrice = 88, },
            [2] = { itemId = 18611, oldPrice = 999, newPrice = 588, },
        },
    },
    [3] = {
         [1] = {
            [1] = { itemId = 60077, oldPrice = 720, newPrice = 368, },
            [2] = { itemId = 60083, oldPrice = 500, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 18615, oldPrice = 200, newPrice = 88, },
            [2] = { itemId = 18611, oldPrice = 999, newPrice = 588, },
        },
    },
  
}




