const WheresMyNFT = artifacts.require('WheresMyNFT.sol');

module.exports = function(deployer){
    deployer.deploy(WheresMyNFT);
};