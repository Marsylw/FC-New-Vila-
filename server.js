import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from root directory
app.use(express.static(__dirname));

// Direct friendly route handlers
app.get(['/', '/index', '/index.html'], (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get(['/admin', '/admin.html'], (req, res) => {
  res.sendFile(path.join(__dirname, 'admin.html'));
});

app.get(['/perfil', '/perfil.html'], (req, res) => {
  res.sendFile(path.join(__dirname, 'perfil.html'));
});

app.get(['/publico', '/publico.html'], (req, res) => {
  res.sendFile(path.join(__dirname, 'publico.html'));
});

// Fallback to index.html
app.use((req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`FC New Vila server listening on http://0.0.0.0:${PORT}`);
});
