
React = require 'react/addons'
DefaultRow  = require '../src/DefaultRow.js'

chai = require 'chai'
{expect} = chai

{findDOMNode} = React
{TestUtils} = React.addons
{createRenderer} = React.addons.TestUtils

shallowRenderer = createRenderer()

describe 'default row', ->
  beforeEach ->
    @rowData = ['column1', 'column2', 'column3']
  describe 'when it renders', ->
    beforeEach ->
      shallowRenderer.render(React.createElement DefaultRow,
        rowData: @rowData
        rowClass: 'row-class'
        rowIndex: 0
      )
      @table = shallowRenderer.getRenderOutput()

