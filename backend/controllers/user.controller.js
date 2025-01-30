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
    // Log full request details
    console.log('=== Profile Update Request ===');
    console.log('URL Parameters:', req.params);
    console.log('Request Body:', req.body);
    console.log('Request Headers:', req.headers);
    console.log('Request URL:', req.originalUrl);
    console.log('Request Method:', req.method);
    
    const { interests, description } = req.body;
    const { userId } = req.params;

    console.log('Processing update for userId:', userId);

    // Validate userId with type check
    if (!userId) {
      console.log('Missing userId in request');
      return res.status(400).json({
        success: false,
        msg: 'User ID is required'
      });
    }

    // Find user with error details
    console.log('Attempting to find user:', userId);
    let user;
    try {
      user = await User.findByPk(userId);
      console.log('Database query result:', user ? 'User found' : 'User not found');
    } catch (dbError) {
      console.error('Database error:', dbError);
      throw dbError;
    }
    
    if (!user) {
      console.log('User not found for ID:', userId);
      return res.status(404).json({
        success: false,
        msg: 'Usuario no encontrado',
        requestedId: userId
      });
    }

    // Log current user state
    console.log('Current user state:', user.toJSON());

    // Update fields with validation
    if (interests) {
      console.log('Updating interests from:', user.interests, 'to:', interests);
      user.interests = interests;
    }
    
    if (description) {
      console.log('Updating description from:', user.description, 'to:', description);
      user.description = description;
    }

    // Save with detailed error handling
    try {
      await user.save();
      console.log('Save successful - Updated user:', user.toJSON());
    } catch (saveError) {
      console.error('Save failed:', saveError);
      throw saveError;
    }

    // Send success response
    return res.status(200).json({
      success: true,
      user: user.toJSON()
    });

  } catch (err) {
    console.error('=== Profile Update Error ===');
    console.error('Error:', err);
    console.error('Stack:', err.stack);
    return res.status(500).json({
      success: false,
      error: 'Error del servidor',
      details: err.message,
      stack: process.env.NODE_ENV === 'development' ? err.stack : undefined
    });
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