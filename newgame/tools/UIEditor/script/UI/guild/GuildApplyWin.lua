-- 申请窗口
super_class.GuildApplyWin(Window)

function GuildApplyWin:__init( window_name, texture_name )
     --背景框
    local bgPanel = self.view
    self.applist =  ApplyList:create()
    self.view:addChild( self.applist.view )
end

function GuildApplyWin:create( texture_name )
	return GuildApplyWin("GuildApplyWin", texture_name, false, 860, 440+60 )
end

-- 提供外部调用更新的静态方法
function GuildApplyWin:update_win( update_type )
    local win = UIManager:find_visible_window( "guild_apply_win" )
    if win ~= nil then
        win:update( update_type )
    end
end

function GuildApplyWin:update( update_type )
    -- print("======GuildApplyWin:update( update_type ): ", update_type)
    self.applist:update( update_type )
end

function GuildApplyWin:destroy()
    -- 汉德这大坑，没释放内存
    if self.applist and self.applist.destroy then
        self.applist:destroy()
    end
    Window.destroy(self)
end