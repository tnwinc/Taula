React = require 'react'
InfiniteTable = require '../src/InfiniteTable.js'
DefaultRow = require '../src/DefaultRow.js'
{createRenderer, scryRenderedComponentsWithType} = require 'react-addons-test-utils'

chai = require 'chai'
{expect} = chai

{Children} = React

shallowRenderer = createRenderer()

describe 'InfiniteTable', ->
  describe 'by default', ->
    beforeEach ->
      @data = [
        rowData: ['one']
      ,
        rowData: ['two']
      ,
        rowData: ['three']
      ]
      shallowRenderer.render(React.createElement InfiniteTable,
        data: @data
        pageLength: 5
        colCount: 3
        loadingMessage: 'LOADING'
        noValuesMessage: 'NODATA'
      )
      @table = shallowRenderer.getRenderOutput()
      @tbody = Children.only @table.props.children
    it 'should render a table', ->
      expect(@table.type).to.equal 'table'

    it 'should render a tbody', ->
      expect(@tbody.type).to.equal 'tbody'

    it 'should a row per datum', ->
      expect(Children.count @tbody.props.children).to.equal @data.length

  describe 'when the initial load is happening', ->
    beforeEach ->
      @data = []
      shallowRenderer.render(React.createElement InfiniteTable,
        data: @data
        loading: true
        loadingMessage: 'LOADING'
        pageLength: 5
        colCount: 3
      )
      @table = shallowRenderer.getRenderOutput()
      @tbody = Children.only @table.props.children
      @messageRow = Children.only @tbody.props.children
      @messageCell = Children.only @messageRow.props.children

    it 'should show the loading message', ->
      expect(@messageCell.props.children).to.equal 'LOADING'

    it 'should not show any other rows', ->
      expect(Children.count @tbody.props.children).to.equal 1

  describe 'when no data is provided', ->
    beforeEach ->
      @data = []
      shallowRenderer.render(React.createElement InfiniteTable,
        data: @data
        loading: false
        loadingMessage: 'LOADING'
        noValuesMessage: 'NODATA'
        pageLength: 5
        colCount: 3
      )
      @table = shallowRenderer.getRenderOutput()
      @tbody = Children.only @table.props.children
      @messageRow = Children.only @tbody.props.children
      @messageCell = Children.only @messageRow.props.children

    it 'should show the no data message', ->
      expect(@messageCell.props.children).to.equal 'NODATA'

    it 'should not show any other rows', ->
      expect(Children.count @tbody.props.children).to.equal 1
