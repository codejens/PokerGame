--MapStartPage.lua

MapStartPage = {}

local _layout_info = {
	{label="输入场景id",lx=100,ly=600,ex=200,ey=590,btn="修改配置",bx=400,by=570},
	{label="输入地图名字（xsc）",lx=100,ly=400,ex=200,ey=390,btn="新建配置",bx=400,by=370},
}

function MapStartPage:create(  )

	local page =  CCBasePanel:panelWithFile( 0, 0, 960, 640, "", 500, 500 )
	for i=1,2 do
		local layout = _layout_info[i]
		local label = UILabel:create_lable_2(layout.label, layout.lx, layout.ly)
		page:addChild(label)

		self.editbox_title = CCZXEditBox:editWithFile(layout.ex,layout.ey,100,35,UILH_COMMON.bg_10 , 20, 16,  EDITBOX_TYPE_NORMAL ,500,500);
		page:addChild(self.editbox_title)

		local function endit_func(  )
			
		end 
		self.editbox_title:registerScriptHandler( endit_func )
		local function enter_scene_cb( ... )
			MapModel:enter_scene(  )
		end 

		local btn = ZTextButton:create( page, layout.btn, 
		    	UILH_COMMON.btn4_nor, enter_scene_cb, layout.bx, layout.by )
	end

	return page
end