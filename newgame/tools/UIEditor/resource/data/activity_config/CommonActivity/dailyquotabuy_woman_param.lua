-- region dailyquotabuy_new_param.lua    --新服服每日限购活动配置参数
-- Author : 肖进超
-- Date   : 2014/10/27

WDailyQuotaBuyParam = {
    --活动说明
    desc = "在活动期间，放出下列超级限购物品！先买先得！",
}

--前端根据后端发来的标签选择相应的标签
--如果找到某天的数值，默认使用第一天的数值
--配置标签 1（法宝）
WDailyQuotaBuyParam[1] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 45009, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 45010, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 34942, oldPrice = 1532, newPrice = 988, },
            [2] = { itemId = 54957, oldPrice = 1500, newPrice = 1288, },
        },
    },
}

--配置标签 2
WDailyQuotaBuyParam[2] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 45009, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 45010, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 34942, oldPrice = 1532, newPrice = 988, },
            [2] = { itemId = 58214, oldPrice = 640, newPrice = 518, },
        },
    },
}

--配置标签 3
WDailyQuotaBuyParam[3] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 45009, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 45010, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 45086, oldPrice = 2650, newPrice = 888, },
            [2] = { itemId = 45087,oldPrice = 2683,newPrice = 888, },
        },
    },
}

--配置标签 4
WDailyQuotaBuyParam[4] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 45009, oldPrice = 298, newPrice = 198, },
            [2] = { itemId = 45010, oldPrice = 720, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 34942, oldPrice = 1532, newPrice = 988, },
            [2] = { itemId = 18611, oldPrice = 999, newPrice = 588, },
        },
    },
}
--配置标签 5
WDailyQuotaBuyParam[5] = {
    --第一天
    [1] = {
        [1] = {
            [1] = { itemId = 60075, oldPrice = 300, newPrice = 188, },
            [2] = { itemId = 60076, oldPrice = 500, newPrice = 298, },
        },

        [2] = {
            [1] = { itemId = 60096, oldPrice = 1500, newPrice = 888, },
            [2] = { itemId = 60097, oldPrice = 298, newPrice = 198, },
        },
    },
    [2] = {
        [1] = {
            [1] = { itemId = 60077, oldPrice = 720, newPrice = 368, },
            [2] = { itemId = 60083, oldPrice = 500, newPrice = 288, },
        },

        [2] = {
            [1] = { itemId = 18614, oldPrice = 640, newPrice = 518, },
            [2] = { itemId = 18611, oldPrice = 999, newPrice = 588, },
        },
    },
    [3] = {
        [1] = {
            [1] = { itemId = 60078, oldPrice = 2650, newPrice = 1388, },
            [2] = { itemId = 60079, oldPrice = 2830, newPrice = 1488, },
        },

        [2] = {
            [1] = { itemId = 60081, oldPrice = 540, newPrice = 298, },
            [2] = { itemId = 60082, oldPrice = 1600, newPrice = 988, },
        },
    },
}




