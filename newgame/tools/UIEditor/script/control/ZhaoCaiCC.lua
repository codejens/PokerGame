-- ZhaoCaiCC.lua
-- created by fjh on 2013-1-10
-- 招财进宝系统

-- super_class.ZhaoCaiCC()
ZhaoCaiCC = {}

----获取今天已经招财的次数
--s->c ,26,25
function ZhaoCaiCC:do_has_zc_num( pack )
	local num = pack:readInt();
	ZhaoCaiModel:set_has_zc_num(num);
end

--招财事件
--c->s,139,31
function ZhaoCaiCC:request_zhaocai( is_batch )
	local pack = NetManager:get_socket():alloc(139, 31);
	if is_batch then
		pack:writeByte(1);
	else
		pack:writeByte(0);
	end
	NetManager:get_socket():SendToSrv(pack);
end

--招财事件回调
-- s->c 139,32
function ZhaoCaiCC:do_zhaocai( pack )
	--状态码：1：批量成功，0:单次成功，-1元宝不足，-2招财次数不足
	local status_code = pack:readChar();

	local num = pack:readInt();	--今天已经招财的次数
	if status_code == 1 or status_code == 0 then
		ZhaoCaiModel:set_has_zc_num(num);
		local window = UIManager:find_window("zhaocai_win");
		if window ~= nil then
			window:update();
		end

	else
		print("元宝不足或招财次数不足");
	end
end