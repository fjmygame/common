-- Http 请求 get post
--
local skynet    = require "skynet"
local json      = require "cjson"
local sname     = require "sname"
require "bash"

local M = {}
function M.get(url, get, header, no_reply)
    --skynet.error("http get:", url, json.encode(get))
    if no_reply then
        return skynet.send(sname.WEB, "lua", "request", url, get, nil, header, no_reply)
    else
        return skynet.call(sname.WEB, "lua", "request", url, get, nil, header, no_reply)
    end
end

function M.post(url, post, header, no_reply)
    skynet.error("http post:", url, post)
    if no_reply then
        return skynet.send(sname.WEB, "lua", "request", url, nil, post, header, no_reply)
    else
        return skynet.call(sname.WEB, "lua", "request", url, nil, post, header, no_reply)
    end
end

function M.url_encoding(tbl, encode)
    local data = {}
    for k, v in pairs(tbl) do
        table.insert(data, string.format("%s=%s", k, v))
    end

    local url = table.concat(data, "&")
    if encode then
        return string.gsub(url, "([^A-Za-z0-9])", function(c) 
            return string.format("%%%02X", string.byte(c)) 
        end)
    else
        return url
    end
end

return M
