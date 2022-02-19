local home_c = {}

home_c.path = "/"

function home_c:GET()
	return {render = true}
end

return home_c
