(function() {
'use strict';
angular.module('main', [
  'ngCordova',
  'ui.router',
  'ngCookies',
  'angular-loading-bar'
  // TODO: load other modules selected during generation
])
.config(function ($stateProvider, $urlRouterProvider, $httpProvider ) {

  $urlRouterProvider.otherwise('/selectManifest');

  // some basic routing
  $stateProvider
    .state('main', {
      url: '/main',
      templateUrl: 'main/templates/start.html',
      controller: 'StartCtrl as start'
    })
    .state('selectManifest', {
      url: '/selectManifest',
      templateUrl: 'main/templates/selectManifest.html',
      controller: 'selectManifestCtrl as vm'
    })
    .state('manifest', {
      url: '/manifest/:mani_num',
      templateUrl: 'main/templates/manifest.html',
      controller: 'ManifestCtrl as vm'
    });

    $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=utf-8';

    var param = function(obj) {
      var query = '', name, value, fullSubName, subName, subValue, innerObj, i;
      
      for(name in obj) {
        value = obj[name];
          
        if(value instanceof Array) {
          for(i=0; i<value.length; ++i) {
            subValue = value[i];
            fullSubName = name + '[' + i + ']';
            innerObj = {};
            innerObj[fullSubName] = subValue;
            query += param(innerObj) + '&';
          }
        }
        else if(value instanceof Object) {
          for(subName in value) {
            subValue = value[subName];
            fullSubName = name + '[' + subName + ']';
            innerObj = {};
            innerObj[fullSubName] = subValue;
            query += param(innerObj) + '&';
          }
        }
        else if(value !== undefined && value !== null) {
          query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&';
        }
      }
        
      return query.length ? query.substr(0, query.length - 1) : query;
    };
  
    // Override $http service's default transformRequest
    $httpProvider.defaults.transformRequest = [function(data) {
      return angular.isObject(data) && String(data) !== '[object File]' ? param(data) : data;
    }];

})
.constant('apiRoot', 'http://apps.staplcotn.com/scripts/sccawhs/');
})();