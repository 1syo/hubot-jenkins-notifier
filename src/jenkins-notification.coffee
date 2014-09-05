# Description
#   hubot-jenkins-notification script notify build status form jenkins notification plugin.
#
# Notes:
#   If you use slack adapter then your message use slack attachments.
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]

Postman = require "./postman"
module.exports = (robot) ->
  robot.router.post "/#{robot.name}/jenkins/:room", (req, res) ->
    try
      postman = Postman.create(req, robot)
      if postman.deliverable()
        postman.deliver()
        res.end "[Jenkins] Sending message"
      else
        res.end ""
    catch e
      res.end "[Jenkins] #{e}"
