###*
 * Team Model
###

DataTypes = require 'sequelize'

module.exports = (db) ->

	Team = db.define 'Team',
		id:
			type: DataTypes.UUID
			primaryKey: true
			defaultValue: DataTypes.UUIDV4
			validate:
				isUUID: 4
		name:
			type: DataTypes.STRING
			allowNull: false
	,
		# Table-specific configuration
		tableName: 'teams'
		classMethods:
			# Associations
			associate: (models) ->
				Team.belongsTo models.Organization
				Team.hasMany models.Member, through: "team_has_members"
