
const React = require('react');
const {PropTypes} = React;

const DefaultRow = React.createClass({
  displayName: 'DefaultRow',
  propTypes: {
    item: PropTypes.arrayOf(PropTypes.node).isRequired,
    className: PropTypes.string,
    colSpanOverride: PropTypes.number,
    rowIndex: PropTypes.number.isRequired,
    getMoreRowClasses: PropTypes.func,
  },
  _renderCell: function _renderCell(cellData, index) {
    return (<td key={index} colSpan={this.props.colSpanOverride}>{cellData}</td>);
  },
  render: function render() {
    const {item, className, rowIndex, getMoreRowClasses} = this.props;
    const classNames = getMoreRowClasses ? getMoreRowClasses(className, item, rowIndex) : className;
    return (
      <tr className={classNames} key={rowIndex}>
       {
         item.map(this._renderCell)
       }
      </tr>
    );
  },
});
module.exports = DefaultRow;
