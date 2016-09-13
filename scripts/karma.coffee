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
# Known Bugs/Issues:
# 	 - All the karma breakdowns are broken. Don't want to keep duplicating
#     code to find the users so I'm going to break that up into a function
#     eventually...
#   - Pushing users into an array everytime I hear --/++ etc. Need to look
#     into an optimization, while still ensuring that newly added or removed
#     users are included.
#   - Allow multiple (in/de)crements in one line. 
#   - Condense and refactor some code, break things out into functions at least.

class Karma

  constructor: (@robot) ->
    @cache = {}

    @increment_responses = [
      "+1!",
      "gained a level!",
      "is a boss!",
      "is going to the top!",
      "found a green mushroom!",
      "*fist bumb*",
      "is the new God!",
      "can do anything!",
      "is aight I guess...",
      "here you go :)",
      "is impressive, hmmm..."
    ]

    @decrement_responses = [
      "took a hit! *chirps*.",
      "took a dive.",
      "lost a life.",
      "lost a level.",
      "got owned",
      "got slapped on the hand",
      "got punked!",
      "is a loser!",
      "lol sorry bro",
      "is dead to me.",
      "later skater!"
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
      if key isnt null
         s.push({ name: key, karma: val })
    s.sort (a, b) -> b.karma - a.karma

  top: (n = 5) =>
    sorted = @sort()
    sorted.slice(0, n)

  bottom: (n = 5) =>
    sorted = @sort()
    sorted.slice(-n).reverse()

  purgeBadData: (userList) =>
    for key, val of @cache
      if key not in userList
        @kill(key)

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
    subjectCase = msg.match[1]
   
    allUsers = []
	 # Always make sure Jeeves is an available member.
    allUsers.push new User "Jeeves", "Jeeves", '530'

    returnedUsers = robot.brain.users()
    #console.log returnedUsers
   
    for user, userData of returnedUsers
      allUsers.push new User userData.name, userData.nickname, userData.user_id unless userData.name is "system"

    duplicate = false
    recipient = null

    # If nicknames ever change and become necessary from the API call just 
    # copy the username logic below.
    for user in allUsers
      matchUserName = user.username.toLowerCase().split " "
      
      # Definitely could be optimized...
      for name in matchUserName
        if subject is name
          duplicate = true if recipient isnt null
          # This line is obsolete if there is a duplicate.
          recipient = user
  
    if recipient is null
      msg.send "Sorry I couldn't find a person with the name #{subjectCase}"
      return

    if msg.message.user.user_id is recipient.userId
      msg.send "You can't karmify yourself!"
      return
    
    if duplicate
      msg.send "There are multiple people with the name #{subjectCase}"
      return

    karma.increment recipient.userId
    msg.send "#{recipient.username} #{karma.incrementResponse()} (Karma: #{karma.get(recipient.userId)})"

  ###
  # Listen for "--" messages and decrement
  # TODO: Optimize increment/decrement, too much code reuse but it works.
  ###
  robot.hear /@?(\S+[^-\s])--(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()
    subjectCase = msg.match[1]

    allUsers = []
	 # Always make sure Jeeves is an available member.
    allUsers.push new User "Jeeves", "Jeeves", '530'

    returnedUsers = robot.brain.users()
    #console.log returnedUsers
   
    # Push all users in a given group onto the array. 
    for user, userData of returnedUsers
      allUsers.push new User userData.name, userData.nickname, userData.user_id unless userData.name is "system"

    duplicate = false
    recipient = null

    # If nicknames ever change and become necessary from the API call just 
    # copy the username logic below.
    for user in allUsers
      matchUserName = user.username.toLowerCase().split " "
      
      # Definitely could be optimized...
      for name in matchUserName
        if subject is name
          duplicate = true if recipient isnt null
          # This line is obsolete if there is a duplicate.
          recipient = user
  
    if recipient is null
      msg.send "Sorry I couldn't find a person with the name #{subjectCase}"
      return

    if msg.message.user.user_id is recipient.userId
      msg.send "You can't karmify yourself!"
      return
    
    if duplicate
      msg.send "There are multiple people with the name #{subjectCase}"
      return

    karma.decrement recipient.userId
    msg.send "#{recipient.username} #{karma.decrementResponse()} (Karma: #{karma.get(recipient.userId)})"
   
  ###
  # Listen for "karma empty x" and empty x's karma
  ###
  #robot.respond /karma empty ?(\S+[^-\s])$/i, (msg) ->
  #  subject = msg.match[1].toLowerCase()
  #  karma.kill subject
  #  msg.send "#{subject} has had its karma scattered to the winds."

  ###
  # Function that finds user given an ID.
  # @param usr The username or id of a user. 
  ###
  findUser = (usrId) ->
    allUsers = []
    allUsers.push new User "Jeeves", "Jeeves", '530'

    returnedUsers = robot.brain.users()
   
    for user, userData of returnedUsers
      allUsers.push new User userData.name, userData.nickname, userData.user_id unless userData.name is "system"

    recipient = null
    for user in allUsers
      if user.userId is usrId
        recipient = user

    return recipient

  ###
  # Function that handles best and worst list
  # @param msg The message to be parsed
  # @param title The title of the list to be returned
  # @param rankingFunction The function to call to get the ranking list
  ###
  parseListMessage = (msg, title, rankingFunction) ->
    user = null
    #count = if msg.match.length > 1 then msg.match[1] else null
    count = 5
    verbiage = [title]
    if count?
      verbiage[0] = verbiage[0].concat(" ", count.toString())
    for item, rank in rankingFunction(count)
      user = findUser(item.name)
      verbiage.push "#{rank + 1}. #{user.username} - #{item.karma}" unless user is null
    msg.send verbiage.join("\n")

  ###
  # Listen for "karma best [n]" and return the top n rankings
  ###
  #robot.respond /karma best\s*(\d+)?$/i, (msg) ->
  #  parseData = parseListMessage(msg, "The Best", karma.top)

  ###
  # Listen for "karma worst [n]" and return the bottom n rankings
  ###
  #robot.respond /karma worst\s*(\d+)?$/i, (msg) ->
  #  parseData = parseListMessage(msg, "The Worst", karma.bottom)

  ###
  # Listen for "karmaranks" and return the top 5 and bottom 5. Using this
  # instead of best/worst, count is set to 5 by default.
  ###
  robot.respond /karmaranks/i, (msg) ->
    karmaUserList = []
    karmaUserList.push '530' # push Jeeves on.
    for user, userData of robot.brain.users()
      karmaUserList.push userData.user_id

    # Ensure any users who left don't stick around. Will optimize later.
    karma.purgeBadData(karmaUserList)
    parseDataTop = parseListMessage(msg, "Karma Ranks Top", karma.top)
    parseDataBottom = parseListMessage(msg, "Karma Ranks Bottom", karma.bottom)

  ###
  # Listen for "karma x" and return karma for x
  ###
  robot.respond /karma (\S+[^-\s])$/i, (msg) ->
    subject = msg.match[1].toLowerCase()
    subjectCase = msg.match[1]

    allUsers = []
    allUsers.push new User "Jeeves", "Jeeves", '530'

    returnedUsers = robot.brain.users()
    
    for user, userData of returnedUsers
      allUsers.push new User userData.name, userData.nickname, userData.user_id unless userData.name is "system"

    duplicate = false
    recipient = null

    for user in allUsers
      matchUserName = user.username.toLowerCase().split " "
      
      for name in matchUserName
        if subject is name
          duplicate = true if recipient isnt null
          recipient = user
  
    if recipient is null
      msg.send "Sorry I couldn't find a person with the name #{subjectCase}"
      return

    if duplicate
      msg.send "There are multiple people with the name #{subjectCase}"
      return

    if not (recipient.userId in ["best", "worst"])
      msg.send "#{recipient.username} has #{karma.get(recipient.userId)} karma."

