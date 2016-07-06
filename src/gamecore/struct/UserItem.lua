-- UserItem.lua
-- created by aXing on 2012-11-30
-- 用户道具结构

UserItem = simple_class()

-- require "config/ItemConfig"

local function get_smith( pack )
	local smith = {}
	smith.type	= pack:readByte()
	smith.value	= pack:readInt()
	return smith
end

function UserItem:__init( pack )

	-- 初始化
	self.holes  = {}
	self.smiths	= {}

	if pack ~= nil then
		self.series 		= pack:readInt64()				-- 物品唯一的一个序列号
		self.item_id		= pack:readWord()				-- 标准物品id
		self.quality		= pack:readByte()				-- 物品品质等级
		self.strong			= pack:readByte()				-- 物品强化等级
		self.duration		= pack:readWord()				-- 物品耐久度
		self.duration_max	= pack:readWord()				-- 物品耐久度最大值
		self.count			= pack:readWord()				-- 此物品的数量，默认为1，当多个物品堆叠在一起的时候此值表示此类物品的数量
		self.flag			= pack:readByte()				-- 物品标志，使用比特位标志物品的标志，例如绑定否 1表示绑定

		self.holes[1]		= pack:readWord()				-- 宝石孔
		self.holes[2]		= pack:readWord()
		self.holes[3]		= pack:readWord()
		
		self.deadline		= pack:readUInt()				-- 道具使用时间

		self.void_bytes_tab = {};
		for i = 1, 32 do 
            self.void_bytes_tab[i] = pack:readByte()
		end
		-- local std_item = ItemConfig:get_item_by_id( self.item_id )
		-- if std_item and std_item.type ~= ItemConfig.ITEM_TYPE_SKILL_MIJI	 then
		-- 	for i=1,8 do
		-- 		self.void_bytes_tab[i] = pack:readByte();		-- 预留字段第一个是品质
		-- 		if ( i == 1 ) then
		-- 			self.void_bytes_tab[i] = self.void_bytes_tab[i] + 1; -- 服务端发过来的品质值从0开始,客户端要从1开始
		-- 		end
		-- 	end
		-- else  --技能秘籍 若是秘籍，则第二个字节表示重数，第3,4,5，6个字节使用来保存经验,第7个字节保存仙练值
		-- 	self.void_bytes_tab[1] = pack:readByte();
		-- 	self.void_bytes_tab[2] = pack:readByte();
		-- 	self.void_bytes_tab[3] = pack:readInt();
		-- 	self.void_bytes_tab[7] = pack:readByte();
		-- 	self.void_bytes_tab[8] = pack:readByte();
		-- 	--print("秘籍重数 经验 仙炼值 品质等级",self.void_bytes_tab[2] ,self.void_bytes_tab[3] ,self.void_bytes_tab[7],self.quality )
		-- end
		--local void_byte 	= pack:readUint64()				-- 预留字段 8个字节



		self.smith_num		= pack:readByte()				-- 物品的洗炼属性开启个数
		self.smiths[1]		= get_smith(pack)
		self.smiths[2]		= get_smith(pack)
		self.smiths[3]		= get_smith(pack)
		self.smiths[4]		= get_smith(pack)
		self.smiths[5]		= get_smith(pack)

        self:updateAdditionAttributes( pack )
	end
end

function UserItem:updateAdditionAttributes( pack )
    local amount = pack:readByte() -- 开启的属性个数
    self.additionAttributes = self.additionAttributes or {}
    for i = 1, 5 do 
        local addAtt = {}
        addAtt.type = pack:readByte() 
		addAtt.percent = pack:readWord()
		addAtt.value = pack:readUInt()
		self.additionAttributes[i] = addAtt
    end
end

function UserItem:updateSmith( pack )
	self.smithSaveList = self.smithSaveList or {}
	self.swordSaveList = self.swordSaveList or {}
	self.swordCurrent = pack:readInt() -- 当前洗练属性战斗力
    self.smithSaveListLength = pack:readInt() -- 洗练数量 1或者10
    for i = 1, self.smithSaveListLength do 
        local smithNumOfThis = pack:readByte() --洗练激活数 1-_SMITH_CNT
        self.smithSaveList[i] = self.smithSaveList[i] or {}
        for j = 1, smithNumOfThis do 
            local vect = self.smithSaveList[i]
            vect[j] = get_smith( pack )
        end
        self.swordSaveList[i] = pack:readInt()
    end
end
