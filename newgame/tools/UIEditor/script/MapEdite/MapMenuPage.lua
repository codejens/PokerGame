--MapMenuPage.lua

MapMenuPage  ={}

local name = {
	"取消","刷怪","NPC","传送","保存坐标"
}

function MapMenuPage:create(  )
	
	local page =  CCBasePanel:panelWithFile( 0, 0, 960, 640, "", 500, 500 )
	for i=1,#name do
		local function btn_func( ... )
			MapModel:menu_event(i-1)
		end 
		local btn = ZTextButton:create( page, name[i], 
		    	UILH_COMMON.btn4_nor, btn_func, 100+120*i, 600 )
	end

	return page
end