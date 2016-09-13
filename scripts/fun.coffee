# Description:
# 	Jeeves responses for various easter eggs and inside jokes. 
#
# Commands:
#  Boom Boom Pow - Fergie pops up and sings boom boom pow
#	/batmetal me - Links a batmetal gif
#	Hacking in progress - Posts a hacker gif
#	I see you - The horse sees all
#	Womp - The classic manatee
#  REEEE - Posts the frog
#  Who is your creator - Posts a string
#  Smoke screen - Links an image of smoke
#
# Group:
#	All

module.exports = (robot) ->
   robot.hear /Boom Boom Pow/i, (res) ->
      res.send "https://33.media.tumblr.com/17c4b0c1c8b73c764015facb2c3346d5/tumblr_mtfyv5XMVl1qd8zg3o7_250.gif"

   batmetal = [
               "https://media0.giphy.com/media/3WTLDnMiAsFfq/200.gif",
               "https://media3.giphy.com/media/r4Lrfbl5fj4qI/200.gif",
               "https://49.media.tumblr.com/a4b4bcb9bd6ba0ad104747548dc16276/tumblr_n8bp7hbZix1qirsuqo2_500.gif",
               "https://45.media.tumblr.com/88c6f737c27649caf5eaf330e116eb4b/tumblr_n84isurQUA1sfmnmgo1_1280.gif"
   ]
   robot.respond /batmetal( me)?/i, (res) ->
      res.send res.random batmetal

   hacking = [
               "http://i.imgur.com/LRUQ1jF.mp4",
               "https://i.imgur.com/f7rJAZ7.webm"
   ]
   robot.hear /hacking in progress/i, (res) ->
      res.send res.random hacking

   robot.hear /i see you/i, (res) ->
      res.send "http://imgur.com/3ZfhAcJ"

   robot.hear /womp/i, (res) ->
      res.send "http://i.imgur.com/NA8RHzS.gifv"

   robot.hear /RE(E)+/, (res) ->
      res.send "http://img.ifcdn.com/images/4ebab825ebae7d959903fd458735d6d76fd5135537336ec65de8fe28a035ddfc_3.jpg"

   robot.respond /who is (yo)?ur creator/, (res) ->
      res.send "The great developer Noj!"

   robot.hear /smoke screen!*/i, (res) ->
      res.send "http://i.imgur.com/LDlOjKv.jpg"

# Hidden Easter Eggs.
   sassy = [
            "Fuck you too pussy",
            "U wot bitch"
   ]
   robot.hear /(Jeeves (fuck|fuk) (you|u)|(fuck|fuk) (you|u) Jeeves)/i, (res) ->
      res.send res.random sassy
