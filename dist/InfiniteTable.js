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
	    data: PropTypes.arrayOf(PropTypes.object).isRequired,
	    pageLength: PropTypes.number.isRequired,
	    rowComponent: PropTypes.func
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
	    return React.createElement(Row, { data: datum, key: index });
	  },
	  render: function render() {
	    return React.createElement(
	      'div',
	      null,
	      this.props.data.map(this._renderRow)
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
	    data: PropTypes.object.isRequired
	  },
	  render: function render() {
	    return React.createElement(
	      'div',
	      null,
	      'Hey!'
	    );
	  }
	});

	module.exports = DefaultRow;

/***/ }
/******/ ])
});
;