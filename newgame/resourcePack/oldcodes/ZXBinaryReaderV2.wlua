require"iuplua"
require 'ZXBinaryV2Lua'

local inputfile = arg[1]

ZXBinary = ZXBinaryV2Lua
ZXImageSet = ZXBinary.ZXImageSetV2
ZXImageUnit = ZXBinary.ZXImageUnitV2

ZXFrameData = ZXBinary.ZXFrameData
ZXFrameSet = ZXBinary.ZXFrameSet



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
  local s = string.find(filename,'.imageset$')
  local f = string.find(filename,'.frame$')

  local gImageSet = ZXImageSet()
  local gImageUnit = ZXImageUnit()
  local gFrameData = ZXFrameData()
  local gFrameSet = ZXFrameSet()

  if s then
	  gImageSet:Load(filename)
	  local szTable = {}
	  local count = gImageSet:ImageUnitCount()
	  local ver = gImageSet:GetVersion()
	  szTable[#szTable + 1] = string.format("file=\"%s\" count=%d ver =%d\n",gImageSet:TextureName(),count,ver);
	  szTable[#szTable + 1] = '----------------------------------------------\n'
	  for i=0, count - 1 do
		local iu = gImageSet:Get(i)
		--
		local rot = 0
		if iu.rotation then
			rot = 1
		end

		szTable[#szTable + 1] = string.format("[%d] file=\"%s\" x=%d y=%d width=%d height=%d rot=%d offset={%d,%d}, sourceSize={%d,%d}\n",
		i,iu:ImageName(),iu.x,iu.y,iu.width,iu.height,rot, iu.offsetX, iu.offsetY, iu.sourceSizeX, iu.sourceSizeY);
	  end

	  notepad.mlCode.value= table.concat(szTable)
	  notepad.lastfilename = filename
	  notepad.lblFileName.title = notepad.lastfilename
  elseif f then
	  gFrameSet:Load(filename)
  	  local szTable = {}
	  local count = gFrameSet:FrameDataCount()
	  szTable[#szTable + 1] = string.format("file=\"%s\" count=%d\n",gFrameSet:TextureName(),count);
	  szTable[#szTable + 1] = '----------------------------------------------\n'
	  for i=0, count - 1 do
		local fdata = gFrameSet:Get(i)
		szTable[#szTable + 1] = string.format("    [%d] file=\"%s\", x=%d y=%d width=%d height=%d anchor_x=%d anchor_y=%d\n",
													i,fdata:ImageName(),fdata.x,fdata.y,fdata.width,fdata.height,fdata.anchor_x,fdata.anchor_y);

	  end
	  notepad.mlCode.value= table.concat(szTable)
	  notepad.lastfilename = filename
	  notepad.lblFileName.title = notepad.lastfilename
  else
	error('鏈煡鏂囦欢鍚庣紑',filename)
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
                     alignment="ATOP"}, title="Commands"}
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
                                 title="图片数据查看器",
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
