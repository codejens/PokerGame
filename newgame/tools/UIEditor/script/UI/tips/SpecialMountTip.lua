--SpecialMountTip
--特殊坐骑的tip（不是item的tip）


super_class.SpecialMountTip(Window)



function SpecialMountTip:__init(  )
	self.dialog = ZDialog:create(self.view, self.data.str, 10, 18, 180, 140, 16)
	-- self.dialog.view:setLineEmptySpace (15)
end

function SpecialMountTip:create( data )
	self.data = data;

	local t_width = 200
	if data.width then
		t_width = data.width
	end
	local t_height = 235
	if data.height then
		t_height = data.height
	end
	print(t_width,t_width)
	return SpecialMountTip("special_mount_tip","",true,t_width,t_height);
end
