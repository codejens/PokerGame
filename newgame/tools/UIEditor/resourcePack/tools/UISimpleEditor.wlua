require ("iuplua")
require 'ZXNet'
--require 'strbuf'
require 'list'
srv = nil
console = {}
console.c_x = 0
console.c_y = 0
--[[
-- creates a button entitled Exit
btn_exit = iup.button{ title = "Exit" }
-- callback called when the exit button is activated
function btn_exit:action()
  dlg:hide()
end
]]
console.savebtn = iup.button{ title = "save layouts" }
console.savename = iup.text{expand="Horizontal", dragdrop = "Yes"}

console.openbtn = iup.button{ title = "open layouts" }
console.auto_load = iup.text{expand="Horizontal", dragdrop = "Yes"}

console.loadbtn = iup.button{ title = "AutoLoad" }

console.prompt = iup.text{expand="Horizontal", dragdrop = "Yes"}
console.tag  = iup.text{expand="Horizontal", dragdrop = "No"}
console.parentbtn = iup.button{ title = "choose compnent" }

console.posX = iup.text{expand="Horizontal", dragdrop = "No"}
console.posY = iup.text{expand="Horizontal", dragdrop = "No"}
console.posbtn = iup.button{ title = "OK" }

console.absPosX = iup.text{expand="Horizontal", dragdrop = "No"}
console.absPosY = iup.text{expand="Horizontal", dragdrop = "No"}
console.absPosbtn = iup.button{ title = "OK" }
console.poscenterbtn = iup.button{ title = "Center" }

console.width = iup.text{expand="Horizontal", dragdrop = "No"}
console.width_btn = iup.button{ title = "-1" }
console.height = iup.text{expand="Horizontal", dragdrop = "No"}
console.height_btn = iup.button{ title = "-1" }
console.zOrder = iup.text{expand="Horizontal", dragdrop = "No"}
console.sizebtn = iup.button{ title = "OK" }

console.btn = iup.button{ title = "find" }
console.comp_list = iup.list {nil;
value = 1, size = "120x80"}

console.comp_class = iup.text{expand="Horizontal", dragdrop = "Yes"}
console.root_class = iup.text{expand="Horizontal", dragdrop = "Yes"}


console.texture  = iup.text{expand="Horizontal", dragdrop = "No"}
console.texturebtn = iup.button{ title = "OK" }

console.textrue_down = iup.text{expand="Horizontal", dragdrop = "No"}
console.texture_downbtn = iup.button{ title = "OK" }

console.is_nine = iup.text{expand="Horizontal", dragdrop = "No"}
console.is_nine_btnTrue = iup.button{ title = "true" }
console.is_nine_btnFalse = iup.button{ title = "false" }
console.is_ninebtn = iup.button{ title = "OK" }

console.str = iup.text{expand="Horizontal", dragdrop = "No"}
console.strbtn = iup.button{ title = "OK" }

console.fontsize = iup.text{expand="Horizontal", dragdrop = "No"}
console.fontsizebtn = iup.button{ title = "OK" }

console.align = iup.text{expand="Horizontal", dragdrop = "No"}
console.alignbtn = iup.button{ title = "OK" }

console.align = iup.text{expand="Horizontal", dragdrop = "No"}
console.alignbtn = iup.button{ title = "OK" }

console.scroll_type = iup.text{expand="Horizontal", dragdrop = "No"}
console.scroll_typebtn = iup.button{ title = "OK" }

console.name = iup.text{expand="Horizontal", dragdrop = "No"}
console.namebtn = iup.button{ title = "OK" }

console.parent = iup.text{expand="Horizontal", dragdrop = "No"}
console.parentbtn = iup.button{ title = "OK" }

-- 是否翻转
console.isFlipX = iup.text{expand = "Horizontal", dragdrop = "No"}
console.isFlipX_btnTrue = iup.button{ title = "true" }
console.isFlipX_btnFalse = iup.button{ title = "false" }
console.isFlipY = iup.text{expand = "Horizontal", dragdrop = "No"}
console.isFlipY_btnTrue = iup.button{ title = "true" }
console.isFlipY_btnFalse = iup.button{ title = "false" }
console.flipBtn = iup.button{ title = "OK" }

-- 是否隐藏
console.isVisible = iup.text{expand = "Horizontal", dragdrop = "No"}
console.isVisible_btnTrue = iup.button{ title = "true" }
console.isVisible_btnFalse = iup.button{ title = "false" }
console.visibleBtn = iup.button{ title = "OK" }

-- 多选x间距
console.x_distance = iup.text{expand = "Horizontal", dragdrop = "No"}
console.x_Btn = iup.button{ title = "OK" }

-- 多选y间距
console.y_distance = iup.text{expand = "Horizontal", dragdrop = "No"}
console.y_Btn = iup.button{ title = "OK" }


console.prompt.tip = "Enter - executes a Lua command\n"..
                     "Esc - clears the command\n"..
                     "Ctrl+Del - clears the output\n"..
                     "Ctrl+O - selects a file and execute it\n"..
                     "Ctrl+X - exits the console\n"..
                     "Up Arrow - shows the previous command in history\n"..
                     "Down Arrow - shows the next command in history\n"..
                     "Drop files here to execute them"

console.orig_output = io.output
console.orig_write = io.write
console.orig_print = print
function io.output(filename)
  console.orig_output(filename)
  if (filename) then
    io.write = console.orig_write
  else
    io.write = console.new_write
  end
end

function console.new_write(...)
  -- Try to simulate the same behavior of the standard io.write
  local arg = {...}
  local str -- allow to print a nil value
  for i,v in ipairs(arg) do
    if (str) then
      str = str .. tostring(v)
    else
      str = tostring(v)
    end
  end
  console.print2output(str, true)
end
io.write = console.new_write

function print(...)
  -- Try to simulate the same behavior of the standard print
  local arg = {...}
  local str -- allow to print a nil value
  for i,v in ipairs(arg) do
    if (i > 1) then
      str = str .. "\t"  -- only add Tab for more than 1 parameters
    end
    if (str) then
      str = str .. tostring(v)
    else
      str = tostring(v)
    end
  end
  console.print2output(str)
end

function console.print2output(s, no_newline)
  if (no_newline) then
    console.output.append = tostring(s)
    console.no_newline = no_newline
  else
    if (console.no_newline) then
      -- if io.write was called, then a print is called, must add a new line before
      console.output.append = "\n" .. tostring(s) .. "\n"
      console.no_newline = nil
    else
      --console.output.append = tostring(s) .. "\n"
    end
  end
end

function console.print_command(cmd)
  console.add_command(cmd)
  console.print2output("> " .. cmd)
end

function  console.add_command(cmd)
  console.cmd_index = nil
  if (not console.cmd_list) then
    console.cmd_list = {}
  end
  local n = #(console.cmd_list)
  console.cmd_list[n+1] = cmd
end

function  console.prev_command()
  if (not console.cmd_list) then
    return
  end
  if (not console.cmd_index) then
    console.cmd_index = #(console.cmd_list)
  else
    console.cmd_index = console.cmd_index - 1
    if (console.cmd_index == 0) then
      console.cmd_index = 1
    end
  end
  console.prompt.value = console.cmd_list[console.cmd_index]
end

function  console.next_command()
  if (not console.cmd_list) then
    return
  end
  if (not console.cmd_index) then
    return
  else
    console.cmd_index = console.cmd_index + 1
    local n = #(console.cmd_list)
    if (console.cmd_index == n+1) then
      console.cmd_index = n
    end
  end
  console.prompt.value = console.cmd_list[console.cmd_index]
end

function console.do_file(filename)
  local cmd = 'dofile(' .. string.format('%q', filename) .. ')'
  console.print_command(cmd)
  dofile(filename)
end

function console.do_string(cmd)
  console.print_command(cmd)
  srv:Send(cmd)
  --assert(loadstring(cmd))()
end

function console.open_file()
  local fd=iup.filedlg{dialogtype="OPEN", title="Load File",
                       nochangedir="NO", directory=console.last_directory,
                       filter="*.*", filterinfo="All Files", allownew="NO"}
  fd:popup(iup.CENTER, iup.CENTER)
  local status = fd.status
  local filename = fd.value
  console.last_directory = fd.directory -- save the previous directory
  fd:destroy()
  print("filename", filename)

  if (status == "-1") or (status == "1") then
    if (status == "1") then
      error ("Cannot load file: "..filename)
    end
  else
    console.do_file(filename)
  end
end

function console.prompt:dropfiles_cb(filename)
  -- will execute all dropped files, can drop more than one at once
  -- works in Windows and in Linux
  console.do_file(filename)
end

function console.prompt:k_any(key)
  if (key == iup.K_CR) then  -- Enter executes the string
    console.do_string(self.value)
    self.value = ""
  end
  if (key == iup.K_ESC) then  -- Esc clears console.prompt
    self.value = ""
  end
  if (key == iup.K_cO) then  -- Ctrl+O selects a file and execute it
    console.open_file()
  end
  if (key == iup.K_cX) then  -- Ctrl+X exits the console
    console.dialog:close_cb()
  end
  if (key == iup.K_cDEL) then  -- Ctrl+Del clears console.output
    console.output.value = ""
  end
  if (key == iup.K_UP) then  -- Up Arrow - shows the previous command in history
    console.prev_command()
  end
  if (key == iup.K_DOWN) then  -- Down Arrow - shows the next command in history
    console.next_command()
  end
end

--[[
console.comp_name  = iup.text{expand="Horizontal", dragdrop = "No"}
console.texture  = iup.text{expand="Horizontal", dragdrop = "No"}
]]--
console.dialog = iup.dialog
{
  iup.vbox
  {
	iup.hbox
	{
		console.savebtn,
    console.savename,
		console.openbtn,
		title = "读取操作",
    console.auto_load,
    console.loadbtn,
	},

	iup.frame
  {
		iup.vbox -- use it to inherit margins
		{
			iup.hbox
			{
				console.name,
				console.namebtn,
				console.parent,
				console.parentbtn,
			}
		},
		title = "name-----------------------------name of parent",
	},
	
	iup.frame
  {
		iup.vbox -- use it to inherit margins
		{
			iup.hbox
			{
				console.posX,
				console.posY,
        console.posbtn,
        console.poscenterbtn,
			}
		},
		title = "position:  x  y",
	},



	iup.frame
  {
		iup.vbox -- use it to inherit margins
		{
			iup.hbox
			{
				console.width,
        console.width_btn,
        console.height,
				console.height_btn,
        console.zOrder,
				console.sizebtn,
			}
		},
		title = "size:  x  y  z",
	},

  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.texture,
        console.texturebtn
      }
    },
    title = "texture_img_nor:",
  },

  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.is_nine,
        console.is_nine_btnTrue,
        console.is_nine_btnFalse,
        console.is_ninebtn
      }
    },
    title = "scale9Sprite:  true or false",
  },

  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.isFlipX,
        console.isFlipX_btnTrue,
        console.isFlipX_btnFalse,
        console.isFlipY,
        console.isFlipY_btnTrue,
        console.isFlipY_btnFalse,
        console.flipBtn
      }
    },
    title = "flip:  true or false",
  },

  iup.frame
    {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.isVisible,
        console.isVisible_btnTrue,
        console.isVisible_btnFalse,
        console.visibleBtn,
      }
    },
    title = "visible:  true or false",
  },
  
  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.str,
        console.strbtn,

      }
    },
    title = "label",
  },

  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.fontsize,
        console.fontsizebtn,
        console.align,
        console.alignbtn
      }
    },
    title = "fontSize:  align,left_middle_right,1,2,3",
  },

  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.scroll_type,
        console.scroll_typebtn
      }
    },
    title = "scroll vertical:  Horisontal,1,2",
  },

  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.x_distance,
        console.x_Btn,
        console.y_distance,
        console.y_Btn,
      }
    },
    title = "Multiselect:---x_distance----------y_distance",
  },

  iup.frame
  {
    iup.vbox -- use it to inherit margins
    {
      iup.hbox
      {
        console.textrue_down,
        console.texture_downbtn
      }
    },
    title = "texture_img_down,general_ignore:",
  },


  


    margin = "5x5",
    gap = "5",
  },
  title="Lua Console",
  size="250x475", -- initial size
  icon=0, -- use the Lua icon from the executable in Windows
}

function console.dialog:close_cb()
  print = console.orig_print  -- restore print and io.write
  io.write = console.orig_write
  iup.ExitLoop()  -- should be removed if used inside a bigger application
  console.dialog:destroy()
  return iup.IGNORE
end

function console.version_info()
  print(_VERSION, _COPYRIGHT) -- _COPYRIGHT does not exists by default, but it could...

  print("IUP " .. iup._VERSION .. "  " .. iup._COPYRIGHT)
  print("  System: " .. iup.GetGlobal("SYSTEM"))
  print("  System Version: " .. iup.GetGlobal("SYSTEMVERSION"))

  local mot = iup.GetGlobal("MOTIFVERSION")
  if (mot) then print("  Motif Version: ", mot) end

  local gtk = iup.GetGlobal("GTKVERSION")
  if (gtk) then print("  GTK Version: ", gtk) end
end

local  func = nil
function idle_cb()
	if srv then
		local _msg = srv:PopMessage()
		local _log = srv:PopLog()
		if _msg then
			if string.sub(_msg,1,1) == '>' then
				local cmd = string.sub(_msg,2)
				func =  loadstring(cmd)
        if func then
          func()
        end
			else
				print(_msg)
			end
		end

		if _log then
			print('[L]:' .. _log)
		end
	end
end

function setSelected(x,y,width,height,zOrder)
	--print(tag,x,y)
	--console.tag.value = tag
	console.posX.value = x
	console.posY.value = y
	console.width.value = width
	console.height.value = height
  if zOrder then
    console.zOrder.value = zOrder
  else
    console.zOrder.value = 0
  end
end

function setCompClasses(root, node)
	if root == '' then
		root = '未知'
	end
	if node == '' then
		node = '未知'
	end
	console.root_class.value = root
	console.comp_class.value = node
end

function setTexture(texture)
	console.texture.value = texture
end

function setName(name)
	console.comp_name.value = name
end

function refreshFileName(dict)
 console.savename.value = dict.fileName
end

function sethAutoLoad(value)
 console.auto_load.value = value
end

function refreshGUI(dict)
	if not dict then
		setSelected('','','','','','')
		---setCompClasses('','')
		setTexture('')
		--setName('未知')
		return
	end
	local x 	= dict.pos[1]
	local y 	= dict.pos[2]
  dict.size = dict.size or {}
	local width =  dict.size[1]
	local height = dict.size[2]
  console.c_x = 0
  console.c_y = 0
  if dict.parent_layout and width and height then
    console.c_x = dict.parent_layout.size[1]/2 - width/2
    console.c_y= dict.parent_layout.size[2]/2 - height/2
  end


  -- 选中后更新GUI面板的flip数据
  local flipX = false
  local flipY = false
  if dict.flip and dict.flip[1] and dict.flip[2] then
    flipX = dict.flip[1]
    flipY = dict.flip[2]
  else
    flipX = false
    flipY = false
  end


  local zOrder = 1
  if dict.zOrder then
      zOrder = dict.zOrder
  end

	setSelected(x, y,width, height, zOrder)
	--setCompClasses(dict.root_class,dict.comp_class)
	setTexture(dict.img_n)
	set_info(dict.is_nine,dict.fontsize, dict.align, dict.stype, dict.img_s, dict.str, dict.flip)
	set_name(dict.name,dict.parent)
  sethAutoLoad(dict.auto_load)
end

function set_name(name,parent)
	console.name.value = name
	console.parent.value = parent
end 

function set_Flip(flipX, flipY)
  console.flipX.value = tostring(flipX)
  console.flipY.value = tostring(flipY)
end

function set_info(is_nine, fontsize, align, ttype, img_s, str, flip)


  console.is_nine.value = tostring(is_nine)
  
  console.isFlipX.value = tostring(false)
  console.isFlipY.value = tostring(false)

  if flip then
    console.isFlipX.value = tostring(flip[1])
    console.isFlipY.value = tostring(flip[2])
  end
  console.fontsize.value = fontsize
  console.align.value = align
  console.scroll_type.value = ttype
  console.textrue_down.value = img_s
  console.str.value = str
end

--x间距
function console.x_Btn:action()
   srv:Send(string.format('x_distance,%d',console.x_distance.value))
end

--y间距
function console.y_Btn:action()
   srv:Send(string.format('y_distance,%d',console.y_distance.value))
end

function console.openbtn:action()
    local dlg = iup.filedlg{dialogtype="OPEN"}
    dlg:popup()
    if dlg.status == "0" then
        --text_location.value = dlg.value
		srv:Send(string.format('open,%s',dlg.value))
   end
end


function console.namebtn:action()
	srv:Send(string.format('name,%s',console.name.value))
end

function console.parentbtn:action()
	srv:Send(string.format('parent,%s',console.parent.value))
end

function console.posbtn:action()
	srv:Send(string.format('pos,%d,%d',
	console.posX.value,
	console.posY.value))

end

function console.poscenterbtn:action()
  srv:Send(string.format('pos,%s,%s',console.c_x,console.c_y))
end

function console.width_btn:action()
  console.width.value = tostring(-1)
end
function console.height_btn:action()
  console.height.value = tostring(-1)
end

function console.sizebtn:action()
	srv:Send(string.format('size,%d,%d,%d',
	console.width.value,
	console.height.value,
  console.zOrder.value
 ))
end

function console.texturebtn:action()
	srv:Send(string.format('img_n,%s',console.texture.value))
end

function console.texture_downbtn:action()
  srv:Send(string.format('img_s,%s',console.textrue_down.value))
end


function console.is_nine_btnTrue:action()
  console.is_nine.value = tostring(true)
end
function console.is_nine_btnFalse:action()
  console.is_nine.value = tostring(false)
end

function console.is_ninebtn:action()
  srv:Send(string.format('is_nine,%s',console.is_nine.value))
end

function console.isFlipX_btnTrue:action()
  console.isFlipX.value = tostring(true)
end
function console.isFlipX_btnFalse:action()
  console.isFlipX.value = tostring(false)
end
function console.isFlipY_btnTrue:action()
  console.isFlipY.value = tostring(true)
end
function console.isFlipY_btnFalse:action()
  console.isFlipY.value = tostring(false)
end

-- 翻转的回调函数
function console.flipBtn:action()
  srv:Send(string.format('flip,%s,%s', console.isFlipX.value, console.isFlipY.value))
end

function console.isVisible_btnTrue:action()
  console.isVisible.value = tostring(true)
end
function console.isVisible_btnFalse:action()
  console.isVisible.value = tostring(false)
end

-- 是否隐藏
function console.visibleBtn:action()
  srv:Send(string.format('isVisible,%s',console.isVisible.value))
end

function console.strbtn:action()
  srv:Send(string.format('str,%s',console.str.value))
end
function console.fontsizebtn:action()
  srv:Send(string.format('fontsize,%d',console.fontsize.value))
end
function console.alignbtn:action()
  srv:Send(string.format('align,%d',console.align.value))
end
function console.scroll_typebtn:action()
  srv:Send(string.format('scroll_type,%d',console.scroll_type.value))
end


function  console.savebtn:action()
	srv:Send(string.format('save,%d,%s',-1, console.savename.value))
end

function  console.loadbtn:action()
  srv:Send(string.format('auto_load,%d,%s',-1, console.auto_load.value))
end


function console.posX:action(key,txt,e)
	--print('hello',key,txt)
end

function console.posY:action()

end


function console.width:action()

end

function console.height:action()

end

function setSelectedChild(clist)
	local list = console.comp_list

	for i=1,list.count do
		list[i] = nil
	end

	for i,v in pairs(clist) do
		list[i] = tostring(v)

	end
end


function console.comp_list:action(t, i, v)
  if v == 0 then
    --state = "deselected"
  else
	srv:Send(string.format('UIEditor:setSelectedChild(%d)',i))
    --state = "selected"
  end
  --iup.Message("Competed in", "Item "..i.." - "..t.." - "..state)
  return iup.DEFAULT
end
iup.ShowXY(console.dialog,0,0)
--console.dialog:show()
console.dialog.size = nil -- reset initial size, allow resize to smaller values
iup.SetFocus(console.prompt)

console.version_info()

if (iup.MainLoopLevel() == 0) then
  srv = ZXNet.CSimpleServer_GetSingleton()
  srv:Create(8314)
  iup.SetIdle(idle_cb)
  setSelected(100,200,0,0)
  -- console.savename = "uieditor_test"
  iup.MainLoop()
  ZXNet.CSimpleServer_Kill()
end
