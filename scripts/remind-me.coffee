#	Description:
#    Reminds people of stuff
#
#	Dependencies:
#	  node-schedule
#
#	Configuration:
#	  NONE

schedule = require "node-schedule"

MINUTE_MAX = 59
HOUR_MAX = 23
DAY_OF_MONTH_MAX = 31
MONTH_MAX = 12

class Reminder
   constructor: (description, rule, job) ->
      # Reminder description
      @description = description
      # Reccurrence rule or datetime
      @rule = rule
      # job scheduled to run
      @job = job

convertMonthToNum = (month) ->
   return new Date(Date.parse(month + " 16, 1995")).getMonth() + 1

validateRule = (rule) ->
   date = null
   if rule instanceof schedule.RecurrenceRule
      date = new Date new Date().getFullYear(), rule.month, rule.date, rule.hour, rule.minute, 0
   else if rule instanceof Date
      date = rule
   else
      return false

   today = new Date()
   return +date > +today

printFormatError = (res, msg) ->
   message = ["Formatting error: " + msg]
   message.push "/remind me description: month day [, year [ hour [ minute ] ] ]"
   res.send message.join("\n")

# Returns a valid date, given a RecurrenceRule or Date object
parseReminder = (reminder) ->
   rule = reminder.rule
   if rule instanceof schedule.RecurrenceRule
      if not validateRule(rule)
         return new Date new Date().getFullYear() + 1, rule.month, rule.date, rule.hour, rule.minute, 0
      else
         return new Date new Date().getFullYear(), rule.month, rule.date, rule.hour, rule.minute, 0
   else if rule instanceof Date
      return rule
   return null

module.exports = (robot) ->
   # Map of current cron jobs scheduled to run
   robot.brain.data.reminders = {}

   # Reminder: month day [, year [ hour [ minute ] ] ]
   # (text): (Jan - Dec) (1-31) [, (current year - beyond) [ (0-23) [ (1-12) ] ] ]
   robot.respond /remind me(?: about)? (.+):? ([a-zA-Z]{3,9}) ([0-9]{1,2})(?:st|nd|rd|th)?,?( [0-9]{4})?( [0-9]{1,2})?( [0-9]{1,2})?/, (res) ->
      reminder = res.match[1].toLowerCase()
      if reminder[reminder.length - 1] is ":"
         reminder = reminder.substring(0, reminder.length - 1)

      month = convertMonthToNum(res.match[2])
      if month is NaN
         printFormatError(res, "invalid month")
         return

      dayOfMonth = +res.match[3]
      year = if isNaN(+res.match[4]) then 0 else +res.match[4]
      hour = if isNaN(+res.match[5]) then 8 else +res.match[5]
      minute = if isNaN(+res.match[6]) then 0 else +res.match[6]

      if robot.brain.data.reminders[reminder]?
         res.send "Job already scheduled. Kill the reminder and reschedule to replace."
         return
      else if not minute? or minute > MINUTE_MAX or minute < 0
         printFormatError(res, "minute out of range [0-59]")
         return
      else if not hour? or hour > HOUR_MAX or hour < 0
         printFormatError(res, "hour out of range [0-23]")
         return
      else if not dayOfMonth? or dayOfMonth > DAY_OF_MONTH_MAX or dayOfMonth < 1
         printFormatError(res, "day of month out of range [1-31]")
         return
      else if not month? or month > MONTH_MAX or month < 1
         printFormatError(res, "month out of range [1-12]")
         return
      else if not year? or year is 0
         # Reoccurring
         rule = new schedule.RecurrenceRule()
         rule.minute = minute
         rule.hour = hour
         rule.date = dayOfMonth
         rule.month = month - 1
      else
         # One occurrence
         rule = new Date year, month - 1, dayOfMonth, hour, minute, 0

      if not validateRule(rule) and rule not instanceof schedule.RecurrenceRule
         res.send "Date is invalid or before the current date and time."
         return

      scheduledJob = schedule.scheduleJob rule, () ->
         robot.messageRoom robot.adapter.room_id, reminder
         if rule not instanceof schedule.RecurrenceRule
            delete robot.brain.data.reminders[reminder]

      robot.brain.data.reminders[reminder] = new Reminder reminder, rule, scheduledJob
      res.send "Reminder \"" + reminder + "\" scheduled for " + parseReminder(robot.brain.data.reminders[reminder])

   robot.respond /list reminders/, (res) ->
      message = []
      room = robot.adapter.room_id

      if Object.keys(robot.brain.data.reminders).length == 0
         res.send "There are currently no scheduled reminders."
         return

      for reminder, reminderObj of robot.brain.data.reminders
         readableDate = parseReminder(reminderObj)
         if message.length >= 5
            robot.messageRoom room, message.join("\n")
            message = []

         reoccur = if reminderObj.rule instanceof schedule.RecurrenceRule then "[REOCCURING] " else ""
         message.push reoccur + reminder + " -- " + readableDate

      if message.length > 0
         robot.messageRoom room, message.join("\n")

   robot.respond /remove reminder (.+)/, (res) ->
      reminder = res.match[1].toLowerCase()
      reminderObj = robot.brain.data.reminders[reminder]

      if reminderObj?
         reminderObj.job.cancel()
         delete robot.brain.data.reminders[reminder]
         res.send "Reminder \"" + reminderObj.description + "\" has been removed."
      else
         res.send "Reminder to remove was not found."

#   robot.respond /purge reminders/, (res) ->
#      for job, jobObj of schedule.scheduledJobs
#         jobObj.cancel()
