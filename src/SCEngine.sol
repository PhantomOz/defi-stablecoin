// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Stable Coin Engine
/// @author Favour Aniogor
/// @notice This helps keeps Stable Coin at constant exchange rate.
/// @dev This system is designed to help Stable Coin maintain a 1 token = $1 peg.
contract SCEngine {

}

interface ISCEngine {
    function depositCollateralAndMintSC() external;
    function depositCollateral() external;
    function redeemCollateralForSC() external;
    function redeemCollateral() external;
    function mintSC() external;
    function burnSC() external;
    function liquidate() external;
    function getHealthFactor() external view;
}