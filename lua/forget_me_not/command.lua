local Count = require("forget_me_not.count")
local Operator = require("forget_me_not.operator")
local Motion = require("forget_me_not.motion")

local Command = {}

Command.metatable = {
   __index = Command,
   __eq = function(a, b)
      return a.count1 == b.count1 and
         a.operator == b.operator and
         a.count2 == b.count2 and
         a.motion == b.motion
   end,
   __tostring = function(self)
      return tostring(self.count1) .. tostring(self.operator) .. tostring(self.count2) .. tostring(self.motion)
   end
}

function Command.new(cnt1, op, cnt2, motion)
   local ret = {
      count1 = cnt1,
      operator = op,
      count2 = cnt2,
      motion = motion
   }
   return setmetatable(ret, Command.metatable)
end

function Command:parse(str)
   local cnt1 = Count.new()
   str = cnt1:parse(str)
   print("After Count 1: " .. str .. ", cnt1: " .. tostring(cnt1))
   local op = Operator.new()
   str = op:parse(str)
   if str == nil then
      return nil
   end
   print("After op: " .. str .. ", op: " .. tostring(op))
   local cnt2 = Count.new()
   str = cnt2:parse(str)
   print("After Count 2: " .. str .. ", cnt2: " .. tostring(cnt2))
   local motion = Motion.new()
   str = motion:parse(str)
   if str == nil then
      return nil
   end
   print("After motion: " .. str .. ", motion: " .. tostring(motion))
   self.count1, self.operator, self.count2, self.motion = cnt1, op, cnt2, motion
   print("Command: " .. tostring(self))
   return str
end

return Command
