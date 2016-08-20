require"iuplua"
require 'io'
require 'strbuf'
require 'list'
require 'ZXBinaryLua'

local inputfile = arg[1]

ZXBinary = ZXBinaryLua
ZXImageSet = ZXBinary.ZXImageSet
ZXImageUnit = ZXBinary.ZXImageUnit

local lom = require "lxp.lom"

local frametable = {}

function getLastPath(path)
	local i = string.find(path,'[/\\]')
	if i == nil then
		return path
	elseif  i == string.len(path) then
		return string.sub(path,0,string.len(path)-1)
	end
	local subpath = string.sub(path,i+1,string.len(path))
	return getLastPath(subpath)
end

function convert(src,dst)
	frametable = {}
	f = io.open(src,'r')
	s = f:read('*all')
	local t = lom.parse(s)
	for k,v in ipairs(t) do
		--dict
		if v.tag == 'dict' then
			parseframe(v)
		end
	end
	--print(frametable)

	src = string.gsub(src,'[/\\]','/')

	local i = string.find(src,'resource/')
	local j = string.find(src,'.plist')



	local out = string.sub(src,1,j-1) .. '.imageset'
	local tp =  string.sub(src,i+string.len('resource/'),j-1)
	local tn = tp .. '.png'

	local fp = string.sub(src,i+string.len('resource/'),string.len(src))
	local lp = string.find(fp,getLastPath(src))

	local devPath = string.sub(src,1,i-1)


	local texFile = io.open(devPath .. '/script/texOffset.lua', 'r+')
	local offsetTable = {}
	texString = texFile:read('*all')
	if texString ~= '' then
		assert(loadstring(texString))()
		offsetTable = texOffset
	else
		offsetTable = {}
	end
	texFile:close()

	texFile = io.open(devPath .. '/resource/data/texOffset.lua', 'w+')

	lp = string.sub(fp,1,lp-1)

	local is = ZXImageSet()
	local count = 0
	for k, v in pairs(frametable) do
		--print(k)
		count = count + 1
	end

	is:Initialize(tn,count)

	count = 0;
	for k, v in pairs(frametable) do

		local iu = ZXImageUnit()
		local x,y,w,h = string.match(v['frame'],'{(%d+),(%d+)},{(%d+),(%d+)}')
		local offsetX,offsetY = string.match(v['offset'],'{(.+),(.+)}')
		--print(v['offset'], offsetX,offsetY)
		local iuname = lp .. k
		iu:Set( x,y,w,h,lp .. k)

		is:Set(iu,count)
		count = count + 1

		offsetTable[iuname] = {offsetX,offsetY}
	end
	--print(out)
	is:Save(out)

	local s = 'texOffset = {\n'
	for k,v in pairs(offsetTable) do
		s = s .. '[\"' .. k .. '\"] = {' .. v[1] .. ',' .. v[2] .. '},\n'
	end
	s = s .. '}\n'
	texFile:write(s)
	texFile:close()

end

function parseframe(root)
	local framefound = false
	for k,v in ipairs(root) do
		if v.tag == 'key' and v[1] == 'frames' then
			framefound = true
		end
		if framefound then
			if v.tag == 'dict' then
				readframe(v)
				framefound = false
			end
		end
	end
end

function readframe(root)
	local file = nil
	for i,v in ipairs(root) do

		if v.tag == 'key' then
			file = v[1]
			frametable[file] = {}

		elseif v.tag == 'dict' then
			filltable(v,frametable[file])
			file = nil
		end
	end
end


function filltable(root,t)
	local key = nil
	for k,v in ipairs(root) do
		if v.tag == 'key' then
			key = v[1]

		elseif v.tag == 'true' then
			t[key] = 1
			key = nil

		elseif v.tag == 'false' then
			t[key] = 0
			key = nil

		elseif v.tag ~= nil and v.tag ~= '' then
			t[key] = v[1]
			key = nil
		end
	end
end

local inputfile = arg[1]




notepad = {}

-- Notepad Dialog

notepad.lastfilename = nil -- Last file open
notepad.mlCode = iup.multiline{expand="YES", size="400x300", font="Courier, 10"}
notepad.lblPosition = iup.label{title="Lin 0, Col 0", size="50x"}
notepad.lblFileName = iup.label{title="", size="50x", expand="HORIZONTAL"}

function notepad.mlCode:caret_cb(lin, col)
  notepad.lblPosition.title = "Lin ".. lin .. ", Col " .. col
end

function notepad.New()
  notepad.mlCode.value=''
  notepad.lblFileName.title = ''
  notepad.lastfilename = nil
end

notepad.butExecute = iup.button{size="50x15", title="Execute",
                                    action="iup.dostring(notepad.mlCode.value)"}
notepad.butNewCommands = iup.button{size="50x15", title="New", action=notepad.New}
notepad.butLoadFile = iup.button{size="50x15", title="Load..."}
notepad.butSaveasFile = iup.button{size="50x15", title="Save As..."}
notepad.butSaveFile = iup.button{size="50x15", title="Save"}

function notepad.butSaveFile:action()
  if (notepad.lastfilename == nil) then
    notepad.butSaveasFile:action()
  else
    newfile = io.open(notepad.lastfilename, "w+")
    if (newfile) then
      newfile:write(notepad.mlCode.value)
      newfile:close()
    else
      error ("Cannot Save file: "..filename)
    end
  end
end

function notepad.butSaveasFile:action()
  local fd = iup.filedlg{dialogtype="SAVE", title="Save File",
                         nochangedir="NO", directory=notepad.last_directory,
                         filter="*.*", filterinfo="All files",allownew=yes}

  fd:popup(iup.LEFT, iup.LEFT)

  local status = fd.status
  notepad.lastfilename = fd.value
  notepad.lblFileName.title = fd.value
  notepad.last_directory = fd.directory
  fd:destroy()

  if status ~= "-1" then
    if (notepad.lastfilename == nil) then
      error ("Cannot Save file "..filename)
    end
    local newfile=io.open(notepad.lastfilename, "w+")
    if (newfile) then
      newfile:write(notepad.mlCode.value)
      newfile:close(newfile)
    else
      error ("Cannot Save file")
    end
   end
end

function notepad.LoadFile(filename)
  local s = string.find(filename,'.plist$')

  if s then

	  convert(filename)
	  notepad.mlCode.value= notepad.mlCode.value .. 'convert ' .. filename .. '\n'
	  notepad.lastfilename = filename
	  notepad.lblFileName.title = notepad.lastfilename
  end
  --[[

  ]]--
  --[[
  local newfile = io.open (filename, "r")
  if (newfile == nil) then
    error ("Cannot load file "..filename)
  else
    notepad.mlCode.value=newfile:read("*a")
    newfile:close (newfile)
    notepad.lastfilename = filename
    notepad.lblFileName.title = notepad.lastfilename
  end
  ]]
end

function notepad.butLoadFile:action()
  local fd=iup.filedlg{dialogtype="OPEN", title="Load File",
                       nochangedir="NO", directory=notepad.last_directory,
                       filter="*.imageset;*.frame", filterinfo="All Files", allownew="NO"}
  fd:popup(iup.CENTER, iup.CENTER)
  local status = fd.status
  local filename = fd.value
  notepad.last_directory = fd.directory
  fd:destroy()

  if (status == "-1") or (status == "1") then
    if (status == "1") then
      error ("Cannot load file "..filename)
    end
  else
    notepad.LoadFile(filename)
  end
end

notepad.vbxNotepad = iup.vbox
{
  iup.frame{iup.hbox{iup.vbox{notepad.butLoadFile,
                             -- notepad.butSaveFile,
                             -- notepad.butSaveasFile,
                              --notepad.butNewCommands,
                              --notepad.butExecute,
                              margin="0x0", gap="10"},
                     iup.vbox{notepad.lblFileName,
                              notepad.mlCode,
                              notepad.lblPosition,
                              alignment = "ARIGHT"},
                     alignment="ATOP"}, title="TexturePacker格式转换器"}
   ,alignment="ACENTER", margin="5x5", gap="5"
}

-- Main Menu Definition.

notepad.mnuMain = iup.menu
{
  iup.submenu
  {
    iup.menu
    {
      iup.item{title="Exit", action="return iup.CLOSE"}
    }, title="&File"
  },
--  iup.submenu{iup.menu
--  {
--    iup.item{title="Print Version Info...", action=notepad.print_version_info},
--    iup.item{title="About...", action="notepad.dlgAbout:popup(iup.CENTER, iup.CENTER)"}
--  },title="Help"}
}

-- Main Dialog Definition.

notepad.dlgMain = iup.dialog{notepad.vbxNotepad,
                                 title="TexturePacker格式转换器",
                                 menu=notepad.mnuMain,
                                 dragdrop = "YES",
                                 defaultenter=notepad.butExecute}

function notepad.dlgMain:dropfiles_cb(filename, num, x, y)
  --if (num == 0) then -- only the first one
   notepad.LoadFile(filename)
  --end
end

function notepad.dlgMain:close_cb()
  iup.ExitLoop()  -- should be removed if used inside a bigger application
  notepad.dlgMain:destroy()
  return iup.IGNORE
end

-- Displays the Main Dialog

notepad.dlgMain:show()
notepad.mlCode.size = nil -- reset initial size, allow resize to smaller values
iup.SetFocus(notepad.mlCode)
if inputfile then
	notepad.LoadFile(inputfile)
end
if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end
