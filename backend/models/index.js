const User = require('./user.model');
const Friend = require('./friend.model');
const Message = require('./message.model');
// Define associations after both models are loaded
Message.belongsTo(User, { as: 'sender', foreignKey: 'senderId' });
Message.belongsTo(User, { as: 'receiver', foreignKey: 'receiverId' });

User.hasMany(Message, { as: 'sentMessages', foreignKey: 'senderId' });
User.hasMany(Message, { as: 'receivedMessages', foreignKey: 'receiverId' });


module.exports = {
    User,
    Friend,
    Message
};