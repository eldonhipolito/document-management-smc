$(function(){

    $("#registration").submit(function(e){
        e.preventDefault();

        let username = $("#username").val();
        let name = $("#name").val();

        App.contractTemplates.Identity.new(username, name).then(function(result){
            console.log(result);
        });

    });


    $("#reqVerification").submit(function(e){
            e.preventDefault();

            let idnAddress = $("#idnAddress").val();

            App.contractInstances.Identities.reqIdnVerification(idnAddress).then(function(result){
                console.log(result);
            });

        });



});