pragma solidity ^0.8.5;


contract BuyCars {
    
    
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can do this");
        _;
    }
    
    
    uint public UserID;
    uint public CarID;
    
    struct car {
        uint price;
        string brand;
        string model;
    }
    
    struct order {
        uint price;
        uint userID;
        uint carID;
        uint date;
    }
    
    mapping(address => string) public Users;
    mapping(uint => address) public UserIDs;
    mapping(uint => car) public Cars;
    
    //FUNCTIONS
    
    //Function for adding users to smart contract
    
    function addUser(string memory _name) public onlyOwner {
        UserID += 1;
        Users[msg.sender] = _name;
        UserIDs[UserID] = msg.sender;
    }
    
    function addCar(string memory _brand, string memory _model, uint _price) public onlyOwner{
        CarID += 1;
        Cars[CarID].brand = _brand;
        Cars[CarID].model = _model;
        Cars[CarID].price = _price;
    }
    
    
    
    
}