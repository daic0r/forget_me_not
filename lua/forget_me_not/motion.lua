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
   categories = {
      VERTICAL = 0,
      HORIZONTAL = 1
   }
}

-- Pattern matching for motions
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
   local ret = {
      motion = "",
      category = nil,
   }
   if motion ~= nil then
      ret.motion = motion
   end
   return setmetatable(ret, Motion)
end

-- @param str: string
-- @return true if a motion was parsed, false otherwise
function Motion:parse(str)
   if #str == 0 then
      return false
   end
   for i = math.min(2, #str), 1, -1 do
      local keys = string.sub(str, 1, i)
      if Motion.vertical_motions[keys] then
         self.motion = keys
         self.category = Motion.categories.VERTICAL
         return true
      elseif Motion.horizontal_motions[keys] then
         self.motion = keys
         self.category = Motion.categories.HORIZONTAL
         return true
      end
   end
   return false
end

return Motion
