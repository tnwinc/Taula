const React = require('react');
const {PropTypes} = React;
const {PureRenderMixin} = require('react-addons-pure-render-mixin');
const {domFromReact} = require('./ReactUtils');

const Chunk = React.createClass({
  displayName: 'Chunk',

  propTypes: {
    data: PropTypes.arrayOf(PropTypes.shape({
      rowData: PropTypes.arrayOf(PropTypes.node),
      item: PropTypes.object,
      rowClass: PropTypes.string,
      colSpanOverride: PropTypes.number,
      otherProps: PropTypes.object,
    })).isRequired,
    rowComponent: PropTypes.func.isRequired,
    visible: PropTypes.bool.isRequired,
    columnMetadata: PropTypes.arrayOf(PropTypes.object),
  },
  mixins: [PureRenderMixin],

  getInitialState: function getInitialState() {
    return {
      height: 0,
    };
  },

  componentDidMount: function componentDidMount() {
    this._updateElementCache();
  },

  componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
    if (this.props.visible && !nextProps.visible) {
      this.setState({
        height: this.getHeight(),
      });
    }
  },

  componentDidUpdate: function componentDidUpdate() {
    this._updateElementCache();
  },

  getHeight: function getHeight() {
    return this.props.visible ? this.body.height() : this.state.height;
  },

  isVisibleIn: function isVisibleIn(parent) {
    const parentOffset = parent.offset();
    const parentHeight = parent.height();
    // window doesn't have an offset, so if it's our parent, use its scrollTop
    const parentTop = parentOffset ? parentOffset.top : parent.scrollTop();
    const myTop = this.body.offset().top - parentTop;
    const myBottom = myTop + this.getHeight();
    return myBottom >= 0 && myTop <= parentHeight;
  },

  _updateElementCache: function _updateEndRows() {
    this.body = domFromReact(this.refs.body);
  },

  _renderRow: function _renderRow(datum, index) {
    const {rowComponent, columnMetadata} = this.props;
    const Row = rowComponent;
    const {rowData, item, rowClass, colSpanOverride, otherProps} = datum;
    return (
      <Row
        ref={index}
        key={index}
        columnMetadata={columnMetadata}
        rowData={rowData}
        item={item}
        rowClass={rowClass}
        colSpanOverride={colSpanOverride}
        rowIndex={index}
        otherProps={otherProps}
      />
    );
  },

  render: function render() {
    if (this.props.visible) {
      return (
        <tbody ref='body'>
          {
            this.props.data.map(this._renderRow)
          }
        </tbody>
      );
    }
    return (
      <tbody ref='body'>
        <tr style={{minHeight: this.state.height + 'px', display: 'block'}}/>
      </tbody>
    );
  },
});

module.exports = Chunk;
