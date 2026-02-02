Name = "nerdfont"
NamePretty = "Nerd Font Icons"

local cache_dir = os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")
local cache_file = cache_dir .. "/nerdfont/icons.txt"

-- downloads once, then uses cached file
local json_url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json"

local function build_cache()
	os.execute("mkdir -p " .. cache_dir .. "/nerdfont")
	os.execute(
		"curl -sL '"
			.. json_url
			.. "'"
			.. [[ | jq -r 'del(.METADATA) | to_entries[] | "\(.value.char)\t\(.key)"']]
			.. " > "
			.. cache_file
	)
end

function GetEntries()
	local entries = {}

	local f = io.open(cache_file, "r")
	if not f then
		build_cache()
		f = io.open(cache_file, "r")
		if not f then
			return entries
		end
	end

	for line in f:lines() do
		local icon, name = line:match("^(.-)\t(.+)$")
		if icon and name then
			table.insert(entries, {
				Text = icon .. "  " .. name,
				Actions = {
					activate = "printf '%s' '" .. icon .. "' | wl-copy",
				},
			})
		end
	end

	f:close()
	return entries
end
