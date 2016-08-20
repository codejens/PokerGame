require 'os'
require 'ex'
function del_allfile(_path)
	_path = string.gsub(_path,'/','\\')
	os.execute('del /s /q ' .. _path)
end

del_allfile('./../resource/frame')
del_allfile('./../resource/scene')
del_allfile('./../resource/chat_face')
del_allfile('./../resource/ui')
del_allfile('./../resource/ui2')

proclist = {}
proclist[#proclist+1] = os.spawn('lua',{'pack_frame_effect.lua'})
proclist[#proclist+1] = os.spawn('lua',{'pack_frame_gem.lua'})
proclist[#proclist+1] = os.spawn('lua',{'pack_frame_human.lua'})
proclist[#proclist+1] = os.spawn('lua',{'pack_frame_mount.lua'})
proclist[#proclist+1] = os.spawn('lua',{'pack_frame_pet.lua'})
proclist[#proclist+1] = os.spawn('lua',{'pack_frame_common.lua'})
proclist[#proclist+1] = os.spawn('lua',{'pack_scene.lua'})
proclist[#proclist+1] = os.spawn('lua',{'pack_ui.lua'})

for i,v in ipairs(proclist) do
	v:wait()
end