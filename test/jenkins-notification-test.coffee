Robot = require("hubot/src/robot")

chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect
request = require 'supertest'

valid_json = require './fixtures/valid.json'
invalid_json = require './fixtures/invalid.json'

describe 'jenkins-notification', ->
  robot = null
  beforeEach (done) ->
    robot = new Robot null, 'mock-adapter', yes, 'hubot'
    robot.adapter.on 'connected', ->
      require("../src/jenkins-notification")(robot)
      adapter = @robot.adapter
      done()
    robot.run()

  it 'should be valid', (done) ->
    request(robot.router)
      .post('/hubot/jenkins/general')
      .set('Accept','application/json')
      .send(valid_json)
      .expect(200)
      .end (err, res) ->
        expect(res.text).to.eq "[Jenkins] Sending message"
        throw err if err
        done()

  # it 'should be invalid', (done) ->
  #   request(robot.router)
  #     .post('/hubot/jenkins/general')
  #     .set('Accept','application/json')
  #     .send(invalid_json)
  #     .expect(200)
  #     .end (err, res) ->
  #       expect(res.text).match /\[Jenkins\] TypeError: Cannot read property 'number' of undefined/
  #       throw err if err
  #       done()

  afterEach ->
    robot.server.close()
    robot.shutdown()
