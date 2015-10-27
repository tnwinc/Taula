
const $ = require('jquery');
const ReactDOM = require('react-dom');

const domFromReact = function domFromReact(component) {
  return $(ReactDOM.findDOMNode(component));
};

module.exports = {
  domFromReact,
};
