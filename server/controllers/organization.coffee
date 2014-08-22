###*
 * Organization Controller
 * /api/organization
###

express = require 'express'

module.exports = (app) ->
	###*
	 * v1
	###

	api_v1 = express.Router()

	app.use '/v1/organization', api_v1

	return app