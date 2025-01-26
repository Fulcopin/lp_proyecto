// controllers/search.controller.js
const { User } = require('../models');
const { Op } = require('sequelize');

exports.searchUsers = async (req, res) => {
  try {
    const { age, location } = req.query;
    const whereClause = {};

    if (age) {
      whereClause.age = age; 
    }

    if (location) {
      whereClause.location = {
        [Op.like]: `%${location}%`,
      };
    }

    const users = await User.findAll({
      where: whereClause,
    });

    res.status(200).json(users);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};