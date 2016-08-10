-----------------------------------------------------------------------------
-- 滚动控件
-- @author zengsi
-- @release 1
-----------------------------------------------------------------------------

GUITableViewCell = simple_class(GUITouchBase)

function GUITableViewCell:__init( view )
	self.class_name = "GUITableViewCell"
end

function GUITableViewCell:create()
	return self(cc.TableViewCell:new())
end

function GUITableViewCell:getChildByTag(tag)
	if self.core then
		return self.core:getChildByTag(tag)
	end
end