describe("Command:", function()
   it("should be able to parse a command", function()
      local Command = require("forget_me_not.command")
      local cmd = Command.new()
      local str = "3d2w"
      str = cmd:parse(str)
      assert.are.equal(str, "")
      assert.is_true(cmd:is_valid())
      assert.are.equal(3, cmd.count_op.value)
      assert.are.equal("d", cmd.operator.operator)
      assert.are.equal(2, cmd.count_motion.value)
      assert.are.equal("w", cmd.motion.motion, "w")

      str = "y2f,"
      str = cmd:parse(str)
      assert.are.equal(str, "")
      assert.is_true(cmd:is_valid())
      assert.are.equal(1, cmd.count_op.value)
      assert.are.equal("y", cmd.operator.operator)
      assert.are.equal(2, cmd.count_motion.value)
      assert.are.equal("f,", cmd.motion.motion)

      str = "2w"
      str = cmd:parse(str)
      assert.are.equal(str, "")
      assert.is_false(cmd.count_op:is_valid())
      assert.is_false(cmd.operator:is_valid()) 
      assert.are.equal(2, cmd.count_motion.value)
      assert.are.equal("w", cmd.motion.motion)

      str = "y2iw"
      str = cmd:parse(str)
      assert.are.equal(str, "")
      assert.is_true(cmd.operator:is_valid()) 
      assert.is_true(cmd.count_op:is_valid())
      assert.are.equal(cmd.count_motion.value, 2)
      assert.are.equal("iw", cmd.motion.motion)
   end)
end)
