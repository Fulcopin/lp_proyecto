const { User, Friend } = require('../models');
const { Op } = require('sequelize');

const friendController = {
  async sendFriendRequest(req, res) {
    try {
      const { friendId } = req.params;
      const userId = req.user.userId;

      if (userId === parseInt(friendId)) {
        return res.status(400).json({ msg: 'No puedes enviarte solicitud a ti mismo' });
      }

      const existingFriendship = await Friend.findOne({
        where: {
          [Op.or]: [
            { userId, friendId: parseInt(friendId) },
            { userId: parseInt(friendId), friendId: userId }
          ]
        }
      });

      if (existingFriendship) {
        return res.status(400).json({ msg: 'Ya existe una solicitud pendiente o son amigos' });
      }

      const friendRequest = await Friend.create({
        userId,
        friendId: parseInt(friendId),
        status: 'pending'
      });

      res.status(201).json({ 
        msg: 'Solicitud enviada con éxito',
        friendRequest 
      });
    } catch (err) {
      console.error('Send request error:', err);
      res.status(500).json({ msg: 'Error del servidor' });
    }
  },



  async getPendingRequests(req, res) {
    try {
      const userId = req.user.userId || req.user.id; // Handle both token formats
      
      console.log('Debug - Getting pending requests for user:', userId);

      if (!userId) {
        return res.status(400).json({ msg: 'ID de usuario no válido' });
      }

      const requests = await Friend.findAll({
        where: {
          friendId: parseInt(userId),
          status: 'pending'
        },
        include: [{
          model: User,
          as: 'sender',
          attributes: ['id', 'username', 'age', 'location']
        }]
      });

      console.log('Debug - Found requests:', requests);
      res.json(requests);
      
    } catch (err) {
      console.error('List requests error:', err);
      res.status(500).json({ 
        msg: 'Error al obtener solicitudes',
        error: err.message 
      });
    }
  },


    async acceptFriendRequest(req, res) {
      try {
        const requestId = parseInt(req.params.requestId);
        const userId = req.user.userId || req.user.id;
  
        console.log('Debug - Accept request:', { requestId, userId });
  
        if (!requestId || !userId) {
          return res.status(400).json({ msg: 'Parámetros inválidos' });
        }
  
        const friendRequest = await Friend.findOne({
          where: {
            id: requestId,
            friendId: userId,
            status: 'pending'
          }
        });
  
        if (!friendRequest) {
          return res.status(404).json({ msg: 'Solicitud no encontrada' });
        }
  
        friendRequest.status = 'accepted';
        await friendRequest.save();
  
        console.log('Debug - Request accepted:', friendRequest);
  
        return res.status(200).json({ 
          msg: 'Solicitud aceptada',
          friendRequest 
        });
  
      } catch (err) {
        console.error('Accept request error:', err);
        return res.status(500).json({ 
          msg: 'Error al aceptar solicitud',
          error: err.message 
        });
      }
    },
  
 


    async rejectFriendRequest(req, res) {
      try {
        const requestId = parseInt(req.params.requestId);
        const userId = parseInt(req.user.userId || req.user.id);
  
        console.log('Debug - Reject request:', { requestId, userId });
  
        if (!requestId || !userId) {
          return res.status(400).json({ msg: 'Parámetros inválidos' });
        }
  
        const friendRequest = await Friend.findOne({
          where: {
            id: requestId,
            friendId: userId,
            status: 'pending'
          }
        });
  
        console.log('Debug - Found request:', friendRequest);
  
        if (!friendRequest) {
          return res.status(404).json({ msg: 'Solicitud no encontrada' });
        }
  
        friendRequest.status = 'rejected';
        await friendRequest.save();
  
        console.log('Debug - Request rejected:', friendRequest);
  
        return res.status(200).json({ 
          msg: 'Solicitud rechazada',
          friendRequest 
        });
  
      } catch (err) {
        console.error('Reject request error:', err);
        return res.status(500).json({ 
          msg: 'Error al rechazar solicitud',
          error: err.message 
        });
      }
  },

    async getFriendsList(req, res) {
      try {
        const userId = parseInt(req.user.userId || req.user.id);
        console.log('Debug - User ID:', userId);
  
        if (!userId || isNaN(userId)) {
          return res.status(400).json({ msg: 'ID de usuario no válido' });
        }
  
        const friends = await Friend.findAll({
          where: {
            [Op.or]: [
              { userId, status: 'accepted' },
              { friendId: userId, status: 'accepted' }
            ]
          },
          include: [
            {
              model: User,
              as: 'sender',
              attributes: ['id', 'username', 'age', 'location']
            },
            {
              model: User,
              as: 'receiver',
              attributes: ['id', 'username', 'age', 'location']
            }
          ]
        });
  
        console.log('Debug - Raw friends:', friends);
  
        if (!friends) {
          return res.json([]);
        }
  
        const friendsList = friends.map(friend => 
          friend.userId === userId ? friend.receiver : friend.sender
        ).filter(Boolean);
  
        console.log('Debug - Processed friends:', friendsList);
        return res.json(friendsList);
  
      } catch (err) {
        console.error('Get friends error:', err);
        return res.status(500).json({ 
          msg: 'Error al obtener lista de amigos',
          error: err.message 
        });
      }
    }
  };
  
  module.exports = friendController;