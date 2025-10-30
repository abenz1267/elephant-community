Name = "power-profiles"
NamePretty = "Power profiles"
HideFromProviderlist = true -- Change to false to have the menu appear in the Provider List
Cache = false
Action = "powerprofilesctl set %VALUE%; notify-send 'Power Profile' 'Set to %VALUE%'"

function GetEntries()
    local entries = {}
    local handle = io.popen("powerprofilesctl")

    if not handle then
        return entries
    end

    for line in handle:lines() do
        local profile_name = line:match("^[* ] ([%a-]+):")

        if profile_name then
            local is_current = line:match("^%*")

            table.insert(entries, {
                Text = profile_name:gsub("^%l", string.upper):gsub("-", " "),
                Value = profile_name,
                state = is_current and { "current" } or nil,
            })
        end
    end

    handle:close()

    if #entries == 0 then
        table.insert(entries, {
            Text = "No power profiles found",
            Value = "",
        })
    end

    return entries
end
