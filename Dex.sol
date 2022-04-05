// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
 
interface IERC20 {
    function transferFrom(address _from , address _to , uint256 _value)external returns(bool success);
    function transfer(address _to,uint256 _value)external returns(bool success);
}


contract Exchange {

    address public feesAccount = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    uint256 public feesRate = 10;
    address public constant ETH = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;//Address wher user gonna send ETH on the DEX
    
    //mapping of the address of holders who deposit tokens on the DEX
    mapping(address => mapping(address => uint256)) public tokens;
    
    event deposit(address indexed token , address indexed user , uint256 amount , uint256 balance);

    receive() external payable {
        revert("Not now");
    }
    
    function depositETH() external payable {
        tokens[ETH][msg.sender]+=msg.value;
        emit deposit(ETH , msg.sender , msg.value,tokens[ETH][msg.sender]);
    }

    function depositTokens(address _tokenAddress , uint256 _amount) external payable {
        require(_tokenAddress!=ETH , "This is not the right address");
        require(IERC20(_tokenAddress).transferFrom(msg.sender , address(this), _amount));
        tokens[_tokenAddress][msg.sender]+=_amount;

        emit deposit(_tokenAddress , msg.sender , _amount ,tokens[_tokenAddress][msg.sender] );
    }

}