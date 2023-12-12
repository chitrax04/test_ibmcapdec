const cds = require("@sap/cds");
const mysrvdemo = function(srv){

    const { ReadEmployeeSrv } = this.entities;
    const { employees } = cds.entities("anubhav.db.master");

    srv.on('hello', (req,res) => {
        console.log('Call has come to my service code');
        return "Hello " + req.data.name;
    });

    srv.on('READ', "ReadEmployeeSrv", async(req, res) => {

        // return {
        //     "ID": "02BD2137-0890-1EEA-A6C2-BB55C1989595",
        //     "nameFirst": "Christiano",
        //     "nameMiddle": "Ronaldo"
        // }

        var whereCondition = req.data;
        console.log(whereCondition);
        if(whereCondition.hasOwnProperty("ID")){
            results = await cds.tx(req).run(SELECT.from(employees).limit(10).where(whereCondition));
        }else{
            results = await cds.tx(req).run(SELECT.from(employees).limit(5));
        }

        return results;

    });


};

module.exports = mysrvdemo;