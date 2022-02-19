pragma solidity ^0.8.9;


import './interfaces/IShapeGenerator.sol';
import './interfaces/IShapesSVGs.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

/// @dev Generate Hardware SVG and properties
contract ShapeGenerator is IShapeGenerator {
    using Strings for uint16;

    IShapesSVGs immutable shapesSVGs1;


    constructor(ShapesSVGs memory svgs) {
        shapesSVGs1 = svgs.shapesSVGs1;
    }

    function callShapesSVGs(IShapesSVGs target, uint16 shape)
        internal
        view
        returns (IShapesSVGs.ShapeData memory)
    {
        bytes memory functionSelector = abi.encodePacked('shape_', uint16(shape).toString(), '()');

        bool success;
        bytes memory result;
        (success, result) = address(target).staticcall(abi.encodeWithSelector(bytes4(keccak256(functionSelector))));

        return abi.decode(result, (IShapesSVGs.ShapeData));
    }

    function getShape(uint16 shape) external view override returns (IShapesSVGs.ShapeData memory) {
        if (shape <= 5) {
            return callShapesSVGs(shapesSVGs1, shape);
        }

        revert('invalid shape selection');
    }
}