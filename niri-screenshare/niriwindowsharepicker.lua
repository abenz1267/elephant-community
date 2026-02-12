Name = "nirisharepicker"
NamePretty = "Niri Share-Picker"
FixedOrder = true
Icon = "view-restore"
Actions = {
    share = "%VALUE%",
}

function GetEntries()
    local entries = {}
    local handle = io.popen("niri msg -j windows")
    local json_output = handle:read("*a")
    handle:close()

    local data = jsonDecode(json_output)

    table.insert(entries, {
        Text = "Focused Window",
        Value = "niri msg action set-dynamic-cast-window",
    })

    table.insert(entries, {
        Text = "Monitor",
        Value = "niri msg action set-dynamic-cast-monitor",
    })

    table.insert(entries, {
        Text = "Clear Target",
        Value = "niri msg action clear-dynamic-cast-target",
    })

    for _, window in ipairs(data) do
        table.insert(entries, {
            Text = window.title,
            Value = "niri msg action set-dynamic-cast-window --id " .. tostring(window.id),
        })
    end

    return entries
end
