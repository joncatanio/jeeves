#	Description:
#		Hilarious 420 notifier... cuz stoners crack us the fuck up.
#
#	Dependencies:
#		NONE
#
#	Configuration:
#		NONE
###
schedule = require "node-schedule"

module.exports = (robot) ->
   rule = new schedule.RecurrenceRule()
#   rule.hour = 23
#   rule.minute = 1
   rule.second = 1
   rule.dayOfWeek = [0, new schedule.Range(1, 6)]

   schedule.scheduleJob rule, () ->
#      if robot.brain.data.notify420
      console.log "420!"
#      robot.sendMessage process.env.HUBOT_GROUPME_ROOM_ID "420 bitches!"

   robot.respond /ENABLE 420 NOTIFICATIONS/, (res) ->
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = false
      res.send "420 notifications enabled! Blaze it!"

   robot.respond /DISABLE 420 NOTIFICATIONS/, (res) ->
      console.log res
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = true
      res.send "420 notifications disabled... Wow."
###
