local model = require("lapis.db.model")
local Model, enum = model.Model, model.enum

local Donations = Model:extend("donations", {
	relations = {
		{"user", belongs_to = "users", key = "user_id"},
	},
	url_params = function(self, req, ...)
		return "donation", {donation_id = self.id}, ...
	end,
})

Donations.service_types = enum({
	paypal = 1,
	patreon = 2,
	liberapay = 3,
	boosty = 4,
	bank = 5,
})

Donations.currency_types = enum({
	RUB = 1,
	USD = 2,
	EUR = 3,
})

function Donations:to_name(donation)
	donation.service = Donations.service_types:to_name(donation.service_type)
	donation.currency_in = Donations.currency_types:to_name(donation.currency_in_type)
	donation.currency_out = Donations.currency_types:to_name(donation.currency_out_type)
	if donation.is_complete == 1 then
		donation.is_complete = true
	else
		donation.is_complete = false
	end 
end

return Donations
