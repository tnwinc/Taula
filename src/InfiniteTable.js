
const React = require('react');
const {PropTypes} = React;

const $ = require('jquery');

const PRELOAD_PAGES = 2;
const MAX_PAGES = 1 + 2 * PRELOAD_PAGES;

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
      bottomChunk: MAX_PAGES - 1,
      hiddenTop: 0,
      hiddenBottom: 0,
      initialLoading: true,
    };
  },
  componentDidMount: function componentDidMount() {
    this.props.loadData(0, this.props.pageLength * MAX_PAGES);
  },
  componentDidUpdate: function componentDidUpdate(prevProps, prevState) {
    if (prevState.topChunk !== this.state.topChunk || prevState.bottomChunk !== this.state.bottomChunk) {
      this._handleChunkUpdate(prevState);
    }
  },
  scrollToIndex: function scrollToIndex() {
    // implement later
  },
  resetData: function resetData() {
    this.setState(this.getInitialState());
  },
  _calculateChunkHeight: function _calculateChunkHeight(index) {
    const rows = $(this.refs.body).find('tr');
    // offset for hidden trs?
    const firstRow = index * this.props.pageLength;
    const lastRow = (index + 1) * this.props.pageLength;
    let sum = 0;
    for (let rowIndex = firstRow; rowIndex < lastRow; rowIndex++) {
      sum += rows.eq(rowIndex).height();
    }
    return sum;
  },
  _findVisibleChunks: function findVisibleChunks() {
    const table = $(this.refs.table);
    const tableTop = table.offset().top;
    const scrollTop = table.scrollTop();
    const scrollBottom = scrollTop + table.height();
    const rows = table.find('tbody tr');
    const headHeight = table.find('thead').height();
    const visibleChunks = [];
    const lastChunk = this.state.bottomChunk - this.state.topChunk;
    for (let chunkIndex = 0; chunkIndex <= lastChunk; chunkIndex++) {
      const firstRow = rows.eq(chunkIndex * this.props.pageLength);
      const chunkTop = firstRow.offset().top - tableTop - headHeight;
      const topOfChunkVisible = chunkTop >= scrollTop && chunkTop <= scrollBottom;
      const topOfChunkOffBottom = chunkTop > scrollBottom;
      if (topOfChunkVisible) {
        if (chunkIndex === 0) {
          visibleChunks.push(chunkIndex);
        } else if (chunkIndex === lastChunk) {
          visibleChunks.push(chunkIndex - 1);
          visibleChunks.push(chunkIndex);
        } else {
          visibleChunks.push(chunkIndex - 1);
        }
      } else if (topOfChunkOffBottom) {
        visibleChunks.push(chunkIndex - 1);
        break;
      }
    }
    if (visibleChunks.length === 0) {
      visibleChunks.push(lastChunk);
    }
    return visibleChunks;
  },
  _handleChunkUpdate: function _handleChunkUpdate(prevState) {
    const prevTopChunk = prevState.topChunk;
    const {topChunk, hiddenTop} = this.state;
    let newHeight = hiddenTop;
    for (let chunkIndex = prevTopChunk; chunkIndex < topChunk; chunkIndex++) {
      newHeight += this._calculateChunkHeight(chunkIndex);
    }
    this.setState({
      hiddenTop: newHeight,
    });
  },
  handleScroll: function handleScroll() {
    const {pageLength, loadData} = this.props;
    const {topChunk, bottomChunk} = this.state;
    const visibleChunks = this._findVisibleChunks();
    // How to handle telling when there's no more to scroll?
    if (visibleChunks[visibleChunks.length - 1] >= bottomChunk) {
      loadData((topChunk + 1) * pageLength, (bottomChunk + 2) * pageLength);
      this.setState({
        topChunk: topChunk + 1,
        bottomChunk: bottomChunk + 1,
      });
    } else if (topChunk > 0 && visibleChunks[0] <= topChunk) {
      loadData((topChunk - 1) * pageLength, bottomChunk * pageLength);
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
  _renderRows: function _renderRows() {
    const rows = [];
    const firstRow = 0;
    const lastRow = MAX_PAGES * this.props.pageLength;
    const {hiddenTop} = this.state;
    if (hiddenTop > 0) {
      rows.push(
        <tr key='hiddenTop' style={{height: hiddenTop + 'px'}} />
      );
    }
    for (let rowIndex = firstRow; rowIndex < lastRow && rowIndex < this.props.data.length; rowIndex++) {
      rows.push(this._renderRow(this.props.data[rowIndex], rowIndex));
    }
    return rows;
  },
  render: function render() {
    const {headerElement, footerElement, loading, data, loadingMessage, noValuesMessage, colCount} = this.props;
    return (
      <table ref='table' onScroll={this.handleScroll}>
       { headerElement }
       <tbody ref='body'>
       {(() => {
         if (loading) {
           return (<tr ref='loading-row' className='centered-row'><td colSpan={colCount}>{loadingMessage}</td></tr>);
         } else if (data.length === 0 && noValuesMessage) {
           return (<tr ref='no-value-row' className='centered-row'><td colSpan={colCount}>{noValuesMessage}</td></tr>);
         }
         return this._renderRows();
       }
       )()}
       </tbody>
       { footerElement }
      </table>
    );
  },
});

module.exports = InfiniteTable;
