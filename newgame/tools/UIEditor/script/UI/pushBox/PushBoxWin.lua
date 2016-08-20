-- PushBoxWin.lua  
-- created by liuguowang on 2014-2-20
-- 推箱子主窗口 


super_class.PushBoxWin(Window)

local m_Map = {}
local m_Size = 30 --边长
local m_Image = {}
local cur_level = 1
local max_level 


function PushBoxWin:LoadMap(lv)
	cur_level = lv

	if self.m_lv_label then
		self.m_lv_label:setText("第" .. lv  .. "关")
	end

	m_Map = {}
	local tempMap = m_push_box_map[lv]
	for i=1,#tempMap do
		-- print("i=",i)
		if m_Map[i] == nil then
			m_Map[i] = {}
		end
		for j=1,#tempMap[i] do
			m_Map[i][j] = tempMap[i][j]
		end
	end
end

function PushBoxWin:RemoveImg()
	for i=1,#m_Map do
		if m_Image[i] == nil then
			m_Image[i]={}
		end
		for j=1,#m_Map[i] do
			if m_Image[i][j] ~= nil then
				print("m_Image[i][j] i= ",i)
				print("m_Image[i][j] j= ",j)
				self.view:removeChild(m_Image[i][j].view,true)			
			end
		end
	end
end


function PushBoxWin:DrawMap()
	local big_win_info = UIManager:get_big_win_create_info()
	local offerX = big_win_info.width/2 - #m_Map[1]*m_Size/2
	local offerY = (big_win_info.height-33)/2 - #m_Map*m_Size/2 -- -33标题高度
	local x ,y

	self:RemoveImg()

	for i=1,#m_Map do

		for j=1,#m_Map[i] do
			x = m_Size * (j -1 )             + offerX
			y = #m_Map * m_Size - i * m_Size + offerY
			if m_Map[i][j] ~= 0 then
				m_Image[i][j] = ZImage:create(self.view, UIResourcePath.FileLocate.PushBox .. m_Map[i][j] .. ".bmp", x, y, m_Size, m_Size)
			end
		end
	end
end



function PushBoxWin:Click_Way_Btn(key)
	if PushBoxModel:IsWinGame(m_Map) == true then 
		return
	end

	function next_level_fun( )
		if cur_level < max_level then
			cur_level = cur_level +1
		else
			cur_level = 1
		end
		self:RemoveImg()
		self:LoadMap(cur_level)
		self:DrawMap()
		self._timer:stop()
	end
	x1,y1 = PushBoxModel:GetRolePos(m_Map)
	local x2,y2,x3,y3 = PushBoxModel:GetNextPos(key,x1,y1)
	if PushBoxModel:ChangeMap(m_Map,x1,y1,x2,y2,x3,y3) == true then	
		self:DrawMap()
	end
	if PushBoxModel:IsWinGame(m_Map) then
		self._timer:start(1,next_level_fun) --过一秒后 进入下一关
	end
end

function PushBoxWin:CreateBtn()
	self.btn_panel = ZBasePanel:create( self.view, nil, 620, 5, 150, 300, 600, 600 )
	-- if x1 == nil or y1 == nil then
	-- 	return
	-- end
	-------------------------------------------------------------------------------------------------------
	local function Left_Btn( )
		self:Click_Way_Btn(m_Key.LEFT)
	end
	ZButton:create(self.btn_panel,UIResourcePath.FileLocate.common .. "button2_bg.png",Left_Btn,0,50,50,50,nil,500,500)
	-------------------------------------------------------------------------------------------------------
	local function Right_Btn( )
		self:Click_Way_Btn(m_Key.RIGHT)
	end
	ZButton:create(self.btn_panel,UIResourcePath.FileLocate.common .. "button2_bg.png",Right_Btn,100,50,50,50,nil,500,500)
	-------------------------------------------------------------------------------------------------------
	local function Up_Btn( )
		self:Click_Way_Btn(m_Key.UP)

	end
	ZButton:create(self.btn_panel,UIResourcePath.FileLocate.common .. "button2_bg.png",Up_Btn,50,100,50,50,nil,500,500)
	-------------------------------------------------------------------------------------------------------
	local function Down_Btn( )
		self:Click_Way_Btn(m_Key.DOWN)

	end
	ZButton:create(self.btn_panel,UIResourcePath.FileLocate.common .. "button2_bg.png",Down_Btn,50,0,50,50,nil,500,500)



	self.m_lv_label = ZLabel:create(self.btn_panel,nil,25,160+160,22)

	-------------------------------------------------------------------------------------------------------
	local function pre_Btn( ) --上一关
		if cur_level > 1 then
			cur_level = cur_level -1
		else
			cur_level = max_level
		end
		self:RemoveImg()
		self:LoadMap(cur_level)
		self:DrawMap()
	end
	ZTextButton:create(self.btn_panel,"上一关",UIResourcePath.FileLocate.common .. "button2_bg.png",pre_Btn,25,160+100,100,50,nil,500,500)
	
	local function next_Btn( ) --下一关
		if cur_level < max_level then
			cur_level = cur_level +1
		else
			cur_level = 1
		end
		self:RemoveImg()
		self:LoadMap(cur_level)
		self:DrawMap()

	end
	ZTextButton:create(self.btn_panel,"下一关",UIResourcePath.FileLocate.common .. "button2_bg.png",next_Btn,25,160+50,100,50,nil,500,500)
	
	local function Replay_Btn( ) -- 重新开始
		self:RemoveImg()
		self:LoadMap(cur_level)
		self:DrawMap()
	end
	ZTextButton:create(self.btn_panel,"重新开始",UIResourcePath.FileLocate.common .. "button2_bg.png",Replay_Btn,25,160,100,50,nil,500,500)
end

function PushBoxWin:__init( window_name, texture_name )
	max_level = #m_push_box_map
	self:LoadMap(1)
	self:DrawMap()
	self:CreateBtn()
   	self._timer = timer();

end



-- 激活
function PushBoxWin:active( active )
	if active then 
		self:LoadMap(1)
	end
end

-- 销毁
function PushBoxWin:destroy(  )
    Window.destroy(self)
end

