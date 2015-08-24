local config = require('config')

local function start()
    local srv = net.createServer(net.TCP, 30)
    srv:listen(12345, function(sock)
        sock:send(cjson.encode({states={0, 1}}))
    end)
end

return {start = start}
