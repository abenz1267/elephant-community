Name = "pass"
NamePretty = "Pass"
Icon = "dialog-password"
Cache = true
Actions = {
    copy = "wl-copy %VALUE% && sleep 5 && wl-copy --clear"
}

function GetEntries()
    local entries = {}
    local password_store = os.getenv("PASSWORD_STORE_DIR") or
        (os.getenv("HOME") .. "/.password-store")

    -- Find all .gpg files recursively
    local handle = io.popen("find '" .. password_store ..
        "' -type f -name '*.gpg' 2>/dev/null")

    if handle then
        for line in handle:lines() do
            -- Remove prefix path
            local password_name = line:gsub("^" .. password_store:gsub("([^%w])", "%%%1") .. "/", "")
            -- Remove .gpg extension
            password_name = password_name:gsub("%.gpg$", "")

            -- Get the actual password (first line of pass show)
            local pass_handle = io.popen("pass show '" .. password_name .. "' 2>/dev/null")
            local password = ""
            if pass_handle then
                password = pass_handle:read("*l") or ""
                pass_handle:close()
            end

            table.insert(entries, {
                Text = password_name,
                Value = password
            })
        end
        handle:close()
    end

    return entries
end
