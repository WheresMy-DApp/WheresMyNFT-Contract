const WheresMyNFT = artifacts.require('WheresMyNFTV2.sol');

module.exports = function(deployer){
    deployer.deploy(WheresMyNFT);
};