var path = require('path');

module.exports = {
  entry: './src/InfiniteTable.js',
  output: {
    path: path.join(__dirname, '/dist'),
    filename: 'InfiniteTable.js',
    library: 'InfiniteTable',
    libraryTarget: 'umd'
  },
  eslint: {
    configFile: './.eslintrc'
  },
  module: {
    preLoaders: [
      {
        test: /\.jsx?$/,
        include: path.join(__dirname, 'src'),
        loader: 'eslint-loader'
      }
    ],
    loaders: [
      {
        test: /\.css$/,
        loader: 'style!css'
      },
      { test: /\.coffee$/, loaders: ['coffee']},
      {
        test: /\.jsx?$/,
        exclude: /(test|dist|node_modules|bower_components)/,
        loader: 'babel?optional=runtime'
      }
    ]
  },
  externals: [
    {
      'react': {
        root: 'React',
        commonjs2: 'react',
        commonjs: 'react',
        amd: 'react'
      }
    },
    {
      'react-dom': {
        root: 'ReactDOM',
        commonjs2: 'react-dom',
        commonjs: 'react-dom',
        amd: 'react-dom'
      }
    }
  ]
};
