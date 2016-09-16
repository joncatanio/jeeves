# Description:
#  Jeeves responses for when Dave and I need to Jersey Rage!
#
# Commands:
#  Did you just talk about my family - Jersey girls get mad!
#
# Group(s):
#  All

module.exports = (robot) ->
   robot.hear /did you just t(o|a|oa)lk about my (family|fam ily)\?*!*/i, (res) ->
      res.send "http://i.imgur.com/b55SAIk.jpg"
