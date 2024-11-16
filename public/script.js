const backendURL = 'https://2503f20c-33d2-42c9-a252-3e32ae999a01-00-333mj5s20cksj.pike.replit.dev';
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
Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// Animation effect on page load
window.onload = () => {
    const sections = document.querySelectorAll('section');
    sections.forEach(section => {
        section.style.opacity = 0;
        section.style.transform = 'translateY(20px)';
        setTimeout(() => {
            section.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            section.style.opacity = 1;
            section.style.transform = 'translateY(0)';
        }, 100);
    });
};
