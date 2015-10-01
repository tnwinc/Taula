
const React = require('react');
const {PropTypes} = React;

const DefaultRow = React.createClass({
  displayName: 'DefaultRow',
  propTypes: {
    data: PropTypes.object.isRequired
  },
  render: function render() {
    return (
      <div>Hey!</div>
    );
  }
});

module.exports = DefaultRow;
