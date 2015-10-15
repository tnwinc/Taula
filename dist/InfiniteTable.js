(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory(require("react"));
	else if(typeof define === 'function' && define.amd)
		define(["react"], factory);
	else if(typeof exports === 'object')
		exports["InfiniteTable"] = factory(require("react"));
	else
		root["InfiniteTable"] = factory(root["React"]);
})(this, function(__WEBPACK_EXTERNAL_MODULE_1__) {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var React = __webpack_require__(1);
	var PropTypes = React.PropTypes;

	var InfiniteTable = React.createClass({
	  displayName: 'InfiniteTable',
	  propTypes: {
	    pageLength: PropTypes.number.isRequired,
	    rowComponent: PropTypes.func,
	    headerElement: PropTypes.node,
	    footerElement: PropTypes.node,
	    columns: PropTypes.arrayOf(PropTypes.object),
	    colCount: PropTypes.number.isRequired,
	    data: PropTypes.arrayOf(PropTypes.shape({
	      rowData: PropTypes.arrayOf(PropTypes.node),
	      item: PropTypes.object,
	      rowClass: PropTypes.string,
	      colSpanOverride: PropTypes.number
	    })).isRequired,
	    RowComponent: PropTypes.func,
	    loading: PropTypes.bool,
	    loadingMessage: PropTypes.node,
	    noValuesMessage: PropTypes.node
	  },
	  getDefaultProps: function getDefaultProps() {
	    return {
	      rowComponent: __webpack_require__(2)
	    };
	  },
	  getInitialState: function getInitialState() {
	    return {
	      topIndex: 0,
	      bottomIndex: this.props.pageLength - 1
	    };
	  },
	  _renderRow: function _renderRow(datum, index) {
	    var Row = this.props.rowComponent;
	    datum.rowIndex = index;
	    return React.createElement(Row, { data: datum, key: index });
	  },
	  render: function render() {
	    var _this = this;

	    var _props = this.props;
	    var headerElement = _props.headerElement;
	    var footerElement = _props.footerElement;
	    var loading = _props.loading;
	    var data = _props.data;
	    var loadingMessage = _props.loadingMessage;
	    var noValuesMessage = _props.noValuesMessage;
	    var colCount = _props.colCount;

	    return React.createElement(
	      'table',
	      null,
	      React.createElement(
	        'tbody',
	        null,
	        (function () {
	          if (loading) {
	            return React.createElement(
	              'tr',
	              { className: 'centered-row' },
	              React.createElement(
	                'td',
	                { colSpan: colCount },
	                loadingMessage
	              )
	            );
	          } else if (data.length === 0 && noValuesMessage) {
	            return React.createElement(
	              'tr',
	              { className: 'centered-row' },
	              React.createElement(
	                'td',
	                { colSpan: colCount },
	                noValuesMessage
	              )
	            );
	          } else {
	            return data.map(_this._renderRow);
	          }
	        })()
	      )
	    );
	  }
	});

	module.exports = InfiniteTable;

/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = __WEBPACK_EXTERNAL_MODULE_1__;

/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var React = __webpack_require__(1);
	var PropTypes = React.PropTypes;

	var DefaultRow = React.createClass({
	  displayName: 'DefaultRow',
	  propTypes: {
	    rowData: PropTypes.arrayOf(PropTypes.node).isRequired,
	    rowClass: PropTypes.string,
	    colSpanOverride: PropTypes.number,
	    rowIndex: PropTypes.number.isRequired
	  },
	  _renderCell: function _renderCell(cellData, index) {
	    return React.createElement(
	      'td',
	      { ref: 'renderedCell', key: index, colSpan: this.props.colSpanOverride },
	      cellData
	    );
	  },
	  render: function render() {
	    var _props = this.props;
	    var rowData = _props.rowData;
	    var rowClass = _props.rowClass;
	    var rowIndex = _props.rowIndex;

	    return React.createElement(
	      'tr',
	      { className: rowClass, key: rowIndex },
	      rowData.map(this._renderCell)
	    );
	  }
	});
	module.exports = DefaultRow;

/***/ }
/******/ ])
});
;