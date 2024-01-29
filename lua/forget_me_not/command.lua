local Count = require("forget_me_not.count")
local Operator = require("forget_me_not.operator")
local Motion = require("forget_me_not.motion")

local Command = {}

function Command.new(cnt1, op, cnt2, motion)
   local ret = {
      count1 = cnt1,
      operator = op,
      count2 = cnt2,
      motion = motion
   }
   return setmetatable(ret, {
      __index = Command
   })
end

return Command
