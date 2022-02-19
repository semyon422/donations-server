local lapis = require("lapis")
local json_params = require("lapis.application").json_params
local app_helpers = require("lapis.application")
local app = lapis.Application()

app:enable("etlua")
app.layout = require("views.layout")

app:post("/json", json_params(function(self)
	local params = self.params
	return {json = params}
end))

local controllers = {
	"home",
	"users",
	"user",
	"donations",
	"donation",
}

for _, name in ipairs(controllers) do
	local controller = require("controllers." .. name)
	app:match(name, controller.path, app_helpers.respond_to(controller))
end

return app
