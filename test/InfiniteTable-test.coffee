React = require('react/addons')
InfiniteTable = require('../src/InfiniteTable.js')
DefaultRow = require('../src/DefaultRow.js')

chai = require 'chai'
{expect} = chai

{findDOMNode} = React
{TestUtils} = React.addons
{createRenderer} = React.addons.TestUtils

shallowRenderer = createRenderer()

describe 'InfiniteTable', ->
  beforeEach ->
    @data = [
      { one: 'one' }
      { two: 'two' }
      { three: 'three' }
    ]
    shallowRenderer.render(React.createElement InfiniteTable,
      data: @data
      pageLength: 5
    )
    @table = shallowRenderer.getRenderOutput()
  it 'renders a row per data item', ->
    expect(@table.props.children.length).to.equal @data.length
