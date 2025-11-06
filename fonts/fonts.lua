Name = "fonts"
NamePretty = "Fonts"
Icon = "font-select"
HideFromProviderlist = false
Cache = false
function GetEntries()
    local entries = {}
    local seen_fonts = {}
    local preview_text =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum."
    local handle = io.popen("fc-list : family | head -100")
    if handle then
        for line in handle:lines() do
            local font_name = line:match("^([^,]+)")
            if font_name then
                font_name = font_name:gsub("^%s*(.-)%s*$", "%1")
                if not seen_fonts[font_name] then
                    seen_fonts[font_name] = true
                    local escaped_font = font_name:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                    local preview_markup = "<span font_desc='"
                        .. escaped_font
                        .. " 22' weight='bold'>"
                        .. font_name
                        .. "</span>\n\n"
                        .. "<span font_desc='"
                        .. escaped_font
                        .. " 15' weight='bold'>Standard Weight Text</span>\n"
                        .. "<span font_desc='"
                        .. escaped_font
                        .. " 12'>"
                        .. preview_text
                        .. "</span>\n\n"
                        .. "<span font_desc='"
                        .. escaped_font
                        .. " 15' weight='bold'>Bold Text</span>\n"
                        .. "<span font_desc='"
                        .. escaped_font
                        .. " 12' weight='bold'>"
                        .. preview_text
                        .. "</span>\n\n"
                        .. "<span font_desc='"
                        .. escaped_font
                        .. " 15' weight='bold'>Italic Text</span>\n"
                        .. "<span font_desc='"
                        .. escaped_font
                        .. " 12' style='italic'>"
                        .. preview_text
                        .. "</span>"
                    table.insert(entries, {
                        Text = font_name,
                        Value = font_name,
                        Preview = preview_markup,
                        PreviewType = "pango",
                        Actions = {
                            copy = "echo '" .. font_name .. "' | wl-copy && notify-send 'Copied' '" .. font_name .. "'",
                        },
                    })
                end
            end
        end
        handle:close()
    end
    if #entries == 0 then
        table.insert(entries, {
            Text = "No fonts found",
            Value = "",
        })
    end
    return entries
end
