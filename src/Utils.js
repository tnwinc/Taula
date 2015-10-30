
const $ = require('jquery');
const React = require('react');
const ReactDOM = require('react-dom');
const domFromReact = function domFromReact(component) {
  return $(ReactDOM.findDOMNode(component));
};
const {Children} = React;

const {findRenderedComponentWithType} = require('react-addons-test-utils');

let iframe = undefined;
let div = undefined;
module.exports = {
  domFromReact,
  setupForTest: function setupForTest(){
    if (iframe){
      if(div){
        ReactDOM.unmountComponentAtNode(div);
      }
      document.body.removeChild(iframe);
    }

    iframe = document.createElement('iframe');
    document.body.appendChild(iframe);
    
    div = document.createElement('div'); 
    div.id = 'test_container';
    
    iframe.contentDocument.body.appendChild(div)
  },
  renderFromReactClass: function renderFromReactClass (claz, props, type){
      let parent = div;
      let element = React.createElement(claz, props);
      let component = undefined;
      if (type){
        parent = document.createElement(type);
        div.appendChild(parent);
      }

      component = ReactDOM.render(element, parent);

      return {component, element, $domNode: $(ReactDOM.findDOMNode(component))};
   },
};


