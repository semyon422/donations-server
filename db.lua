local schema = require("lapis.db.schema")

local db = {}

-- CREATE DATABASE backend;

local tables = {
	"users",
	"donations",
}

local table_declarations = {}

local _types = schema.types
local types = {
	id = _types.id({null = false, unsigned = true}),
	fk_id = _types.integer({null = false, unsigned = true, default = 0}),
	size = _types.integer({null = false, unsigned = true, default = 0}),
	md5_hash = "BINARY(16) NOT NULL",
	time = _types.bigint({unsigned = true, default = 0}),
	boolean = _types.boolean({default = false}),
	float = _types.float({default = 0}),
	varchar = _types.varchar({default = ""}),
	enum = _types.enum,
	text = _types.text,
	ip = _types.integer({null = false, unsigned = true, default = 0}),
}
db.types = types

local options = {
	engine = "InnoDB",
	-- charset = "utf8mb4 COLLATE=utf8mb4_0900_ai_ci"
	charset = "utf8mb4 COLLATE=utf8mb4_unicode_ci"
}

-- https://stackoverflow.com/questions/766809/whats-the-difference-between-utf8-general-ci-and-utf8-unicode-ci
-- COLLATE=utf8mb4_0900_ai_ci
-- COLLATE=utf8mb4_unicode_520_ci

table_declarations.users = {
	{"id", types.id},
	{"name", types.varchar},
	{"description", types.text},
	{"donations_amount", types.float},
	"UNIQUE KEY `name` (`name`)",
	"KEY `donations_amount` (`donations_amount`)",
}

table_declarations.donations = {
	{"id", types.id},
	{"user_id", types.fk_id},
	{"created_at", types.time},
	{"is_complete", types.boolean},
	{"service_type", types.enum},
	{"currency_in_type", types.enum},
	{"currency_out_type", types.enum},
	{"amount_in", types.float},
	{"amount_out", types.float},
	"KEY `user_id` (`user_id`)",
	"KEY `service_type` (`service_type`)",
}

function db.drop()
	for _, table in ipairs(tables) do
		schema.drop_table(table)
	end
end

function db.create()
	for _, table in ipairs(tables) do
		schema.create_table(table, table_declarations[table], options)
	end
end

return db
