const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Autenticação v1.0 - Rodando no Kubernetes via GitHub Actions!');
});

app.listen(port, () => {
  console.log(`Auth app listening on port ${port}`);
});