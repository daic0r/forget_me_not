local cnt = require("forget_me_not.count")

local Command = {
   prototype = {
      count = cnt.new()
   }
}

Command.new = function(count)
   local ret = {}
   if count ~= nil then
      ret.count = count
   end
   return setmetatable(ret, {
      __index = Command.prototype
   })
end

return Command
