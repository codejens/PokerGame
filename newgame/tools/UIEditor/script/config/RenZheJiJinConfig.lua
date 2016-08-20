-- RenZheJiJinConfig.lua

require "../data/fanhuanconfig"

RenZheJiJinConfig = {}

RenZheJiJinConfig.NONE_JIJIN = 0
RenZheJiJinConfig.n30DAY = 1
RenZheJiJinConfig.n7DAY = 2

function RenZheJiJinConfig:get_fanhuan_by_index( index )
	require "../data/fanhuanconfig"
	return fanhuanconfig[index];
end

function RenZheJiJinConfig:get_jijin_by_type( type )
	return fanhuanconfig[type]
end

function RenZheJiJinConfig:get_fanhuan_by_type( type )
	return RenZheJiJinConfig:get_jijin_by_type(type).fanhuan
end

function RenZheJiJinConfig:get_cost_by_type( type )
	return RenZheJiJinConfig:get_jijin_by_type(type).money
end

function RenZheJiJinConfig:get_award( type, day)
	return RenZheJiJinConfig:get_fanhuan_by_type(type)[day]
end

function RenZheJiJinConfig:get_all_award( type )
	local all = 0
	local fanhuan = RenZheJiJinConfig:get_fanhuan_by_type(type)
	for i=2,#fanhuan do
		all = all + RenZheJiJinConfig:get_award(type, i)
	end
	return all
end