# Description:
# 	Rolls a number.
#
# Commands:
# -/roll [ min [ max ] ] - Rolls a number from [min, max] inclusive.
#
# Group:
#	Any

module.exports = (robot) ->
   robot.respond /roll( (\d+) (\d+))?/i, (res) ->
      # TextMessage {user, text, id, done, room}
      textMessage = res.message
      user = textMessage.user

      min = res.match[2] || 1
      max = res.match[3] || 100

      if parseInt(min, 10) >= parseInt(max, 10)
         min = 1
         max = 100

      randomNum = Math.floor(Math.random() * (max - min + 1)) + \
         parseInt(min, 10)

      res.send "#{user.name} rolls #{randomNum} (#{min}-#{max})"
