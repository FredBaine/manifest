'use strict';

angular.module('main').factory('WhsService', function($http, $cookies, apiRoot) {

	return {
		getWarehouses: getWarehouses,
		getCurrentWhs: getCurrentWhs,
		setCurrentWhs: setCurrentWhs
	};

	function getWarehouses() {
		var url = 'SccaWhs.cfc?method=getWarehouses';
		if (window.cordova) {
			url = apiRoot + 'SccaWhs.cfc?method=getWarehouses';
		}
		return $http.get(url);
	};

	/* get currentWhs from cookie if it exists, else set to default and create cookie */
	function getCurrentWhs() {
		var currentWhs = $cookies.getObject('currentWhs');
		if (!currentWhs) {
			var currentWhs = {WHS: '476512', NAME: 'RISING SUN'};
			$cookies.putObject('currentWhs', currentWhs);
		}
		return currentWhs
	};

	function setCurrentWhs(currentWhs) {
		$cookies.remove('currentWhs');
		$cookies.putObject('currentWhs', currentWhs);
	};

});
