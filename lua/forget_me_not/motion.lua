local Motion = {
   vertical_motions = {
      ["j"] = "UP",
      ["k"] = "DOWN",
      [vim.api.nvim_replace_termcodes("<C-u>", true, false, true)] = "HALF_PAGE_UP",
      [vim.api.nvim_replace_termcodes("<C-d>", true, false, true)] = "HALF_PAGE_DOWN",
      [vim.api.nvim_replace_termcodes("<C-b>", true, false, true)] = "PAGE_UP",
      [vim.api.nvim_replace_termcodes("<C-f>", true, false, true)] = "PAGE_DOWN",
      ["G"] = "END_OF_FILE",
      ["gg"] = "BEGINNING_OF_FILE",
   },
   horizontal_motions = {
      ["h"] = "LEFT",
      ["l"] = "RIGHT",
      ["w"] = "WORD",
      ["e"] = "WORD_END",
      ["b"] = "WORD_START",
      ["W"] = "CAPITAL_WORD_FORWARD",
      ["B"] = "CAPITAL_WORD_BACKWARD",
      ["$"] = "END_OF_LINE",
      ["0"] = "BEGINNING_OF_LINE",
      ["ge"] = "BACK_TO_END_OF_WORD",
      ["gE"] = "BACK_TO_END_OF_CAPITAL_WORD",
      ["^"] = "FIRST_NON_BLANK",
      ["_"] = "LAST_NON_BLANK",
      ["f."] = "FIND_CHAR_FORWARD",
      ["F."] = "FIND_CHAR_BACKWARD",
      ["t."] = "FIND_CHAR_TILL_FORWARD",
      ["T."] = "FIND_CHAR_TILL_BACKWARD",
   },
   motion = "",
   category = nil,
   categories = {
      VERTICAL = 0,
      HORIZONTAL = 1
   }
}

local motion_mt = {
   __index = function(table, key)
      for keys, name in pairs(table) do
         if string.match(key, "^" .. keys) then
            return name
         end
      end
      return nil
   end
}
setmetatable(Motion.vertical_motions, motion_mt)
setmetatable(Motion.horizontal_motions, motion_mt)

-- @param motion: string
-- @return Motion
function Motion.new(motion)
   local ret = {}
   if motion ~= nil then
      ret.motion = motion
   end
   return setmetatable(ret, {
      __index = Motion
   })
end

-- @param str: string
-- @return true if a motion was parsed, false otherwise
function Motion:parse(str)
   if #str == 0 then
      return false
   elseif #str == 1 then
      local first = string.sub(str, 1, 1)
      if Motion.vertical_motions[first] then
         self.motion = first
         self.category = Motion.categories.VERTICAL
         return true
      elseif Motion.horizontal_motions[first] then
         self.motion = first
         self.category = Motion.categories.HORIZONTAL
         return true
      end
   else
      local first_two = string.sub(str, 1, 2)
      local first = string.sub(str, 1, 1)
      if Motion.vertical_motions[first_two] then
         self.motion = first_two
         self.category = Motion.categories.VERTICAL
         return true
      elseif Motion.vertical_motions[first] then
         self.motion = first
         self.category = Motion.categories.VERTICAL
         return true
      end
      if Motion.horizontal_motions[first_two] then
         self.motion = first_two
         self.category = Motion.categories.HORIZONTAL
         return true
      elseif Motion.vertical_motions[first] then
         self.motion = first
         self.category = Motion.categories.HORIZONTAL
         return true
      end
   end
   return false
end

return Motion
