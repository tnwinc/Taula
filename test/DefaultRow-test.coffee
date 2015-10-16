
React = require 'react'
{createRenderer} = require 'react-addons-test-utils'
DefaultRow  = require '../src/DefaultRow.js'

{Children} = React

chai = require 'chai'
{expect} = chai

shallowRenderer = createRenderer()

describe 'default row', ->
  beforeEach ->
    @rowData = ['column1', 'column2', 'column3']
  describe 'when it renders', ->
    beforeEach ->
      shallowRenderer.render(React.createElement DefaultRow,
        rowData: @rowData
        rowClass: 'row-class'
        rowIndex: 42
        colSpanOverride: 5
      )
      @row = shallowRenderer.getRenderOutput()

    it 'should render a tr', ->
      expect(@row.type).to.equal 'tr'

    it 'should render a cell for each piece of data', ->
      expect(Children.count @row.props.children).to.equal @rowData.length
      expect(Children.toArray(@row.props.children)[0].type).to.equal 'td'

    it 'should pass through the className property', ->
      expect(@row.props.className).to.equal 'row-class'

    it 'should pass through the key property', ->
      expect(@row.key).to.equal 42.toString()

    it 'should respect the colspan property', ->
      expect(Children.toArray(@row.props.children)[0].props.colSpan).to.equal 5

    it 'should dump the data into the cells', ->
      Children.forEach @row.props.children, (cell, index)=>
        expect(cell.props.children).to.equal @rowData[index]
