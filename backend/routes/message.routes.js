// routes/message.routes.js
const express = require('express');
const router = express.Router();
const messageController = require('../controllers/message.controller');
// const authMiddleware = require('../middleware/auth.middleware'); // Ya no se necesita aquí

router.post('/', messageController.sendMessage); // Sin authMiddleware
router.get('/received/:userId', messageController.getReceivedMessagesByParam); // Sin authMiddleware
router.get('/sent', messageController.getSentMessages); // Sin authMiddleware
router.get('/history/:otherUserId', messageController.getMessageHistory); // Sin authMiddleware
router.put('/read/:messageId', messageController.markAsRead); // Sin authMiddleware

module.exports = router;