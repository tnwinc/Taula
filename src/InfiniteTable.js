
const React = require('react');
const {PropTypes} = React;

const $ = require('jquery');

const PRELOAD_PAGES = 3;
const MAX_PAGES = 1 + 2 * PRELOAD_PAGES;

const Chunk = require('./Chunk');
const update = require('react-addons-update');

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
    // loading: PropTypes.bool,
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
      chunks: [],
    };
  },
  componentDidMount: function componentDidMount() {
    this.props.loadData(0, this.props.pageLength * MAX_PAGES);
  },
  componentWillUpdate: function componentWillUpdate(nextProps) {
    if (nextProps.data !== this.props.data) {
      this._updateChunkedData(nextProps.data);
      this.setState({
        initialLoading: false,
      });
    }
  },
  resetData: function resetData() {
    this.setState(this.getInitialState());
  },
  _updateChunkedData: function _updateChunkedData(data) {
    const chunks = this.state.chunks;
    const {pageLength} = this.props;
    const dataChunkCount = Math.ceil(data.length / pageLength);
    const newChunks = [];
    for (let chunkIndex = chunks.length; chunkIndex < dataChunkCount; chunkIndex++) {
      const topIndex = chunkIndex * pageLength;
      const bottomIndex = (chunkIndex + 1) * pageLength;
      newChunks.push(data.slice(topIndex, bottomIndex));
    }
    const updatedChunks = update(chunks, {
      $push: newChunks,
    });
    this.setState({
      chunks: updatedChunks,
    });
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
    const visibleChunks = [];
    for (let chunkIndex = 0; chunkIndex <= this.state.bottomChunk; chunkIndex++) {
      const chunk = this.refs[chunkIndex.toString()];
      if (chunk && chunk.isVisibleIn(table)) {
        visibleChunks.push(chunkIndex);
      }
    }
    return visibleChunks;
  },
  handleScroll: function handleScroll() {
    const {pageLength, loadData} = this.props;
    const {topChunk, bottomChunk} = this.state;
    const visibleChunks = this._findVisibleChunks();
    const newTopChunk = Math.max(visibleChunks[0] - PRELOAD_PAGES, 0);
    const newBottomChunk = Math.max(visibleChunks[0] + PRELOAD_PAGES, MAX_PAGES);
    const triggeringChunk = bottomChunk - Math.floor(PRELOAD_PAGES / 2);
    const scrolledDown = visibleChunks[visibleChunks.length - 1] >= triggeringChunk;
    const scrolledUp = topChunk > 0 && visibleChunks[0] <= topChunk;
    if (scrolledDown || scrolledUp) {
      loadData(newTopChunk * pageLength, (newBottomChunk + 1) * pageLength);
      this.setState({
        topChunk: newTopChunk,
        bottomChunk: newBottomChunk,
      });
    }
  },
  _renderChunks: function _renderChunks() {
    const {rowComponent, pageLength} = this.props;
    const {topChunk, bottomChunk} = this.state;
    return this.state.chunks.map((data, index) => {
      const chunkIsVisible = (index >= topChunk && index <= bottomChunk);
      return (
        <Chunk index={index} visible={chunkIsVisible} ref={index} data={data} key={index} rowComponent={rowComponent} topIndex={index * pageLength} />
      );
    });
  },
  render: function render() {
    const {headerElement, footerElement, data, loadingMessage, noValuesMessage, colCount} = this.props;
    return (
      <table ref='table' onScroll={this.handleScroll}>
       { headerElement }
       {(() => {
         if (this.state.initialLoading) {
           return (<tbody><tr ref='loading-row' className='centered-row'><td colSpan={colCount}>{loadingMessage}</td></tr></tbody>);
         } else if (data.length === 0 && noValuesMessage) {
           return (<tbody><tr ref='no-value-row' className='centered-row'><td colSpan={colCount}>{noValuesMessage}</td></tr></tbody>);
         }
         return this._renderChunks();
       }
       )()}
       { footerElement }
      </table>
    );
  },
});

module.exports = InfiniteTable;
