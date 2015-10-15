
const React = require('react');
const {PropTypes} = React;

const DefaultRow = React.createClass({
  displayName: 'DefaultRow',
  propTypes: {
    rowData: PropTypes.arrayOf(PropTypes.node).isRequired,
    rowClass: PropTypes.string,
    colSpanOverride: PropTypes.number,
    rowIndex: PropTypes.number.isRequired,
  },
  _renderCell: function _renderCell(cellData, index) {
    return (<td ref="renderedCell" key={index} colSpan={this.props.colSpanOverride}>{cellData}</td>);
  },
  render: function render() {
    const {rowData, rowClass, rowIndex} = this.props;
    return (
      <tr className={rowClass} key={rowIndex}>
       {
         rowData.map(this._renderCell)
       }
      </tr>
    );
  },
});
module.exports = DefaultRow;
