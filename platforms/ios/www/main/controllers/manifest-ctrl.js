(function() {
'use strict';

angular.module('main')
  .controller('ManifestCtrl', ManifestController);

  ManifestController.$inject = ['$scope', '$stateParams', 'ManifestSummaryService'];

  function ManifestController($scope, $stateParams, ManifestSummaryService) {

    var vm = this,
        allBales = [],
        firstBlock = '0000',
        lastBlock = '0000',
        arrBlockList = [],
        objBalesByBlock = {};

    vm.currentBlockIndex = 0;
    vm.currentBlock = '0000';
    vm.blockBales = [];

    vm.sortColumn = 'DEPTH';
    vm.sortDirection = true;

    $scope.$watch('vm.currentBlockIndex', function(newValue, oldValue) {
        vm.currentBlock = arrBlockList[newValue];
        vm.blockBales = objBalesByBlock[arrBlockList[newValue]];
    });

    ManifestSummaryService.getManifestBales($stateParams.mani_num).then( function(data) {
        allBales = data;
        objBalesByBlock = _.groupBy(allBales, function(bale) {
            return bale.BLOCK;
        });
        arrBlockList = _.keys(objBalesByBlock);
        vm.currentBlock = arrBlockList[vm.currentBlockIndex];
        vm.blockBales = objBalesByBlock[arrBlockList[vm.currentBlockIndex]];
        firstBlock = arrBlockList[0];
        lastBlock = arrBlockList[arrBlockList.length-1];
    });

    vm.nextBlock = function() {
        if (vm.currentBlock !== lastBlock) {
            vm.currentBlockIndex++;
        }
    };
        
    vm.prevBlock = function() {
        if (vm.currentBlock !== firstBlock) {
            vm.currentBlockIndex--;
        }
    };
        
    vm.gotoBlock = function() {        
        vm.currentBlockIndex = _.sortedIndex(arrBlockList, vm.currentBlock);
    };
        
    vm.toggleSortDirection = function() {        
        vm.sortDirection = !vm.sortDirection;
    };

    vm.changeSort = function(column) {
      vm.sortDirection = (vm.sortColumn === column) ? !vm.sortDirection : false;
      vm.sortColumn = column;
    };
        
    vm.completeBlock = function() {
        var arrBales = objBalesByBlock[arrBlockList[vm.currentBlockIndex]];
        arrBales.forEach(function(bale) { 
            if (bale.IMPORTANCE === 'PRIMARY')
                bale.pulled = true;
            if (bale.IMPORTANCE === 'SECONDARY')
                bale.fronted = true;
        });
    };

    vm.isBlockWorked = function(block) {
        return _.where(vm.blockBales, {pulled: true}).length;
    };
};
})();