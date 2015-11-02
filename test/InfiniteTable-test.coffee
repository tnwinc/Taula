React = require 'react'
InfiniteTable = require '../src/InfiniteTable.js'
DefaultRow = require '../src/DefaultRow.js'
{createRenderer, scryRenderedComponentsWithType} = require 'react-addons-test-utils'

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

{expect} = chai
{spy, stub} = sinon

{setupForTest, renderFromReactClass} = require('../src/Utils')

{Children} = React

shallowRenderer = createRenderer()

describe 'InfiniteTable', ->
  beforeEach ->
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
