const express = require('express');
const cors = require('cors');
const { sequelize, authenticateDB } = require('./config/db');
const path = require('path');
const fs = require('fs');


const app = express();



// Basic middleware
app.use(express.json());

// Simple CORS
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
});

// Database and Routes
authenticateDB()
    .then(() => sequelize.sync())
    .then(() => {
        console.log('✅ Database connected');
        
        // Routes
        app.use('/api/users', require('./routes/user.routes'));
        app.use('/api/search', require('./routes/search.routes'));
        app.use('/api/friends', require('./routes/friend.routes'));
        
        const PORT = 5000;
        app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
    })
    .catch(err => {
        console.error('Server error:', err);
        process.exit(1);
    });