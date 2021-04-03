const Store = artifacts.require("Store.sol");

contract("Store", async accounts => {
    describe("when creating store", async () => {
        it("should manage points", async() => {
            const instance = await Store.deployed();
            assert.equal( (await instance.getPoints.call()).toNumber(), 0, "Wrong number of points");

            const buyer = "0xB1CfbCb104cd967247D8d712B2A8380EC31376d0";
            const price = await instance.price.call();
            const receipt = await instance.buy( {from: buyer, value: price * 3});

            assert.equal( (await instance.getPoints.call()).toNumber(), 3, "Wrong number of points");
        });

        it("should sell products", async () => {
            const instance = await Store.deployed();

            const buyer1 = "0x0a6178408B22eEdd9423acdAd417f9091524AA70";
            const buyer2 = "0x3C27763Ab2aF36a4B97a442219e3c665DC12855C";

            const price = await instance.price.call();
            const stock = (await instance.stock.call()).toNumber();

            await instance.buy({ from: buyer1, value: price} );
            await instance.buy( { from: buyer2, value: price*2} );

            const points1 = await instance.getBalance(buyer1);
            const points2 = await instance.getBalance(buyer2);

            assert.equal(points1, 1, "Account should have 1 point");
            assert.equal(points2, 2, "Account should have 2 points");

            assert.equal( (await instance.stock.call()).toNumber(), stock-3, "Final stock is invalid");
        });

        it("should return change to buyer", async () => {
            const instance = await Store.deployed();

            const buyer = "0xd469a342f0816A48f4EE82cf0c9565C70E15E367";
            const price = await instance.price.call();

            const receipt = await instance.buy( { from: buyer, value: price*1.5 } );

            const change = receipt.logs[0].args.change.toNumber();

            assert.equal( receipt.logs[0].event, "ChangeReceipt", "Event should be triggered");
            assert.equal( change, price/2, "Change is not correct");
        });
    });
});