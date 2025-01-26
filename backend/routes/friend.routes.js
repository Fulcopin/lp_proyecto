// routes/friend.routes.js
const express = require('express');
const router = express.Router();
const friendController = require('../controllers/friend.controller');
const authMiddleware = require('../middleware/auth.middleware');

router.post('/:friendId', authMiddleware, friendController.sendFriendRequest);

router.put('/accept/:requestId', authMiddleware, friendController.acceptFriendRequest);

router.put('/reject/:requestId', authMiddleware, friendController.rejectFriendRequest);

module.exports = router;