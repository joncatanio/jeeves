# Description:
#	Responses for Movie and TV Show keywords.
#
# Commands:
#  Great White Buffalo - Posts the gif from Hot Tub Time Machine.
#  Center for ants? - Posts the Zoolander center for ants gif. 
#  one friend - Posts Kip Drordy.
#  Where is everyone? - Kip Drordy youtube video.
#  Meegan you left your jacket! - Meegan appears, just give up on her already!

module.exports = (robot) ->
	robot.hear /Great White Buffalo/i, (res) ->
		res.send "https://i.imgur.com/2Y7NEq3.webm"

	robot.hear /Center for ants?/i, (res) ->
		res.send "https://38.media.tumblr.com/a5f174e7fa5da41a771f7f61470c6cc7/tumblr_mweix0ZXCn1qzee63o1_500.gif"

	# South Park 
	robot.hear /(one|1)( friend)/i, (res) ->
		res.send "http://img1.wikia.nocookie.net/__cb20100408124933/southpark/images/thumb/6/67/Kip_Drody.jpg/500px-Kip_Drody.jpg"

	robot.hear /where is every(one|body)\??/i, (res) ->
		res.send "Lol you have no friends https://youtu.be/SvExPAHT_TM"

	meegan = ["https://media4.giphy.com/media/us72CO9KatWAE/200.gif",
				 "https://media.giphy.com/media/4tIcgqABXEsnK/giphy.gif"
				]
	robot.hear /Meegan you left your jacket!/i, (res) ->
		res.send res.random meegan

