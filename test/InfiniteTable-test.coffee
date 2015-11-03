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

setReturns = (stubbed, def, results...) ->
  stubbed.returns def
  stubbed.onCall(index).returns(results[index]) for index in [0..results.length - 1] by 1

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
    ,
      rowData: ['four']
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
    describe 'and a loading message was passed in', ->
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

    describe 'and a loading message was NOT passed in', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          data: []
          loading: true
          loadingMessage: undefined
        @cells = @$domNode.find 'td'
        @cell = @cells.eq 0

      it 'should not render any rows', ->
        expect(@cells.length).to.equal 0


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
    describe 'when no data is passed in', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          data: []
        @component.debouncedLoadData = undefined
        @component._updateChunkedData = spy()
        @component.componentWillMount()
      it 'should store off a debounced version of loadData', ->
        expect(@component.debouncedLoadData).is.a 'function'
      it 'should not update the chunks', ->
        expect(@component._updateChunkedData).to.not.have.been.called
    describe 'when data is passed in', ->
      beforeEach ->
        @renderDefault()
        @component.getInitialLength = -> 1
        @component.debouncedLoadData = undefined
        @component._updateChunkedData = spy()
        @component.componentWillMount()
      it 'should store off a debounced version of loadData', ->
        expect(@component.debouncedLoadData).is.a 'function'
      it 'should update the chunks', ->
        expect(@component._updateChunkedData).to.have.been.calledWith @defaultProps.data

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

    describe 'when no data is passed in', ->
      beforeEach ->
        @renderDefault @defaultProps.plus
          data: []
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

    describe 'when data is passed in', ->
      beforeEach ->
        @renderDefault()
        @defaultProps.loadData.reset()
        @component.getInitialLength = -> 2
        @component.scrollParent.off 'scroll'
        @component.scrollParent = undefined
        @component.handleScroll = spy()
        @component.componentDidMount()
        @component.scrollParent.trigger 'scroll'
      it 'should not load any more data', ->
        expect(@defaultProps.loadData).to.not.have.been.called

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

    it 'should reload the initial state', ->
      expect(@component.setState).to.have.been.called
      expect(@component.getInitialState).to.have.been.called

    it 'should use the passed in callback as its setState callback', ->
      expect(@component.setState.firstCall.args[1]).to.equal @callback

  describe 'the debounced load data', ->
    beforeEach ->
      @renderDefault @defaultProps.plus
        data: []
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
    beforeEach ->
      FakeChunk::isVisibleIn = stub()
    describe 'when all chunks are visible', ->
      beforeEach ->
        FakeChunk::isVisibleIn.returns true
        @renderDefault @defaultProps.plus
          chunkSize: 2
      it 'should return all the chunks', ->
        expect(@component._findVisibleChunks()).to.eql [0, 1]

    describe 'when only some chunks are visible', ->
      beforeEach ->
        setReturns FakeChunk::isVisibleIn, false, false, true, true, false, true
        @renderDefault @defaultProps.plus
          chunkSize: 1
          data: [{}, {}, {}, {}, {}]
        @visibleChunks = @component._findVisibleChunks()
      it 'should return only the visible chunks', ->
        expect(@visibleChunks).to.eql [1, 2]
      it 'should short circuit if it gets into non-visible chunks', ->
        expect(@visibleChunks.indexOf(3)).to.equal -1
        expect(@visibleChunks.indexOf(4)).to.equal -1

  describe 'on scroll', ->
    beforeEach ->
      FakeChunk::isVisibleIn = stub()
    describe 'scrolled to the top', ->
      beforeEach ->
        setReturns FakeChunk::isVisibleIn, false, true, true
        @renderDefault()
        {@MIN_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 1
          bottomChunk: 1
        @component.handleScroll()
      it 'should set the bottom chunk to the minimum value', ->
        expect(@component.state.bottomChunk).to.equal @MIN_CHUNKS

    describe 'no change', ->
      beforeEach ->
        setReturns FakeChunk::isVisibleIn, false, true, true
        @renderDefault()
        {@MIN_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 0
          bottomChunk: 2
          noMoreToLoad: false
        @component.setState = spy()
        @defaultProps.loadData.reset()
        @component.handleScroll()
      it 'should not set anything into the state', ->
        expect(@component.setState).to.not.have.been.called
      it 'should not load any data', ->
        expect(@defaultProps.loadData).to.not.have.been.called

    describe 'scrolled down, but not far enough', ->
      beforeEach ->
        @renderDefault()
        {@MIN_CHUNKS, @TRIGGER_COUNT, @PRELOAD_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 4
          bottomChunk: 8
          noMoreToLoad: false
        @component._findVisibleChunks = stub()
        @bottomTriggeringChunk = @component.state.bottomChunk - @TRIGGER_COUNT
        @component._findVisibleChunks.returns [Infinity, @bottomTriggeringChunk - 1]
        @component.setState = spy()
        @defaultProps.loadData.reset()
        @component.handleScroll()
      it 'should not set anything into the state', ->
        expect(@component.setState).to.not.have.been.called
      it 'should not load any data', ->
        expect(@defaultProps.loadData).to.not.have.been.called

    describe 'scrolled up, but not far enough', ->
      beforeEach ->
        @renderDefault()
        {@MIN_CHUNKS, @TRIGGER_COUNT, @PRELOAD_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 4
          bottomChunk: 8
          noMoreToLoad: false
        @component._findVisibleChunks = stub()
        @topTriggeringChunk = @component.state.topChunk + @TRIGGER_COUNT
        @component._findVisibleChunks.returns [@topTriggeringChunk + 1, -Infinity]
        @component.setState = spy()
        @defaultProps.loadData.reset()
        @component.handleScroll()
      it 'should not set anything into the state', ->
        expect(@component.setState).to.not.have.been.called
      it 'should not load any data', ->
        expect(@defaultProps.loadData).to.not.have.been.called

    describe 'scrolled down', ->
      beforeEach ->
        @renderDefault()
        {@MIN_CHUNKS, @TRIGGER_COUNT, @PRELOAD_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 0
          bottomChunk: @MIN_CHUNKS
          noMoreToLoad: false
        @component._findVisibleChunks = stub()
        @bottomTriggeringChunk = @component.state.bottomChunk - @TRIGGER_COUNT
        @component._findVisibleChunks.returns [@bottomTriggeringChunk - 1, @bottomTriggeringChunk]
        @component.setState = spy()
        @defaultProps.loadData.reset()
        @component.handleScroll()
      it 'should set the new chunks into the state', ->
        expect(@component.setState).to.have.been.calledWith
          topChunk: @bottomTriggeringChunk - 1 - @PRELOAD_CHUNKS
          bottomChunk: @bottomTriggeringChunk + @PRELOAD_CHUNKS
      it 'should load the data', ->
        expect(@defaultProps.loadData).to.have.been.calledWith((@bottomTriggeringChunk + @PRELOAD_CHUNKS + 1) * @defaultProps.chunkSize)

    describe 'scrolled up', ->
      beforeEach ->
        @renderDefault()
        {@MIN_CHUNKS, @TRIGGER_COUNT, @PRELOAD_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 4
          bottomChunk: 10000
          noMoreToLoad: false
        @component._findVisibleChunks = stub()
        @topTriggeringChunk = @component.state.topChunk + @TRIGGER_COUNT
        @component._findVisibleChunks.returns [@topTriggeringChunk - 1, @topTriggeringChunk]
        @component.setState = spy()
        @defaultProps.loadData.reset()
        @component.handleScroll()
      it 'should set the new chunks into the state', ->
        expect(@component.setState).to.have.been.calledWith
          topChunk: @topTriggeringChunk - 1 - @PRELOAD_CHUNKS
          bottomChunk: @topTriggeringChunk + @PRELOAD_CHUNKS
      it 'should not load any data', ->
        expect(@defaultProps.loadData).to.not.have.been.called

    describe 'scrolled way down', ->
      beforeEach ->
        @renderDefault()
        {@MIN_CHUNKS, @TRIGGER_COUNT, @PRELOAD_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 0
          bottomChunk: @MIN_CHUNKS
          noMoreToLoad: false
        @component._findVisibleChunks = stub()
        @newBottomChunk = 10000
        @component._findVisibleChunks.returns [@newBottomChunk, @newBottomChunk + 1]
        @component.setState = spy()
        @defaultProps.loadData.reset()
        @component.handleScroll()
      it 'should set the new chunks into the state', ->
        expect(@component.setState).to.have.been.calledWith
          topChunk: @newBottomChunk - @PRELOAD_CHUNKS
          bottomChunk: @newBottomChunk + 1 + @PRELOAD_CHUNKS
      it 'should load the data', ->
        expect(@defaultProps.loadData).to.have.been.calledWith((@newBottomChunk + 1 + @PRELOAD_CHUNKS + 1) * @defaultProps.chunkSize)

    describe 'scrolled way up', ->
      beforeEach ->
        @renderDefault()
        {@MIN_CHUNKS, @TRIGGER_COUNT, @PRELOAD_CHUNKS} = @component.getConstants()
        @component.setState
          topChunk: 10000
          bottomChunk: 100001
          noMoreToLoad: false
        @component._findVisibleChunks = stub()
        @newTopChunk = 100
        @component._findVisibleChunks.returns [@newTopChunk, @newTopChunk + 1]
        @component.setState = spy()
        @defaultProps.loadData.reset()
        @component.handleScroll()
      it 'should set the new chunks into the state', ->
        expect(@component.setState).to.have.been.calledWith
          topChunk: @newTopChunk - @PRELOAD_CHUNKS
          bottomChunk: @newTopChunk + 1 + @PRELOAD_CHUNKS
      it 'should not load the data', ->
        expect(@defaultProps.loadData).to.not.have.been.called

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
