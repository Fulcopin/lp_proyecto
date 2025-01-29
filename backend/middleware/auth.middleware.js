const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.verifyToken = (req, res, next) => {
    try {
        // Get token from Authorization header
        const authHeader = req.header('Authorization');
        if (!authHeader) {
            return res.status(401).json({ msg: 'No token proporcionado' });
        }

        // Extract token without Bearer prefix
        const token = authHeader.replace('Bearer ', '');

        // Verify token exists
        if (!token) {
            return res.status(401).json({ msg: 'Token no encontrado' });
        }

        // Verify JWT_SECRET exists
        if (!process.env.JWT_SECRET) {
            console.error('JWT_SECRET no configurado');
            return res.status(500).json({ msg: 'Error de configuración del servidor' });
        }

        // Verify token and extract user data
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        
        next();
    } catch (err) {
        console.error('Auth error:', err);
        res.status(401).json({ msg: 'Token inválido' });
    }
};