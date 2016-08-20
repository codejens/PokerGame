-- MallSellItemStruct.lua
-- created by lyl on 2012-2-18
-- 热销产品数据结构

super_class.MallSellItemStruct()

function MallSellItemStruct:__init( pack )
	if pack ~= nil then
		self.mall_item_id  = pack:readInt()		     -- 商品id
		self.uCount	       = pack:readUInt()		 -- 积累销售量
	end
end