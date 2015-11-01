
DefaultRow  = require '../src/DefaultRow.js'
$ = require 'jquery'

chai = require 'chai'
{expect} = chai


{setupForTest, renderFromReactClass} = require('../src/Utils')

describe 'default row', ->

  beforeEach ->
    @rowData = ['column1', 'column2', 'column3']
    setupForTest()

  describe 'when it renders', ->

    beforeEach ->
      {@component, @element, @$domNode} = renderFromReactClass DefaultRow,
        rowData: @rowData
        rowClass: 'row-class'
        rowIndex: 42
        colSpanOverride: 5
      , 'tbody'

    it 'should render a tr', ->
      expect(@$domNode.is 'tr').to.be.true

    it 'should render a cell for each piece of data', ->
      expect(@$domNode.find('td').length).to.equal @rowData.length

    it 'should pass through the className property', ->
      expect(@$domNode.hasClass 'row-class').to.be.true

    it 'should respect the colspan property', ->
      expect(@$domNode.find('td').attr('colspan')).to.equal '5'

    it 'should dump the data into the cells', ->
      rowData = @rowData
      @$domNode.find('td').each (index) ->
        expect($(@).text()).to.equal rowData[index]
