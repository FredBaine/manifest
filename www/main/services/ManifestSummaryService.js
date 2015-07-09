(function() {
'use strict';

angular.module('main').factory('ManifestSummaryService', function($http, $q, WhsService, apiRoot) {

/*
	function transformOrders(data, headersGetter) {
		var transformed = angular.fromJson(data);
		transformed.forEach(function(currentValue, index, array) {
			currentValue.selected = false;
		});
		return transformed;
	};
*/
	return {
		getManifestsOnFile: getManifestsOnFile,
		getManifestBales: getManifestBales
	};

	function getManifestBales(mani) {
		var url = 'SccaWhs.cfc?method=getManifestBales';
		if (window.cordova) {
			url = apiRoot + 'SccaWhs.cfc?method=getManifestBales';
		}
		var req = {
			url: url,
		    method: 'POST',
		    data: {mani_num: mani}
//		    transformResponse: transformOrders
		};

		return $http(req).then(sendResponseData)
						 .catch(sendError);
	};


	function getManifestsOnFile(whsNum) {
		var whs = whsNum || WhsService.getCurrentWhs().WHS;
		var url = 'SccaWhs.cfc?method=getManifestsOnFile';
		if (window.cordova) {
			url = apiRoot + 'SccaWhs.cfc?method=getManifestsOnFile';
		}
		var req = {
			url: url,
		    method: 'POST',
		    data: {WHS: whs}
//		    transformResponse: transformOrders
		};

		return $http(req).then(sendResponseData)
						 .catch(sendError);
	}

	function sendResponseData(resp) {
		return resp.data;
	}

	function sendError(resp) {
		return $q.reject('Error getting Orders: ' + resp.status);
	}

});
})();