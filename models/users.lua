local Model = require("lapis.db.model").Model

local Users = Model:extend("users", {
	relations = {
		{"donations", has_many = "donations", key = "user_id"},
	},
	url_params = function(self, req, ...)
		return "user", {user_id = self.id}, ...
	end,
})

return Users
