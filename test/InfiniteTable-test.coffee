React = require 'react'

{createRenderer, scryRenderedComponentsWithType} = require 'react-addons-test-utils'
{$} = require '../src/Dependencies'

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

{expect} = chai
{spy, stub} = sinon

{setupForTest, renderFromReactClass, getMock} = require('./TestUtils')

FakeChunk = React.createClass
  render: ->
    React.DOM.tbody()

InfiniteTable = getMock require('inject!../src/InfiniteTable'),
  './Chunk': FakeChunk

describe 'InfiniteTable', ->
  beforeEach (done) ->
    setupForTest()
    @data = [
      rowData: ['one']
    ,
      rowData: ['two']
    ,
      rowData: ['three']
    ]
    @defaultProps =
      data: @data
      chunkSize: 5
      columnCount: 3
      loadingMessage: 'LOADING'
      noDataMessage: 'NODATA'
      loadData: spy()
      plus: (props) => Object.assign {}, @defaultProps, props

    @renderDefault = (opts = @defaultProps) ->
      {@component, @element, @$domNode} = renderFromReactClass(InfiniteTable, opts)
    done()

  describe 'by default', ->
    beforeEach ->
      @renderDefault()

    it 'should render a table', ->
      expect(@$domNode.is('table')).to.be.true

  describe 'when the initial load is happening', ->
    beforeEach ->
      @renderDefault @defaultProps.plus
        data: []
        loading: true
      @cells = @$domNode.find 'td'
      @cell = @cells.eq 0

    it 'should render a row with the loading message', ->
      expect(@cell.text()).to.equal @defaultProps.loadingMessage

    it 'should set the colspan to the width of the table', ->
      expect(@cell.attr 'colspan').to.equal @defaultProps.columnCount.toString()

    it 'should not render any other rows', ->
      expect(@cells.length).to.equal 1


  describe 'when no data is provided', ->
    beforeEach ->
      @renderDefault @defaultProps.plus
        data: []
      @cells = @$domNode.find 'td'
      @cell = @cells.eq 0

    it 'should render a row with the no data message', ->
      expect(@cell.text()).to.equal @defaultProps.noDataMessage

    it 'should set the colspan to the width of the table', ->
      expect(@cell.attr 'colspan').to.equal @defaultProps.columnCount.toString()

    it 'should not render any other rows', ->
      expect(@cells.length).to.equal 1

  describe 'when a header element is passed in', ->
    beforeEach ->
      @renderDefault @defaultProps.plus
        headerElement: React.createElement 'thead', null,
          React.createElement 'tr', null,
            React.createElement 'th', null, 'IAMAHEADER'
      @thead = @$domNode.find 'thead'

    it 'should render the header element', ->
      expect(@thead.text()).to.equal 'IAMAHEADER'

  describe 'before the component mounts', ->
    beforeEach ->
      @renderDefault()
      @component.debouncedLoadData = undefined
      @component.componentWillMount()
    it 'should store off a debounced version of loadData', ->
      expect(@component.debouncedLoadData).is.a 'function'

  describe 'before the component updates', ->
    describe 'when the data has changed', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          data: [{o: 'o'}]
        @component._updateChunkedData = spy()
        @component.componentWillUpdate
          data: [{n: 'n'}]
      it 'should update the chunked data', ->
        expect(@component._updateChunkedData).to.have.been.calledWith [{n: 'n'}]

    describe 'when the data has not changed', ->
      beforeEach ->
        @data = [{o: 'o'}]
        @renderDefault @defaultProps.plus
          data: @data
        @component._updateChunkedData = spy()
        @component.componentWillUpdate
          data: @data
      it 'should update the chunked data', ->
        expect(@component._updateChunkedData).to.not.have.been.called

  describe 'when the component mounts', ->
    beforeEach ->
      @renderDefault()
      @defaultProps.loadData.reset()
      @component.getInitialLength = -> 42
      @component.scrollParent.off 'scroll'
      @component.scrollParent = undefined
      @component.handleScroll = spy()
      @component.componentDidMount()
      @component.scrollParent.trigger 'scroll'
    it 'should load the initial data', ->
      expect(@defaultProps.loadData).to.have.been.calledWith 42

    it 'should store off its scroll parent', ->
      expect(@component.scrollParent).to.not.equal undefined

    it 'should attach a scroll handler to its scroll parent', ->
      expect(@component.handleScroll).to.have.been.called

  describe 'before the component unmounts', ->
    beforeEach ->
      @renderDefault()
      @component.scrollParent.off 'scroll'
      @component.scrollParent = undefined
      @component.handleScroll = spy()
      @component.componentDidMount()
      @component.componentWillUnmount()
      @component.scrollParent.trigger 'scroll'

    it 'should remove the scroll handler from its scroll parent', ->
      expect(@component.handleScroll).to.not.have.been.called

  describe 'resetting the data', ->
    beforeEach ->
      @renderDefault()
      @callback = spy()
      @component.setState = spy()
      @component.getInitialState = spy()
      @component.resetData @callback

    xit 'should do some sort of scroll thing?'

    it 'should reload the initial state', ->
      expect(@component.setState).to.have.been.called
      expect(@component.getInitialState).to.have.been.called

    it 'should use the passed in callback as its setState callback', ->
      expect(@component.setState.firstCall.args[1]).to.equal @callback

  describe 'the debounced load data', ->
    beforeEach ->
      @renderDefault()
      @defaultProps.loadData.reset()
    describe 'when there is more data', ->
      beforeEach ->
        @component.debouncedLoadData 42
      it 'should load the data', ->
        expect(@defaultProps.loadData).to.have.been.calledWith 42
    describe 'when there is no more data', ->
      beforeEach ->
        @component.setState
          noMoreToLoad: true
        @component.debouncedLoadData 42
      it 'should not load the data', ->
        expect(@defaultProps.loadData).to.not.have.been.called


  describe 'finding the visible chunks', ->
  describe 'on scroll', ->

  describe 'rendering chunks', ->
    beforeEach ->
      @renderDefault()
      @component.setState
        chunks: [[{}],[{}],[{}],[{}],[{}]]
        topChunk: 1
        bottomChunk: 3
      @component._renderChunks()
      @chunks = scryRenderedComponentsWithType(@component, FakeChunk)
    it 'should render each chunk', ->
      expect(@chunks.length).to.equal 5
    it 'should set the appropriate visibility on the chunks', ->
      expect(@chunks[0].props.visible).to.be.false
      expect(@chunks[1].props.visible).to.be.true
      expect(@chunks[2].props.visible).to.be.true
      expect(@chunks[3].props.visible).to.be.true
      expect(@chunks[4].props.visible).to.be.false

  describe 'updating the chunked data', ->
    describe 'when there is still more data', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          chunkSize: 2
        @oldChunks = [[{old: 'old'}]]
        @component.setState
          chunks: @oldChunks
        @newData = [{new: 'new'},{new: 'new'},{1: '1'},{2: '2'}, {3: '3'}, {4: '4'}]
        @component.setState = spy()
        @component._updateChunkedData @newData
        @updatedChunks = @component.setState.firstCall.args[0].chunks
      it 'should set the state to have the new chunks', ->
        expect(@updatedChunks.length).to.equal 3
      it 'should not overwrite existing chunks', ->
        expect(@updatedChunks[0]).to.equal @oldChunks[0]
      it 'should append the new chunks', ->
        expect(@updatedChunks[1]).to.eql [@newData[2], @newData[3]]
        expect(@updatedChunks[2]).to.eql [@newData[4], @newData[5]]
      it 'should set the state to having more data to load', ->
        expect(@component.setState.firstCall.args[0].noMoreToLoad).to.be.false
    describe 'when we don\'t get all the requested data', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          chunkSize: 2
        @oldChunks = [[{old: 'old'}]]
        @component.setState
          chunks: @oldChunks
        @newData = [{new: 'new'},{new: 'new'},{1: '1'},{2: '2'}, {3: '3'}]
        @component.setState = spy()
        @component._updateChunkedData @newData
        @updatedChunks = @component.setState.firstCall.args[0].chunks
      it 'should set the state to have the new chunks', ->
        expect(@updatedChunks.length).to.equal 3
      it 'should not overwrite existing chunks', ->
        expect(@updatedChunks[0]).to.equal @oldChunks[0]
      it 'should append the new chunks', ->
        expect(@updatedChunks[1]).to.eql [@newData[2], @newData[3]]
        expect(@updatedChunks[2]).to.eql [@newData[4]]
      it 'should set the state to having more data to load', ->
        expect(@component.setState.firstCall.args[0].noMoreToLoad).to.be.true
