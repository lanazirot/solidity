// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../SimpleCoin/simpleCoin.sol";

contract SimpleCrowdSale {
    address owner;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice;
    uint256 public weiInvestementObjective;

    mapping(address => uint256) public investmentAmmountOf;
    uint256 public investmentReceived;
    uint256 public investmentRefunded;

    bool public isFinalized;
    bool public isRefunding;

    SimpleCoin public crowdSaleToken;

    event LogInvestment(address indexed investor, uint256 ammount);
    event LogTokenAssignment(address indexed investor, uint256 numTokens);

    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _etherInvestmentObjective
    ) {
        require(
            _startTime >= block.timestamp,
            "Start time must be ge block.timestamp"
        );
        require(_endTime >= _startTime, "End time must be ge Start time");
        require(_weiTokenPrice != 0, "Wei token price != 0");
        require(
            _etherInvestmentObjective != 0,
            "Ether investment objective != 0"
        );

        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestementObjective = _etherInvestmentObjective * 1e18;

        crowdSaleToken = new SimpleCoin(0);
        isFinalized = isRefunding = false;

        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert();
        _;
    }

    function isValidInvestment(uint _investment) internal view returns (bool) {
        return
            _investment != 0 &&
            block.timestamp >= startTime &&
            block.timestamp <= endTime;
    }

    function calculateNumberOfTokens(uint _investment) internal view returns(uint256) {
        return _investment / weiTokenPrice;
    }

    function assignTokens(
        address _beneficiario,
        uint256 _investment
    ) internal {
        uint256 _numberOfTokens = calculateNumberOfTokens(_investment);
        crowdSaleToken.mint(_beneficiario, _numberOfTokens);
    }

    function invest() public payable {
        require(isValidInvestment(msg.value));
        address investor = msg.sender;
        uint256 investment = msg.value;
        investmentAmmountOf[investor] = investment;
        investmentReceived += investment;
        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);
    }

    function finalize() public onlyOwner {}

    function refund() public {}
}
