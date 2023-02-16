// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract WheresMyNFT is ERC721, AccessControl {
    bytes32 public constant SERVER_ROLE = keccak256("SERVER_ROLE");

    struct LocationData {
        uint256 timestamp;
        string locationCode;
    }

    struct NFTData {
        address owner;
        LocationData[] metadata;
        uint256 nftTokenId;
        bytes32 deviceHash;
        bool isLost;
        uint256 lostTimestamp;
    }

    uint256 tokenIdCounter;

    NFTData[] private nftData;
    uint256[] private tokenIdArray;
    mapping(bytes32 => uint256) private deviceHashMap;

    event FoundLostDevice(
        address indexed owner
    );

    constructor(address serverAddress) ERC721("WheresMyNFT", "WMNFT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(SERVER_ROLE, serverAddress);
        mint("0", "0", 0);
    }

    function mint(
        string memory _deviceHash,
        string memory _locationCode,
        uint256 _timestamp
    ) public {
        require(
            deviceHashMap[keccak256(abi.encode(_deviceHash))] == 0,
            "Device already exists"
        );
        uint256 tokenId = nftData.length;
        deviceHashMap[keccak256(abi.encode(_deviceHash))] = tokenId;
        // Create NFT First and Push Location Data to LocationData Array in the NFT
        NFTData storage deviceNft = nftData.push();
        deviceNft.metadata.push(LocationData(_timestamp, _locationCode));
        deviceNft.owner = msg.sender;
        deviceNft.nftTokenId = tokenId;
        deviceNft.deviceHash = keccak256(abi.encode(_deviceHash));
        deviceNft.isLost = false;
        deviceNft.lostTimestamp = 0;
        tokenIdArray.push(tokenId);
        _safeMint(msg.sender, tokenId);
    }

    function reportLost(string memory _deviceHash, uint256 _lostTimestamp)
        public
    {
        require(
            deviceHashMap[keccak256(abi.encode(_deviceHash))] != 0,
            "Device does not exist"
        );
        uint256 _tokenId = deviceHashMap[keccak256(abi.encode(_deviceHash))];
        require(
            nftData[_tokenId].owner == msg.sender,
            "Only the owner can report lost"
        );
        nftData[_tokenId].isLost = true;
        nftData[_tokenId].lostTimestamp = _lostTimestamp;
    }

    function reportFound(string memory _deviceHash) public {
        require(
            deviceHashMap[keccak256(abi.encode(_deviceHash))] != 0,
            "Device does not exist"
        );
        uint256 _tokenId = deviceHashMap[keccak256(abi.encode(_deviceHash))];
        require(
            nftData[_tokenId].owner == msg.sender,
            "Only the owner can report found"
        );
        require(nftData[_tokenId].isLost == true, "Device is not lost");
        nftData[_tokenId].isLost = false;
        nftData[_tokenId].lostTimestamp = 0;
    }

    function foundDevicePing(
        string memory _deviceHash,
        string memory _locationCode,
        uint256 _timestamp
    ) public onlyRole(SERVER_ROLE) {
        require(
            deviceHashMap[keccak256(abi.encode(_deviceHash))] != 0,
            "Device does not exist"
        );
        uint256 _tokenId = deviceHashMap[keccak256(abi.encode(_deviceHash))];
        LocationData[] storage locationDataArray = nftData[_tokenId].metadata;
        locationDataArray.push(LocationData(_timestamp, _locationCode));
        if(nftData[_tokenId].isLost == true) {
            emit FoundLostDevice(nftData[_tokenId].owner);
        }
    }

    function getLatestDeviceLocation(string memory _deviceHash)
        public
        view
        returns (uint256, string memory)
    {
        require(
            deviceHashMap[keccak256(abi.encode(_deviceHash))] != 0,
            "Device does not exist"
        );
        uint256 _tokenId = deviceHashMap[keccak256(abi.encode(_deviceHash))];
        require(
            nftData[_tokenId].owner == msg.sender,
            "Only the owner can get device location"
        );
        return (
            nftData[_tokenId]
                .metadata[nftData[_tokenId].metadata.length - 1]
                .timestamp,
            nftData[_tokenId]
                .metadata[nftData[_tokenId].metadata.length - 1]
                .locationCode
        );
    }

    function getLocationHistory(string memory _deviceHash)
        public
        view
        returns (LocationData[] memory)
    {
        require(
            deviceHashMap[keccak256(abi.encode(_deviceHash))] != 0,
            "Device does not exist"
        );
        uint256 _tokenId = deviceHashMap[keccak256(abi.encode(_deviceHash))];
        require(
            nftData[_tokenId].owner == msg.sender,
            "Only the owner can get device location"
        );
        return nftData[_tokenId].metadata;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
