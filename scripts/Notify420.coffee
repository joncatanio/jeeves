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
   "http://crazycrackerz.com/wp-content/uploads/2010/03/R2K2.jpg",
   "http://i.imgur.com/0r80IDG.png",
   "http://2static.fjcdn.com/pictures/Turtles+reppin+the+vapenashe_f541f8_5867661.jpg",
   "http://i.imgur.com/oWKF1NZ.jpg",
   "http://i.imgur.com/2HoPf4j.jpg",
   "https://i.ytimg.com/vi/Dkm8Hteeh6M/hqdefault.jpg",
   "https://i.ytimg.com/vi/u4D7oRwWPkg/maxresdefault.jpg",
   "http://i.imgur.com/gipW3ma.jpg",
   "http://i.imgur.com/m9I020S.jpg",
   "https://s-media-cache-ak0.pinimg.com/736x/e1/95/ed/e195edd961a2a1792179094f5082298a.jpg",
   "https://s-media-cache-ak0.pinimg.com/736x/d5/7f/3e/d57f3ee16dfea55d053e6622a92b7d6d.jpg",
   "http://weedmemes.com/wp-content/uploads/2016/03/stoner-arthritis-weed-memes.jpg",
   "http://img.memecdn.com/what-weed_o_4295267.jpg",
   "http://img.memecdn.com/overly-attached-weed_o_1052726.jpg",
   "http://www.thenug.com/sites/default/pub/070714/thenug-EiRIxld5ni.jpg",
   "https://s-media-cache-ak0.pinimg.com/736x/2e/b2/14/2eb21446df1c01e4192fa4ef4b7f3607.jpg",
   "http://s2.quickmeme.com/img/6d/6d214bcc433dff814b3edd726266e6ef5f478e43564a351462a2142f8812df79.jpg",
   "https://s-media-cache-ak0.pinimg.com/736x/c1/2a/8a/c12a8a5de037a43fad08c2b3b7154423.jpg",
   "http://40.media.tumblr.com/d89f3f769c0b1e0d725a7315f3cd0510/tumblr_nyftk10uOq1ushej2o1_1280.png",
   "http://cdn.theweedblog.com/wp-content/uploads/marijuana-christmas-meme-3.png",
   "http://media3.popsugar-assets.com/files/2015/04/14/062/n/1922398/a6879dc8_edit_img_cover_file_15775818_14290536953gbpXB.xxxlarge/i/Funny-Weed-Memes.jpg",
   "http://40.media.tumblr.com/tumblr_mc3yqc4cDG1risyk5o1_500.jpg",
   "http://static.vibe.com/files/2015/04/2-weed-meme.png",
   "https://findmarijuana.files.wordpress.com/2015/11/kermit-stoner-gif-weed-memes.gif",
   "https://findmarijuana.files.wordpress.com/2015/11/hit-bong-hard-gif-weedmemes.gif",
   "https://media.giphy.com/media/hHFR8gd2GGnq8/giphy.gif",
   "http://i.imgur.com/s73RbTN.gif",
   "http://i2.kym-cdn.com/photos/images/original/000/288/844/101.jpg",
   "https://media.giphy.com/media/VRzJthG6cq3Ac/giphy.gif",
   "http://i1.kym-cdn.com/photos/images/original/000/790/813/ce0.gif",
   "http://31.media.tumblr.com/b88ae453d22e4eb07dad427f389880c8/tumblr_mruk5jaB7j1sp8x0mo1_250.gif",
   "http://33.media.tumblr.com/8e481ed0284de7cc45570785837eedf5/tumblr_n8melyX3IE1r07rtgo1_250.gif",
   "https://49.media.tumblr.com/2fb5b40a99a567a498abd39c422d6cfd/tumblr_npm11x6jgl1rl7arbo1_500.gif",
   "http://i1.kym-cdn.com/photos/images/newsfeed/000/946/725/754.gif"
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
   "So sleepy, almost forgot to hit the blunt!",
   "VAPE NAYSH BROS!",
   "Bust out the vape!",
   "Never miss 4:20 oiii!!!",
   "I'm an addict.",
   "Somebody help me.... JK BLAZE IT BITCH!",
   "Need the weed <3"
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
