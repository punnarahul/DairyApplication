pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Product_Full_Details.sol';
import './Stakeholders.sol';



contract Processes{

    struct Process {
        uint id; // 
	    string name;       
        uint timestamp; // when it was registered
        string description; // other info
	    bool active;
        address maker; // who registered it and will execute it,stakeholder
	    uint [] involvedproducts; // id of products that use this process

    }

    mapping(uint => Process) private processChanges; //

    
    uint public productsCount;
    uint public processCount;

    
    function addProcess (string memory _name, string memory _description,address addr) public restricted(addr) {

        processCount++;

        processChanges[processCount].id = processCount;
        processChanges[processCount].name = _name; 
        processChanges[processCount].timestamp = now; 
        processChanges[processCount].description = _description; 
        processChanges[processCount].active = true; 
        processChanges[processCount].maker = msg.sender;
    
    }



    //_id is the product id
    //processid is the processsone
    //addr1 is address of the stakeholder instance
    //addr2 is addresss of the Product full details instance
    function addProcessesProduct(uint processid,uint _id,address addr1,address addr2) public restricted(addr1) { 
        processChanges[processid].involvedproducts.push(_id);
        Product_Full_Details p = Product_Full_Details(addr2);
        p.addProductProcessInvolved(processid,_id);
    }


    //stakeholder contract address
    function changeStatus (address addr,uint _id, bool _active) public restricted(addr) { 
        require(_id > 0 && _id <= processCount); 
        processChanges[processCount].active = _active;
    }
    
    function getProcessesProduct (uint _id) public view returns (uint [] memory)  {
        require(_id > 0 && _id <= processCount); 
        return processChanges[_id].involvedproducts;
    }


    function getProcess (uint _processId) public view returns (Process memory)  {
        require(_processId > 0 && _processId <= processCount); 
       //require(Processes.checkStakeholder(address addr, msg.sender)==true); // if valid stakeholder    
        return processChanges[_processId];
    }
    
    // returns global number of stories, needed to iterate the mapping and to know info.
    function getNumberOfProcesses () public view returns (uint){
    //tx.origin 
        return processCount;
    }
    function concatenate(string memory a,string memory b) private pure returns (string memory){
        return string(abi.encodePacked(a,' ',b));
    } 

    function getProcessDetails (uint _processId) public view returns (string memory){
        require(_processId > 0 && _processId <= processCount); 
        string memory r = "";
        r = concatenate(r,"ProcessName: ");
        r = concatenate(r,processChanges[_processId].name);
        r = concatenate(r,"ProcessDescription: ");
        r = concatenate(r,processChanges[_processId].description);
        r = concatenate(r,"Processtimestamp: ");
        r = concatenate(r,uint2str(processChanges[_processId].timestamp));
        return r;
 }
    

    //This function has no use here
    // function checkStakeholder (address addr, address stake) public view returns (bool){
    //     Stakeholders s = Stakeholders(addr);
    //     bool ex=s.exists(stake);
    //     return ex;
    // }

    function updateNumberOfProducts (address addr) public {
        Product_Full_Details f = Product_Full_Details(addr);
        productsCount =f.getNumberOfProducts(); 
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
            if (_i == 0) {
                return "0";
            }
            uint j = _i;
            uint len;
            while (j != 0) {
                len++;
                j /= 10;
            }
            bytes memory bstr = new bytes(len);
            uint k = len;
            while (_i != 0) {
                k = k-1;
                uint8 temp = (48 + uint8(_i - _i / 10 * 10));
                bytes1 b1 = bytes1(temp);
                bstr[k] = b1;
                _i /= 10;
            }
            return string(bstr);
        }


    modifier restricted(address addr){
        Stakeholders s = Stakeholders(addr);
        bool ex=s.isManufacturer(msg.sender);
        require(ex);
        _;
    }
    
}