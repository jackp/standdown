###*
 * Dependencies
###

# NPM
express      = require 'express'
_            = require 'lodash'
bodyParser   = require 'body-parser'  # https://github.com/expressjs/body-parser
compress     = require 'compression'  # https://github.com/expressjs/compression
errorHandler = require 'errorhandler' # https://github.com/expressjs/errorhandler
morgan       = require 'morgan'       # https://github.com/expressjs/morgan
Sequelize    = require 'sequelize'    # http://sequelizejs.com/docs/latest/installation

# Node
fs           = require 'fs'
path         = require 'path'

###*
 * Express Configuration
###

app = express()

# Connect Middleware
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()
app.use compress()
app.use errorHandler()

# Environment-specific configuration
app.set('env', process.env.NODE_ENV or 'development')

# Load environment config from config.json
_.forIn require('./config.json')[app.get('env')], (value, key) ->
  app.set key, value

switch app.get('env')
  when 'development'
    app.use morgan 'dev'

    app.use require('connect-livereload')(port: 35729)
    
    app.use express.static(path.resolve(__dirname, "../client"))
    app.use express.static(path.resolve(__dirname, "../.tmp"))

    # Load secret environment variables from env.json
    # NOTE: Make sure this file is not in version control
    _.forIn require('./env.json'), (value, key) ->
      process.env[key] = value

  when 'production'
    app.use morgan 'default'

    app.use express.static(path.resolve(__dirname, "../client"))

###*
 * Database Connection
###
sequelize = new Sequelize process.env.DB_CONNECTION,
  dialect: 'postgres'
  native: true
  define:
    underscored: true

###*
 * Load models
###
app.db = {}
fs.readdirSync("#{__dirname}/models").forEach (file) ->
  model = sequelize.import("#{__dirname}/models/#{file}")
  app.db[model.name] = model

# Create associations
Object.keys(app.db).forEach (modelName) ->
  app.db[modelName].associate app.db if "associate" of app.db[modelName]

###*
 * Load Controllers & Mount Routes
###
fs.readdirSync("#{__dirname}/controllers").forEach (file) ->
  require("#{__dirname}/controllers/#{file}")(app)

# Send to index.html for all other routes
app.use (req, res) ->
  res.sendFile path.resolve(__dirname, "../client/index.html")

###*
 * Connect to database
###
sequelize
  .sync force: true
  .complete (err) ->
    return console.log "Unable to connect to database: #{err}" if err

    ###*
     * Initializers
     * Run any scripts in /boot
    ###
    fs.readdirSync("#{__dirname}/boot").forEach (initializer) ->
      require("#{__dirname}/boot/#{initializer}")(app)

    ###*
     *  Start server
    ###
    port = app.get('PORT') or 3001

    app.listen port, () ->
      console.log "Server listening on port #{port}"