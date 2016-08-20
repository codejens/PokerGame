-- VIPCC.lua
-- created by fjh on 2012-12-29
-- VIP仙尊系统

-- super_class.VIPCC()
VIPCC = {}

--获取到vip信息
--s->c ,0,50
function VIPCC:do_vip_info( pack )
	local vip_info = VIPStruct(pack);
	VIPModel:set_vip_info(vip_info);
end