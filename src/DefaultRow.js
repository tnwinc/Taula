
const React = require('react');
const {PropTypes} = React;

const DefaultRow = React.createClass({
  displayName: 'DefaultRow',
  propTypes: {
    item: PropTypes.arrayOf(PropTypes.node).isRequired,
    className: PropTypes.string,
    colSpanOverride: PropTypes.number,
    rowIndex: PropTypes.number.isRequired,
  },
  _renderCell: function _renderCell(cellData, index) {
    return (<td key={index} colSpan={this.props.colSpanOverride}>{cellData}</td>);
  },
  render: function render() {
    const {item, className, rowIndex} = this.props;
    return (
      <tr className={className} key={rowIndex}>
       {
         item.map(this._renderCell)
       }
      </tr>
    );
  },
});
module.exports = DefaultRow;
