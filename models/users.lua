local Model = require("lapis.db.model").Model
local Donations = require("models.donations")

local Users = Model:extend("users", {
	relations = {
		{"donations", has_many = "donations", key = "user_id"},
	},
	url_params = function(self, req, ...)
		return "user", {user_id = self.id}, ...
	end,
})

function Users:compute_amount(user)
	user:get_donations()
	local sum = 0
	for _, donation in ipairs(user.donations) do
		Donations:to_name(donation)
		sum = sum + donation.amount_out_usd
	end
	user.donations_amount = sum
	user:update("donations_amount")
end

return Users
