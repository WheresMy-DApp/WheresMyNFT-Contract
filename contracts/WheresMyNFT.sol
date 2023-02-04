pragma solidity ^0.8.0;

contract LocationNFT {
    uint256 public tokenId;

    address public authorizedUser;
    
    mapping (uint256 => bool) public tokens;
    mapping (uint256 => bytes12) public deviceMacAddresses;
    mapping (uint256 => uint[]) public latitudesArrays;
    mapping (uint256 => uint[]) public longitudesArrays;
    mapping (uint256 => uint[]) public timestampsArrays;
    
    constructor () public {
        tokenId = 0;
    }

    function createNFT(uint[] memory _latitudes, uint[] memory _longitudes, uint[] memory _timestamps, bytes12 _deviceMacAddress) public {
        tokenId++;
        tokens[tokenId] = true;
        latitudesArrays[tokenId] = _latitudes;
        longitudesArrays[tokenId] = _longitudes;
        timestampsArrays[tokenId] = _timestamps;
        deviceMacAddresses[tokenId] = _deviceMacAddress;
    }
    
    function getLatitudes(uint256 _tokenId) public isAuthorized view returns (uint[] memory) {
        return latitudesArrays[_tokenId];
    }
    
    function getLongitudes(uint256 _tokenId) public isAuthorized view returns (uint[] memory) {
        return longitudesArrays[_tokenId];
    }
    
    function getTimestamps(uint256 _tokenId) public isAuthorized view returns (uint[] memory) {
        return timestampsArrays[_tokenId];
    }
    
    function getDeviceMacAddress(uint256 _tokenId) public isAuthorized view returns (bytes12) {
        return deviceMacAddresses[_tokenId];
    }
    
    function transfer(uint256 _tokenId, address _to) public {
        require(tokens[_tokenId] == true, "Token does not exist");
        tokens[_tokenId] = false;
        payable(_to).transfer(_tokenId);
    }

    modifier isAuthorized() {
        require(msg.sender == authorizedUser, "Not authorized");
        _;
    }
}
