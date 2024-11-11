const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(cors());

app.use(express.static(path.join(__dirname, 'public')));

// Serve index.html at the root URL
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html','style.css','script.js','fuzz_target.c','inputs','sam.bmp','outputs'));
});

// Endpoint to receive the command and execute it
app.post('/execute', (req, res) => {
    const command = req.body.command;

    // Check if the command is intended for fuzz_target execution
    if (command.startsWith('./fuzz_target')) {
        exec(command, (error, stdout, stderr) => {
            if (error) {
                res.status(500).send(`Error: ${stderr}`);
                //res.send(`Error: ${error.message}`);
                //return;
            }
            res.send(stderr || stdout); // Send AddressSanitizer output
        });
    } else {
        // Execute other commands, e.g., 'ls', with basic error handling
        exec(command, (error, stdout, stderr) => {
            if (error) {
                res.send(`Error: ${error.message}`);
                return;
            }
            res.send(stderr || stdout);
        });
    }
});

// Start the server
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
