-- BigActivityRankStruct.lua
-- create by lyl on 2013-10-26
-- 大型活动排行结构

super_class.BigActivityRankStruct()


function BigActivityRankStruct:__init( pack )
    self.player_id   = pack:readInt()           -- 玩家id
    self.player_name = pack:readString()        -- 玩家姓名
    self.state       = pack:readByte()          --  奖励情况，0为不可领取，1为可领取，2为已领取
end