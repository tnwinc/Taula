const sinon = require('sinon');
const {stub} = sinon;

const realDependencies = require('../src/Dependencies');

const debounce = stub();
debounce.returnsArg(0);

const scrollparent = stub();
scrollparent.returns(window);


const fakeDependencies = {
  debounce,
  scrollparent,
};

module.exports = Object.assign({}, realDependencies, fakeDependencies);
