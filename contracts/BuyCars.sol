pragma solidity ^0.8.5;

import "./IERC20.sol";

contract BuyCars {
    
    
    address public owner;
    address public bonusTokenAddress;
    address public accounter;
    
    event createOrderEvent(uint _tokens);
    
    constructor(address _btkaddr) {
        owner = msg.sender;
        bonusTokenAddress = _btkaddr;
    }
    
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can do this");
        _;
    }
    
    
    uint public UserID;
    uint public CarID;
    uint public OrderID;
    uint public ServicesOrderID;
    
    struct car {
        uint price;
        string brand;
        string model;
    }
    
    struct order {
        uint userID;
        uint carID;
        uint date;
        bool active;
        uint tokens;
    }

    struct serviceOrder {
        address userAddress;
        uint price;
        uint date;
    }
    
    struct user {
        string name;
        uint tokens;
        uint[] orders;
    }
    
    mapping(address => user) public Users;
    mapping(uint => address) public UserIDs;
    mapping(uint => car) public Cars;
    mapping(uint => order) public Orders;
    mapping(uint => serviceOrder) public ServicesOrders;
    
    
    //FUNCTIONS
    
    //Function for adding users to smart contract
    
    function setBonusTokenAddress(address _address) public onlyOwner {
        bonusTokenAddress = _address;
    }

    function addAccounter (address _address) public onlyOwner {
        accounter = _address;
    }
    
    
    function addUser(string memory _name, address _userAddress) public onlyOwner {
        UserID += 1;
        Users[_userAddress].name = _name;
        UserIDs[UserID] = _userAddress;
    }
    
    function addCar(string memory _brand, string memory _model, uint _price) public onlyOwner {
        CarID += 1;
        Cars[CarID].brand = _brand;
        Cars[CarID].model = _model;
        Cars[CarID].price = _price;
    }
    
    
    function createOrder(uint _car_id, uint _user_id) public onlyOwner {
        OrderID += 1;
        Orders[OrderID].userID = _user_id;
        Orders[OrderID].carID = _car_id;
        Orders[OrderID].date = block.timestamp;
        Orders[OrderID].active = true;
        address _user_address = UserIDs[_user_id];
        Users[_user_address].orders.push(OrderID);
        uint _tokens = Cars[_car_id].price/100; 
        Orders[OrderID].tokens = _tokens;
        Users[_user_address].tokens = _tokens;
        IERC20 _bonusToken = IERC20(bonusTokenAddress);
        _bonusToken.mint(_user_address, _tokens * 10 ** 18);
        emit createOrderEvent(_tokens);  
    }

    function createServiceOrder (address _address, uint _price) public onlyOwner {
        ServicesOrderID += 1;
        ServicesOrders[ServicesOrderID].userAddress = _address;
        ServicesOrders[ServicesOrderID].price = _price;
        ServicesOrders[ServicesOrderID].date = block.timestamp;
    }

    /*
    function checkUserTokens(uint _order_id, uint _user_id) public onlyOwner {

    }
    */

    function payByTokens(uint _servOrder_id) public {
        uint _serviceAmount = ServicesOrders[_servOrder_id].price;
        require(Users[msg.sender].tokens >= _serviceAmount, "Not enought tokens");
        IERC20 _bon_token = IERC20(bonusTokenAddress);
        _bon_token.transferFrom(msg.sender, accounter, _serviceAmount * 10 ** 18);
        Users[msg.sender].tokens -= _serviceAmount;
    }

    
    
    
    
}