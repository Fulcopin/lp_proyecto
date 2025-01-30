const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/auth.middleware');
const messageController = require('../controllers/message.controller');

router.post('/send', verifyToken, messageController.sendMessage);
router.get('/received', verifyToken, messageController.getReceivedMessages);
router.get('/sent', verifyToken, messageController.getSentMessages);
router.get('/history/:otherUserId', verifyToken, messageController.getMessageHistory);
router.put('/:messageId/read', verifyToken, messageController.markAsRead);

module.exports = router;