-----------------------------------------------------------------------------
-- WebView控件(目前只支持Android与iOS)
-- @author liubo
-- @release 1
-----------------------------------------------------------------------------

--!class GUIWebView
GUIWebView = simple_class(GUITouchBase)

--- 构造函数
-- @param view WebView控件对象
-- @see members
function GUIWebView:__init(view)
	
end

--- 创建函数
-- @usage GUIWebView:create()
function GUIWebView:create()
	local view = ccexp.WebView and ccexp.WebView:create() or ccui.Widget:create()
	return self(view)
end

--- 加载网页
-- @param url 统一资源定位符
-- @usage loadURL("http://www.xxx.com")
function GUIWebView:loadURL(url)
	if self.view.loadURL then
		self.view:loadURL(url)
	end
end

--- 是否调整WebView内容以适应所设置内容的大小
-- @param bool 布尔值
-- @usage setScalesPageToFit(true)
function GUIWebView:setScalesPageToFit(bool)
	if self.view.setScalesPageToFit then
		self.view:setScalesPageToFit(bool)
	end
end

--- 设置加载开始的回调
-- @usage setOnShouldStartLoading(function(sender, url) print(url) end)
function GUIWebView:setOnShouldStartLoading(cb_func)
	if self.view.setOnShouldStartLoading then
		self.view:setOnShouldStartLoading(cb_func)
	end
end

--- 设置加载完成的回调
-- @usage setOnDidFinishLoading(function(sender, url) print(url) end)
function GUIWebView:setOnDidFinishLoading(cb_func)
	if self.view.setOnDidFinishLoading then
		self.view:setOnDidFinishLoading(cb_func)
	end
end

--- 设置加载失败的回调
-- @usage setOnDidFailLoading(function(sender, url) print(url) end)
function GUIWebView:setOnDidFailLoading(cb_func)
	if self.view.setOnDidFailLoading then
		self.view:setOnDidFailLoading(cb_func)
	end
end

--- 后退
-- @usage goBack()
function GUIWebView:goBack()
	if self.view.goBack then
		self.view:goBack()
	end
end

---  前进
-- @usage goForward()
function GUIWebView:goForward()
	if self.view.goForward then
		self.view:goForward()
	end
end

---  重新加载
-- @usage reload()
function GUIWebView:reload()
	if self.view.reload then
		self.view:reload()
	end
end

---  加载网页文件
-- @usage loadFile("Test.html")
function GUIWebView:loadFile(file)
	if self.view.loadFile then
		self.view:loadFile(file)
	end
end

---  加载HTML字符串
-- @usage loadHTMLString("<label name=\"mylabel\">test</label>")
function GUIWebView:loadHTMLString(string)
	if self.view.loadHTMLString then
		self.view:loadHTMLString(string)
	end
end

---  执行JavaScript
-- @usage evaluateJS("alert(\"test\")")
function GUIWebView:evaluateJS(string)
	if self.view.evaluateJS then
		self.view:evaluateJS(string)
	end
end