React = require 'react'
{scryRenderedComponentsWithType} = require 'react-addons-test-utils'
{setupForTest, renderFromReactClass, getWrapper, getMock} = require('./TestUtils')

Chunk = getMock(require 'inject!../src/Chunk')


{$} = require('../src/Dependencies')

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai
{expect} = chai
{spy, stub} = sinon

getRowData = (index) ->
  return ["column#{index}1", "column2#{index}", "column3#{index}"]


describe 'chunk of table rows', ->
  beforeEach ->
    @fakeRow = React.createClass
      render: stub().returns(React.DOM.tr())
    @rowData = []
    @rowData.push getRowData(index) for index in [1..10]
    @rows = @rowData.map (rowData) ->
      rowData: @rows
      rowClass: 'row-class'
      colSpanOverride: 5
    setupForTest()
    @defaultProps =
      data: @rows
      rowComponent: @fakeRow
      visible: true
      rowIndexOffset: 0
    @defaultProps.plus = (props) => Object.assign {}, @defaultProps, props

    @renderDefault = (opts = @defaultProps) ->
      {@component, @element, @$domNode} = renderFromReactClass(Chunk, opts , 'table')

  describe 'when it mounts', ->
    beforeEach ->
      @renderDefault()
    it 'should store a ref to the tbody', ->
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
        @component.setState.restore()
        @component.getHeight.restore()

      it 'should store the height', ->
        expect(@getHeightStub).to.have.been.called
        expect(@setStateSpy).to.have.been.calledWith height: 10

    describe 'to visible', ->
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
        @component.setState.restore()
        @component.getHeight.restore()
      it 'should not store the height', ->
        expect(@getHeightStub).not.to.have.been.called
        expect(@setStateSpy).not.to.have.been.called

  describe 'when it updates', ->
    beforeEach ->
      @renderDefault()
      @component.body = undefined
      @component.componentDidUpdate()
    it 'should store a ref to the tbody', ->
      expect(@component.body).to.be.truthy

  describe 'getting the height', ->
    describe 'when its visible', ->
      it 'should get the height from the dom', ->
    describe 'when its hidden', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          visible: false
        @component.setState
          height: 42
      it 'should get the height from the state', ->
        expect(@component.getHeight()).to.equal 42

  describe 'when checking visibility', ->
    beforeEach ->
      @style =
        display: 'block'
        position: 'absolute'
        plus: (style) => Object.assign {}, @style, style
      @renderDefault()
    describe 'when the scroll parent is the window', ->
      beforeEach ->
        @parent = $(window)
        @parentHeight = @parent.height()
      describe 'when the chunk is fully contained', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / 4}px"
            height: "#{@parentHeight / 2}px"
        it 'should report the chunk as visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true
      describe 'when the chunk is partially off the top', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / -2}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true
      describe 'when the chunk is partially off the bottom', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / 2}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true
      describe 'when the chunk is off the bottom', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{2 * @parentHeight}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as not visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.false
      describe 'when the chunk is off the top', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{-2 * @parentHeight}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as not visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.false
      describe 'when the chunk is larger than the parent height and is centered on its parent', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / 4}px"
            height: "#{@parentHeight / 2}px"
        it 'should report the chunk as not visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true

    describe 'when the scroll parent is not the window', ->
      beforeEach ->
        @parentHeight = 10
        @parent = getWrapper()
        @parent.css @style.plus
          height: "#{@parentHeight}px"

      describe 'when the chunk is fully contained', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / 4}px"
            height: "#{@parentHeight / 2}px"
        it 'should report the chunk as visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true
      describe 'when the chunk is partially off the top', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / -2}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true
      describe 'when the chunk is partially off the bottom', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / 2}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true
      describe 'when the chunk is off the bottom', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{2 * @parentHeight}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as not visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.false
      describe 'when the chunk is off the top', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{-2 * @parentHeight}px"
            height: "#{@parentHeight}px"
        it 'should report the chunk as not visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.false
      describe 'when the chunk is larger than the parent height and is centered on its parent', ->
        beforeEach ->
          @$domNode.css @style.plus
            top: "#{@parentHeight / 4}px"
            height: "#{@parentHeight / 2}px"
        it 'should report the chunk as not visible', ->
          expect(@component.isVisibleIn(@parent)).to.be.true

  describe 'when it renders', ->
    describe 'when chunk is not visible', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          visible: false
        @component.setState
          height: 51

      it 'should render a tbody', ->
        expect(@$domNode.is('tbody')).to.be.true
      it 'should have a single child with the correct height', ->
        expect(@component.refs.body.children[0].style.minHeight).to.equal '51px'
        expect(@component.refs.body.children[0].style.display).to.equal 'block'

    describe 'when chunk is visible', ->
      beforeEach ->
        @renderDefault()
      it 'should render a visible chunk tbody', ->
        expect(@$domNode.is('tbody')).to.be.true
      it 'should have default row as its first child', ->
        expect(scryRenderedComponentsWithType(@component, @fakeRow).length).to.equal @rows.length
