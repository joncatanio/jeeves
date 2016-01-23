# Description:
#   Track arbitrary karma
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <thing>++ - give thing some karma
#   <thing>-- - take away some of thing's karma
#   hubot karma <thing> - check thing's karma (if <thing> is omitted, show the top 5)
#   hubot karma empty <thing> - empty a thing's karma
#   hubot karma best [n] - show the top n (default: 5)
#   hubot karma worst [n] - show the bottom n (default: 5)
#
# Contributors:
#   D. Stuart Freeman (@stuartf) https://github.com/stuartf
#   Andy Beger (@abeger) https://github.com/abeger
#
# Edited/Appended:
#   joncatanio
#
# Known Bugs:
# 	 1.) All the karma breakdowns are broken. Don't want to keep duplicating
#       code to find the users so I'm going to break that up into a function
#       eventually...
#

class Karma

  constructor: (@robot) ->
    @cache = {}

    @increment_responses = [
      "+1!",
      "gained a level!",
      "is a boss!",
      "is going to the top!",
      "found a green mushroom!"
    ]

    @decrement_responses = [
      "took a hit! *chirps*.",
      "took a dive.",
      "lost a life.",
      "lost a level.",
      "got owned",
      "got slapped on the hand"
    ]

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.karma
        @cache = @robot.brain.data.karma

  kill: (thing) ->
    delete @cache[thing]
    @robot.brain.data.karma = @cache

  increment: (thing) ->
    @cache[thing] ?= 0
    @cache[thing] += 1
    @robot.brain.data.karma = @cache

  decrement: (thing) ->
    @cache[thing] ?= 0
    @cache[thing] -= 1
    @robot.brain.data.karma = @cache

  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]

  decrementResponse: ->
     @decrement_responses[Math.floor(Math.random() * @decrement_responses.length)]

  get: (thing) ->
    k = if @cache[thing] then @cache[thing] else 0
    return k

  sort: ->
    s = []
    for key, val of @cache
      s.push({ name: key, karma: val })
    s.sort (a, b) -> b.karma - a.karma

  top: (n = 5) =>
    sorted = @sort()
    sorted.slice(0, n)

  bottom: (n = 5) =>
    sorted = @sort()
    sorted.slice(-n).reverse()

class User
  constructor: (username, nickname, userId) ->
    @username = username
    @nickname = nickname
    @userId = userId

module.exports = (robot) ->
  karma = new Karma robot

  ###
  # Listen for "++" messages and increment
  ###
  robot.hear /@?(\S+[^+\s])\+\+(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()

    allUsers = []
	 # Always make sure Jeeves is an available member.
    allUsers.push new User "Jeeves", "Jeeves", 530

    returnedUsers = robot.brain.users()
    #console.log returnedUsers
   
    # Push all users in a given group onto the array. 
    for user, userData of returnedUsers
      allUsers.push new User userData.name, userData.nickname, userData.user_id unless userData.name is "system"
      #console.log "#{user}:#{userData}"
      #console.log "Object Properties: " + userData.name + ", " + userData.nickname + ", " + userData.user_id

    found = false
    for user in allUsers when found isnt true
      matchUserName = user.username.toLowerCase().split " "
      matchNickName = user.nickname.toLowerCase().split " "
		
      # Definitely could be optimized...
      for name in matchUserName when found isnt true
        if subject is name
          karma.increment user.user_id
          found = true
          msg.send "#{user.username} #{karma.incrementResponse()} (Karma: #{karma.get(user.user_id)})"

      for name in matchNickName when found isnt true
        if subject is name
          karma.increment user.user_id
          found = true
          msg.send "#{user.username} #{karma.incrementResponse()} (Karma: #{karma.get(user.user_id)})"

    msg.send "Sorry I couldn't find a person named #{subject}" unless found

  ###
  # Listen for "--" messages and decrement
  # TODO: Optimize increment/decrement, too much code reuse but it works.
  ###
  robot.hear /@?(\S+[^-\s])--(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()

    allUsers = []
	 # Always make sure Jeeves is an available member.
    allUsers.push new User "Jeeves", "Jeeves", 530

    returnedUsers = robot.brain.users()
    #console.log returnedUsers
   
    # Push all users in a given group onto the array. 
    for user, userData of returnedUsers
      allUsers.push new User userData.name, userData.nickname, userData.user_id unless userData.name is "system"
      #console.log "#{user}:#{userData}"
      #console.log "Object Properties: " + userData.name + ", " + userData.nickname + ", " + userData.user_id

    found = false
    for user in allUsers when found isnt true
      matchUserName = user.username.toLowerCase().split " "
      matchNickName = user.nickname.toLowerCase().split " "
		
      # Definitely could be optimized...
      for name in matchUserName when found isnt true
        if subject is name
          karma.decrement user.user_id
          found = true
          msg.send "#{user.username} #{karma.decrementResponse()} (Karma: #{karma.get(user.user_id)})"

      for name in matchNickName when found isnt true
        if subject is name
          karma.decrement user.user_id
          found = true
          msg.send "#{user.username} #{karma.decrementResponse()} (Karma: #{karma.get(user.user_id)})"

    msg.send "Sorry I couldn't find a person named #{subject}" unless found

  ###
  # Listen for "karma empty x" and empty x's karma
  ###
  #robot.respond /karma empty ?(\S+[^-\s])$/i, (msg) ->
  #  subject = msg.match[1].toLowerCase()
  #  karma.kill subject
  #  msg.send "#{subject} has had its karma scattered to the winds."

  ###
  # Function that handles best and worst list
  # @param msg The message to be parsed
  # @param title The title of the list to be returned
  # @param rankingFunction The function to call to get the ranking list
  ###
  parseListMessage = (msg, title, rankingFunction) ->
    count = if msg.match.length > 1 then msg.match[1] else null
    verbiage = [title]
    if count?
      verbiage[0] = verbiage[0].concat(" ", count.toString())
    for item, rank in rankingFunction(count)
      verbiage.push "#{rank + 1}. #{item.name} - #{item.karma}"
    msg.send verbiage.join("\n")

  ###
  # Listen for "karma best [n]" and return the top n rankings
  ###
  robot.respond /karma best\s*(\d+)?$/i, (msg) ->
    parseData = parseListMessage(msg, "The Best", karma.top)

  ###
  # Listen for "karma worst [n]" and return the bottom n rankings
  ###
  robot.respond /karma worst\s*(\d+)?$/i, (msg) ->
    parseData = parseListMessage(msg, "The Worst", karma.bottom)

  ###
  # Listen for "karma x" and return karma for x
  ###
  robot.respond /karma (\S+[^-\s])$/i, (msg) ->
    match = msg.match[1].toLowerCase()
    if not (match in ["best", "worst"])
      msg.send "\"#{match}\" has #{karma.get(match)} karma."

