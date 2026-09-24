import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from root
app.use(express.static(__dirname));

// Route handlers for convenient URLs
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'admin.html'));
});

app.get('/perfil', (req, res) => {
  res.sendFile(path.join(__dirname, 'perfil.html'));
});

app.get('/publico', (req, res) => {
  res.sendFile(path.join(__dirname, 'publico.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`FC New Vila server listening on http://0.0.0.0:${PORT}`);
});
