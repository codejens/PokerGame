require ("iuplua")
require 'ZXNet'
require 'strbuf'
require 'list'
srv = nil
console = {}

--[[
-- creates a button entitled Exit
btn_exit = iup.button{ title = "Exit" }
-- callback called when the exit button is activated
function btn_exit:action()
  dlg:hide()
end
]]
console.save   = iup.button{ title = "保存" }
console.prompt = iup.text{expand="Horizontal", dragdrop = "Yes"}
console.tag  = iup.text{expand="Horizontal", dragdrop = "No"}
console.parentbtn = iup.button{ title = "选中父控件" }

console.posX = iup.text{expand="Horizontal", dragdrop = "No"}
console.posY = iup.text{expand="Horizontal", dragdrop = "No"}
console.posbtn = iup.button{ title = "修改" }

console.width = iup.text{expand="Horizontal", dragdrop = "No"}
console.height = iup.text{expand="Horizontal", dragdrop = "No"}
console.sizebtn = iup.button{ title = "修改" }

console.btn = iup.button{ title = "查找" }
console.comp_list = iup.list {nil;
value = 1, size = "120x120"}

console.comp_class = iup.text{expand="Horizontal", dragdrop = "Yes"}
console.root_class = iup.text{expand="Horizontal", dragdrop = "Yes"}


console.output = iup.text{expand="Yes",
                  readonly="Yes",
                  bgcolor="232 232 232",
                  font = "Courier, 11",
                  appendnewline = "No",
                  multiline = "Yes"}

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
      console.output.append = tostring(s) .. "\n"
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

console.dialog = iup.dialog
{
  iup.vbox
  {

	iup.frame
    {
		iup.vbox -- use it to inherit margins
		{
			iup.hbox
			{
				iup.label{title = '根控件类型'},
				console.root_class,
				iup.label{title = '控件类型'},
				console.comp_class,
			}
		},
		title = "类型:",
	},

	iup.frame
    {
		iup.vbox -- use it to inherit margins
		{
			iup.hbox
			{
				console.tag,
			}
		},
		title = "Tag:",
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
			}
		},
		title = "位置:",
	},

	iup.frame
    {
		iup.vbox -- use it to inherit margins
		{
			iup.hbox
			{
				console.width,
				console.height,
				console.sizebtn,
			}
		},
		title = "大小:",
	},

	iup.frame
    {
      iup.vbox -- use it to inherit margins
      {
		console.parentbtn,
        console.comp_list,
      },
      title = "子控件:",
    },

    iup.frame
    {
      iup.hbox -- use it to inherit margins
      {
        console.prompt,
      },
      title = "Command:",
    },
    iup.frame
    {
      iup.hbox -- use it to inherit margins
      {
        console.output
      },
      title = "Output:",
    },
    margin = "5x5",
    gap = "5",
  },
  title="Lua Console",
  size="250x400", -- initial size
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

function idle_cb()
	if srv then
		local _msg = srv:PopMessage()
		local _log = srv:PopLog()
		if _msg then
			if string.sub(_msg,1,1) == '>' then
				local cmd = string.sub(_msg,2)
				--print(cmd)
				loadstring(cmd)()
			else
				print(_msg)
			end
		end

		if _log then
			print('[L]:' .. _log)
		end
	end
end

function setSelected(tag,x,y,width,height)
	--print(tag,x,y)
	console.tag.value = tag
	console.posX.value = x
	console.posY.value = y
	console.width.value = width
	console.height.value = height
end

function setCompClasses( root, node )
	if root == '' then
		root = '未知'
	end
	if node == '' then
		node = '未知'
	end
	console.root_class.value = root
	console.comp_class.value = node
end

function console.parentbtn:action()
	srv:Send(string.format('UIEditor:getSelectedParent(%d)',
							console.tag.value))
end

function console.posbtn:action()
	srv:Send(string.format('UIEditor:setSelectedPosition(%d,%d)',
	console.posX.value,
	console.posY.value))
end

function console.sizebtn:action()
	srv:Send(string.format('UIEditor:setSelectedSize(%d,%d)',
	console.width.value,
	console.height.value))
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

console.dialog:show()
console.dialog.size = nil -- reset initial size, allow resize to smaller values
iup.SetFocus(console.prompt)

console.version_info()

if (iup.MainLoopLevel() == 0) then
  srv = ZXNet.CSimpleServer_GetSingleton()
  srv:Create(8314)
  iup.SetIdle(idle_cb)
  setSelected(99,100,200,0,0)
  iup.MainLoop()
  ZXNet.CSimpleServer_Kill()
end
