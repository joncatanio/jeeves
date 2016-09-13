# Description:
# 	Jeeves responses for various Hoose requests. 
#
# Commands:
# 	The real Hoose! - Posts the real Hoose, we know who you really are.
#	Mexican Hoose - Posts the real Hoose as a Mexican drug lord.
#  Appalachian Native Hoose - Posts the real Hoose as an Appalachian Native.
#	Emo Hoose - Posts the real Hoose dressed Emo.
#	Eskimo Hoose - Posts the real Hoose as an Eskimo.
# 	Jewish Hoose - Posts the real Hoose in traditional Jewish attire.
#
# Enable/Disable:
#  ENABLE HOOSE - Enables all responses in this script file.
#  DISABLE HOOSE - Disables all responses in this script file. 
#
# Group:
#	Nostalgia

module.exports = (robot) ->
   robot.hear /The real Hoose!/i, (res) ->
      if robot.brain.data.hoose
         res.send "http://cs5.pikabu.ru/images/big_size_comm/2015-02_2/14235830609123.jpg"

   robot.hear /Mexican Hoose/i, (res) ->
      if robot.brain.data.hoose
         res.send "http://i.imgur.com/MjUjqz7.jpg"

   robot.hear /appalachian native hoose/i, (res) ->
      if robot.brain.data.hoose
         res.send "https://i.groupme.com/1080x720.png.c49b818ad57c49f0a4f8504e176328b7.large"

   robot.hear /eskimo hoose/i, (res) ->
      if robot.brain.data.hoose
         res.send "https://i.groupme.com/1080x717.png.75cd2fd3e41e4ebe9c11f5019acb710e.large"

   robot.hear /emo hoose/i, (res) ->
      if robot.brain.data.hoose
         res.send "https://i.groupme.com/1080x722.png.941b83322d284c89aade4638771580cd.large"

   robot.hear /(jew(ish)? hoose|joose)/i, (res) ->
      if robot.brain.data.hoose
         res.send "https://i.groupme.com/1080x724.png.d5319c79d05344bd8b46a04d0b854a03.large"

   robot.respond /hoose bomb/i, (res) ->
      if robot.brain.data.hoose
         res.send "http://cs5.pikabu.ru/images/big_size_comm/2015-02_2/14235830609123.jpg"
         res.send "http://i.imgur.com/MjUjqz7.jpg"
         res.send "https://i.groupme.com/1080x720.png.c49b818ad57c49f0a4f8504e176328b7.large"
         res.send "https://i.groupme.com/1080x717.png.75cd2fd3e41e4ebe9c11f5019acb710e.large"
         res.send "https://i.groupme.com/1080x722.png.941b83322d284c89aade4638771580cd.large"
         res.send "https://i.groupme.com/1080x724.png.d5319c79d05344bd8b46a04d0b854a03.large"

   robot.respond /ENABLE HOOSE/, (res) ->
      robot.brain.data.hoose ?= {}
      robot.brain.data.hoose = true
      res.send "hoose.coffee enabled"

   robot.respond /DISABLE HOOSE/, (res) ->
      robot.brain.data.hoose ?= {}
      robot.brain.data.hoose = false
      res.send "hoose.coffee disabled"
