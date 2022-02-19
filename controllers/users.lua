local Users = require("models.users")

local users_c = {}

users_c.path = "/users"

function users_c:GET()
	self.users = Users:select()
	return {render = true}
end

function users_c:POST()
	local params = self.params

	local user = Users:create({
		name = params.name,
		description = params.description,
		donations_amount = 0,
	})

	return {redirect_to = self:url_for(user)}
end

return users_c
