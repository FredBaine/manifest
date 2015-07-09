'use strict';

angular.module('main').factory('WhsService', function($http, $cookies, apiRoot) {

	return {
		getWarehouses: getWarehouses,
		getCurrentWhs: getCurrentWhs,
		setCurrentWhs: setCurrentWhs
	};

	function getWarehouses() {
		return $http.get('SccaWhs.cfc?method=getWarehouses')
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
