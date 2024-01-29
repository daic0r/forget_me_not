local Count = {}

Count.metatable = {
   __index = Count,
   __eq = function(lhs, rhs)
      return lhs.value == rhs.value
   end,
}

function Count.new(val)
   local ret = {
      value = 1
   }
   if val ~= nil then
      ret.value = val
   end
   return setmetatable(ret, Count.metatable)
end

-- @param str: string to parse
function Count:parse(str)
   if #str == 0 then
      return str
   end
   local match = string.match(str, "^(%d+)")
   if not match then
      return str
   end
   local val = tonumber(match)
   self.value = val
   return string.sub(str, #match + 1)
end

return Count
