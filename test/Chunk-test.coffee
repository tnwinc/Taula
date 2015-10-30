React = require 'react'
{Children} = React
{createRenderer, isElementOfType, renderIntoDocument} = require 'react-addons-test-utils'

Chunk  = require '../src/Chunk.js'
DefaultRow  = require '../src/DefaultRow.js'

{domFromReact, setupForTest, renderFromReactClass} = require('../src/Utils')

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai
{expect} = chai
{spy, stub} = sinon

shallowRenderer = createRenderer()

getRow = (index) ->
  return ["column#{index}1", "column2#{index}", "column3#{index}"]


describe 'chunk of table rows', ->
  beforeEach ->
    @rows = []
    @rows.push getRow(index) for index in [1..10]
    setupForTest()
    @defaultProps = 
      data:[
        rowData: @rows
        rowClass: 'row-class'
        colSpanOverride: 5
      ],
      rowComponent: DefaultRow
      visible: true
    @defaultProps.plus = (props) => Object.assign {}, @defaultProps, props

    @renderDefault = (opts = @defaultProps) ->
     {@component, @element, @$domNode} = renderFromReactClass(Chunk, opts , 'table')

  describe 'when it mounts', ->
    beforeEach ->
      @renderDefault()
    it 'should store a ref to the tbody',->
      expect(@component.body).to.be.truthy

  describe 'when the visibility changes', ->
    describe 'to hidden', ->
      beforeEach ->
        @renderDefault()
        @component.setState height: 42

        @setStateSpy = spy(@component, "setState")
        @getHeightStub = stub(@component, "getHeight")
        @getHeightStub.returns 10

        @component.componentWillReceiveProps visible: false

      afterEach ->
        @component.setState.restore();
        @component.getHeight.restore();

      it 'should store the height', ->
        expect(@getHeightStub).to.have.been.called
        expect(@setStateSpy).to.have.been.calledWith height: 10

    describe 'to visible',->
      beforeEach ->
        props = @defaultProps.plus
          visible: false
        @renderDefault(props)

        @component.setState height: 89

        @setStateSpy = spy(@component, "setState")
        @getHeightStub = stub(@component, "getHeight")
        @getHeightStub.returns 20

        @component.componentWillReceiveProps visible: true

      afterEach ->
        @component.setState.restore();
        @component.getHeight.restore();
      it 'should not store the height', ->
        expect(@getHeightStub).not.to.have.been.called
        expect(@setStateSpy).not.to.have.been.called

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