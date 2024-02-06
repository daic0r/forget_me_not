local M = {
   tips = {}
}

local Command = require("forget_me_not.command")

local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

local key_sequence = ""
local parse_timer = nil
local parsed_commands = {}
local concatted_cmds = ""
local ns = nil

local EXPECT = {
   CountOperator = 0,
   Operator = 1,
   CountMotion = 2,
   Motion = 3
}

local current = EXPECT.CountOperator

function M:register_tip(keys, message, timeout)
   --self.tips = self.tips or {}
   self.tips[keys] = { msg = message, timeout = timeout or 1000 }
end

function M:setup()
   ns = vim.api.nvim_create_namespace("ic0r.forget_me_not")
   vim.api.nvim_set_hl(ns, "Normal", { fg = "lightred", })
   local float_border = vim.api.nvim_get_hl(0, { name = "DiagnosticOk", })
   -- P(float_border)
   vim.api.nvim_set_hl(ns, "FloatBorder", float_border)
   vim.api.nvim_set_hl(ns, "FloatTitle", { fg = "lightblue", })

   key_sequence = ""

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
      vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, type(msg.msg) == "table" and msg.msg or { msg.msg })
      vim.api.nvim_win_set_hl_ns(win, ns)
      local timer = vim.uv.new_timer()
      timer:start(msg.timeout, 0, vim.schedule_wrap(function()
         vim.api.nvim_win_close(win, true)
         vim.api.nvim_buf_delete(buf, { force = true })
      end))
   end

   parse_timer = vim.uv.new_timer()

   vim.on_key(function(key)
      key_sequence = key_sequence .. key
      parse_timer:start(500, 0, function()
         local cmd = Command.new()
         repeat
            key_sequence = cmd:parse(key_sequence)
            if cmd:is_valid() then
               table.insert(parsed_commands, cmd)
               concatted_cmds = concatted_cmds .. tostring(cmd)
            end
         until not cmd:is_valid() or #key_sequence == 0
         -- print("Parsing: " .. key_sequence)
         -- key_sequence = cmd:parse(key_sequence)
         if cmd:is_valid() then
            --table.insert(parsed_commands, cmd)
            --concatted_cmds = concatted_cmds .. tostring(cmd)
            print("Parsed command: " .. concatted_cmds .. ", " .. table.getn(parsed_commands))
         else
            key_sequence = ""
            concatted_cmds = ""
         end
         -- else
         --    print("Invalid command: " .. tostring(cmd))
         --    key_sequence = ""
         --    concatted_cmds = ""
         --    parsed_commands = {}
         -- end
         for keys, msg in pairs(self.tips) do
            if string.find(concatted_cmds, keys) then
               vim.schedule(function()
                  show_tip(msg)
               end)
            end
         end
         key_sequence = ""
         parsed_commands = {}
         concatted_cmds = ""
      end)
      if key == esc then
         print("Escape")
         key_sequence = ""
         parsed_commands = {}
         concatted_cmds = ""
         return
      end

   end, ns)
end

print("Loaded forget_me_not")
M:register_tip("yiw", "Yanked inside word", 2000)

M:setup()

return M
