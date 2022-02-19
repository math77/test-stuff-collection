pragma solidity ^0.8.9;

import './IShapesSVGs.sol';


interface IShapeGenerator {
    

    function getShape(uint16 shape) external view returns (IShapesSVGs.ShapeData memory);


    struct ShapesSVGs {
        IShapesSVGs shapesSVGs1;
    }

}