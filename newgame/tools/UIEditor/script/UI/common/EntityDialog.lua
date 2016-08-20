-- EntityDialog.lua
-- created by hcl on 2013/3/13
-- 玩家或者宠物说话的对话框

super_class.EntityDialog()

require "utils/MUtils"

function EntityDialog:__init(parent,str )	
	self:init_with_str( parent,str );
end

function EntityDialog:init_with_str( parent, str , delTime)

	local delTime = delTime or t_entdialog_
	local dialog_node = parent:getChildByTag( UI_TAG_ENTITY_DIALOG );

	if ( dialog_node ) then
		dialog_node:removeAllChildrenWithCleanup(true);
	else
		dialog_node = CCNode:node();
		parent:addChild( dialog_node,10,UI_TAG_ENTITY_DIALOG );
	end
	--记得retain，要不然NPC被销毁了，调用dismiss就会崩溃
	
	--require "model/ChatModel/ChatModel"
	str = ChatModel:AnalyzeInfo(str)
	self.dialog_content = MUtils:create_ccdialogEx( dialog_node,str,10,35,320,0,15,18,2,ADD_LIST_DIR_DOWN);
	local size = self.dialog_content:getInfoSize();
	--print("str = ",str,"size.width = ",size.width,"size.height",size.height);
	local half_width = (size.width + 20) / 2;
	self.dialog_content:setPosition(10 -half_width,35);
	

	self.dialog_top = MUtils:create_zximg( dialog_node,UILH_COMMON.bg_07,0-half_width,25,size.width+20,size.height+14,500,500);
	
	local curr_width = (size.width+20 - 18 - 14) /2; 
	-- self.dialog_bottom1 = MUtils:create_zximg( dialog_node,UIResourcePath.FileLocate.common .. "dialog_bottom.png",7-half_width,24,curr_width,6,1,6);
	-- self.dialog_bottom2 = MUtils:create_sprite( dialog_node,UIResourcePath.FileLocate.common .. "dialog_bottom2.png",(size.width+20)/2-half_width,24);
	-- self.dialog_bottom3 = MUtils:create_zximg( dialog_node,UIResourcePath.FileLocate.common .. "dialog_bottom.png",curr_width+7+18-half_width,24,curr_width,6,1,6);

	dialog_node:runAction(effectCreator.createDelayRemove(delTime))

	self.view = dialog_node
end