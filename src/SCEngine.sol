// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { StableCoin } from "./StableCoin.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/// errors
error SCEngine__MustBeMoreThanZero();
error SCEngine__tokensAndPriceFeedsArrayMustBeSameLength();
error SCEngine__TokenNotAllowed();
error SCEngine__TransferFailed();

/// @title Stable Coin Engine
/// @author Favour Aniogor
/// @notice This helps keeps Stable Coin at constant exchange rate.
/// @dev This system is designed to help Stable Coin maintain a 1 token = $1 peg.
contract SCEngine {

    /// State Variables
    /// @dev maps the approved colleteral tokens to their price feed
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 balance)) private s_addressToCollateralDeposited;
    StableCoin private immutable i_SC;

    /// Events
    event CollateralDeposited(address indexed _sender, address indexed _token, uint256 _value);

    /// Modifiers
    modifier moreThanZero(uint256 _amount){
        if(_amount <= 0) {
            revert SCEngine__MustBeMoreThanZero();
        }
        _;
    }
    modifier isTokenAllowed(address _token) {
        if(s_priceFeeds[_token] == address(0)){
            revert SCEngine__TokenNotAllowed();
        }
        _;
    }

    /// Functions
    constructor(address[] memory _tokens, address[] memory _priceFeeds, address _SCAddress){
        if(_tokens.length != _priceFeeds.length) {
            revert SCEngine__tokensAndPriceFeedsArrayMustBeSameLength();
        }
        for(uint8 i = 0; i < _tokens.length; i++){
            s_priceFeeds[_tokens[i]] = _priceFeeds[i];
        }
        i_SC = StableCoin(_SCAddress);
    }
    
    /// @param _tokenCollateralAddress The address of the token to deposit as collateral
    /// @param _amountOfCollateral The amount of collateral to deposit
    function depositCollateral(address _tokenCollateralAddress, uint256 _amountOfCollateral) external moreThanZero(_amountOfCollateral) isTokenAllowed(_tokenCollateralAddress){
        s_addressToCollateralDeposited[msg.sender][_tokenCollateralAddress] += _amountOfCollateral;
        emit CollateralDeposited(msg.sender, _tokenCollateralAddress, _amountOfCollateral);
        bool _success = IERC20(_tokenCollateralAddress).transferFrom(msg.sender, address(this), _amountOfCollateral);
        if(!_success){
            revert SCEngine__TransferFailed();
        }
    }
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