// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleCoin {
    mapping(address => uint256) public coinBalance;
    mapping(address => bool) public frozenAccount;
    mapping(address => mapping(address => uint256)) public allowance;
    address owner;
    bool released = false;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event FrozzenAccount(address target, bool frozen);

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        mint(owner, _initialSupply);
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert();
        _;
    }

    function transfer(
        address _to,
        uint256 _amount
    ) public returns (bool success) {
        require(coinBalance[msg.sender] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);

        if (released) {
            coinBalance[msg.sender] -= _amount;
            coinBalance[_to] += _amount;
            emit Transfer(msg.sender, _to, _amount);
            return true;
        }

        revert();
    }

    function setAllowance(
        uint256 coins,
        address address1,
        address address2
    ) public {
        allowance[address1][address2] = coins;
    }

    function authorize(
        address _authorizedAccount
    ) public view returns (bool success) {
        allowance[msg.sender][_authorizedAccount];
        return true;
    }

    /**
     * Transfer from an source account
     * @param _from From account
     * @param _to To account
     * @param _ammount Coins
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _ammount
    ) public returns (bool) {
        require(
            _to != address(0),
            "Address must be provided when transfering coins"
        );
        require(coinBalance[_from] >= _ammount);
        require(coinBalance[_to] + _ammount >= coinBalance[_to]);
        require(_ammount >= 0, "Invalid ammount");
        require(_ammount <= allowance[_from][msg.sender]);

        if (released) {
            coinBalance[_from] -= _ammount;
            coinBalance[_to] += _ammount;
            emit Transfer(_from, _to, _ammount);
            return true;
        }

        revert();
    }

    /**
     * Add balance to target address
     * @param _recipient Target address
     * @param _mintedAmmount Desired ammount
     */
    function mint(address _recipient, uint256 _mintedAmmount) public onlyOwner {
        require(msg.sender == owner);
        coinBalance[_recipient] += _mintedAmmount;
        emit Transfer(owner, _recipient, _mintedAmmount);
    }

    /**
     * Freezze an account
     * @param target Target account
     * @param freezze True if want to freeze
     */
    function freezeAccount(address target, bool freezze) public onlyOwner {
        frozenAccount[target] = freezze;
        emit FrozzenAccount(target, freezze);
    }

    function release() public onlyOwner {
        released = true;
    }
}
