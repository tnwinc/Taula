var path = require('path');

module.exports = {
  port: port,
  debug: true,
  output: {
    path: path.join(__dirname, '/dist'),
    filename: 'InfiniteTable.js',
  },
  module: {
    preLoaders: [
      {
        test: /\.(js|jsx)$/,
        include: path.join(__dirname, 'lib'),
        loader: 'eslint-loader'
      }
    ],
    loaders: [
      {
        test: /\.css$/,
        loader: 'style!css'
      }
    ]
  }
};
