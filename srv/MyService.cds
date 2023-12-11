using { anubhav.db.master } from '../db/datamodel';

service MyService @(path:'MyService') {

    function hello(name:String(30)) returns String;

    entity ReadEmployeeSrv as projection on master.employees;

}