pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    struct LocationData {
        uint256 timestamp;
        string locationCode;
    }

    struct NFTData {
        address owner;
        LocationData[] metadata;
        uint256 nftTokenId;
        bytes32 deviceHash;
    }

    NFTData[] private nftData;
    uint256[] private tokenIdArray;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function mint() public {
        uint256 tokenId = nftData.length;
        tokenIdArray.push(tokenId);
        nftData.push(
            NFTData(msg.sender, new LocationData[](0), tokenId, bytes32(0))
        );
        _safeMint(msg.sender, tokenId);
    }
}
