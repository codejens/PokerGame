require"iuplua"
require 'io'
require 'strbuf'
require 'list'

require 'packCode/ConvertPlist'
require 'packCode/ImageSetReader'
require 'packCode/WebpHelper'
require 'packCode/AnchorShift'
require 'packCode/ResizeImage'
require 'packCode/ZXBinaryReader'
--------------------------------------------------------------------------------
notepad = {}

-- Notepad Dialog
local OPTION = 1
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
notepad.butLoadFile    = iup.button{size="50x15", title="Load..."}
notepad.butSaveasFile  = iup.button{size="50x15", title="Save As..."}
notepad.butSaveFile    = iup.button{size="50x15", title="Save"}
notepad.func_list 	   = iup.list { "plist打包",
									"静帧文件查看",
									"动画文件查看",
									"webp转化",
									"动画锚点位移 (X-40 Y0)",
									"changeImageSize",
									"动画文件转换pkm格式",
									"动画文件转换pvr格式",
									"ui文件转换pvr格式",
									value = 1}
notepad.textureChangeLabel  = iup.label{title='对应纹理文件', size="50x", expand="HORIZONTAL"}
notepad.textureChangeEdit   = iup.text{title='',size="360x"}
notepad.textureChangeButton = iup.button{size="50x15", title="修改",
								   action="changeTextureName()"}
notepad.textureChangeCacheButton = iup.button{size="64x15", title="Cache文件名",
								   action="change2CacheTextureName()"}

notepad.iuChangeLabel  = iup.label{title='替换', size="50x", expand="HORIZONTAL"}
notepad.iuChangeEdit1   = iup.text{title='',size="180x"}
notepad.iuChangeEdit2   = iup.text{title='',size="180x"}
notepad.iuChangeButton = iup.button{size="50x15", title="修改",
								   action="searchReplace()"}

local INTRO = '选中相应功能，将需要处理的文件拖动到这里\n'

function change2CacheTextureName()
	local s = notepad.textureChangeEdit.value
	local i = string.find(s,'cache/')
	if i then
		assert(false,'已经指向到cache目录了')
	end
	notepad.textureChangeEdit.value = 'cache/' .. string.gsub(s,'/','_')
end


function splitfilename(strfilename)
	-- Returns the Path, Filename, and Extension as 3 values
	return string.match(strfilename, "(.-)([^\\/]-([^\\/%.]+))$")
end

function changeTextureName()

	if OPTION == 2 then
		local ret, message = ImageSetReaderV1.changeTextureName(notepad.textureChangeEdit)
		print(message)
		notepad.mlCode.value = INTRO .. message .. '[' .. os.date() .. ']'
	elseif OPTION == 3 then
		local ret, message = ImageSetReader.changeTextureName(notepad.textureChangeEdit)
		print(message)
		notepad.mlCode.value = INTRO .. message .. '[' .. os.date() .. ']'
	end
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


function notepad.func_list:action(op)
	OPTION = tonumber(notepad.func_list.value)
end

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
	local ok = false
	local message = 'unknow error'

	ImageSetReader.loadedfile = nil
	if OPTION == 1 then
		notepad.mlCode.value = '开始打包'
		ok, message = plistTool.convert(filename)
	elseif OPTION == 2 then
		ok, message = ImageSetReaderV1.load(filename,  notepad.textureChangeEdit)
	elseif OPTION == 3 then
		ok, message = ImageSetReader.load(filename,  notepad.textureChangeEdit)
	elseif OPTION == 4 then
		ok, message = WebpHelper.convert(filename)
	elseif OPTION == 5 then
		ok, message = AnchorShift.convertSpineAvatarAnchor(filename,-40,0)
	elseif OPTION == 6 then
		ok, message = ResizeImage.convertSpineAvatarAnchor(filename,0,0,48,48)
	elseif OPTION == 7 then
		ok, message = ImageSetReader.patchLoad(filename,  notepad.textureChangeEdit)
	elseif OPTION == 8 then
	ok, message = ImageSetReader.patchLoad_pvr(filename,  notepad.textureChangeEdit)
	elseif  OPTION == 9 then
	ok, message = ImageSetReaderV1.patchLoad(filename,  notepad.textureChangeEdit)
	end

	if not ok then
		dlg = iup.messagedlg{
		  dialogtype = "ERROR",
		  title = "Error!",
		  value = message .. ' [' .. tostring(OPTION) .. ']'
		  }
		dlg:popup()
		dlg:destroy()
	elseif OPTION == 1 then
		dlg = iup.messagedlg{
		  dialogtype = "OK",
		  title = "成功!",
		  value = '成功打包文件\n' .. filename .. '\n'
		  }
		dlg:popup()
		dlg:destroy()
		notepad.mlCode.value = INTRO .. message .. ' [' .. os.date() .. ']\n'
	else
		notepad.mlCode.value = INTRO .. message .. ' [' .. os.date() .. ']\n'
	end
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
                              notepad.func_list,
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
							  --[[iup.hbox{
							  notepad.iuChangeLabel,
							  notepad.iuChangeEdit1,
							  notepad.iuChangeEdit2,
							  notepad.iuChangeButton,
							  alignment = "ALEFT"
							  },]]--
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
notepad.mlCode.value = INTRO
notepad.dlgMain:show()
notepad.mlCode.size = nil -- reset initial size, allow resize to smaller values
iup.SetFocus(notepad.mlCode)
if inputfile then
	notepad.LoadFile(inputfile)
end
if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end
