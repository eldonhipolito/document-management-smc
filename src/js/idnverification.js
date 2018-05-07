$(function(){


    App.poll(
       //Main function...
        function(){
            let Idns = App.contractInstances.Identities;
             console.log("hello world!");
            Idns.requestsCount.call().then(function(rqCount){
                console.log("hello world!");
                for(let ndx = 0; ndx < rqCount; ndx++) {
                    getIdentity(Idns, ndx);
                }

            });


            });






function getIdentity(idns, ndx) {
idns.singleVerRequest(ndx).then(function(res){

                let userAddress = res[0];
                let identity = res[1];
                let timestamp = res[2];

           App.contractTemplates.Identity.at(identity).then(function(inst){
            inst.userId.call().then(function(userId){

                inst.name.call().then(function(name){
                    let $row = $("<tr> </tr>");
                    $row.append("<td>" + userId + "</td>").append("<td>" + name + "</td>").append("<td>" + identity + "</td>").append("<td>" + userAddress + "</td>");
                    $("#verTbody").append($row);
                });

            });



           });




          });

}




});