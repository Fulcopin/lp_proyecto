const { User, Sequelize } = require('../models');
const { Op } = require('sequelize');

exports.searchUsers = async (req, res) => {
    try {
        console.log('Consulta de búsqueda:', req.query); // Registro para depurar

        const { location, edadMin, edadMax } = req.query; // Nombres correctos de los parámetros

        let whereClause = {};

        if (edadMin && edadMax) {
            const minAge = parseInt(edadMin); // Convertir a entero
            const maxAge = parseInt(edadMax); // Convertir a entero

            if (isNaN(minAge) || isNaN(maxAge)) {
                return res.status(400).json({ msg: 'Edad Mínima y Edad Máxima deben ser números.' });
            }

            whereClause.age = {
                [Op.between]: [minAge, maxAge]
            };
        }

        if (location) {
            whereClause.location = {
                [Op.like]: `%${location}%`
            };
        }

        console.log('Cláusula where:', whereClause); // Registro para depurar

        const users = await User.findAll({
            where: whereClause,
            attributes: ['id', 'username', 'age', 'location']
        });

        console.log('Usuarios encontrados:', users.length); // Registro para depurar
        res.json(users);

    } catch (err) {
        console.error('Error en la búsqueda:', err);
        res.status(500).json({ msg: 'Error en búsqueda' });
    }
};