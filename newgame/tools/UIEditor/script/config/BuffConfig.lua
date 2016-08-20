-- BuffConfig.lua
-- created by hcl on 2013-7-9
-- buff配置


BuffConfig = {}

--  根据buff_id取得buff的描述信息
function BuffConfig:get_buff_desc_by_buff_id( buff_id )
	require "../data/buff_desc"
	return buff_descs[buff_id] or '';
end
