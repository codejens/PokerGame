--loginModel.lua
--登陆逻辑处理
LoginModel = {}

function LoginModel:init(self)
   print("LoginModel:init")
   self._serverList = {}
end

function LoginModel:do_login(name,password )
   		--scene.XGameScene.sharedScene()
         self.name = name
         self.password = password
         -- print("name,password=",name,password)
   	  -- _loginInfo.user_name = name
      local url = "http://192.168.25.35:8080/ms/noplatform/get_servlist.jsp"
      local param = 'account=' ..name.."&pw="..password
      local function login_call_back(error,message)

      		if error == 0 then
               message = json.decode(message,1)
            	local resulst_code = message['ret']                                   -- 0：操作失败   1：操作成功   -1：其他错误
            	if resulst_code == "1" then 
	               self._serverList = message['srvlist']
		      		require 'gamecore.state.selectServer_state'
		      		gameStateManager:setState(selectServerState)
		      		local win = GUIManager:find_window( "selectserver" )
		      		if win then
		      			win:update_select_btn( #self._serverList )
		      		end
		      		SelectServerModel:do_group_btn( 1 )
	           end
      		end
      end 
      local http_request = HttpRequest:new( url,param,login_call_back)
      http_request:send()


end

function LoginModel:get_serverlist_date()
	return self._serverList
end

-- function get_loginInfo(self  )
	-- return _loginInfo
-- end

function LoginModel:get_name_with_password()
   return self.name,self.password
end

function LoginModel:show_login_win()
   GUIManager:show_window("login_win")
end

function LoginModel:close_login_win()
   GUIManager:hide_window("login_win")
end