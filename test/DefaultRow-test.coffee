
{setupForTest, renderFromReactClass, getMock} = require('./TestUtils')

DefaultRow = getMock(require 'inject!../src/DefaultRow')

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai
{expect} = chai
{stub} = sinon

{$} = require '../src/Dependencies'


describe 'default row', ->

  beforeEach ->
    @rowData = ['column1', 'column2', 'column3']
    setupForTest()

  describe 'when it renders', ->

    beforeEach ->
      {@component, @element, @$domNode} = renderFromReactClass DefaultRow,
        item: @rowData
        className: 'row-class'
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

  describe 'when it has a getMoreRowClasses property', ->
    beforeEach ->
      @rowClass = stub()
      @rowClass.returns 'myClass'
      {@component, @element, @$domNode} = renderFromReactClass DefaultRow,
        item: @rowData
        className: 'row-class'
        rowIndex: 42
        colSpanOverride: 5
        getMoreRowClasses: @rowClass
      , 'tbody'

    it 'should use the getMoreRowClasses property to get the classes', ->
      (expect @rowClass).to.have.been.calledWith 'row-class', @rowData, 42

    it 'should apply the result as the className', ->
      (expect @$domNode.hasClass('myClass')).to.be.true
