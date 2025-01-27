// controllers/user.controller.js
const { User } = require('../models');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
// Registro de usuario


exports.registerUser = async (req, res) => {
  try {
    const { username, email, password, age, location } = req.body;

    if (!username || !email || !password || !age || !location) {
      return res.status(400).json({ msg: 'Por favor complete todos los campos' });
    }

    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ msg: 'El usuario ya existe' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      age,
      location,
    });

    // Generate JWT token
    const token = jwt.sign(
      { userId: newUser.id },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.status(201).json({
      msg: 'Usuario registrado exitosamente',
      userId: newUser.id,
      token,
      user: {
        id: newUser.id,
        username: newUser.username,
        email: newUser.email
      }
    });

  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ msg: 'Error del servidor' });
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

exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validación
    if (!email || !password) {
      return res.status(400).json({ 
        success: false,
        msg: 'Por favor ingrese email y contraseña' 
      });
    }

    // Buscar usuario
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(400).json({ 
        success: false,
        msg: 'Email o contraseña incorrectos' 
      });
    }

    // Verificar contraseña
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ 
        success: false,
        msg: 'Email o contraseña incorrectos' 
      });
    }

    // Generar token usando JWT_SECRET del .env
    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    // Respuesta exitosa
    res.status(200).json({
      success: true,
      msg: 'Login exitoso',
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        age: user.age,
        location: user.location
      }
    });

  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ 
      success: false,
      msg: 'Error en el servidor' 
    });
  }
};