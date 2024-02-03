describe("Command:", function()
   it("should be able to parse a command", function()
      local Command = require("forget_me_not.command")
      local cmd = Command.new()
      local str = "3d2w"
      str = cmd:parse(str)
      assert.are.equal(str, "")
      assert.are.equal(cmd.count_op.value, 3)
      assert.are.equal(cmd.operator.operator, "d")
      assert.are.equal(cmd.count_motion.value, 2)
      assert.are.equal(cmd.motion.motion, "w")

      str = "y2f,"
      str = cmd:parse(str)
      assert.are.equal(str, "")
      assert.are.equal(cmd.count_op.value, 1)
      assert.are.equal(cmd.operator.operator, "y")
      assert.are.equal(cmd.count_motion.value, 2)
      assert.are.equal(cmd.motion.motion, "f,")

      str = "2w"
      str = cmd:parse(str)
      assert.are.equal(str, "")
      assert.is_false(cmd.count_op:is_valid())
      assert.is_false(cmd.operator:is_valid()) 
      assert.are.equal(cmd.count_motion.value, 2)
      assert.are.equal(cmd.motion.motion, "w")
   end)
end)
