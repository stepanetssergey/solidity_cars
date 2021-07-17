pragma solidity  ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CarSalonNFT is ERC721URIStorage {

    uint public tokenIDCounter;
    constructor() ERC721 ("CarSalon NFT", "CSNFT") {
        tokenIDCounter = 1;
    }

    function createClientCardNFT(string memory _tokenURI) public returns (uint) {
        _safeMint(msg.sender, tokenIDCounter);
        _setTokenURI(tokenIDCounter, _tokenURI);
        tokenIDCounter += 1;
    }
}