const backendURL = "https://afc9-2401-4900-4ddf-f63e-148-eb91-c50b-d0ee.ngrok-free.app/"
document.getElementById('runButton').addEventListener('click', () => {
    const commandInput = document.getElementById('commandInput');
    const terminalOutput = document.getElementById('terminalOutput'); // Fixed ID
    const command = commandInput.value;


    // Send command to the server
    fetch('http://localhost:3000/execute', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ command })
    })
    .then(response => response.text())
    .then(output => {
        // Display the output in the terminal
        terminalOutput.value += `> ${command}\n${output}\n\n`;
        terminalOutput.scrollTop = terminalOutput.scrollHeight; // Auto-scroll to the bottom
    })
    .catch(error => {
        terminalOutput.value += `Error: ${error.message}\n\n`;
        terminalOutput.scrollTop = terminalOutput.scrollHeight;
    });

    // Clear the input after command is run
    commandInput.value = '';
});
