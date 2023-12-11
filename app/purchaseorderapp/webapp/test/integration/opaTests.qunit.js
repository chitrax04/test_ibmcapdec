sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'anubhav/po/purchaseorderapp/test/integration/FirstJourney',
		'anubhav/po/purchaseorderapp/test/integration/pages/POsList',
		'anubhav/po/purchaseorderapp/test/integration/pages/POsObjectPage',
		'anubhav/po/purchaseorderapp/test/integration/pages/PurchaseOrderItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, POsList, POsObjectPage, PurchaseOrderItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('anubhav/po/purchaseorderapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePOsList: POsList,
					onThePOsObjectPage: POsObjectPage,
					onThePurchaseOrderItemsObjectPage: PurchaseOrderItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);