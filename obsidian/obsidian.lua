Name = "obsidian"
NamePretty = "Obsidian"
Icon = "obsidian"
Placeholder = "Search Notes..."
Match = "Fuzzy"
Cache = "True"

Action = "obsidian '%VALUE%'"

local function url_encode(str)
	if not str then
		return ""
	end
	str = str:gsub("\n", "\r\n")
	-- Encode non-alphanumeric chars (excluding standard safe chars)
	str = str:gsub("([^%w %-%_%.%~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	return str:gsub(" ", "%%20")
end

function GetEntries()
	local entries = {}
	local home = os.getenv("HOME")
	local vault_config = home .. "/.config/obsidian/obsidian.json"

	-- Check config existence
	local f = io.open(vault_config, "r")
	if f ~= nil then
		io.close(f)
	else
		return entries
	end

	-- Extract vault path using jq (matches your bash script logic for the 1st vault)
	local handle_vault = io.popen("jq -r '.vaults | to_entries | .[0].value.path' " .. vault_config)
	local vault_path = handle_vault:read("*a"):gsub("%s+", "")
	handle_vault:close()

	if vault_path == "" then
		return entries
	end

	-- Extract just the folder name from the path to use as the 'vault=' parameter
	-- e.g., /home/Documents/MyVault -> MyVault
	local vault_name = vault_path:match("([^/]+)$")
	local encoded_vault_name = url_encode(vault_name)

	-- Use fd to get relative paths for cleaner display and URI compatibility
	local fd_cmd = "fd --extension md --type file --strip-cwd-prefix --base-directory='" .. vault_path .. "'"
	local handle_fd = io.popen(fd_cmd)

	for relative_path in handle_fd:lines() do
		-- Construct the specific URI: obsidian://open?vault=NAME&file=FILE
		-- This prevents vault ambiguity compared to using absolute paths
		local encoded_file = url_encode(relative_path)
		local uri = "obsidian://open?vault=" .. encoded_vault_name .. "&file=" .. encoded_file

		table.insert(entries, {
			Text = relative_path:gsub("%.md$", ""),
			Subtext = "Obsidian Note",
			Value = uri,
			Icon = "obsidian",
		})
	end
	handle_fd:close()

	return entries
end
