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
      ["g?"] = "ROT13_ENCODING",
      [">"] = "SHIFT_RIGHT",
      ["<"] = "SHIFT_LEFT",
      ["zf"] = "DEFINE_A_FOLD",
      ["g@"] = "CALL_FUNCTION",
   }
}

local operators_metatable = {
   __index = function(table, key)
      for keys, name in pairs(table) do
         if string.match(key, "^" .. keys) then
            return name
         end
      end
      return nil
   end,
}
setmetatable(Operator.operators, operators_metatable)

Operator.metatable = {
   __index = Operator,
   __eq = function(lhs, rhs)
      return lhs.operator == rhs.operator
   end,
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

function Operator:parse(str)
   if #str == 0 then
      return nil
   end
   for i = math.min(2, #str), 1, -1 do
      local keys = string.sub(str, 1, i)
      if Operator.operators[keys] then
         self.operator = keys
         return string.sub(str, i + 1)
      end
   end
   return nil
end

return Operator
