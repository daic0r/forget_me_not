local pw = require("plenary.window.float")

local key_sequence = ""

local ns = vim.api.nvim_create_namespace("ic0r.forget_me_not")
vim.api.nvim_set_hl(ns, "Normal", { fg = "#ff0000",  })
local float_border = vim.api.nvim_get_hl(0, { name = "DiagnosticOk",  })
-- P(float_border)
vim.api.nvim_set_hl(ns, "FloatBorder", float_border)

local ns = vim.on_key(function(key)
   key_sequence = key_sequence .. key
   if string.find(key_sequence, "Vj") then
      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, false, {
         relative = "cursor",
         width = 40,
         height = 3,
         row = 1,
         col = 1,
         style = "minimal",
         border = "rounded"
      })
      vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, { "Hello, world!" })
      vim.api.nvim_win_set_hl_ns(win, ns)
      local timer = vim.uv.new_timer()
      timer:start(1000, 0, vim.schedule_wrap(function()
         vim.api.nvim_win_close(win, true)
         vim.api.nvim_buf_delete(buf, {force = true})
      end))
      key_sequence = ""
      return nil
   end
end, ns)

print(ns)

local ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor."

