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
   rule.hour = 1
   rule.minute = 7
   rule.dayOfWeek = [0, new schedule.Range(1, 6)]

   schedule.scheduleJob rule, () ->
      if robot.brain.data.notify420
         console.log "420!"
         group = '<%= ENV['HUBOT_GROUPME_ROOM_ID'] %>'
         robot.sendMessage room "420 bitches!"

   robot.respond /ENABLE 420 NOTIFICATIONS/, (res) ->
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = true
      res.send "420 notifications enabled! Blaze it!"

   robot.respond /DISABLE 420 NOTIFICATIONS/, (res) ->
      console.log res
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = false
      res.send "420 notifications disabled... Wow."
