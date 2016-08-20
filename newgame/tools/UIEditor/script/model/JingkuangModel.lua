-- JingkuangModel.lua
-- created by lxm on 2014-4-10
-- 晶矿 动态数据

JingkuangModel = {}

local _pin_zhi =1-- 矿场品质
local _shengyu_count =0 --选矿剩余次数
-- 挖矿次数 ，挖矿品质，身份，矿主ID，矿主名称，召唤镜像费用，矿工数量
local _kaikuang_info = {wakua_count=0,wakuang_pinzhi=0,shen_fen=0,kuangzhu_id=0,kuangzhu_name="",pay_zhaohuan=0,miner_count=0}  --开矿信息
local _all_miner_info = {}
local _all_kuangchang_info = {} --矿场信息
--local _kuangchang_info = {kuangchang_id=0,kuangzhu_name="",miner_count=0,max=0,pin_zhi=0,shou_yi=0}  --矿场信息
--local _miner_info = {miner_name="",miner_id=0,touxiang_id=0,xingbie=0}  --矿工信息

function JingkuangModel:fini( ... )
	_pin_zhi = 1
	_shengyu_count = 0
	_kaikuang_info = {wakua_count=0,wakuang_pinzhi=0,shen_fen=0,kuangzhu_id=0,kuangzhu_name="",pay_zhaohuan=0,miner_count=0} 
	_all_miner_info = {}
	_all_kuangchang_info = {}
	--_miner_info = {miner_name="",miner_id=0,touxiang_id=0,xingbie=0}
end

-- 设置矿场品质
function JingkuangModel:set_pin_zhi( pin_zhi)
	_pin_zhi = pin_zhi
end
-- 获取矿场品质
function JingkuangModel:get_pin_zhi( )
	return _pin_zhi 
end

-- 设置矿工信息
function JingkuangModel:set_all_miner_info( all_miner_info)
	_all_miner_info = all_miner_info
end
-- 获取矿工信息
function JingkuangModel:get_all_miner_info( )
	return _all_miner_info 
end

-- 设置开矿信息
function JingkuangModel:set_kaikuang_info( kaikuang_info)
	_kaikuang_info = kaikuang_info
	_shengyu_count = kaikuang_info.wakua_count
end
-- 获取开矿信息
function JingkuangModel:get_kaikuang_info( )
	return _kaikuang_info 
end

--选矿剩余次数get_all_kuangchang_info
function JingkuangModel:get_shengyu_count( ... )
	return _shengyu_count
end

-- 设置矿场信息
function JingkuangModel:set_all_kuangchang_info( all_kuangchang_info)
	_all_kuangchang_info = all_kuangchang_info
end
-- 获取矿场信息
function JingkuangModel:get_all_kuangchang_info( )
	return _all_kuangchang_info 
end

-- 获取召唤使者费用
function JingkuangModel:get_pay_zhaohuan( ... )
	return _kaikuang_info.pay_zhaohuan
end

-- 获取开矿身份
function JingkuangModel:get_shenfen( ... )
	return _kaikuang_info.shen_fen
end

-- 获取挖矿品质
function JingkuangModel:get_wakuang_pinzhi( )
	return _kaikuang_info.wakuang_pinzhi
end

-- 提供外部静态调用的更新窗口方法
function JingkuangModel:update_yuanbao(  )
    local win = UIManager:find_visible_window("shenmi_shop_win")
    if win then
    	win:update_yuanbao()
        
    end
end





