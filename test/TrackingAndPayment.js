const TrackingAndPayment = artifacts.require("TrackingAndPayment.sol");


contract("TrackingAndPayment", async accounts => {

	describe("when tracking supply chaing", async() => {
		it("should run payments during lifecycle", async () => {
			let instance = await TrackingAndPayment.deployed();

			const roles = {
				supplier: {
					account: await instance.supplier.call(),
					steps: 4
				},
				factory: {
					account: await instance.factory.call(),
					steps: 4,
					deposit: 1000000000000000000
				},
				store: {
					account: await instance.store.call(),
					steps: 2,
					deposit: 2000000000000000000
				}
			}

			for (let i in roles) {
				let role = roles[i];
				if(role.deposit) {
					await instance.deposit({
						from: role.account,
						value: role.deposit
					});
				}
			}

			const supplierBalance = await instance.supplierBalance.call();
			const factoryBalance = await instance.factoryBalance.call();

			assert.equal(supplierBalance, roles.factory.deposit, "Factory deposit doesn't match supplier balance");
			assert.equal(factoryBalance, roles.store.deposit, "Store deposit doesn't match factory balance");

			for(let i in roles) {
				let role = roles[i];
				await instance.accept({ from: role.account });
			}

			for(let i in roles) {
				let role = roles[i];
				for (let j=0; j<roles.steps; j++) {
					await instance.next( { from: role.account } );
				}
			}

			assert.equal(await web3.eth.getBalance(instance.address), 0, "The contract still have founds");

			assert.equal( (await instance.storeVerificationState.call()).toNumber(), 2, "Workflow is not finished");

		})
	})
})