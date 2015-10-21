const React = require('react');
const {PropTypes} = React;
const {PureRenderMixin} = require('react-addons-pure-render-mixin');
const {domFromReact} = require('./Utils');

const Chunk = React.createClass({
  displayName: 'Chunk',
  propTypes: {
    data: PropTypes.arrayOf(PropTypes.shape({
      rowData: PropTypes.arrayOf(PropTypes.node),
      item: PropTypes.object,
      rowClass: PropTypes.string,
      colSpanOverride: PropTypes.number,
    })).isRequired,
    topIndex: PropTypes.number.isRequired,
    rowComponent: PropTypes.func.isRequired,
  },
  mixins: [PureRenderMixin],

  componentDidMount: function componentDidMount() {
    this._updateEndRows();
  },

  componentDidUpdate: function componentDidUpdate() {
    this._updateEndRows();
  },

  getHeight: function getHeight() {
    const firstRow = this.firstRow;
    const lastRow = this.lastRow;
    const firstRowTop = firstRow.offset().top;
    const lastRowTop = lastRow.offset().top;
    const lastRowBottom = lastRowTop + lastRow.height();
    return lastRowBottom - firstRowTop;
  },

  isVisibleIn: function isVisibleIn(parent) {
    const parentTop = parent.offset().top;
    const parentHeight = parent.height();
    const firstRow = this.firstRow;
    const myTop = firstRow.offset().top - parentTop;
    const myBottom = myTop + this.getHeight();
    if (myTop >= 0 && myTop <= parentHeight) {
      return true;
    } else if (myBottom >= 0 && myBottom <= parentHeight) {
      return true;
    } else if (myTop <= 0 && myBottom >= parentHeight) {
      return true;
    }
    return false;
  },

  _updateEndRows: function _updateEndRows() {
    this.firstRow = domFromReact(this.refs['0']);
    this.lastRow = domFromReact(this.refs[(this.props.data.length - 1).toString()]);
  },

  _renderRow: function _renderRow(datum, index) {
    const Row = this.props.rowComponent;
    return (
      <Row {...datum} rowIndex={index} key={index} ref={index}/>
    );
  },
  render: function render() {
    return (
      <tbody>
        {
          this.props.data.map(this._renderRow)
        }
      </tbody>
    );
  },
});

module.exports = Chunk;
