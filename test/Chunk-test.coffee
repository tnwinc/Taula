React = require 'react'
{createRenderer, isElementOfType, renderIntoDocument} = require 'react-addons-test-utils'
Chunk  = require '../src/Chunk.js'
DefaultRow  = require '../src/DefaultRow.js'

{Children} = React

chai = require 'chai'
{expect} = chai

shallowRenderer = createRenderer()

getRow = (index) ->
  return ["column#{index}1", "column2#{index}", "column3#{index}"]

describe 'chunk of table rows', ->
  beforeEach ->
    @rows = []
    @rows.push getRow(index) for index in [1..10]

  describe 'when it renders', ->
    describe 'when chunk is not visible', ->
      beforeEach ->
        @row = renderIntoDocument(React.createElement Chunk,
          data:[
            rowData: @rows
            rowClass: 'row-class'
            colSpanOverride: 5
          ],
          rowComponent: DefaultRow
          visible: false
        ) 

      it 'should render a tbody', ->
        expect(@row.type).to.equal 'tbody'
      it 'should have a single child with the correct height', ->

    describe 'when chunk is visible', ->
      beforeEach ->
        shallowRenderer.render(React.createElement Chunk,
          data:[
            rowData: @rows
            rowClass: 'row-class'
            colSpanOverride: 5
          ],
          rowComponent: DefaultRow
          visible: true
        ) 
        @row = shallowRenderer.getRenderOutput()

      it 'should render a tbody', ->
        expect(@row.type).to.equal 'tbody'
      it 'should have default row as its first child', ->
        expect(isElementOfType(Children.toArray(@row.props.children)[0], DefaultRow)).to.be.true

