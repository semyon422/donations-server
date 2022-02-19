local Users = require("models.users")
local Donations = require("models.donations")

local user_c = {}

user_c.path = "/users/:user_id"

function user_c:GET()
	local user = Users:find(self.params.user_id)
	user:get_donations()

	for _, donation in ipairs(user.donations) do
		Donations:to_name(donation)
	end

	self.user = user
	self.currency_types = Donations.currency_types
	self.service_types = Donations.service_types
	return {render = true}
end

function user_c:POST()
	local params = self.params
	local user = Users:find(params.user_id)

	if params.method == "DELETE" then
		user:delete()
		return {redirect_to = "/"}
	elseif params.method == "PATCH" then
		user.name = params.name
		user.description = params.description
		user:update("name", "description")
	end

	return {redirect_to = self:url_for(user)}
end

return user_c
