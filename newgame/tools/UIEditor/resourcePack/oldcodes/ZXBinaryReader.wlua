require"iuplua"
require 'ZXBinaryLua'
require 'os'
local inputfile = arg[1]
--ËØªÂÜô‰∫åËøõÂà∂ÂõæÁâá
ZXBinary = ZXBinaryLua
ZXImageSet = ZXBinary.ZXImageSet
ZXImageUnit = ZXBinary.ZXImageUnit

ZXFrameData = ZXBinary.ZXImageSet
ZXFrameSet = ZXBinary.ZXFrameSet



notepad = {}

-- Notepad Dialog

notepad.lastfilename = nil -- Last file open
notepad.mlCode = iup.multiline{expand="YES", size="400x300", font="Courier, 10"}
notepad.lblPosition = iup.label{title="Lin 0, Col 0", size="50x"}
notepad.lblFileName = iup.label{title="", size="50x", expand="HORIZONTAL"}
notepad.textureChangeLabel  = iup.label{title='∂‘”¶Œ∆¿ÌŒƒº˛', size="50x", expand="HORIZONTAL"}
notepad.textureChangeEdit   = iup.text{title='',size="360x"}
notepad.textureChangeButton = iup.button{size="50x15", title="–ﬁ∏ƒ",
								   action="changeTextureName()"}
notepad.textureChangeCacheButton = iup.button{size="64x15", title="CacheŒƒº˛√˚",
								   action="change2CacheTextureName()"}

notepad.iuChangeLabel  = iup.label{title='ÃÊªª', size="50x", expand="HORIZONTAL"}
notepad.iuChangeEdit1   = iup.text{title='',size="180x"}
notepad.iuChangeEdit2   = iup.text{title='',size="180x"}
notepad.iuChangeButton = iup.button{size="50x15", title="–ﬁ∏ƒ",
								   action="searchReplace()"}

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

function change2CacheTextureName()
	local s = notepad.textureChangeEdit.value
	local i = string.find(s,'cache/')
	if i then
		assert(false,'already has cache')
	end
	notepad.textureChangeEdit.value = 'cache/' .. string.gsub(s,'/','_')
end


function splitfilename(strfilename)
	-- Returns the Path, Filename, and Extension as 3 values
	return string.match(strfilename, "(.-)([^\\/]-([^\\/%.]+))$")
end

function changeTextureName()



	local filename = notepad.lastfilename
	local fs = ZXFrameSet()
	fs:Load(filename)

	local e0,f0,s0 = splitfilename(notepad.lastfilename)
	local e1,f1,s1 = splitfilename(fs:TextureName())

	local fn = e0 .. f1

	notepad.mlCode.value = fn
	fn = string.gsub(fn,'[/\\]','\\')

	--os.execute('copy /s ' .. fn .. ' ' .. notepad.textureChangeEdit.value)
	--if true then return end


	fs:SetTextureName(notepad.textureChangeEdit.value)
	fs:Save(filename)
	notepad.LoadFile(filename)


	--assert(false,filename)
end

function searchReplace()
	local filename = notepad.lastfilename
	local src = notepad.iuChangeEdit1.value
	local dst = notepad.iuChangeEdit2.value
	local gImageSet = ZXImageSet()
	local gImageUnit = ZXImageUnit()
	local gFrameData = ZXFrameData()
	local gFrameSet = ZXFrameSet()

	gImageSet:Load(filename)
	local count = gImageSet:ImageUnitCount()
	for i=0, count - 1 do
		local iu = gImageSet:Get(i)
		if iu:ImageName() == src then
			iu:SetImageName(dst)
			--print('>>>',dst)
		end
	end
	gImageSet:Save(filename)
	notepad.LoadFile(filename)
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
	  szTable[#szTable + 1] = string.format("file=\"%s\" count=%d\n",gImageSet:TextureName(),count);
	  szTable[#szTable + 1] = '----------------------------------------------\n'
	  notepad.textureChangeEdit.value = gImageSet:TextureName()
	  for i=0, count - 1 do
		local iu = gImageSet:Get(i)
		szTable[#szTable + 1] = string.format("[%d] file=\"%s\" x=%d y=%d width=%d height=%d\n",i,iu:ImageName(),iu.x,iu.y,iu.width,iu.height);
	  end

	  notepad.mlCode.value= table.concat(szTable)
	  notepad.lastfilename = filename
	  notepad.lblFileName.title = notepad.lastfilename
	  notepad.data = { 1, gImageSet }

  elseif f then
	  gFrameSet:Load(filename)
	  notepad.textureChangeEdit.value = gFrameSet:TextureName()
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
	  notepad.data = { 2, gFrameSet }

  else
	error('Êú™Áü•Êñá‰ª∂ÂêéÁºÄ',filename)
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
							  iup.hbox{
							  notepad.textureChangeLabel,
							  notepad.textureChangeEdit,
							  notepad.textureChangeCacheButton,
							  notepad.textureChangeButton,
							  alignment = "ALEFT"
							  },
							  iup.hbox{
							  notepad.iuChangeLabel,
							  notepad.iuChangeEdit1,
							  notepad.iuChangeEdit2,
							  notepad.iuChangeButton,
							  alignment = "ALEFT"
							  },
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
                                 title="Õº∆¨ ˝æ›≤Èø¥∆˜",
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
