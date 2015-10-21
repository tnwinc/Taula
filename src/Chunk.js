const React = require('react');
const {PropTypes} = React;
const {PureRenderMixin} = require('react-addons-pure-render-mixin');

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

  _renderRow: function _renderRow(datum, index) {
    const Row = this.props.rowComponent;
    return (
      <Row {...datum} rowIndex={index} key={index}/>
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
