#	Description:
#		Hilarious 420 notifier... cuz stoners crack us the fuck up.
#
#	Dependencies:
#		NONE
#
#	Configuration:
#		NONE

schedule = require "node-schedule"

memes = [
   "http://img.memecdn.com/420-blaze-it_c_1131360.webp",
   "http://img.memecdn.com/also-nice-temperature-outside_o_5320763.webp",
   "http://i.imgur.com/F90nvZ2.jpg",
   "http://weknowmemes.com/wp-content/uploads/2013/04/high-dog-meme.jpg"
   "http://i.imgur.com/ymU48Db.webm",
   "http://puu.sh/41mMg.gif",
   "http://puu.sh/41mQ5.gif",
   "https://i.imgur.com/n41tcFI.jpg",
   "https://media4.giphy.com/media/CQMeuG5I0LPVu/200_s.gif",
   "https://media.giphy.com/media/2rTsUYN97qdR46j184/giphy.gif",
   "http://image.blingee.com/images19/content/output/000/000/000/7e9/805402018_216021.gif",
   "https://media1.giphy.com/media/1Htf8DnyeeWI/200_s.gif",
   "http://image.blingee.com/images19/content/output/000/000/000/7e3/822715060_1086719.gif",
   "https://media0.giphy.com/media/8DxZjIT6RT71e/200_s.gif",
   "http://i.imgur.com/NGFD11L.gif",
   "http://ecdn.funzypics.com/funnypicturesutopia/pics/17/Game-Of-Thrones---Game-Of-Thrizzle---Snoop-Dogg---420-Blaze-It-Draggy---I-Bought-Weed-From-That-Dragon-.jpg",
   "http://25.media.tumblr.com/0ce23dcc4e035696b97d4c6f006441f5/tumblr_mpqilkvC4Y1spo3yuo1_400.gif",
   "https://media.giphy.com/media/9dcPOhIUuKEms/giphy.gif",
   "http://spi3uk.itvnet.lv/upload2/articles/70/700580/images/_origin_420-pasaule-lielakie-3.jpg",
   "http://brandgeek.net/wp-content/uploads/2013/04/marijuana420.jpg",
   "https://i.warosu.org/data/cgl/img/0063/82/1352092647860.jpg",
   "http://i.imgur.com/2YdvmUK.jpg",
   "http://i3.kym-cdn.com/photos/images/newsfeed/000/499/656/6c7.png",
   "http://crazycrackerz.com/wp-content/uploads/2010/03/R2K2.jpg"
]

messages = [
   "420 bitches!",
   "Get skoned!",
   "Where that skunkunkunk at?!",
   "I can't see I'm so high!",
   "Oi! Light that grass!",
   "Yo let's boxhot dude!?",
   "Put some bomb ass dank ass nug nug in there dude, make sure it's crystallized dude...",
   "This is bomb ass dank ass nug nug!",
   "This from up North bro?! Off the 1-5? TOKE TOKE!",
   "Get that purp scurp dude!",
   "Straight legalize it or I'm goin' Gandhi!",
   "So. High.",
   "Rip up the bongs m8!",
   "So sleepy, almost forgot to hit the blunt!"
]

module.exports = (robot) ->
   rule = new schedule.RecurrenceRule()
   rule.hour = 16
   rule.minute = 20
   rule.dayOfWeek = [0, new schedule.Range(1, 6)]

   schedule.scheduleJob rule, () ->
      if robot.brain.data.notify420
         memeIndex = Math.floor(Math.random() * memes.length)
         mesIndex = Math.floor(Math.random() * messages.length)

         room = robot.adapter.room_id
         robot.messageRoom room, messages[mesIndex]
         robot.messageRoom room, memes[memeIndex]

   robot.respond /ENABLE 420 NOTIFICATIONS/, (res) ->
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = true
      res.send "420 notifications enabled! Blaze it!"

   robot.respond /DISABLE 420 NOTIFICATIONS/, (res) ->
      robot.brain.data.notify420 ?= {}
      robot.brain.data.notify420 = false
      res.send "420 notifications disabled... Wow."
