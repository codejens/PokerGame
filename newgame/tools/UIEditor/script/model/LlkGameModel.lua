-- LlkGameModel.lua
-- created by liuguowang on 2013-2-14


-- super_class.LlkGameModel()
LlkGameModel = {}

local	m_ptSta = 0;
local	m_ptEnd = 0;
local	m_ptFir = 0;
local	m_ptSec = 0;
local   m_icon_size = 48   --图片边长
local   m_left_offer = 114-m_icon_size --左方偏移
local   m_top_offer =  20-m_icon_size  --上方偏移
local	m_Xs = 13;   --X多少个
local	m_Ys = 10;   --Y多少个

function LlkGameModel:GetRandNum(Array,len)
	local a = math.random(1,len)
	local b = Array[a]
	for i = a, len-1 do
		Array[i] = Array[i + 1]
	end
	return b -- 
end

function LlkGameModel:GetCenterFromRect(rect)
	local pt = {}
	pt.x = rect.x + rect.w/2;
	pt.y = rect.y + rect.h/2;
	return pt
end

function LlkGameModel:initMapData(Map)
	for i=1,m_Xs do
		Map[i] = {}
		for j=1,m_Ys do
			Map[i][j] = {}
			Map[i][j].rect = {x =m_left_offer + (i-1)*m_icon_size , y =m_top_offer + (j-1)*m_icon_size ,w = m_icon_size , h = m_icon_size }
			-- print("Map[i][j].rect.y=",Map[i][j].rect.y)
			-- Map[i][j].exist = false
			-- Map[i][j].bmpNum = 0
			-- Map[i][j].pBtn = nil
		end
	end
end

function LlkGameModel:check_connect(Map, curbtn, oldbtn )
	--图案不相同
	-- print("curbtn.x=",curbtn.x)
	-- print("curbtn.y=",curbtn.y)
	-- print("oldbtn.x=",oldbtn.x)
	-- print("oldbtn.y=",oldbtn.y)
	-- print("Map[curbtn.x][curbtn.y].bmpNum=",Map[curbtn.x][curbtn.y].bmpNum)
	if Map[curbtn.x][curbtn.y].bmpNum ~= Map[oldbtn.x][oldbtn.y].bmpNum then
		print("return ~1")
		return false
	end
	--至少有一个已经被隐去
	if Map[curbtn.x][curbtn.y].exist == false or Map[oldbtn.x][oldbtn.y].exist == false then
		print("return ~2")
		return false;
	end
	--获取起始按钮的中心点，用于消除后画线
	m_ptSta = self:GetCenterFromRect(Map[curbtn.x][curbtn.y].rect)
	m_ptEnd = self:GetCenterFromRect(Map[oldbtn.x][oldbtn.y].rect)

	if self:IsOneLine(Map,curbtn,oldbtn) then													--单线消除
		print("line1_ok")
		return true;
	end
	if self:IsTwoLine(Map,curbtn,oldbtn) then											--双线消除
		print("line2_ok")
		return true;
	end
	if self:IsThreeLine(Map,curbtn,oldbtn) then								--三线消除
		print("line3_ok")
		return true;
	end
	return false;
end

-------------------------------------------------------------------------
--一条线直连--------------------------------------------------------------------
-------------------------------------------------------------------------
function LlkGameModel:IsOneLine(Map,curbtn,oldbtn)

	local flag = self:IsVisual(Map,curbtn,oldbtn);
	if flag then
		m_ptFir = 0;
		m_ptSec = 0;
	end
	return flag;
end

-------------------------------------------------------------------------
--两条线相连
-------------------------------------------------------------------------
function LlkGameModel:IsTwoLine(Map,curbtn, oldbtn)

	local bt1 = {}
	local bt2 = {}															--两次点击按钮的交叉点
	bt1.x = curbtn.x;
	bt1.y = oldbtn.y;
	bt2.x = oldbtn.x;
	bt2.y = curbtn.y;
	-- print(" enter IsTwoLine")
	--判断交叉点与起始两点之间是不是都无障碍
	if self:IsVisual(Map,curbtn,bt1) then												--交叉点与起点之间无障碍
		-- print("enter 1")
		if self:IsVisual(Map,bt1,oldbtn) then												--交叉点与终点之间无障碍
			-- print("enter 2")
			if false == Map[bt1.x][bt1.y].exist then									--交叉点为空
				-- print("enter 3")
				m_ptSec = 0														--先置零后获取点，若是三线调用此函数时
				m_ptFir = self:GetCenterFromRect(Map[bt1.x][bt1.y].rect)						--第二个拐点才会有值	
				print("m_ptFir.x=",m_ptFir.x)
				print("m_ptFir.y=",m_ptFir.y)
				return true;
			end
		end
	end
	if self:IsVisual(Map,curbtn,bt2) then 
		if self:IsVisual(Map,bt2,oldbtn) then 
			if false == Map[bt2.x][bt2.y].exist then	
				m_ptSec = 0
				m_ptFir = self:GetCenterFromRect(Map[bt2.x][bt2.y].rect)
				print("m_ptFir.x=",m_ptFir.x)
				print("m_ptFir.y=",m_ptFir.y)
				return	true
			end
		end
	end
	return false
end
-- -------------------------------------------------------------------------
-- --三条线相连
-- -------------------------------------------------------------------------
function LlkGameModel:IsThreeLine(Map,curbtn,oldbtn)

	local tempBtn={};
	for i = 1,m_Xs do
		tempBtn.x = i
		tempBtn.y = curbtn.y
		if i ~= curbtn.x and													--临时点不与起点重合	
		    false == Map[tempBtn.x][tempBtn.y].exist and							--临时点必须为空		
			self:IsTwoLine(Map,tempBtn,oldbtn) and									--临时点与终点可以两线相连		
			self:IsVisual(Map,tempBtn,curbtn)   then										--临时点与起点之间没有障碍
			m_ptSec = self:GetCenterFromRect(Map[tempBtn.x][tempBtn.y].rect);
			print("m_ptSec.x=",m_ptSec.x)
			print("m_ptSec.y=",m_ptSec.y)
			return true
		end
	end
	for i = 1, m_Ys do
		tempBtn.x = curbtn.x
		tempBtn.y = i
		if i ~= curbtn.y and 
			false == Map[tempBtn.x][tempBtn.y].exist and
			self:IsTwoLine(Map,tempBtn,oldbtn) and
			self:IsVisual(Map,tempBtn,curbtn)  then
		
			m_ptSec = self:GetCenterFromRect(Map[tempBtn.x][tempBtn.y].rect);
			print("m_ptSec.x=",m_ptSec.x)
			print("m_ptSec.y=",m_ptSec.y)
			return true
		end
	end
	return false
end

--判断两按钮之间是否有障碍
function LlkGameModel:IsVisual(Map,startbtn,endbtn)
	local max,min;
	if startbtn.x == endbtn.x then
		if startbtn.y > endbtn.y then
			max = startbtn.y
			min = endbtn.y
		else
			max = endbtn.y
			min = startbtn.y
		end

		if max == min + 1 then												--相邻
			return true
		end
		for i = min + 1, max-1 do
		
			if Map[startbtn.x][i].exist == true then
				-- print("startbtn.x=",startbtn.x)
				-- print("i=",i)
				-- print("max=",max)
				return false
			end
		end
		return true
	end

	if startbtn.y == endbtn.y then

		if startbtn.x > endbtn.x then
			max = startbtn.x
			min = endbtn.x
		else
			max = endbtn.x
			min = startbtn.x
		end

		if max == min + 1 then													--相邻
			return true
		end
		for i = min + 1,max-1 do
			if Map[i][startbtn.y].exist == true then
				-- print("startbtn.y=",startbtn.y)
				-- print("i=",i)
				-- print("max=",max)
				return false;
			end
		end
		return true;
	end
	return false;
end

function LlkGameModel:is_game_win(Map) --计算是否全消完
	for i=1,m_Xs do
		for j=1,m_Ys do
			if Map[i][j].exist == true then
				return false
			end
		end
	end
	return true
end


function LlkGameModel:math_line(pt1,pt2) --计算线
	local max,min,size
	max={}
	min={}
	size={}
	if pt2.x > pt1.x then
		max.x = pt2.x		
		min.x = pt1.x		
	else
		max.x = pt1.x		
		min.x = pt2.x	
	end
	if pt2.y > pt1.y then
		max.y = pt2.y		
		min.y = pt1.y		
	else
		max.y = pt1.y		
		min.y = pt2.y	
	end
	size.w = max.x-min.x
	size.h = max.y-min.y
	if size.w == 0 then
		size.w = 1
	end
	if size.h == 0 then
		size.h = 1
	end
	size.w=size.w+2
	size.h=size.h+2
	return min,size
end


function LlkGameModel:getLinePoints()
	return m_ptSta,m_ptEnd ,m_ptFir,m_ptSec
end

function LlkGameModel:getBoardSize()
	return m_Xs,m_Ys
end