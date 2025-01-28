// controllers/friend.controller.js
const { User, Friend } = require('../models');

// Enviar solicitud
exports.sendFriendRequest = async (req, res) => {
  try {
    const { friendId } = req.params;
    const userId = req.user.id;

    // Validar que no sea el mismo usuario
    if (userId === friendId) {
      return res.status(400).json({ msg: 'No puedes enviarte solicitud a ti mismo' });
    }

    const existingFriendship = await Friend.findOne({
      where: {
        userId: userId,
        friendId: friendId
      }
    });

    if (existingFriendship) {
      return res.status(400).json({ msg: 'Ya existe una solicitud pendiente o son amigos' });
    }

    const friendRequest = await Friend.create({
      userId,
      friendId,
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
};

// Listar solicitudes pendientes
exports.getPendingRequests = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const requests = await Friend.findAll({
      where: {
        friendId: userId,
        status: 'pending'
      },
      include: [{
        model: User,
        as: 'sender',
        attributes: ['username', 'age', 'location']
      }]
    });

    res.json(requests);
  } catch (err) {
    console.error('List requests error:', err);
    res.status(500).json({ msg: 'Error al obtener solicitudes' });
  }
};

// ...existing accept and reject code...

// Aceptar solicitud de amistad
exports.acceptFriendRequest = async (req, res) => {
  try {
    const { requestId } = req.params;
    const userId = req.user.id; 

    // Buscar la solicitud de amistad
    const friendRequest = await Friend.findOne({
        where: {
            id: requestId,
            friendId: userId, // Asegurarse de que el usuario actual es el destinatario
            status: 'pending'
        }
    });
    
    if (!friendRequest) {
        return res.status(404).json({ msg: 'Friend request not found' });
    }

    // Actualizar el estado de la solicitud a 'accepted'
    friendRequest.status = 'accepted';
    await friendRequest.save();

    res.status(200).json({ msg: 'Friend request accepted', friendRequest });

  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

// Rechazar solicitud de amistad
exports.rejectFriendRequest = async (req, res) => {
    try {
        const { requestId } = req.params;
        const userId = req.user.id;

        const friendRequest = await Friend.findOne({
            where: {
                id: requestId,
                friendId: userId,
                status: 'pending'
            }
        });

        if(!friendRequest){
            return res.status(404).json({msg: 'Friend request not found'});
        }

        friendRequest.status = 'rejected';
        await friendRequest.save();

        res.status(200).json({msg: 'Friend request rejected', friendRequest});
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};//fulco