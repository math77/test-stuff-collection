//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


import './interfaces/IShapeGenerator.sol';
import './interfaces/IColorGenerator.sol';


import { Base64 } from "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Collection is ERC721, ReentrancyGuard, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;

    uint256 public constant MAX_SUPPLY = 999;


    IShapeGenerator public immutable shapeGenerator;
    IColorGenerator public immutable colorGenerator;
    

    constructor(IShapeGenerator _shapeG, IColorGenerator _colorG) ERC721("Collection", "COL") Ownable() {
        //init token in 1 instead of 0
        _tokenIDs.increment();
        shapeGenerator = _shapeG;
        colorGenerator = _colorG;
    }


    function claim() payable external {
        uint256 tokenID = _tokenIDs.current();
        require(tokenID < MAX_SUPPLY, "Id Token invalid, try another!");

        _safeMint(msg.sender, tokenID);

        _tokenIDs.increment();
    }

    function generateURI() external view returns (string memory) {
        IShapesSVGs.ShapeData memory shape = shapeGenerator.getShape(1);
        IColorsSVGs.ColorData memory color = colorGenerator.getColor(1);

        string memory name = "Test"; 

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '", "description":"test.", "image": "data:image/svg+xml;base64,',
                                Base64.encode(bytes(generateSVG(color.svgString, shape.svgString))),
                                '}'
                            )
                        )
                    )
                )
            );
    }

    function generateSVG(
        string memory colorSVG,
        string memory shapeSVG
    ) internal pure returns (bytes memory svg) {
        svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1920 1080">',
            colorSVG,
            shapeSVG,
            '</svg>'
        );
    }

    /*
    function tokenURI(uint256 tokenID) public view override returns (string memory) {    

        return string(abi.encodePacked("data:application/json;base64,",green,"LCAibmFtZSI6ICJNYXplNjkgIzEiLCAiZGVzY3JpcHRpb24iOiAiTWF6ZTY5IGlzIGEgc21hbGwsIGZ1biwgbWVtZSBvbmNoYWluIGdhbWUuIn0="));

    }

    
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
          return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
          digits++;
          temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
          digits -= 1;
          buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
          value /= 10;
        }
        return string(buffer);
    }


    function withdraw() public nonReentrant onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success);
    }
    */

}
