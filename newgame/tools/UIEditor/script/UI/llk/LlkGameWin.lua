-- LlkGameWin.lua  
-- created by liuguowang on 2014-2-14
-- 连连看主窗口 


super_class.LlkGameWin(Window)

require "../data/llkConf"

local	m_nTotalPicNum   -- 1.pd 至 m_nTotalPicNum.pd
local	m_CurBtn = {x=-1,y=-1};
local	m_OldBtn = {x=-1,y=-1};
-- local	m_NextBtn1 = {x=-1,y=-1};
-- local	m_NextBtn2 = {x=-1,y=-1};
local   m_RemainInfo = {}
local   m_UsedInfo = {}
local   m_Map = {}
local   m_line_array = {}




function LlkGameWin:initPicData( )
	--ID与图片数组
	local Xs,Ys = LlkGameModel:getBoardSize()
	m_RemainInfo.nIDlen = (Xs - 2 ) * (Ys - 2)  --   -2：是左右上下分别预留一个空格
	m_RemainInfo.nUsedId = {}
	for i=1,m_RemainInfo.nIDlen do
		m_RemainInfo.nUsedId[i] = i
	end
	m_RemainInfo.nBmplen = m_RemainInfo.nIDlen/2 -- 48 对
	m_RemainInfo.nUsedBmp = {}
	for i=1,m_RemainInfo.nBmplen do
		m_RemainInfo.nUsedBmp[i] = math.random(1,m_nTotalPicNum) 
		-- print("i=",i)
		-- print("m_RemainInfo.nUsedBmp[i]=",m_RemainInfo.nUsedBmp[i])
	end
end



function LlkGameWin:restorePoint( )
	m_OldBtn.x = -1;
	m_OldBtn.y = -1;
	m_CurBtn.x = -1;
	m_CurBtn.y = -1;
end

function LlkGameWin:Range()
	--初始起始与终点
	print("Range")
	local icon_path 
	self:restorePoint()
	local Xs,Ys = LlkGameModel:getBoardSize()
	-- 清空以前除位置以外的所有信息
	for  i = 1, Xs  do
		for j = 1, Ys  do
			-- if m_Map[i][j].pBtn then
			-- 	m_Map[x1][y1].pBtn.view:destroy()
			-- end
			-- m_Map[i][j].pBtn = nil;
			m_Map[i][j].exist = false;
			m_Map[i][j].bmpNum = 0;
			if m_Map[i][j].pBtn ~= nil then
				m_Map[i][j].pBtn.view:setIsVisible(true)
			end
		end
	end

	m_UsedInfo.nUsedId = {}
	m_UsedInfo.nUsedBmp = {}
	local len = m_RemainInfo.nBmplen;
	for  i = 1, len  do
		--获取随机ID与图片
		local nID = LlkGameModel:GetRandNum(m_RemainInfo.nUsedId,m_RemainInfo.nIDlen) -1; -- 0 - 95     
		m_RemainInfo.nIDlen = m_RemainInfo.nIDlen -1
		local nBmp = LlkGameModel:GetRandNum(m_RemainInfo.nUsedBmp,m_RemainInfo.nBmplen);--1 - 48
		m_RemainInfo.nBmplen = m_RemainInfo.nBmplen -1
		-- print("nBmp  ==== ",nBmp)
		--UsedInfo要将已经用过的ID与图片信息保留
		m_UsedInfo.nUsedId[i*2-1] = nID;
		m_UsedInfo.nIDlen = i*2 ;
		m_UsedInfo.nUsedBmp[i] = nBmp;
		m_UsedInfo.nBmplen = i;
		-- print("nID1=",nID)

		--计算出的ID与坐标的转换公式
		local x1 = nID% (Xs-2) + 1 + 1;												
		local y1 = math.floor( nID/(Xs-2)) + 1 + 1;  -- (Xs-2)看到的长度左右是各多留1格空白的   ，第一个 +1 是lua的下标为1开始， 第二个+1 是四周预留一个空格

		function btn_event_1()
			-- print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~click x1= ",x1)
			-- print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~click y1= ",y1)
			self:ButtonClick(x1,y1)
		end
		icon_path = _pet_llk_path_root .. _pet_llk_path_name[nBmp] 
		--加载图片显示按钮
		local rect =  m_Map[x1][y1].rect 
		if m_Map[x1][y1].pBtn == nil then
			-- print("first time enter")
			m_Map[x1][y1].pBtn = ZButton:create( self.view, icon_path, btn_event_1, rect.x,rect.y,rect.w,rect.h)
		else
			-- print("second time enter")
			m_Map[x1][y1].pBtn.view:setPosition(rect.x,rect.y)
			m_Map[x1][y1].pBtn:setImage(icon_path)
		end
		m_Map[x1][y1].exist = true;
		m_Map[x1][y1].bmpNum = nBmp;
		m_Map[x1][y1].nID = nID;

		--第二个按钮，与第一个图案相同
		nID = LlkGameModel:GetRandNum(m_RemainInfo.nUsedId,m_RemainInfo.nIDlen)-1
		-- print("nID2=",nID)
		m_RemainInfo.nIDlen = m_RemainInfo.nIDlen - 1
		m_UsedInfo.nUsedId[i*2] = nID;
		m_UsedInfo.nIDlen = i*2 + 1;

		--ID与坐标的转换
		local x2 = nID%(Xs-2) + 1 + 1;
		local y2 = math.floor(nID/(Xs-2)) + 1 + 1;

		function btn_event_2()
			-- print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~click2 x2= ",x2)
			-- print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~click2 y2= ",y2)
			self:ButtonClick(x2,y2)
		end
	    rect =  m_Map[x2][y2].rect 

	    if m_Map[x2][y2].pBtn == nil then
			m_Map[x2][y2].pBtn = ZButton:create( self.view, icon_path, btn_event_2, rect.x,rect.y,rect.w,rect.h)
		else
			m_Map[x2][y2].pBtn.view:setPosition(rect.x,rect.y)
			m_Map[x2][y2].pBtn:setImage(icon_path)
		end
		m_Map[x2][y2].exist = true;
		m_Map[x2][y2].bmpNum = nBmp;
		m_Map[x2][y2].nID = nID;
	end
	-- --如果无路可走，重新布阵
	-- if(IsNoWay()){
	-- 	ReRange();
	-- }
end

function dismiss( dt )
	local win = UIManager:find_window("llk_game_win");
	win:RemoveAllLine()
	win:setTime(false)  --消灭计时器
end

function LlkGameWin:setTime(bStart,time)
	if self._timer == nil then
		return
	end
	if bStart == true then
		self._timer:start(time,dismiss)
	else
		self._timer:stop()
	end

	if bStart == false then  --再判断下，是不是全消完了
		if LlkGameModel:is_game_win(m_Map) then        --是否消完
			reset_function()						   --重置
		end
	end
end



function reset_function( )  --游戏重新开始
	local win = UIManager:find_window("llk_game_win");
	win:initPicData()
	win:Range()
end

function refresh_function( )  --刷新排列顺序
	local win = UIManager:find_window("llk_game_win");
	win:initPicData()
	win:Range()
end

function LlkGameWin:__init( window_name, texture_name )
	m_nTotalPicNum = #_pet_llk_path_name 
	self:initPicData()
	LlkGameModel:initMapData(m_Map)
	self:Range()


	-- ZButton:create(self.view,UIResourcePath.FileLocate.common .. "button_red.png",reset_function,20,330,105,-1)--重新开始游戏
	ZTextButton:create(self.view,"重新开始",UIResourcePath.FileLocate.common .. "button_red.png",refresh_function,6,290,105,-1)--刷新

	self._timer = timer();

   
end

function LlkGameWin:ButtonClick(x,y)


	m_OldBtn.x = m_CurBtn.x;
	m_OldBtn.y = m_CurBtn.y;
	m_CurBtn.x = x
	m_CurBtn.y = y

	if m_OldBtn.x == -1 or m_OldBtn.y == -1  then
		print("return 1")
		return 0
	end
	--第二次点击而且点击不同的按钮时才开始执行
	if m_CurBtn.x == m_OldBtn.x and m_CurBtn.y == m_OldBtn.y then
		print("return 2")
		return 0
	end
	if LlkGameModel:check_connect(m_Map,m_CurBtn,m_OldBtn) then
		print("OK")
		local ptSta,ptEnd,ptFir,ptSec = LlkGameModel:getLinePoints() --取得转角点
		self:DrawLine(ptSta,ptEnd,ptFir,ptSec) -- 画线
		self:HideBtn()                                 -- 隐藏按钮
		self:restorePoint()                            --恢复坐标数据
		self:setTime(true,0.3)                         --设置开始计时

		-- self:RemoveAllLine()
	end
end

function LlkGameWin:RemoveAllLine()

	for i=1,3 do
		if m_line_array[i] ~= nil then
			self.view:removeChild(m_line_array[i].view,true)
			m_line_array[i] = nil
		end
	end
end

function LlkGameWin:DrawLine(ptSta,ptEnd,ptFir,ptSec)
		-- print("ptFir.x=",ptFir.x)
		-- print("ptFir.y=",ptFir.y)
		-- print("ptSec.x=",ptSec.x)
		-- print("ptSec.y=",ptSec.y)
	local min,size 
	if ptFir == 0 and ptSec == 0 then-- 画单线
		print("画单线")
		min,size = LlkGameModel:math_line(ptSta,ptEnd)
		m_line_array[1] = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "red_line.png",min.x,min.y,size.w,size.h,500,500)
	elseif ptFir ~= 0 and ptSec == 0 then-- 画2线
		print("画2线")
		min,size = LlkGameModel:math_line(ptSta,ptFir)
		m_line_array[1] = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "red_line.png",min.x,min.y,size.w,size.h,500,500)
		min,size = LlkGameModel:math_line(ptFir,ptEnd)
		m_line_array[2] = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "red_line.png",min.x,min.y,size.w,size.h,500,500)
	elseif ptFir ~= 0 and ptSec ~= 0 then-- 画3线
		print("画3线")
		min,size = LlkGameModel:math_line(ptSta,ptSec)--curpoint is prstart
		m_line_array[1] = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "red_line.png",min.x,min.y,size.w,size.h,500,500)
		min,size = LlkGameModel:math_line(ptSec,ptFir)
		m_line_array[2] = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "red_line.png",min.x,min.y,size.w,size.h,500,500)
		min,size = LlkGameModel:math_line(ptFir,ptEnd)
		m_line_array[3] = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "red_line.png",min.x,min.y,size.w,size.h,500,500)
	end
	-- CCDrawLine(CCPoint(0,0),CCPoint(100,100))
end

function LlkGameWin:HideBtn( )
		-- print("m_CurBtn.x=",m_CurBtn.x)
		-- print("m_CurBtn.y=",m_CurBtn.y)
		-- print("m_OldBtn.x=",m_OldBtn.x)
		-- print("m_OldBtn.y=",m_OldBtn.y)
	m_Map[m_CurBtn.x][m_CurBtn.y].pBtn.view:setIsVisible( false )
	m_Map[m_OldBtn.x][m_OldBtn.y].pBtn.view:setIsVisible( false )
	m_Map[m_CurBtn.x][m_CurBtn.y].exist = false;
	m_Map[m_OldBtn.x][m_OldBtn.y].exist = false;

	--从结构体中除去已经隐藏的ID与图片
	print(" m_UsedInfo.nBmplen=", m_UsedInfo.nBmplen)
	local len = m_UsedInfo.nBmplen;
	for  i = 1,len do
		if m_UsedInfo.nUsedBmp[i] == m_Map[m_CurBtn.x][m_CurBtn.y].bmpNum then
			for  j = i, len - 1 do
				m_UsedInfo.nUsedBmp[j] = m_UsedInfo.nUsedBmp[j + 1];
			end
			m_UsedInfo.nBmplen =m_UsedInfo.nBmplen-1;
		end
	end

end


-- 更新
function LlkGameWin:update( update_type )

end


-- 设置难度
function LlkGameWin:setHard( totalPic )
	m_nTotalPicNum = totalPic
end


-- 激活
function LlkGameWin:active( active )
	if active then 
		self:setTime(true,0.3)
	else
		self:setTime(false)

	end
end

-- 销毁
function LlkGameWin:destroy(  )
    Window.destroy(self)
end

