
React = require 'react'
{createRenderer} = require 'react-addons-test-utils'
DefaultRow  = require '../src/DefaultRow.js'

chai = require 'chai'
{expect} = chai

{findDOMNode} = React

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
