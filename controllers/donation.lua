local Donations = require("models.donations")

local donation_c = {}

donation_c.path = "/donations/:donation_id"

function donation_c:GET()
	local donation = Donations:find(self.params.donation_id)
	donation:get_user()
	Donations:to_name(donation)
	self.donation = donation
	return {render = true}
end

function donation_c:POST()
	local params = self.params
	local donation = Donations:find(params.donation_id)
	Donations:to_name(donation)

	if params.method == "DELETE" then
		donation:delete()
		return {redirect_to = "/"}
	elseif params.method == "PATCH" then
		donation.is_complete = not donation.is_complete
		donation:update("is_complete")
	end

	return {redirect_to = self:url_for(donation)}
end

return donation_c
