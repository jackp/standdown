###*
 * Member Model
###

DataTypes = require 'sequelize'
bcrypt = require 'bcrypt'

module.exports = (db) ->

	Member = db.define 'Member',
		# Key User Information
		id:
			type: DataTypes.UUID
			primaryKey: true
			defaultValue: DataTypes.UUIDV4
			validate:
				isUUID: 4
		email:
			type: DataTypes.STRING
			unique: true
			allowNull: false
			validate:
				isEmail: true
		password:
			type: DataTypes.STRING
			allowNull: false
			# TODO: Encrypt
		name:
			type: DataTypes.STRING
			allowNull: false

		# TODO: Roles
		# 1) Organization Owner (1)
		# 2) Org Admin (multiple) - Can set org settings
		# 3) Team Lead (1 per team) - Can set team settings
		# Anyone can create team, becomes Team Lead, but then can assign to someone else
	,
		# Table-specific configuration
		tableName: 'members'
		classMethods:
			# Associations
			associate: (models) ->
				Member.hasMany models.Team, through: "team_has_members"
				Member.hasMany models.Organization, through: "organization_has_members"
