const React = require('react');
const ReactDOM = require('react-dom');
const {$} = require('../src/Dependencies');
const TestDependencies = require('./TestDependencies');

let wrapper = undefined;
let parent = undefined;


module.exports.setupForTest = function setupForTest() {
  if (wrapper) {
    if (parent) {
      ReactDOM.unmountComponentAtNode(parent);
      parent = undefined;
    }
    ReactDOM.unmountComponentAtNode(wrapper);
    document.body.removeChild(wrapper);
    wrapper = undefined;
  }

  wrapper = document.createElement('div');
  document.body.appendChild(wrapper);
};

module.exports.getWrapper = function getWrapper() {
  return $(wrapper);
};

module.exports.renderFromReactClass = function renderFromReactClass(claz, props, type) {
  const element = React.createElement(claz, props);

  if (type) {
    parent = document.createElement(type);
    wrapper.appendChild(parent);
  }

  const component = ReactDOM.render(element, parent || wrapper);

  return {component, element, $domNode: $(ReactDOM.findDOMNode(component))};
};

module.exports.getMock = function getMock(injector) {
  return injector({
    './Dependencies': TestDependencies,
  });
};
