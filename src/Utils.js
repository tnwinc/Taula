
const $ = require('jquery');
const ReactDOM = require('react-dom');

export const domFromReact = function domFromReact(component) {
  return $(ReactDOM.findDOMNode(component));
};
