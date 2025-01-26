// controllers/friend.controller.js
const { User, Friend } = require('../models');

// Enviar solicitud de amistad
exports.sendFriendRequest = async (req, res) => {
  try {
    const { friendId } = req.params;
    const userId = req.user.id; // ID del usuario que envía la solicitud

    // Verificar si ya existe una relación de amistad
    const existingFriendship = await Friend.findOne({
      where: {
        userId: userId,
        friendId: friendId
      }
    });

    if (existingFriendship) {
      return res.status(400).json({ msg: 'Friend request already sent or users are already friends' });
    }

    // Crear la solicitud de amistad
    const friendRequest = await Friend.create({
      userId: userId,
      friendId: friendId,
      status: 'pending'
    });

    res.status(201).json({ msg: 'Friend request sent', friendRequest });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

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