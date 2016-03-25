# Description:
# 	Rolls a number.
#
# Commands:
# -/roll - Rolls a number from [1, 100] inclusive.
#
# Group:
#	Any

module.exports = (robot) ->
   robot.hear /roll/i, (res) ->
      # TextMessage {user, text, id, done, room}
      textMessage = res.message
      user = textMessage.user

      min = 1
      max = 100
      randomNum = Math.floor(Math.random() * max) + min

      res.send "#{user.name} rolls #{randomNum} (#{min}-#{max})"
