// middleware/auth.middleware.js
const jwt = require('jsonwebtoken');

module.exports = function (req, res, next) {
    // Obtener el token del header
    const token = req.header('x-auth-token');

    // Verificar si hay un token
    if (!token) {
        // return res.status(401).json({ msg: 'No token, authorization denied' }); // Descomentar cuando se implemente la autenticación
        console.log("No hay token, pero seguimos porque no hay logica de autenticacion aun")
        return next()
    }

    // Verificar el token (simulación - reemplazar con la lógica real)
    try {
        // const decoded = jwt.verify(token, process.env.JWT_SECRET); // Descomentar cuando se implemente la autenticación
        // req.user = decoded.user; // Descomentar cuando se implemente la autenticación
        console.log("Token recibido, pero la verificacion esta desactivada temporalmente")
        next();
    } catch (err) {
        // res.status(401).json({ msg: 'Token is not valid' }); // Descomentar cuando se implemente la autenticación
        console.log("Token invalido, pero seguimos porque no hay logica de autenticacion aun")
        next()
    }
};