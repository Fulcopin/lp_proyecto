// controllers/user.controller.js
const { User } = require('../models');
const bcrypt = require('bcryptjs');

// Registro de usuario
exports.registerUser = async (req, res) => {
  try {
    const { username, email, password, age, location } = req.body;

    // Validar datos de entrada (podrías usar express-validator)
    if (!username || !email || !password || !age || !location) {
      return res.status(400).json({ msg: 'Please enter all fields' });
    }

    // Verificar si el usuario ya existe
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ msg: 'User already exists' });
    }

    // Hashear la contraseña
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Crear el nuevo usuario
    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      age,
      location,
    });

    res.status(201).json({ msg: 'User registered successfully', userId: newUser.id });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

// Crear o actualizar perfil de usuario
exports.createOrUpdateProfile = async (req, res) => {
  try {
      const { interests, photos, description, userId } = req.body; // Obtener userId del cuerpo de la solicitud (para pruebas sin autenticación)

      // Buscar al usuario por el userId proporcionado en el request
      const user = await User.findByPk(userId);

      if (!user) {
          return res.status(404).json({ msg: 'User not found' });
      }

      // Actualizar los campos del perfil
      user.interests = interests || user.interests;
      user.photos = photos || user.photos;
      user.description = description || user.description;

      // Guardar los cambios
      await user.save();

      res.status(200).json({ msg: 'Profile updated successfully', user });
  } catch (err) {
      console.error(err.message);
      res.status(500).send('Server error');
  }
};

// Obtener el perfil de un usuario por ID
exports.getProfile = async(req, res) => {
    try {
        const userId = req.params.userId;
        const user = await User.findByPk(userId);
        if(!user){
            return res.status(404).json({msg: 'User not found'});
        }

        res.status(200).json(user);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};//salamea