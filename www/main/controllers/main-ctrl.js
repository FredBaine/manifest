(function() {
'use strict';

angular.module('main')
  .controller('MainCtrl', MainController);

  MainController.$inject = ['$scope'];

  function MainController($scope) {

    $scope.test = 'Bound';

    $scope.toggleSidebar = function() {
        $scope.toggle = !$scope.toggle;
    };

};
})();