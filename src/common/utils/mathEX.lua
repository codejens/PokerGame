mathEX = {}

function mathEX.distance(x0,y0,x1,y1)
	local dx = x0 - x1
	local dy = y0 - y1
	return math.sqrt(dx*dx + dy*dy)
end