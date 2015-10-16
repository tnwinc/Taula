
const React = require('react');
const {PropTypes} = React;

const $ = require('jquery');

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
    bulkLoad: PropTypes.bool,
    loadData: PropTypes.func,
  },
  getDefaultProps: function getDefaultProps() {
    return {
      rowComponent: require('./DefaultRow.js'),
    };
  },
  getInitialState: function getInitialState() {
    return {
      topChunk: 0,
      bottomChunk: 2,
      initialLoading: true,
    };
  },
  componentDidMount: function componentDidMount() {
    this.props.loadData(0, this.props.pageLength * 3);
  },
  componentDidUpdate: function componentDidUpdate() {
    // if (prevState.topIndex !== this.state.topIndex || prevState.bottomIndex !== this.state.bottomIndex) {
    //   this.scrollToIndex();
    // }
  },
  scrollToIndex: function scrollToIndex() {
    // implement later
  },
  resetData: function resetData() {
    this.setState(this.getInitialState());
  },
  findVisibleChunks: function findVisibleChunks() {
    const tbody = $(this.refs.body);
    const scrollTop = tbody.scrollTop();
    const scrollBottom = scrollTop + tbody.height();
    const rows = tbody.children('tr');
    const visibleChunks = [];
    for (let chunkIndex = 0; chunkIndex <= this.state.bottomChunk - this.state.topChunk; chunkIndex++) {
      const firstRow = rows[chunkIndex * this.props.pageLength];
      const chunkTop = firstRow.scrollTop();
      if (chunkTop >= scrollTop && chunkTop <= scrollBottom) {
        visibleChunks.push(chunkIndex);
      }
    }
    return visibleChunks;
  },
  handleScroll: function handleScroll() {
    const {pageLength, loadData} = this.props;
    const {topChunk, bottomChunk} = this.state;
    const visibleChunks = this.findVisibleChunks();
    // How to handle telling when there's no more to scroll?
    if (visibleChunks[visibleChunks.length - 1] >= bottomChunk) {
      loadData((bottomChunk + 1) * pageLength, (bottomChunk + 2) * pageLength);
      this.setState({
        topChunk: topChunk + 1,
        bottomChunk: bottomChunk + 1,
      });
    } else if (topChunk > 0 && visibleChunks[0] <= topChunk) {
      loadData((topChunk - 1) * pageLength, (topChunk - 0) * pageLength);
      this.setState({
        topChunk: topChunk - 1,
        bottomChunk: bottomChunk - 1,
      });
    }
    // Handle case where no chunks are visible?
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
      <table ref='table' onScroll={this.handleScroll}>
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
