=-- cookie_init.lua
local _M = {}

function _M.init_cookie_store(cookie_store)
    local cjson = require("cjson")
    
    -- Define cookie groups with multiple cookies
    local c_groups = {
        ["cookie_group_1"] = {
            {name = "csrftoken", value = "EDI9av3XPeUGxRJRwF8G9O8T1LlBwIc8", domain = "scopedlens.com", path = "/", expires = "2025-11-01T11:44:03.203Z", http_only = true, secure = true, same_site = "Lax"},
            {name = "sessionid", value = "vlxcipmvpwom52utjdl62eyx8b8ogv45", domain = "scopedlens.com", path = "/", expires = "Session", http_only = true, secure = true, same_site = "Lax"},
            {name = "cf_clearance", value = "vMu4h05dWSKYHWl1cdkzpDhcBbzjt_uDZciwHsq20HM-1730548930-1.2.1.1-HwwcZAboGrnQ_timK4pRPehzFgk9yP5K_eF71Fwp8_ZyU7268llJjlooeB0C1sK2RPqg0p3vDG_ePFGfHoTr4MhOWX6XYcibcLzGwMvfPMmFcmM2zEvaaKG2UBPdnOEJFLafspbfBhBYvsGaa440AK_ZG9_UbLM..TTKtqh0u5IExpZILl2Ij.v0xWfTYxE3Ge9qwoTcMu3AzCcWAHboOIgHqzMtEu5Rhfkj1sSNekOXMaFMulX7bAJ0bA9CXt13Z0i_GlYovcdt_npZUwipcqSC8nCYtXGuVb07hgI7nhS8IZkz9eokRKHrGP8tSuvChONG.oxqR8YIBluuE664_bWQxsx0fVgddDCJ_AetP2VUtg1R9d7mKSzxEj_5qgOf", domain = ".scopedlens.com", path = "/", expires = "2025-11-02T17:02:11.056Z", http_only = true, secure = true, same_site = "None"},
        },
   
    }

    -- Encode each cookie group as JSON and store in shared memory
    for group_name, cookies in pairs(c_groups) do
        local cookie_json = cjson.encode({cookies = cookies})
        cookie_store:set(group_name, cookie_json)
    end
end

function _M.select_random_cookie_group(cookie_store)
    local cjson = require("cjson.safe")
    
    -- Retrieve all cookie group names
    local group_names = cookie_store:get_keys(0)

    -- Select a random group
    if #group_names > 0 then
        local random_group = group_names[math.random(#group_names)]
        
        -- Retrieve and decode the selected cookie group JSON
        local cookie_group_json = cookie_store:get(random_group)
        local cookie_group = cjson.decode(cookie_group_json)
        
        -- Set the selected cookies in ngx.ctx for later access in header_filter_by_lua_block
        ngx.ctx.selected_cookies = cookie_group.cookies
    else
        ngx.log(ngx.ERR, "No cookie groups available.")
    end
end

return _M
