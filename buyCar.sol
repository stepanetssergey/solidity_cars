pragma solidity ^0.8.5;

import "./IERC20.sol";

contract BuyCars {
    
    
    address public owner;
    address public bonusTokenAddress;
    
    event createOrderEvent(uint _tokens);
    
    constructor() {
        owner = msg.sender;
    }
    
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can do this");
        _;
    }
    
    
    uint public UserID;
    uint public CarID;
    uint public OrderID;
    
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
    
    struct user {
        string name;
        uint tokens;
        uint[] orders;
    }
    
    mapping(address => user) public Users;
    mapping(uint => address) public UserIDs;
    mapping(uint => car) public Cars;
    mapping(uint => order) public Orders;
    
    
    //FUNCTIONS
    
    //Function for adding users to smart contract
    
    function setBonusTokenAddress(address _address) public onlyOwner {
        bonusTokenAddress = _address;
    }
    
    
    function addUser(string memory _name) public onlyOwner {
        UserID += 1;
        Users[msg.sender].name = _name;
        UserIDs[UserID] = msg.sender;
    }
    
    function addCar(string memory _brand, string memory _model, uint _price) public onlyOwner{
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


    function checkUserTokens(uint _order_id, uint _user_id) public onlyOwner {

    }


    function payByTokens(uint _order_id) public {
        //msg.sender
        //transferFrom
        // - tokens on order
        // - balance takens for user in user struct
    }


    
    
    
    
}