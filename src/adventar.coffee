# Description
#   A hubot script for listing advent calendars in Adventar
#
# Configuration:
#   None
#
# Commands:
#   hubot adventar <query> - lists advent calendars in Adventar
#
# Author
#   aki

 cheerio = require 'cheerio'
 request = require 'request'

 module.exports = (robot) ->

   robot.respond /adventar(?: (\S+))?/, (msg) ->
     query = msg.match[1]

     # send HTTP request
     baseUrl = 'http://www.adventar.org'
     request baseUrl + '/', (_, res) ->

       # parse response body
       $ = cheerio.load res.body
       calendars = []
       $('.mod-calendarList .mod-calendarList-title a').each ->
         a = $ @
         url = baseUrl + a.attr('href')
         name = a.text()
         calendars.push { url, name }

       # filter calendars
       filtered = calendars.filter (c) ->
         if query? then c.name.match(new RegExp(query, 'i')) else true
 
       # format calendars
       message = filtered
         .map (c) ->
           "#{c.name} #{c.url}"
         .join '\n'

       msg.send message
