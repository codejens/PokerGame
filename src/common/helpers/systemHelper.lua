systemHelper = {}
local sys_helpers = helpers.SystemHelpers
local script_cb_helpers = helpers.ScriptCallbackHelpers
function systemHelper.init()

end

function systemHelper.listenAppEvents(func)
	script_cb_helpers:listenAppEvents(func)
end

function systemHelper.messageBox(title, msg)
	sys_helpers:messageBox(title,msg)
end

function systemHelper.fromClipboard()
	return sys_helpers:fromClipboard()
end

function systemHelper.pathDialog(title,default)
	return sys_helpers:pathDialog(title,default)
end