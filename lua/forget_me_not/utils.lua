local M = {}

function M.get_motions()
   local UP = "j"
   local DOWN = "k"
   local LEFT = "h"
   local RIGHT = "l"
   local HALF_PAGE_UP = vim.api.nvim_replace_termcodes("<C-u>", true, false, true)
   local HALF_PAGE_DOWN = vim.api.nvim_replace_termcodes("<C-d>", true, false, true)
   local PAGE_UP = vim.api.nvim_replace_termcodes("<C-b>", true, false, true)
   local PAGE_DOWN = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
   local WORD = "w"
   local WORD_END = "e"
   local WORD_START = "b"
   local CAPITAL_WORD_FORWARD = "W"
   local CAPITAL_WORD_BACKWARD = "B"
   local END_OF_LINE = "$"
   local BEGINNING_OF_LINE = "0"
   local END_OF_FILE = "G"
   local BEGINNING_OF_FILE = "gg"
   return {
      [UP] = "up",
      [DOWN] = "down",
      [LEFT] = "left",
      [RIGHT] = "right",
      [HALF_PAGE_UP] = "half_page_up",
      [HALF_PAGE_DOWN] = "half_page_down",
      [PAGE_UP] = "page_up",
      [PAGE_DOWN] = "page_down",
      [WORD] = "word",
      [WORD_END] = "word_end",
      [WORD_START] = "word_start",
      [CAPITAL_WORD_FORWARD] = "capital_word_forward",
      [CAPITAL_WORD_BACKWARD] = "capital_word_backward",
      [END_OF_LINE] = "end_of_line",
      [BEGINNING_OF_LINE] = "beginning_of_line",
      [END_OF_FILE] = "end_of_file",
      [BEGINNING_OF_FILE] = "beginning_of_file",
   }
end

return M
