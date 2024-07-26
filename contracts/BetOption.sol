// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BetOption {
    struct Option {
        address optionBuyer;
        address optionSeller;
        uint256 premium;
        uint256 expiration;
        uint256 commission;
        bool resultSet;
        string result;
    }

    Option[] public options;
    address public owner;

    event OptionCreated(uint256 optionId, address optionBuyer, address optionSeller, uint256 premium, uint256 expiration, uint256 commission);
    event ResultSet(uint256 optionId, string result);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier afterExpiration(uint256 _optionId) {
        require(block.timestamp >= options[_optionId].expiration, "Cannot set result before expiration");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function createOption(
        address _optionBuyer,
        address _optionSeller,
        uint256 _premium,
        uint256 _expiration
    ) public payable {
        uint256 commission = (_premium * 2) / 100; // 1% commission from both sides
        uint256 totalRequired = commission + _premium;

        // Require the msg.value to be the total amount required from both buyer and seller
        require(msg.value == totalRequired * 2, "Incorrect ETH value sent");

        Option memory newOption = Option({
            optionBuyer: _optionBuyer,
            optionSeller: _optionSeller,
            premium: _premium,
            expiration: _expiration,
            commission: commission,
            resultSet: false,
            result: ""
        });

        options.push(newOption);
        uint256 optionId = options.length - 1;

        // Transfer the total commission from the contract to the contract owner
        payable(owner).transfer(commission);

        // Emit the event for option creation
        emit OptionCreated(optionId, _optionBuyer, _optionSeller, _premium, _expiration, commission);
    }

    function setResult(uint256 _optionId, string memory _result) public onlyOwner afterExpiration(_optionId) {
        require(!options[_optionId].resultSet, "Result has already been set");

        options[_optionId].result = _result;
        options[_optionId].resultSet = true;

        if (keccak256(abi.encodePacked(_result)) == keccak256(abi.encodePacked("Trump Wins"))) {
            payable(options[_optionId].optionBuyer).transfer(options[_optionId].premium);
        } else {
            payable(options[_optionId].optionSeller).transfer(options[_optionId].premium);
        }

        emit ResultSet(_optionId, _result);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function getOption(uint256 _optionId) public view returns (Option memory) {
        return options[_optionId];
    }

    function getOptions() public view returns (Option[] memory) {
        return options;
    }
}

