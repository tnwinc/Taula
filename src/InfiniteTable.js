
const React = require('react');
const {PropTypes} = React;

const InfiniteTable = React.createClass({
  displayName: 'InfiniteTable',
  propTypes: {
    pageLength: PropTypes.number.isRequired,
    rowComponent: PropTypes.func,
    headerElement: PropTypes.node,
    footerElement: PropTypes.node,
    columns: PropTypes.arrayOf(PropTypes.object),
    colCount: PropTypes.number.isRequired,
    data: PropTypes.arrayOf(PropTypes.shape({
      rowData: PropTypes.arrayOf(PropTypes.node),
      item: PropTypes.object,
      rowClass: PropTypes.string,
      colSpanOverride: PropTypes.number,
    })).isRequired,
    loading: PropTypes.bool,
    loadingMessage: PropTypes.node,
    noValuesMessage: PropTypes.node,
  },
  getDefaultProps: function getDefaultProps() {
    return {
      rowComponent: require('./DefaultRow.js'),
    };
  },
  getInitialState: function getInitialState() {
    return {
      topIndex: 0,
      bottomIndex: this.props.pageLength - 1,
    };
  },
  _renderRow: function _renderRow(datum, index) {
    const Row = this.props.rowComponent;
    return (
      <Row {...datum} rowIndex={index} key={index}/>
    );
  },
  render: function render() {
    const {headerElement, footerElement, loading, data, loadingMessage, noValuesMessage, colCount} = this.props;
    return (
      <table ref='table'>
       <thead>
         { headerElement }
       </thead>
       <tbody ref='body'>
       {(() => {
         if (loading) {
           return (<tr ref='loading-row' className='centered-row'><td colSpan={colCount}>{loadingMessage}</td></tr>);
         } else if (data.length === 0 && noValuesMessage) {
           return (<tr ref='no-value-row' className='centered-row'><td colSpan={colCount}>{noValuesMessage}</td></tr>);
         }
         return data.map(this._renderRow);
       }
       )()}
       </tbody>
       <tfoot>
         { footerElement }
       </tfoot>
      </table>
    );
  },
});

module.exports = InfiniteTable;
