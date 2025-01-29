const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const User = require('./user.model');

const Friend = sequelize.define('Friend', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    userId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'Users',
            key: 'id'
        }
    },
    friendId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'Users',
            key: 'id'
        }
    },
    status: {
        type: DataTypes.ENUM('pending', 'accepted', 'rejected'),
        allowNull: false,
        defaultValue: 'pending',
        validate: {
            isIn: [['pending', 'accepted', 'rejected']]
        }
    }
}, {
    timestamps: true,
    tableName: 'Friends'
});

// Relations
Friend.belongsTo(User, {
    foreignKey: 'userId',
    as: 'sender'
});

Friend.belongsTo(User, {
    foreignKey: 'friendId',
    as: 'receiver'
});

User.hasMany(Friend, {
    foreignKey: 'userId',
    as: 'sentRequests'
});

User.hasMany(Friend, {
    foreignKey: 'friendId',
    as: 'receivedRequests'
});

module.exports = Friend;