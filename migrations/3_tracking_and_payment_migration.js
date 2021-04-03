const TrackingAndPayment = artifacts.require("TrackingAndPayment");

module.exports = function(deployer) {
	deployer.deploy(TrackingAndPayment, 
		"0x07F0f43cF1aCb95D08E107b4F6c9E739500AC261", 
		"0x4d036315F10380247d2935eb5D2FDb0E30fa2D7b", 
		"0x8e627a30Bf0a606f141Da92B5Ba7679e4B4f617D");
};