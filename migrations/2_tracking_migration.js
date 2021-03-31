const Tracking = artifacts.require("Tracking");

module.exports = function (deployer) {
  deployer.deploy(Tracking, "0x2Af691753BF1467Cae6254063306FB3cca8a3aA5", "0x071895d0c9D125577A4385d51e3230d1fB13e908", "0x6d7001dD4FAB3915463133C8Cb23eF3c8561c69a");
};
