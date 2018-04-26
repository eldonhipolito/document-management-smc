App = {
    contractTemplates : {},
    contractAddresses : {},
    contractInstances : {},
    web3Provider : null,

    load : function() {
        return App.initWeb3();
    },
    initWeb3: function() {
       // Is there an injected web3 instance?
       if (typeof web3 !== 'undefined') {
         App.web3Provider = web3.currentProvider;
       } else {
         // If no injected web3 instance is detected, fall back to Ganache
         App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
       }
       web3 = new Web3(App.web3Provider);
        return App.loadContractTemplates();
      },
     loadContractTemplates : function() {
        let ecPromise = $.getJSON("ECRecovery.json", function(data) {
            App.contractTemplates.ECRecovery = TruffleContract(data);
            App.contractTemplates.ECRecovery.setProvider(App.web3Provider);
        });
        let identityPromise = $.getJSON('Identity.json', function(data){
            App.contractTemplates.Identity = TruffleContract(data);
            App.contractTemplates.Identity.setProvider(App.web3Provider);
        });
        let identitiesPromise = $.getJSON('Identities.json', function(data){
            App.contractTemplates.Identities = TruffleContract(data);
            App.contractTemplates.Identities.setProvider(App.web3Provider);
         });
          let documentsPromise = $.getJSON('Documents.json', function(data){
             App.contractTemplates.Documents = TruffleContract(data);
             App.contractTemplates.Documents.setProvider(App.web3Provider);
          });
          let documentPromise = $.getJSON('Document.json', function(data){
                       App.contractTemplates.Document = TruffleContract(data);
                       App.contractTemplates.Document.setProvider(App.web3Provider);
            });

          $.when(ecPromise,identityPromise,identitiesPromise,documentsPromise,documentPromise).then(function(){
            return App.loadContractAddresses();
          }
          );
     },

     loadContractAddresses : function() {
        $.getJSON("../addresses.json", function(data) {
            console.log(data);
            App.contractAddresses = data;
             return App.loadContractInstances();
        });

     },
     loadContractInstances : function() {
        console.log(App.contractTemplates.ECRecovery);
        App.contractTemplates.ECRecovery.at(App.contractAddresses.ecrecovery).then(function(instance) {
            App.contractInstances.ECRecovery = instance;
        });
        App.contractTemplates.Documents.at(App.contractAddresses.documents).then(function(instance){
            App.contractInstances.Documents = instance;
        });
        App.contractTemplates.Identities.at(App.contractAddresses.identities).then(function(instance){
            App.contractInstances.Identities = instance;
        });

        return App.linkContracts();
     },

     linkContracts : function() {
        App.contractTemplates.Identity.detectNetwork().then(function(){
            App.contractTemplates.Identity.link("ECRecovery", App.contractAddresses.ecrecovery);
        });
     }
};



$(function() {
    $(window).load(function(){
        App.load();
    });
});