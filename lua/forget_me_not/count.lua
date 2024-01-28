local Count = {
   prototype = {
      value = 1
   }
}

Count.new = function(val)
   local ret = {}
   if val ~= nil then
      ret.value = val
   end
   return setmetatable(ret, {
      __index = Count.prototype
   })
end

return Count
