// controllers/message.controller.js
const { Message, User } = require('../models');
const { Op } = require('sequelize');

// Enviar un mensaje
exports.sendMessage = async (req, res) => {
    try {
        const { receiverId, content, senderId } = req.body; // Ahora senderId también viene del body

        // Validar que se proporcionen los datos necesarios (incluyendo senderId)
        if (!receiverId || !content || !senderId) {
            return res.status(400).json({ msg: 'Receiver ID, sender ID and message content are required' });
        }

        const newMessage = await Message.create({
            senderId,
            receiverId,
            content,
        });

        res.status(201).json({ msg: 'Message sent', message: newMessage });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Obtener mensajes recibidos por un usuario (usando parámetro de ruta)
exports.getReceivedMessagesByParam = async (req, res) => {
    try {
        const { userId } = req.params; // viene de la URL
        const messages = await Message.findAll({ where: { receiverId: userId } });
        return res.status(200).json(messages);
    } catch (err) {
        console.error(err);
        return res.status(500).send('Server error');
    }
};

// Obtener mensajes recibidos (modificado para no usar req.user.id)
exports.getReceivedMessages = async (req, res) => {
    try {
        const { userId } = req.body; // Ahora el userId viene del body

        const messages = await Message.findAll({
            where: {
                receiverId: userId,
            },
            include: [{
                model: User,
                as: 'sender',
                attributes: ['id', 'username']
            }],
            order: [['createdAt', 'DESC']]
        });

        res.status(200).json(messages);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Obtener mensajes enviados (modificado para no usar req.user.id)
exports.getSentMessages = async (req, res) => {
    try {
        const { userId } = req.body; // Ahora el userId viene del body

        const messages = await Message.findAll({
            where: {
                senderId: userId
            },
            include: [{
                model: User,
                as: 'receiver',
                attributes: ['id', 'username']
            }],
            order: [['createdAt', 'DESC']]
        });

        res.status(200).json(messages);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Obtener historial de mensajes entre dos usuarios (modificado para no usar req.user.id)
exports.getMessageHistory = async (req, res) => {
    try {
        const { userId } = req.body; // Ahora el userId viene del body
        const otherUserId = req.params.otherUserId;

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

        res.status(200).json(messages);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Marcar mensaje como leído (modificado para no usar req.user.id)
exports.markAsRead = async (req, res) => {
    try {
        const messageId = req.params.messageId;
        const { userId } = req.body; // Ahora el userId viene del body

        const message = await Message.findOne({
            where: {
                id: messageId,
                receiverId: userId
            }
        });

        if (!message) {
            return res.status(404).json({ msg: 'Message not found or not authorized to mark as read' });
        }

        if (message.read) {
            return res.status(400).json({ msg: 'Message already read' });
        }

        message.read = true;
        await message.save();

        res.status(200).json({ msg: 'Message marked as read', message });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};