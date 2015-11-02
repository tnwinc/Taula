
const React = require('react');
const {PropTypes} = React;

const PRELOAD_CHUNKS = 3;
const MIN_CHUNKS = 1 + 2 * PRELOAD_CHUNKS;
const TRIGGER_COUNT = Math.floor(PRELOAD_CHUNKS / 2);

const Chunk = require('./Chunk');
const update = require('react-addons-update');
const {$, debounce, scrollparent} = require('./Dependencies');
const {domFromReact} = require('./ReactUtils');

const InfiniteTable = React.createClass({
  displayName: 'InfiniteTable',

  propTypes: {
    customRowComponent: PropTypes.func,
    headerElement: PropTypes.node,
    columnMetadata: PropTypes.arrayOf(PropTypes.object),
    columnCount: PropTypes.number.isRequired,
    data: PropTypes.arrayOf(PropTypes.shape({
      rowData: PropTypes.arrayOf(PropTypes.node),
      item: PropTypes.object,
      rowClass: PropTypes.string,
      colSpanOverride: PropTypes.number,
    })).isRequired,
    loading: PropTypes.bool,
    loadingMessage: PropTypes.node,
    noDataMessage: PropTypes.string,
    chunkSize: PropTypes.number.isRequired,
    loadData: PropTypes.func,
    tableClassName: PropTypes.string,
  },

  getDefaultProps: function getDefaultProps() {
    return {
      customRowComponent: require('./DefaultRow.js'),
    };
  },

  getInitialState: function getInitialState() {
    return {
      topChunk: 0,
      bottomChunk: MIN_CHUNKS - 1,
      chunks: [],
      noMoreToLoad: false,
    };
  },

  componentWillMount: function componentWillMount() {
    this.debouncedLoadData = debounce((bottomIndex)=> {
      if (!this.state.noMoreToLoad) {
        this.props.loadData(bottomIndex);
      }
    }, 200);
    if (this.props.data.length > 0) {
      this._updateChunkedData(this.props.data);
    }
  },

  componentDidMount: function componentDidMount() {
    this.scrollParent = $(scrollparent(this.refs.table));
    this.scrollParent.on('scroll', this.handleScroll);
    const initialLength = this.getInitialLength();
    if (this.props.data.length < initialLength) {
      this.props.loadData(initialLength);
    }
  },

  componentWillUpdate: function componentWillUpdate(nextProps) {
    if (nextProps.data !== this.props.data) {
      this._updateChunkedData(nextProps.data);
    }
  },

  componentWillUnmount: function componentWillUnmount() {
    this.scrollParent.off('scroll', this.handleScroll);
  },

  getInitialLength: function getInitialLength() {
    return this.props.chunkSize * MIN_CHUNKS;
  },

  resetData: function resetData(callback) {
    domFromReact(this.refs.table).scrollTop(0);
    this.setState(this.getInitialState(), callback);
  },

  getConstants: function getConstants() {
    return {
      PRELOAD_CHUNKS, MIN_CHUNKS, TRIGGER_COUNT,
    };
  },

  _updateChunkedData: function _updateChunkedData(data) {
    const chunks = this.state.chunks;
    const {chunkSize} = this.props;
    const dataChunkCount = Math.ceil(data.length / chunkSize);
    const newChunks = [];
    let foundAShortChunk = false;
    for (let chunkIndex = chunks.length; chunkIndex < dataChunkCount; chunkIndex++) {
      const topIndex = chunkIndex * chunkSize;
      const bottomIndex = (chunkIndex + 1) * chunkSize;
      const slice = data.slice(topIndex, bottomIndex);
      foundAShortChunk = slice.length < chunkSize;
      newChunks.push(slice);
    }
    const updatedChunks = update(chunks, {
      $push: newChunks,
    });
    this.setState({
      chunks: updatedChunks,
      noMoreToLoad: foundAShortChunk,
    });
  },

  _findVisibleChunks: function _findVisibleChunks() {
    const parent = $(scrollparent(this.refs.table));
    const visibleChunks = [];
    let chunkIndex = 0;
    let chunk = this.refs['0'];
    let foundVisibleChunk = false;
    while (chunk) {
      if (chunk.isVisibleIn(parent)) {
        foundVisibleChunk = true;
        visibleChunks.push(chunkIndex);
      } else if (foundVisibleChunk) {
        // in this case, we know that there's no more visible chunks
        break;
      }
      chunkIndex++;
      chunk = this.refs[chunkIndex.toString()];
    }
    return visibleChunks;
  },

  handleScroll: function handleScroll() {
    const {chunkSize} = this.props;
    const {topChunk, bottomChunk} = this.state;
    const visibleChunks = this._findVisibleChunks();
    const newTopChunk = Math.max(visibleChunks[0] - PRELOAD_CHUNKS, 0);
    const newBottomChunk = Math.max(visibleChunks[visibleChunks.length - 1] + PRELOAD_CHUNKS, MIN_CHUNKS);
    const triggeringChunkTop = topChunk + TRIGGER_COUNT;
    const triggeringChunkBottom = bottomChunk - TRIGGER_COUNT;
    const scrolledDown = visibleChunks[visibleChunks.length - 1] >= triggeringChunkBottom;
    const scrolledUp = topChunk > 0 && visibleChunks[0] <= triggeringChunkTop;
    if (scrolledDown) {
      this.debouncedLoadData((newBottomChunk + 1) * chunkSize);
    }
    if (scrolledDown || scrolledUp) {
      this.setState({
        topChunk: newTopChunk,
        bottomChunk: newBottomChunk,
      });
    }
  },

  _renderChunks: function _renderChunks() {
    const {customRowComponent, columnMetadata} = this.props;
    const {topChunk, bottomChunk} = this.state;
    return this.state.chunks.map((data, chunkIndex) => {
      const chunkIsVisible = (chunkIndex >= topChunk && chunkIndex <= bottomChunk);
      return (
        <Chunk visible={chunkIsVisible} ref={chunkIndex} data={data} key={chunkIndex} columnMetadata={columnMetadata} rowComponent={customRowComponent} />
      );
    });
  },

  render: function render() {
    const {headerElement, data, loading, loadingMessage, noDataMessage, columnCount, tableClassName} = this.props;
    return (
      <table className={tableClassName} ref='table' onScroll={this.handleScroll}>
       { headerElement }
       {(() => {
         if (!loading && data.length === 0 && noDataMessage) {
           return (<tbody><tr ref='no-value-row' className='centered-row'><td colSpan={columnCount}>{noDataMessage}</td></tr></tbody>);
         }
         return this._renderChunks();
       }
       )()}
       {
         loading ? <tbody><tr className='centered-row'><td colSpan={columnCount}>{loadingMessage}</td></tr></tbody> : undefined
       }
      </table>
    );
  },
});

module.exports = InfiniteTable;
