describe("Motion:", function()
   local Motion = require("forget_me_not.motion")

   it("construct motion", function()
      local m = Motion.new()
      assert.are.equal(m.motion, nil)
      assert.are.equal(m.category, nil)
      assert.is_false(m:is_valid())

      local m2 = Motion.new("j")
      assert.is_true(m2:is_valid())
      assert.are.equal(m2.motion, "j")
      assert.are.equal(m2.category, Motion.categories.VERTICAL)
      local m3 = Motion.new("j")
      assert.is_true(m2 == m3)
   end)

   it("parse a motion", function()
      local str = "j"
      local m = Motion.new()
      local remain = m:parse(str)
      assert.are.equal(m.motion, "j")
      assert.are.equal(m.category, Motion.categories.VERTICAL)
      assert.are.equal(remain, "")

      str = "f/d"
      remain = m:parse(str)
      assert.are.equal(m.motion, "f/")
      assert.are.equal(m.category, Motion.categories.HORIZONTAL)
      assert.are.equal(remain, "d")

      str = "iWhallo"
      remain = m:parse(str)
      assert.are.equal(m.motion, "iW")
      assert.are.equal(m.category, Motion.categories.TEXT_OBJECT)
      assert.are.equal(remain, "hallo")

   end)
end)
