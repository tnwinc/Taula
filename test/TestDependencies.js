const sinon = require('sinon');
const {stub} = sinon;

const debounce = stub();
debounce.returnsArg(0);

const realDependencies = require('../src/Dependencies');

const fakeDependencies = {
  debounce: debounce,
};

module.exports = Object.assign({}, realDependencies, fakeDependencies);
