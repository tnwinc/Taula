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
      otherProps: PropTypes.object,
    })).isRequired,
    topIndex: PropTypes.number.isRequired,
    rowComponent: PropTypes.func.isRequired,
    visible: PropTypes.bool.isRequired,
    index: PropTypes.number,
    columns: PropTypes.arrayOf(PropTypes.object),
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
    const parentTop = parent.offset().top;
    const parentHeight = parent.height();
    const myTop = this.body.offset().top - parentTop;
    const myBottom = myTop + (this.props.visible ? this.getHeight() : this.state.height);
    if (myTop >= 0 && myTop <= parentHeight) {
      return true;
    } else if (myBottom >= 0 && myBottom <= parentHeight) {
      return true;
    } else if (myTop <= 0 && myBottom >= parentHeight) {
      return true;
    }
    return false;
  },

  _updateElementCache: function _updateEndRows() {
    this.body = domFromReact(this.refs.body);
  },

  _renderRow: function _renderRow(datum, index) {
    const {rowComponent, columns} = this.props;
    const Row = rowComponent;
    const {rowData, item, rowClass, colSpanOverride, otherProps} = datum;
    return (
      <Row columns={columns} rowData={rowData} item={item} rowClass={rowClass} colSpanOverride={colSpanOverride} rowIndex={index} otherProps={otherProps} key={index} ref={index}/>
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
