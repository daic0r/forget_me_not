describe("Motion tests", function()
   local Motion = require("forget_me_not.motion")
   it("parse a motion", function()
      local str = "j"
      local m = Motion.new()
      m:parse(str)
      assert.are.equal(m.motion, "j")
      assert.are.equal(m.category, Motion.categories.VERTICAL)
      str = "f/"
      m:parse(str)
      assert.are.equal(m.motion, "f/")
      assert.are.equal(m.category, Motion.categories.HORIZONTAL)
   end)
end)
