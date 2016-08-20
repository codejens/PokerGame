-- TopListBattleStruct
-- HJH
-- 2013-3-4
--

super_class.TopListBattleStruct()

function TopListBattleStruct:__init( pack )
	if pack ~= nil then
        self.playerId = pack:readInt()
        self.playerName = pack:readString()
        self.campId = pack:readInt()
        self.sex = pack:readInt()
        self.job = pack:readInt()
        self.level = pack:readInt()
        self.kill = pack:readInt()
        self.help = pack:readInt()
        self.hit = pack:readInt()
        self.score = pack:readInt()
        print( string.format("playerid=%d,playerName=%s,campId=%d,sex=%d,job=%d,level=%d,kill=%d,help=%d,hit=%d,score=%d",
            self.playerId,self.playerName,self.campId,self.sex,self.job,self.level,self.kill,self.help,self.hit,self.score ) )
    end
end