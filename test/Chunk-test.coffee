React = require 'react'
{createRenderer, isElementOfType, renderIntoDocument} = require 'react-addons-test-utils'
Chunk  = require '../src/Chunk.js'
DefaultRow  = require '../src/DefaultRow.js'
{domFromReact, setupForTest, renderFromReactClass} = require('../src/Utils')

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
    setupForTest()

  describe 'when it mounts', ->
    it 'should store a ref to the tbody',->
  describe 'when the visibility changes', ->
    describe 'to hidden', ->
      it 'should store the height', ->
    describe 'to visible',->
      it 'should not store the height', ->
  describe 'when it updates', ->
    it 'should store a ref to the tbody', ->
  describe 'getting the height',->
    describe 'when its visible', ->
      it 'should get the height from the dom',->
    describe 'when its hidden', ->
      it 'should get the height from the state', ->
  describe 'when checking visibility', ->
    describe 'when the scroll parent is the window', ->
      describe 'when the chunk is fully contained',->
      describe 'when the chunk is partially off the top',->
      describe 'when the chunk is partially off the bottom',->
      describe 'when the chunk is off the bottom',->
      describe 'when the chunk is off the top',->
      describe 'when the chunk is larger than the parent height and it\'s completely visible', ->
    describe 'when the scroll parent is not the window',->
      describe 'when the chunk is fully contained',->
      describe 'when the chunk is partially off the top',->
      describe 'when the chunk is partially off the bottom',->
      describe 'when the chunk is off the bottom',->
      describe 'when the chunk is off the top',->
      describe 'when the chunk is larger than the parent height and it\'s completely visible', ->
        
  describe 'when it renders',->
    describe 'when chunk is not visible', ->
      beforeEach ->
        {@component, @element, @$domNode} = renderFromReactClass(Chunk,
          data:[
            rowData: @rows
            rowClass: 'row-class'
            colSpanOverride: 5
          ],
          rowComponent: DefaultRow
          visible: false
        ,
        'table'
        )

      it 'should render a tbody', ->
        expect(@$domNode.is('tbody')).to.be.true
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

      it 'should render a visible chunk tbody', ->
        expect(@row.type).to.equal 'tbody'
      it 'should have default row as its first child', ->
        expect(isElementOfType(Children.toArray(@row.props.children)[0], DefaultRow)).to.be.true