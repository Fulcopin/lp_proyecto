const { User } = require('../models');
const { Op } = require('sequelize');

exports.searchUsers = async (req, res) => {
    try {
        const { age, location, edadMin, edadMax } = req.query;

        let whereClause = {};

        if (age) {
            whereClause.age = age;
        } else if (edadMin && edadMax) {
            whereClause.age = { [Op.between]: [edadMin, edadMax] };
        }

        if (location) {
            whereClause.location = { [Op.like]: `%${location}%` };
        }

        const users = await User.findAll({
            where: whereClause,
            attributes: ['id', 'username', 'age', 'location', 'description', 'interests', 'photos']
        });

        // Si no se encuentran usuarios, devolver un array vacío o un mensaje
        if (users.length === 0) {
            return res.status(200).json({ msg: 'No users found matching the criteria', users: [] }); 
            // También puedes usar 404 si prefieres, pero 200 con un array vacío es común en búsquedas.
            // return res.status(404).json({ msg: 'No users found matching the criteria' });
        }

        res.status(200).json(users);

    } catch (err) {
        console.error(err.message);

        // Manejo de errores específicos
        if (err instanceof Sequelize.ValidationError) {
            // Error de validación de Sequelize (por ejemplo, datos de entrada incorrectos)
            return res.status(400).json({ msg: 'Validation error', error: err.message });
        }

        if (err instanceof Sequelize.ConnectionError) {
            // Error de conexión a la base de datos
            return res.status(503).json({ msg: 'Database connection error', error: err.message });
        }

        // Error genérico del servidor
        res.status(500).send('Server error');
    }
};