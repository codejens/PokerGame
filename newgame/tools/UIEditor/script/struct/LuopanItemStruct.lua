-- LuopanItemStruct.lua
-- created by lyl on 2013-8-30
-- 黄金罗盘 珍品列表中一项的结构

super_class.LuopanItemStruct()


function LuopanItemStruct:__init( pack )
    self.player_name = pack:readString()        -- 角色名
    self.item_name   = pack:readString()        -- 道具名（带颜色）
    self.item_count  = pack:readChar()          --  道具数量
end