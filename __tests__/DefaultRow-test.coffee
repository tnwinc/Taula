
jest.dontMock '../lib/DefaultRow.js'

React = require 'react/addons'
InfiniteTable = require '../lib/DefaultRow.js'
{findDOMNode} = React
{TestUtils} = React.addons
{renderIntoDocument, findRenderedDOMComponentWithTag} = TestUtils
