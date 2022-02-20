local Donations = require("models.donations")
local Users = require("models.users")
local preload = require("lapis.db.model").preload
local date = require("date")

local function to_unix_time(s)
	return date.diff(date(s):toutc(), date.epoch()):spanseconds()
end

local donations_c = {}

donations_c.path = "/donations"

function donations_c:GET()
	local donations = Donations:select()
	preload(donations, "user")

	for _, donation in ipairs(donations) do
		Donations:to_name(donation)
	end

	self.donations = donations
	return {render = true}
end

function donations_c:POST()
	local params = self.params

	local donation = Donations:create({
		user_id = tonumber(params.user_id),
		created_at = to_unix_time(params.created_at),
		is_complete = false,
		service_type = Donations.service_types:for_db(params.service_type),
		currency_in_type = Donations.currency_types:for_db(params.currency_in_type),
		currency_out_type = Donations.currency_types:for_db(params.currency_out_type),
		amount_in = tonumber(params.amount_in),
		amount_out = tonumber(params.amount_out),
	})
	Users:compute_amount(donation:get_user())

	return {redirect_to = self:url_for(donation)}
	-- return {json = {
	--     params = params,
	--     date = os.date("%c", to_unix_time(params.created_at)),
	-- }}
end

return donations_c
