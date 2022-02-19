local config = require("lapis.config")

-- lapis
config("development", {
	port = 8095,
	secret = "please-change-me",
	hmac_digest = "sha256",
	session_name = "lapis_session1",
	code_cache = "off",
	measure_performance = false,
	logging = {
		queries	= true,
		requests = true,
	},
	mysql = {
		host = "127.0.0.1",
		user = "username",
		password = "password",
		database = "donations",
	},
})

