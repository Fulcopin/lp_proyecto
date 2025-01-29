const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/auth.middleware');
const friendController = require('../controllers/friend.controller');




// Friend request routes
router.post('/:friendId', verifyToken, friendController.sendFriendRequest);
router.get('/requests/pending', verifyToken, friendController.getPendingRequests);
router.put('/request/:requestId/accept', verifyToken, friendController.acceptFriendRequest);
router.put('/request/:requestId/reject', verifyToken, friendController.rejectFriendRequest);
router.get('/list', verifyToken, friendController.getFriendsList);

module.exports = router;