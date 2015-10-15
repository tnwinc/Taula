React = require('react/addons')
InfiniteTable = require('../src/InfiniteTable.js')
DefaultRow = require('../src/DefaultRow.js')

chai = require 'chai'
{expect} = chai

{findDOMNode, Children} = React
{TestUtils} = React.addons
{createRenderer, scryRenderedComponentsWithType} = React.addons.TestUtils

shallowRenderer = createRenderer()

describe 'InfiniteTable', ->
  beforeEach ->
    @data = [
      rowData: ['one']
    ,
      rowData: ['two']
    ,
      rowData: ['three']
    ]
    shallowRenderer.render(React.createElement InfiniteTable,
      data: @data
      pageLength: 5
      colCount: 3
    )
    @table = shallowRenderer.getRenderOutput()
    @tbody = Children.only @table.props.children
  it 'should render a table', ->
    expect(@table.type).to.equal 'table'

  it 'should render a tbody', ->
    expect(@tbody.type).to.equal 'tbody'

  it 'should a row per datum', ->
    expect(Children.count @tbody.props.children).to.equal @data.length
