// models/friend.model.js
const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const User = require('./user.model');

const Friend = sequelize.define('Friend', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    status: {
        type: DataTypes.ENUM('pending', 'accepted', 'rejected'),
        allowNull: false,
        defaultValue: 'pending'
    }
}, {
    timestamps: true,
    tableName: 'Friends'
});

// Definiciones de las relaciones
User.belongsToMany(User, {
    as: 'Friends',
    through: Friend,
    foreignKey: 'userId',
    otherKey: 'friendId'
});

module.exports = Friend;