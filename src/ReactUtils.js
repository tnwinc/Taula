const ReactDOM = require('react-dom');
const {$} = require('./Dependencies');

module.exports.domFromReact = function domFromReact(component) {
  return $(ReactDOM.findDOMNode(component));
};
