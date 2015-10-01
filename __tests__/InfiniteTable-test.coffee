jest.dontMock '../lib/InfiniteTable.js'

React = require('react/addons')
InfiniteTable = require('../lib/InfiniteTable.js')
DefaultRow = require('../lib/DefaultRow.js')

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
    expect(@table.props.children.length).toEqual @data.length
