pragma solidity ^0.8.0;

contract WheresMyNFT {
    uint256 public tokenId;
    uint[] public latitudes;
    uint[] public longitudes;
    uint[] public timestamps;
    
    mapping (uint256 => bool) public tokens;
    mapping (uint256 => bytes12) public deviceMacAddresses;
    
    constructor () public {
        tokenId = 0;
    }
    
    function createNFT(uint[] memory _latitudes, uint[] memory _longitudes, uint[] memory _timestamps, bytes12 _deviceMacAddress) public {
        tokenId++;
        tokens[tokenId] = true;
        latitudes.push(_latitudes);
        longitudes.push(_longitudes);
        timestamps.push(_timestamps);
        deviceMacAddresses[tokenId] = _deviceMacAddress;
    }
    
    function getLatitudes(uint256 _tokenId) public view returns (uint[] memory) {
        return latitudes[_tokenId];
    }
    
    function getLongitudes(uint256 _tokenId) public view returns (uint[] memory) {
        return longitudes[_tokenId];
    }
    
    function getTimestamps(uint256 _tokenId) public view returns (uint[] memory) {
        return timestamps[_tokenId];
    }
    
    function getDeviceMacAddress(uint256 _tokenId) public view returns (bytes12) {
        return deviceMacAddresses[_tokenId];
    }
    
    function transfer(uint256 _tokenId, address _to) public {
        require(tokens[_tokenId] == true, "Token does not exist");
        tokens[_tokenId] = false;
        _to.transfer(_tokenId);
    }
}