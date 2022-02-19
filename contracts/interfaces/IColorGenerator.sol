pragma solidity ^0.8.9;

import './IColorsSVGs.sol';


interface IColorGenerator {
    

    function getColor(uint16 color) external view returns (IColorsSVGs.ColorData memory);


    struct ColorsSVGs {
        IColorsSVGs colorsSVGs1;
    }

}