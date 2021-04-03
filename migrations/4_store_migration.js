const Store = artifacts.require("Store");

module.exports = function (deployer) {
  deployer.deploy(Store, 200, "500000000000000000");
};
