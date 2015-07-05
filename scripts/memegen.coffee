module.exports = (robot) ->
  robot.respond /([^:]+) SAYS (.+[\/|,].+)/i, (msg) ->
    [robot, name, text] = msg.match

    doMemeGen(msg, name, text)

doMemeGen = (msg, name, text) ->
  captions = splitCaption(text, ["/"])

  q = {}
  q.img = name
  q.header = captions[0]
  q.footer = captions[1]

  console.log(q)

  msg.http('http://camp-folsom-memegen.herokuapp.com/memegen').
    query(q).
    get() (err, res, body) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      if res.statusCode isnt 200
        msg.send "Bad HTTP response :( #{res.statusCode}"
        return
      msg.send body

splitCaption = (text, separators) ->
  for separator in separators
    i = text.indexOf(separator)
    return [text.substring(0, i), text.substring(i + 1)] unless i == -1
