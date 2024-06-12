// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error DeadStarToken_ZeroAddress();
error DeadStarToken_InsufficentBalance();
error DeadStarToken_NotAllowed();

contract DeadStarToken {
    // DST - ticker symbol
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    mapping (address => uint256) private _balance;
    mapping (address => mapping(address => uint256)) _allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _balance[msg.sender] = totalSupply_;
        _totalSupply += totalSupply_;
    }


    function balanceOf(address _owner) public view returns(uint256) {
        if (_owner == address(0)) revert DeadStarToken_ZeroAddress();
        return _balance[_owner];
    }

    function transfer(address _to, uint256 _value) public returns(bool) {

        if (!(_balance[msg.sender] >= _value && _balance[msg.sender] > 0)) revert DeadStarToken_InsufficentBalance();

        _balance[msg.sender] -= _value;
        _balance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
        if (_allowance[msg.sender][_from] < _value) revert DeadStarToken_NotAllowed();
        if (!(_balance[msg.sender] >= _value && _balance[_from] > 0)) revert DeadStarToken_InsufficentBalance();

        _balance[_from] -= _value;
        _balance[_to] += _value;
        _allowance[msg.sender][_from] -= _value;

        emit Transfer(_from, _to, _value); 
        return true;
    }

    function approve(address _spender, uint256 _value) public returns(bool) {
        if (_balance[msg.sender] >= _value) revert DeadStarToken_InsufficentBalance();
        _allowance[_spender][msg.sender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint256) {
        return _allowance[_spender][_owner];
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }
}


