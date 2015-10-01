
'use strict';

const React = require('react');
const {PropTypes} = React;

const InfiniteTable = React.createClass({
  displayName: 'InfiniteTable',
  propTypes: {
    data: PropTypes.arrayOf(PropTypes.object).isRequired,
    pageLength: PropTypes.number.isRequired,
    rowComponent: PropTypes.func
  },
  render: function render() {
    return (
      <div>Hey!</div>
    );
  }
});

module.exports = InfiniteTable;
