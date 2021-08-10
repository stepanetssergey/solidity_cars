pragma solidity 0.8.0;
import './IERC20.sol';
contract CourseIDO {

    event BuyIDOToken(address payable _addres, uint _value);
    
    constructor(address _IDOTokenAddress, address payable _withdrawAddress) {
        Admins[msg.sender] = true;
        IDOTokenAddress = _IDOTokenAddress;
        withdrawAddress = _withdrawAddress;
    }  

    uint public RoundID;
    uint public currentRoundID;
    address public IDOTokenAddress;
    address payable public withdrawAddress;

    struct round {
        uint start;
        uint end;
        uint roundValue; //we want to get from this ROUND OF IDO
        uint maxValue;
        uint minValue;
        uint tokenRateToEth;
        bool active;
    }

    

    mapping(address => bool) public Admins;
    mapping(uint => round) public Rounds;

    mapping(address => mapping(uint => uint)) public Users; // 100000
    mapping(address => uint) public UsersTotalValue;

    modifier onlyAdmin() {
        require(Admins[msg.sender] == true, "Only admins");
        _;
    }

    
    function addRound(uint _start, 
                      uint _end, 
                      uint _roundValue,
                      uint _maxValue,
                      uint _minValue,
                      uint _tokenRateToEth) public onlyAdmin {
        require(currentRoundID == 0, "Only one round");
        RoundID += 1;
        Rounds[RoundID].start = _start;
        Rounds[RoundID].end = _end;
        Rounds[RoundID].roundValue = _roundValue;
        Rounds[RoundID].maxValue = _maxValue;
        Rounds[RoundID].minValue = _minValue;
        Rounds[RoundID].tokenRateToEth = _tokenRateToEth;
        Rounds[RoundID].active = true;
    }

    function closeRound(uint _round_id) public onlyAdmin {
        currentRoundID = 0;
        Rounds[_round_id].active = false;
    }
 
    function getEthersForIDO() public payable {
         require(block.timestamp > Rounds[currentRoundID].start, "Active after start");
         require(Rounds[currentRoundID].end > block.timestamp, "Before end only");
         require(Rounds[currentRoundID].active == true, "Not active round");
         require(Rounds[currentRoundID].maxValue > msg.value, "Max Limit");
         require(Rounds[currentRoundID].minValue < msg.value, "Min Limit");
         uint _value = msg.value * Rounds[currentRoundID].tokenRateToEth;
         IERC20 _token = IERC20(IDOTokenAddress);
         _token.mint(msg.sender, _value);
         withdrawAddress.transfer(msg.value);
         emit BuyIDOToken(msg.sender, msg.value);
    }


}