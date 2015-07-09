(function() {
'use strict';

angular.module('main')
  .controller('selectManifestCtrl', SelectManifestController);

  SelectManifestController.$inject = ['$state', 'ManifestSummaryService', 'WhsService'];

  function SelectManifestController($state, ManifestSummaryService, WhsService) {

    var vm = this;
    vm.currentWhs = WhsService.getCurrentWhs();

 	ManifestSummaryService.getManifestsOnFile().then(function(data) {
 		vm.manifestsCollection = data;
 	});

    vm.selectManifest = function(mani) {
        $state.go('manifest', {mani_num: mani.MANI_NUM});
    };
  };

})();