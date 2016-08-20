-- PushBoxModel.lua
-- created by liuguowang on 2013-2-14


-- super_class.PushBoxModel()
PushBoxModel = {}

local	m_ptSta = 0;
local	m_ptEnd = 0;
local	m_ptFir = 0;
local	m_ptSec = 0;
local   m_icon_size = 40   --图片边长
local   m_left_offer = 114-m_icon_size --左方偏移
local   m_top_offer =  20-m_icon_size  --上方偏移
local	m_Xs = 16;   --X多少个
local	m_Ys = 11;   --Y多少个   注： (m_Xs-2 ) * (m_Ys-2) = 偶数

local MAP_BK          =  0  --背景 
local MAP_WALL        =  1  --墙
local MAP_FLOOR       =  2  --地板 
local MAP_FLOOR_BALL  =  3  --地板 +球
local MAP_BOX         =  4  --箱子      （黄色） 
local MAP_BOX_BALL    =  5  --箱子 +球  （红色）
local MAP_ROLE_FLOOR  =  6  --人 + 地板 
local MAP_ROLE_BALL   =  7  --人 + 球 
m_Key = {LEFT=1,RIGHT=2,UP=3,DOWN=4}


function PushBoxModel:GetNextPos(key,x1,y1)
	local x2,y2,x3,y3 
	if key == m_Key.LEFT then
		x2=x1-1
		x3=x2-1
	elseif key == m_Key.RIGHT then
		x2=x1+1
		x3=x2+1
	else
		x2=x1
		x3=x2
	end

----------
	if key == m_Key.UP then
		y2=y1-1
		y3=y2-1
	elseif key == m_Key.DOWN then
		y2=y1+1
		y3=y2+1
	else
		y2=y1
		y3=y2
	end
	return x2,y2,x3,y3
end

--获取是否胜利了
function PushBoxModel:IsWinGame(Map)

	for i=1,#Map do
		for j=1,#Map[i] do
			if MAP_BOX==Map[i][j] then
				return false
			end
		end
	end
	return true
end
--获取人的位置
function PushBoxModel:GetRolePos(Map)
	local point={}
	for i=1,#Map do
	
		for j=1,#Map[i] do
		
			if MAP_ROLE_FLOOR==Map[i][j] or MAP_ROLE_BALL==Map[i][j] then
			
				point.x=j;
				point.y=i;
				print("point.x=",point.x)
				print("point.y=",point.y)
				return point.x,point.y;
			end
		end
	end
	return nil
end


function PushBoxModel:ChangeMap(Map,x1,y1,x2,y2,x3,y3)

	if Map[y2][x2] == MAP_WALL then
		return false
	end
	if Map[y2][x2] == MAP_FLOOR then
		Map[y2][x2]=MAP_ROLE_FLOOR;
		if(MAP_ROLE_FLOOR==Map[y1][x1]) then
			Map[y1][x1]=MAP_FLOOR;
		else
			Map[y1][x1]=MAP_FLOOR_BALL;
		end
		return true
	end
	if Map[y2][x2] == MAP_FLOOR_BALL then
		Map[y2][x2]=MAP_ROLE_BALL;
		if MAP_ROLE_FLOOR==Map[y1][x1] then
			Map[y1][x1]=MAP_FLOOR;
		else
			Map[y1][x1]=MAP_FLOOR_BALL;
		end
		return true
	end
	if Map[y2][x2] == MAP_BOX then
		if MAP_FLOOR==Map[y3][x3] or MAP_FLOOR_BALL==Map[y3][x3] then
		
			Map[y2][x2]=MAP_ROLE_FLOOR;	
			if MAP_FLOOR==Map[y3][x3] then
				Map[y3][x3]=MAP_BOX;
			else
				Map[y3][x3]=MAP_BOX_BALL;
			end
			if MAP_ROLE_FLOOR==Map[y1][x1] then
				Map[y1][x1]=MAP_FLOOR;
			else
				Map[y1][x1]=MAP_FLOOR_BALL;
			end
			return true
		end
	end
	if Map[y2][x2] == MAP_BOX_BALL then
		if MAP_FLOOR==Map[y3][x3] or MAP_FLOOR_BALL==Map[y3][x3] then
		
			Map[y2][x2]=MAP_ROLE_BALL;	
			if  MAP_FLOOR==Map[y3][x3] then
				Map[y3][x3]=MAP_BOX;
			else
				Map[y3][x3]=MAP_BOX_BALL;
			end
			if MAP_ROLE_FLOOR==Map[y1][x1] then
				Map[y1][x1]=MAP_FLOOR;
			else
				Map[y1][x1]=MAP_FLOOR_BALL;
			end
			return true
		end
	end
	return false
end
