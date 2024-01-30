local Operator = {
   --[[
   |c|	c	change
   |d|	d	delete
   |y|	y	yank into register (does not change the text)
   |~|	~	swap case (only if 'tildeop' is set)
   |g~|	g~	swap case
   |gu|	gu	make lowercase
   |gU|	gU	make uppercase
   |!|	!	filter through an external program
   |=|	=	filter through 'equalprg' or C-indenting if empty
   |gq|	gq	text formatting
   |gw|	gw	text formatting with no cursor movement
   |g?|	g?	ROT13 encoding
   |>|	>	shift right
   |<|	<	shift left
   |zf|	zf	define a fold
   |g@|	g@	call function set with the 'operatorfunc' option
   --]]

   -- #TODO: check if dd and yy should stay here or if the second
   -- d and y should be made a motion
   operators = {
      ["c"] = "CHANGE",
      ["d"] = "DELETE",
      ["dd"] = "DELETE_LINEWISE",
      ["x"] = "DELETE_CHARACTER",
      ["y"] = "YANK",
      ["yy"] = "YANK_LINEWISE",
      ["r."] = "REPLACE_CHARACTER",
      ["~"] = "SWAP_CASE",
      ["g~"] = "SWAP_CASE_G",
      ["gu"] = "MAKE_LOWER_CASE",
      ["gU"] = "MAKE_UPPER_CASE",
      ["!"] = "FILTER_THROUGH_EXTERNAL_PROGRAM",
      ["="] = "FILTER_THROUGH_EQUALPRG",
      ["gq"] = "TEXT_FORMATTING",
      ["gw"] = "TEXT_FORMATTING_NO_CURSOR_MOVEMENT",
      ["g%?"] = "ROT13_ENCODING",
      [">"] = "SHIFT_RIGHT",
      ["<"] = "SHIFT_LEFT",
      ["zf"] = "DEFINE_A_FOLD",
      ["g%@"] = "CALL_FUNCTION",
   }
}

-- local operators_metatable = {
--    __index = function(table, key)
--       print("INDEXING " .. key)
--       for keys, name in pairs(table) do
--          if string.match(key, "^" .. keys) then
--             print("Matched " .. key .. " to " .. keys)
--             return keys
--          end
--       end
--       return nil
--    end,
-- }
-- setmetatable(Operator.operators, operators_metatable)

Operator.metatable = {
   __index = Operator,
   __eq = function(lhs, rhs)
      return lhs.operator == rhs.operator
   end,
   __tostring = function(self)
      return self.operator
   end
}

function Operator.new(op)
   local ret = {
      operator = "",
   }
   setmetatable(ret, Operator.metatable)
   if op ~= nil and Operator.operators[op] then
      ret.operator = op
   end
   return ret
end

function Operator.match_operator(str)
   for keys, name in pairs(Operator.operators) do
      local match = string.match(str, "^" .. keys)
      if match then
         return match
      end
   end
   return nil
end

function Operator:parse(str)
   if #str == 0 then
      return nil
   end
   for i = math.min(2, #str), 1, -1 do
      local keys = string.sub(str, 1, i)
      local matched_key = Operator.match_operator(keys)
      if matched_key then
         self.operator = matched_key
         return string.sub(str, #matched_key + 1)
      end
   end
   return nil
end

return Operator
