local M = {}

local utils = require("forget_me_not.utils")
local motions = utils.get_motions()

local esc =  vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

local key_sequence = ""

function M:register_tip(keys, message, timeout)
   self.tips = self.tips or {}
   self.tips[keys] = { msg = message, timeout = timeout or 1000 }
end

function M:setup()
   local ns = vim.api.nvim_create_namespace("ic0r.forget_me_not")
   vim.api.nvim_set_hl(ns, "Normal", { fg = "lightred",  })
   local float_border = vim.api.nvim_get_hl(0, { name = "DiagnosticOk",  })
   -- P(float_border)
   vim.api.nvim_set_hl(ns, "FloatBorder", float_border)
   vim.api.nvim_set_hl(ns, "FloatTitle", { fg = "lightblue",  })

   local show_tip = function(msg)
      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, false, {
         relative = "cursor",
         width = 40,
         height = type(msg.msg) == "table" and #msg.msg or 1,
         row = 1,
         col = 1,
         style = "minimal",
         border = "rounded",
         title = "Forget me not",
      })
      vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, type(msg.msg) == "table" and msg.msg or {msg.msg})
      vim.api.nvim_win_set_hl_ns(win, ns)
      local timer = vim.uv.new_timer()
      timer:start(msg.timeout, 0, vim.schedule_wrap(function()
         vim.api.nvim_win_close(win, true)
         vim.api.nvim_buf_delete(buf, {force = true})
      end))
   end

   vim.on_key(function(key)
      key_sequence = key_sequence .. key
      if key == esc then
         print("Escape")
         key_sequence = ""
         return nil
      end

      for keys, msg in pairs(self.tips) do
         if string.find(key_sequence, keys) then
            show_tip(msg)
            key_sequence = ""
         end 
      end
   end, ns)

   self.tips = {}
   -- M:register_tip("jk", "Exit insert mode", 2000)
end

return M
