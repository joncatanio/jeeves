#	Description:
#		Hilarious 420 notifier... cuz stoners crack us the fuck up.
#
#	Dependencies:
#		NONE
#
#	Configuration:
#		NONE

schedule = require "node-schedule"

module.exports = (robot) ->
   rule = new schedule.RecurrenceRule()
   rule.hour = 16
   rule.minute = 20
   rule.dayOfWeek = [0, new schedule.Range(1, 6)]

   schedule.scheduleJob rule, () ->
      if robot.brain.data.notify420
         room = robot.adapter.room_id
         robot.messageRoom room, "420 bitches!"

   robot.respond /ENABLE 420 NOTIFICATIONS/, (res) ->
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = true
      res.send "420 notifications enabled! Blaze it!"

   robot.respond /DISABLE 420 NOTIFICATIONS/, (res) ->
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = false
      res.send "420 notifications disabled... Wow."
