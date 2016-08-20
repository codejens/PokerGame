-- TopListStruct
-- HJH
-- 2013-3-4
--

super_class.TopListStruct()

function TopListStruct:__init( pack )
	if pack ~= nil then
        self.playerId = pack:readInt()
        self.rankId = pack:readInt()
        self.point = pack:readInt()
        self.campId = pack:readInt()
        self.level = pack:readInt()
        self.job = pack:readInt()
        self.sex = pack:readInt()
        self.score = pack:readInt()
        self.mountStage = pack:readInt()
        self.gemStage = pack:readInt()
        self.wingId = pack:readInt()
        self.petType = pack:readInt()
        self.petId = pack:readInt()
        self.qqVip = pack:readInt()
        self.playerName = pack:readString()
        self.guildName = pack:readString()
        if self.guildName == "" then
            self.guildName = LangGameString[532] -- [532]="无"
        end
        self.petName = pack:readString()
        if self.petName == "" then
            self.petName = LangGameString[532] -- [532]="无"
        end
        --print( string.format("self.playerId=%d, self.rankId=%d, self.point=%d, self.campId=%d, self.level=%d, self.job=%d, self.sex=%d, self.score=%d,self.mountStage=%d, self.gemStage=%d, self.wingId=%d, self.petType=%d, self.petId=%d, self.qqVip=%d, self.playerName=%s, self.guildName=%s, self.petName=%s", self.playerId, self.rankId, self.point, self.campId, self.level, self.job, self.sex, self.score, self.mountStage,self.gemStage, self.wingId, self.petType, self.petId, self.qqVip, self.playerName, self.guildName, self.petName) )
    end
end

super_class.TopListPanelStruct()
function TopListPanelStruct:__init( )
    self.init = false
    self.is_send = false
    self.cur_time = 0
    self.send_time = 0
    self.info = { max_num = 1, page_info = {} }
    --self.max_num = 0
    self.type_index = 0
end
