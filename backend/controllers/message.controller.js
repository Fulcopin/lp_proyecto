const { Message, User } = require('../models');
const { Op } = require('sequelize');

const messageController = {
  async sendMessage(req, res) {
    try {
      const senderId = req.user.userId || req.user.id;
      const { receiverId, content } = req.body;

      if (!receiverId || !content) {
        return res.status(400).json({ msg: 'Faltan datos requeridos' });
      }

      const message = await Message.create({
        senderId,
        receiverId,
        content
      });

      res.status(201).json({ 
        msg: 'Mensaje enviado',
        message 
      });
    } catch (err) {
      console.error('Send message error:', err);
      res.status(500).json({ msg: 'Error al enviar mensaje' });
    }
  },

  async getReceivedMessages(req, res) {
    try {
      const userId = req.user.userId || req.user.id;

      const messages = await Message.findAll({
        where: { receiverId: userId },
        include: [{
          model: User,
          as: 'sender',
          attributes: ['id', 'username']
        }],
        order: [['createdAt', 'DESC']]
      });

      res.json(messages);
    } catch (err) {
      console.error('Get messages error:', err);
      res.status(500).json({ msg: 'Error al obtener mensajes' });
    }
  },

  async getSentMessages(req, res) {
    try {
      const userId = req.user.userId || req.user.id;

      const messages = await Message.findAll({
        where: { senderId: userId },
        include: [{
          model: User,
          as: 'receiver',
          attributes: ['id', 'username']
        }],
        order: [['createdAt', 'DESC']]
      });

      res.json(messages);
    } catch (err) {
      console.error('Get sent messages error:', err);
      res.status(500).json({ msg: 'Error al obtener mensajes enviados' });
    }
  },

  async getMessageHistory(req, res) {
    try {
      const userId = req.user.userId || req.user.id;
      const { otherUserId } = req.params;

      const messages = await Message.findAll({
        where: {
          [Op.or]: [
            { senderId: userId, receiverId: otherUserId },
            { senderId: otherUserId, receiverId: userId }
          ]
        },
        include: [
          { model: User, as: 'sender', attributes: ['id', 'username'] },
          { model: User, as: 'receiver', attributes: ['id', 'username'] }
        ],
        order: [['createdAt', 'ASC']]
      });

      res.json(messages);
    } catch (err) {
      console.error('Get history error:', err);
      res.status(500).json({ msg: 'Error al obtener historial' });
    }
  },

  async markAsRead(req, res) {
    try {
      const { messageId } = req.params;
      const userId = req.user.userId || req.user.id;

      const message = await Message.findOne({
        where: {
          id: messageId,
          receiverId: userId
        }
      });

      if (!message) {
        return res.status(404).json({ msg: 'Mensaje no encontrado' });
      }

      message.read = true;
      await message.save();

      res.json({ msg: 'Mensaje marcado como leído', message });
    } catch (err) {
      console.error('Mark as read error:', err);
      res.status(500).json({ msg: 'Error al marcar mensaje' });
    }
  }
};

module.exports = messageController;