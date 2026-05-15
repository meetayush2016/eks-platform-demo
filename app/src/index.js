const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION || '1.0.0'
  });
});

const items = [
  { id: 1, name: 'EKS Cluster',  type: 'compute'  },
  { id: 2, name: 'S3 Bucket',    type: 'storage'  },
  { id: 3, name: 'RDS Instance', type: 'database' }
];

app.get('/items', (req, res) => {
  res.status(200).json({
    count: items.length,
    items: items
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});