using {anubhav.db} from '../db/datamodel';
using {anubhav.cds} from '../db/CDSViews';


service CatalogService @(
    path    : 'CatalogService',
    requires: 'authenticated-user'
) {

    @Capabilities: {
        Insertable,
        Updatable,
        Deletable: false
    }
    entity BusinessPartnerSet as projection on db.master.businesspartner;

    entity AddressSet         as projection on db.master.address;

    entity EmployeeSet @(restrict: [
        {
            grant: ['READ'],
            to   : 'Viewer',
            where: 'bankName = $user.BankName'
        },
        {
            grant: ['WRITE'],
            to   : 'Admin'
        }
    ])                        as projection on db.master.employees;

    entity PurchaseOrderItems as projection on db.transaction.poitems;
    function getOrderDefaults() returns POs;

    entity POs @(
        odata.draft.enabled         : true,
        Common.DefaultValuesFunction: 'getOrderDefaults'
    )                         as
        projection on db.transaction.purchaseorder {
            case OVERALL_STATUS
                when
                    'A'
                then
                    'Approved'
                when
                    'X'
                then
                    'Rejected'
                when
                    'N'
                then
                    'New'
                when
                    'D'
                then
                    'Delivered'
                when
                    'P'
                then
                    'Pending'
            end as OverallStatus : String(10),
            case OVERALL_STATUS
                when
                    'A'
                then
                    3
                when
                    'X'
                then
                    1
                when
                    'N'
                then
                    2
                when
                    'D'
                then
                    3
                when
                    'P'
                then
                    2
            end as ColorCode     : Integer,

            *,
            Items
        } actions {
            @cds.odata.bindingparameter.name: '_anubhav'
            @Common.SideEffects             : {TargetProperties: ['_anubhav/GROSS_AMOUNT']}
            action   boost();
            function largestOrder() returns array of POs;
        };

    //entity CProductValuesView as projection on cds.CDSViews.CProductValuesView;
    entity ProductSet         as projection on db.master.product;

}
