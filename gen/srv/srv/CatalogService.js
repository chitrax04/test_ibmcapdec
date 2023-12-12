module.exports = cds.service.impl( async function(){

    //Step 1: get the object of our odata entities
    const { EmployeeSet, POs } = this.entities;

    this.before('CREATE', EmployeeSet, async (req, res) => {
        console.log("aa gaya "+  JSON.stringify(req.data));
        if(parseInt(req.data.salaryAmount) >= 1000000){
            req.error(500,"Dude you cannot pass salary over a million");
        }
    });

    this.on('boost', async (req,res) => {
        try {
            const ID = req.params[0];
            console.log("Hey Amigo, Your purchase order with id " + req.params[0] + " will be boosted");
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT: { '+=' : 20000 },
                NOTE: 'Boosted!!'
            }).where(ID);
        } catch (error) {
            return "Error " + error.toString();
        }
    });

    this.on('largestOrder', async (req,res) => {
        try {
            const ID = req.params[0];
            const tx = cds.tx(req);
            
            //SELECT * UPTO 1 ROW FROM dbtab ORDER BY GROSS_AMOUNT desc
            const reply = await tx.read(POs).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);

            return reply;
        } catch (error) {
            return "Error " + error.toString();
        }
    });

    this.on('getOrderDefaults', async (req,res) => {
        try {

            //SELECT * UPTO 1 ROW FROM dbtab ORDER BY GROSS_AMOUNT desc
            const reply = {
                "OVERALL_STATUS": 'N'
            }

            return reply;
        } catch (error) {
            return "Error " + error.toString();
        }
    });

}
);