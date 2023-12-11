using { anubhav.db } from '../db/datamodel';
using { anubhav.cds } from '../db/CDSViews';


service CatalogService @(path:'CatalogService')  {

    @Capabilities:{Insertable,Updatable,Deletable: false}
    entity BusinessPartnerSet as projection on db.master.businesspartner;
    entity AddressSet as projection on db.master.address;
    entity EmployeeSet as projection on db.master.employees;
    entity PurchaseOrderItems as projection on db.transaction.poitems;
    function getOrderDefaults() returns POs;
    entity POs @(
        odata.draft.enabled: true,
        Common.DefaultValuesFunction: 'getOrderDefaults'
    ) as projection on db.transaction.purchaseorder{
        CASE OVERALL_STATUS
            WHEN 'A' then 'Approved'
            WHEN 'X' then 'Rejected'
            WHEN 'N' then 'New'
            WHEN 'D' then 'Delivered'
            WHEN 'P' then 'Pending' end as OverallStatus: String(10),
        case OVERALL_STATUS
            WHEN 'A' then 3
            WHEN 'X' then 1
            WHEN 'N' then 2
            WHEN 'D' then 3
            WHEN 'P' then 2 end as ColorCode: Integer,

        *,
        Items
    } actions{
        @cds.odata.bindingparameter.name: '_anubhav'
        @Common.SideEffects: {
            TargetProperties: ['_anubhav/GROSS_AMOUNT']
        }
        action boost();
        function largestOrder() returns array of POs;
    };
    //entity CProductValuesView as projection on cds.CDSViews.CProductValuesView;
    entity ProductSet as projection on db.master.product;

}