
const $ = require('jquery');
const React = require('react');
const ReactDOM = require('react-dom');

let wrapper = undefined;
let parent = undefined;

module.exports.domFromReact = function domFromReact(component) {
  return $(ReactDOM.findDOMNode(component));
};

module.exports.setupForTest = function setupForTest() {
  if (wrapper) {
    if (parent) {
      ReactDOM.unmountComponentAtNode(parent);
    }
    document.body.removeChild(wrapper);
  }

  wrapper = document.createElement('div');
  document.body.appendChild(wrapper);
};

module.exports.getWrapper = function getWrapper() {
  return $(wrapper);
};

module.exports.renderFromReactClass = function renderFromReactClass(claz, props, type = 'div') {
  const element = React.createElement(claz, props);

  parent = document.createElement(type);
  wrapper.appendChild(parent);

  const component = ReactDOM.render(element, parent);

  return {component, element, $domNode: $(ReactDOM.findDOMNode(component))};
};
