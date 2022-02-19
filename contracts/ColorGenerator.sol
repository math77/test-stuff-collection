pragma solidity ^0.8.9;


import './interfaces/IColorGenerator.sol';
import './interfaces/IColorsSVGs.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

/// @dev Generate Hardware SVG and properties
contract ColorGenerator is IColorGenerator {
    using Strings for uint16;

    IColorsSVGs immutable colorsSVGs1;


    constructor(colorsSVGs memory svgs) {
        colorsSVGs1 = svgs.colorsSVGs1;
    }

    function callColorsSVGs(IColorsSVGs target, uint16 color)
        internal
        view
        returns (IColorsSVGs.ColorData memory)
    {
        bytes memory functionSelector = abi.encodePacked('color_', uint16(color).toString(), '()');

        bool success;
        bytes memory result;
        (success, result) = address(target).staticcall(abi.encodeWithSelector(bytes4(keccak256(functionSelector))));

        return abi.decode(result, (IColorsSVGs.ColorData));
    }

    function getColor(uint16 color) external view override returns (IColorsSVGs.ColorData memory) {
        if (color <= 5) {
            return callColorsSVGs(colorsSVGs1, color);
        }

        revert('invalid color selection');
    }
}