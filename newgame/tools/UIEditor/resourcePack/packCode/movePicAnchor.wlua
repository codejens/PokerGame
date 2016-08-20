-------------------------------------------------------------------------=---
-- Name:        dialog.wx.lua
-- Purpose:     Dialog wxLua sample, a temperature converter
--              Based on the C++ version by Marco Ghislanzoni
-- Author:      J Winwood, John Labenski
-- Created:     March 2002
-- Copyright:   (c) 2001 Lomtick Software. All rights reserved.
-- Licence:     wxWidgets licence
-------------------------------------------------------------------------=---

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

-- IDs of the controls in the dialog
ID_CELSIUS_BUTTON      = 1  -- NOTE: We use the fact that the textctrl ids
ID_CELSIUS_TEXTCTRL    = 2  --       are +1 fom the button ids.
ID_KELVIN_BUTTON       = 3
ID_KELVIN_TEXTCTRL     = 4
ID_FAHRENHEIT_BUTTON   = 5
ID_FAHRENHEIT_TEXTCTRL = 6
ID_RANKINE_BUTTON      = 7
ID_RANKINE_TEXTCTRL    = 8
ID_ABOUT_BUTTON        = 9
ID_CLOSE_BUTTON        = 10

ID__MAX                = 11 -- max of our window ids

-- Create the dialog, there's no reason why we couldn't use a wxFrame and
-- a frame would probably be a better choice.
dialog = wx.wxDialog(wx.NULL, wx.wxID_ANY, "wxLua Temperature Converter",
                     wx.wxDefaultPosition, wx.wxDefaultSize)

-- Create a wxPanel to contain all the buttons. It's a good idea to always
-- create a single child window for top level windows (frames, dialogs) since
-- by default the top level window will want to expand the child to fill the
-- whole client area. The wxPanel also gives us keyboard navigation with TAB key.
panel = wx.wxPanel(dialog, wx.wxID_ANY)

-- Layout all the buttons using wxSizers
local mainSizer = wx.wxBoxSizer(wx.wxVERTICAL)

local staticBox      = wx.wxStaticBox(panel, wx.wxID_ANY, "Enter temperature")
local staticBoxSizer = wx.wxStaticBoxSizer(staticBox, wx.wxVERTICAL)
local flexGridSizer  = wx.wxFlexGridSizer( 2, 2, 0, 0 )
flexGridSizer:AddGrowableCol(1, 0)

-- Make a function to reduce the amount of duplicate code.
function AddConverterControl(name_string, button_text, textCtrlID, value)
    local staticText = wx.wxStaticText( panel, wx.wxID_ANY, name_string)
    local textCtrl   = wx.wxTextCtrl( panel, textCtrlID, value, wx.wxDefaultPosition, wx.wxSize(256,24) )
    flexGridSizer:Add( staticText, 0, wx.wxALIGN_CENTER_VERTICAL+wx.wxALL, 5 )
    flexGridSizer:Add( textCtrl,   0, wx.wxGROW+wx.wxALIGN_CENTER+wx.wxALL, 5 )
    return textCtrl
end

celsiusTextCtrl    = AddConverterControl("目录",    "From &Celsius",    ID_CELSIUS_TEXTCTRL,    '')
kelvinTextCtrl     = AddConverterControl("位移",     "From &Kelvin",     ID_KELVIN_TEXTCTRL,    '-64')


staticBoxSizer:Add( flexGridSizer,  0, wx.wxGROW+wx.wxALIGN_CENTER+wx.wxALL, 5 )
mainSizer:Add(      staticBoxSizer, 1, wx.wxGROW+wx.wxALIGN_CENTER+wx.wxALL, 5 )

local buttonSizer = wx.wxBoxSizer( wx.wxHORIZONTAL )
local aboutButton = wx.wxButton( panel, ID_ABOUT_BUTTON, "转换")
local closeButton = wx.wxButton( panel, ID_CLOSE_BUTTON, "退出")
buttonSizer:Add( aboutButton, 0, wx.wxALIGN_CENTER+wx.wxALL, 5 )
buttonSizer:Add( closeButton, 0, wx.wxALIGN_CENTER+wx.wxALL, 5 )
mainSizer:Add(    buttonSizer, 0, wx.wxALIGN_CENTER+wx.wxALL, 5 )

panel:SetSizer( mainSizer )
mainSizer:SetSizeHints( dialog )

-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------
-- Attach an event handler to the Close button
dialog:Connect(ID_CLOSE_BUTTON, wx.wxEVT_COMMAND_BUTTON_CLICKED,
    function(event) dialog:Destroy() end)

dialog:Connect(wx.wxEVT_CLOSE_WINDOW,
    function (event)
        dialog:Destroy()
        event:Skip()
    end)

-- ---------------------------------------------------------------------------
-- Attach an event handler to the About button
dialog:Connect(ID_ABOUT_BUTTON, wx.wxEVT_COMMAND_BUTTON_CLICKED,
    function(event)
		--require 'packCode/shift'
		--convertSpineAvatarAnchor(celsiusTextCtrl:GetValue(),kelvinTextCtrl:GetValue())
    end)
-- ---------------------------------------------------------------------------
-- Centre the dialog on the screen
dialog:Centre()
-- Show the dialog
dialog:Show(true)

-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()
