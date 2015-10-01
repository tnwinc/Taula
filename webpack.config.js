var path = require('path');

module.exports = {
  entry: './index.js',
  output: {
    path: path.join(__dirname, '/dist'),
    filename: 'InfiniteTable.js',
  },
  eslint: {
    configFile: './.eslintrc.json'
  },
  module: {
    preLoaders: [
      {
        test: /\.jsx?$/,
        include: path.join(__dirname, 'lib'),
        loader: 'eslint-loader'
      }
    ],
    loaders: [
      {
        test: /\.css$/,
        loader: 'style!css'
      },
      {
        test: /\.jsx?$/,
        exclude: /(dist|node_modules|bower_components)/,
        loader: 'babel'
      }
    ]
  }
};
