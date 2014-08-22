###*
 * Organization Model
###

DataTypes = require 'sequelize'

module.exports = (db) ->

	Organization = db.define 'Organization',
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
		tableName: 'organizations'
		classMethods:
			# Associations
			associate: (models) ->
				Organization.hasMany models.Team
				Organization.belongsTo models.Member, as: 'Owner', foreignKey: 'owner_id'
				Organization.hasMany models.Member, through: "organization_has_members"
