local Count = require("forget_me_not.count")
local Operator = require("forget_me_not.operator")
local Motion = require("forget_me_not.motion")

local Command = {}

Command.metatable = {
   __index = Command,
   __eq = function(a, b)
      return a.count_op == b.count_op and
         a.operator == b.operator and
         a.count_motion == b.count_motion and
         a.motion == b.motion
   end,
   __tostring = function(self)
      return tostring(self.count_op) .. tostring(self.operator) .. tostring(self.count_motion) .. tostring(self.motion)
   end
}

function Command.new(cnt1, op, cnt2, motion)
   local ret = {
      count_op = cnt1,
      operator = op,
      count_motion = cnt2,
      motion = motion
   }
   return setmetatable(ret, Command.metatable)
end

function Command:parse(str)
   local cnt1 = Count.new()
   str = cnt1:parse(str)
   -- No explicit count means count of 1
   if not cnt1:is_valid() then
      cnt1 = Count.new(1)
   end
   --print("After Count 1: " .. str .. ", cnt1: " .. tostring(cnt1))
   local op = Operator.new()
   str = op:parse(str)
   -- We can only have a second count if we have an operator
   local cnt2 = Count.new()
   if op:is_valid() then
      --print("After op: " .. str .. ", op: " .. tostring(op))
      str = cnt2:parse(str)
      if not cnt2:is_valid() then
         cnt2 = Count.new(1)
      end
   end
   --print("After Count 2: " .. str .. ", cnt2: " .. tostring(cnt2))
   local motion = Motion.new()
   str = motion:parse(str)
   if not op:is_valid() then
      cnt2 = cnt1
      cnt1 = Count.new()
   end
   --print("After motion: " .. str .. ", motion: " .. tostring(motion))
   self.count_op, self.operator, self.count_motion, self.motion = cnt1, op, cnt2, motion
   print("Command: " .. tostring(self))
   return str
end

return Command
