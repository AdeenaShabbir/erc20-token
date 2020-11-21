pragma solidity ^0.6.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }


    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }


    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

   
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
contract Ownable {
    address payable private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address payable) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

   
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
 
}

contract Token is Ownable {
    
    string public name = "my_erc20_token";
    string public symbol = "ERC";
    uint public total_supply = 5000;
    
    using SafeMath for uint256;

    mapping(address => uint) balance;
    mapping(address => mapping(address => uint)) allowed;
    
    constructor () public{
        balance[owner()] = total_supply;
    }
    
    function totalSupply() public view returns (uint256){
        return total_supply;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint){
        return balance[tokenOwner];
    }
    
    function allowance(address _tokenOwner, address _spender) public view returns (uint){
        return allowed[_tokenOwner][_spender];
    }
    
 
    function transfer(address _receiver, uint _amount) public returns (bool){
        require(_amount <= balance[msg.sender]);
        balance[msg.sender] = balance[msg.sender].sub(_amount);
        balance[_receiver] = balance [_receiver].add(_amount);
        return true;
    }
    
    function approve(address _spender, uint _tokens)  public returns (bool){
        allowed[msg.sender][_spender] = _tokens;
        return true;
    }
    
    function transferFrom(address _tokenowner, address _receiver, uint _tokens) public returns (bool){
        require(_tokens <= balance[_tokenowner]);
        require(_tokens <= allowed[_tokenowner][msg.sender]);
        
        allowed[_tokenowner][msg.sender] = allowed[_tokenowner][msg.sender].sub(_tokens);
        
        balance[_tokenowner] = balance[_tokenowner].sub(_tokens);
        balance[_receiver] = balance[_receiver].add(_tokens);
        
        return true;
    }
    
    function mint (uint256 _amount) internal onlyOwner{
        // ??
        //  require(account != address(0), "ERC20: mint to the zero address");
        // _beforeTokenTransfer(address(0), account, amount);
        
        total_supply = total_supply.add(_amount);
        balance[owner()] = balance[owner()].add(_amount);
    }
    
    function burn(uint256 _amount) internal virtual {
        //??
        // require(account != address(0), "ERC20: burn from the zero address");
        // _beforeTokenTransfer(account, address(0), amount);

        balance[owner()] = balance[owner()].sub(_amount);
        total_supply = total_supply.sub(_amount);
}
}
