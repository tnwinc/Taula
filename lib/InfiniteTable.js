
const React = require('react');
const {PropTypes} = React;
const _ = require('lodash');

const InfiniteTable = React.createClass({
  displayName: 'InfiniteTable',
  propTypes: {
    data: PropTypes.arrayOf(PropTypes.object).isRequired,
    pageLength: PropTypes.number.isRequired,
    rowComponent: PropTypes.func
  },
  getDefaultProps: function getDefaultProps() {
    return {
      rowComponent: require('./DefaultRow.js')
    }
  },
  getInitialState: function getInitialState() {
    return {
      topIndex: 0,
      bottomIndex: this.props.pageLength - 1
    };
  },
  _renderRow: function _renderRow(datum, index) {
    const Row = this.props.rowComponent;
    return (
      <Row data={datum} key={index}/>
    );
  },
  render: function render() {
    return (
      <div>
      {
        _.map(this.props.data, this._renderRow)
      }
      </div>
    );
  }
});

module.exports = InfiniteTable;
