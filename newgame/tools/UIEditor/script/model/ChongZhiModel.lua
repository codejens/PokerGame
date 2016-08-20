-----------------------------------------------
-----------------------------------------------
---------HJH
---------2013-5-29
---------充值
ChongZhiModel = {}
-----------------------------------------------
----state,id,time,money,way
local chong_zhi_ji_lu_info = {}
local chong_zhi_ji_lu_max_num = 30
local chong_zhi_scroll_page = {nil, nil, nil, nil, nil}
-----------------------------------------------
function ChongZhiModel:destroy_scroll_page_info()
	for i = 1, #chong_zhi_scroll_page do
		if chong_zhi_scroll_page[i] ~= nil then
			chong_zhi_scroll_page[i]:destroy()
		end
	end
end
-----------------------------------------------
function ChongZhiModel:fini( ... )
	chong_zhi_ji_lu_info = {}
	chong_zhi_scroll_page = {}
	local chong_zhi_win = UIManager:find_window("chong_zhi_win")
	if chong_zhi_win ~= nil then
		chong_zhi_win:clear_insert_info()
	end
end
-----------------------------------------------
function ChongZhiModel:data_add_chong_zhi_ji_lu_info(info)
	if #chong_zhi_ji_lu_info > chong_zhi_ji_lu_max_num then
		table.remove( chong_zhi_ji_lu_info )
	end
	table.insert( chong_zhi_ji_lu_info, info )
end
-----------------------------------------------
function ChongZhiModel:data_find_chong_zhi_ji_lu_info(id)

end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function ChongZhiModel:open_chong_zhi_win()
	local chong_zhi_win = UIManager:show_window("chong_zhi_win")
	chong_zhi_win:refresh_cur_page()
end
-----------------------------------------------
function ChongZhiModel:exit_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win ~= nil then
		chong_zhi_win:clear_insert_info()
	end
	UIManager:hide_window("chong_zhi_win")
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---充值记录按钮函数
function ChongZhiModel:chong_zhi_ji_lu_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	chong_zhi_win:set_index_scroll_show(1)
end
-----------------------------------------------
---充值记录滑动条创建函数 
function ChongZhiModel:chong_zhi_ji_lu_scroll_function(index)
	
end
-----------------------------------------------
---充值记录滑动条创建函数
function ChongZhiModel:chong_zhi_ji_lu_page_function()
	-- local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	-- if chong_zhi_win == nil then
	-- 	return
	-- end
	-- local scroll_info = chong_zhi_win:get_scroll_info()
	local scroll = Scroll:create( nil, 0, 50, 520, 320, 0, TYPE_HORIZONTAL )
	scroll:setScrollCreatFunction( ChongZhiModel.chong_zhi_ji_lu_scroll_function )
	--scroll:refresh()
	return scroll
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

---支付宝页面充值按钮函数
function ChongZhiModel:zhi_fu_bao_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local select_index = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.zhi_fu_bao[select_index]

	-- 以下是支付宝订单内容
	Alipay:pay(money)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-----------------------------------------------
---移动页面充值按钮函数
-- function ChongZhiModel:yi_dong_page_button_function()
-- 	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
-- 	if chong_zhi_win == nil then
-- 		return
-- 	end
-- 	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
-- 	-- print("self.page_index",self.page_index)
-- 	local info = chong_zhi_win:get_index_page_info(self.page_index)
-- 	local money = chong_zhi_info.yi_dong[info[1]]
-- 	local carid = info[2]
-- 	local psw = info[3]
-- 	-- print( string.format("ChongZhiModel:yi_dong_page_button_function money=%d, carid=%s,psw=%s",money, carid, psw) )
-- 	if carid == "" or psw == "" then
-- 		GlobalFunc:create_screen_notic("请输入卡号和密码")
-- 	else
-- 		Cardpay:pay(CARD_SZX, money, carid, psw)
-- 	end
-- end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---联通页面充值按钮函数
function ChongZhiModel:lian_ton_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	-- print("self.page_index",self.page_index)
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.lian_ton[info[1]]
	local carid = info[2]
	local psw = info[3]
	-- print( string.format("ChongZhiModel:lian_ton_page_button_function money=%d, carid=%s,psw=%s",money, carid, psw) )
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_UNICOM, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---电信页面充值按钮函数
function ChongZhiModel:dian_xin_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.dian_xin[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_TELECOM, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---骏网一卡页面充值按钮函数
function ChongZhiModel:jun_wang_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.jun_wan[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_JUNNET, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---盛大卡页面充值按钮函数
function ChongZhiModel:sn_da_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.sn_da[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_SNDACARD, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---神州行页面充值按钮函数
function ChongZhiModel:szx_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.szx[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_SZX, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---征途卡页面充值按钮函数
function ChongZhiModel:zheng_tu_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.zheng_tu[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_ZHENGTU, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---Q币卡页面充值按钮函数
function ChongZhiModel:qq_car_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.qq_car[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_QQCARD, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---久游卡页面充值按钮函数
function ChongZhiModel:jiu_you_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.jiu_you[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_JIUYOU, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---易宝e卡通页面充值按钮函数
function ChongZhiModel:yp_card_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.yp_card[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_YPCARD, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---网易卡通页面充值按钮函数
function ChongZhiModel:net_ease_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.net_ease[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_NETEASE, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---完美卡通页面充值按钮函数
function ChongZhiModel:wan_mei_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.wan_mei[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_WANMEI, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---搜狐卡通页面充值按钮函数
function ChongZhiModel:sohu_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.sohu[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_SOHU, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---纵游一卡通通页面充值按钮函数
function ChongZhiModel:zong_you_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.zong_you[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_ZONGYOU, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---天下一卡通通通页面充值按钮函数
function ChongZhiModel:tian_xia_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.tian_xia[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_TIANXIA, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-----------------------------------------------
---天宏一卡通通通页面充值按钮函数
function ChongZhiModel:tian_hong_page_button_function()
	local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	if chong_zhi_win == nil then
		return
	end
	
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local info = chong_zhi_win:get_index_page_info(self.page_index)
	local money = chong_zhi_info.tian_hong[info[1]]
	local carid = info[2]
	local psw = info[3]
	
	if carid == "" or psw == "" then
		GlobalFunc:create_screen_notic(LangModelString[61]) -- [61]="请输入卡号和密码"
	else
		Cardpay:pay(Cardpay.CARD_TIANHONG, money, carid, psw)
	end
	chong_zhi_win:clear_index_page_info(self.page_index)
end
