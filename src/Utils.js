
const $ = require('jquery');
const React = require('react');
const ReactDOM = require('react-dom');

let iframe = undefined;
let parent = undefined;

module.exports.domFromReact = function domFromReact(component) {
  return $(ReactDOM.findDOMNode(component));
};

module.exports.setupForTest = function setupForTest() {
  if (iframe) {
    if (parent) {
      ReactDOM.unmountComponentAtNode(parent);
    }
    document.body.removeChild(iframe);
  }

  iframe = document.createElement('iframe');
  document.body.appendChild(iframe);
};

module.exports.renderFromReactClass = function renderFromReactClass(claz, props, type = 'div') {
  const element = React.createElement(claz, props);

  parent = document.createElement(type);
  iframe.appendChild(parent);

  const component = ReactDOM.render(element, parent);

  return {component, element, $domNode: $(ReactDOM.findDOMNode(component))};
};
