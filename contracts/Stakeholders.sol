pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;
 

import './Processes.sol';
import './Product_Full_Details.sol';



contract Stakeholders{
    struct Stakeholder{
        uint id; // id
        string stakeholderType;
        string name; // the name of stakeholder
        uint timestamp; // when it was registered
        uint [] involvedproducts; // products used or related to stakeholder
        string description; // other info
	    address myself; // the address of this stakeholder
        // address maker; // who registered this stakeholder, admin system
        bool active; // to enable or disable this stakeholder
    }

    address admin;

    mapping(address => Stakeholder) private stakeholderAddrs; 
    uint public stakeholderCount;


    constructor ()public {
        admin=msg.sender;
    }


    //_stake is the address of the stakeholder who is going to be added
    function addStakeholder (string memory _name,  string memory _description, address _stake,string memory stakeholdertype) public {

        //&& (stakeholdertype== 'MANUFACTURER' || stakeholdertype=='DISTRIBUTER' || stakeholdertype=='RETAILER')

        require(admin==msg.sender );
        stakeholderCount++;
        stakeholderAddrs[_stake].id = stakeholderCount;
        stakeholderAddrs[_stake].name = _name; 
        stakeholderAddrs[_stake].timestamp = now; 
        stakeholderAddrs[_stake].description = _description;
        stakeholderAddrs[_stake].myself = _stake; 
        stakeholderAddrs[_stake].stakeholderType=stakeholdertype; 
        stakeholderAddrs[_stake].active = true; 
    }



    function isManufacturer(address addr) public view returns (bool){
        string memory y="Manufacturer";
        return keccak256(abi.encode(stakeholderAddrs[addr].stakeholderType)) == keccak256(abi.encode(y));
    }
    function isDistributer(address addr) public view returns (bool){
        string memory y="Distributer";
        return keccak256(abi.encode(stakeholderAddrs[addr].stakeholderType)) == keccak256(abi.encode(y));
    }
    function isRetailer(address addr) public view returns (bool){
        string memory y="Retailer";
        return keccak256(abi.encode(stakeholderAddrs[addr].stakeholderType)) == keccak256(abi.encode(y));
    }



    function addStakeholderProduct(uint _id, address _stake) public { 
        stakeholderAddrs[_stake].involvedproducts.push(_id); 
    }

    function changeStatus (bool _active, address _stake) public {
        require(exists(_stake)==true);
        stakeholderAddrs[_stake].active = _active;
    }


    //require statements 
    function getStakeholdersProduct (address _stake) public view returns (uint [] memory)  {
        return stakeholderAddrs[_stake].involvedproducts;
    }


    function getStakeholder (address _stake) public view returns (Stakeholder memory)  {


        return stakeholderAddrs[_stake];
    }

     function getStakeholdername (address _stake) public view returns (string memory)  {


        return stakeholderAddrs[_stake].name;
    }

     function getStakeholdertype (address _stake) public view returns (string memory)  {


        return stakeholderAddrs[_stake].stakeholderType;
    }

    function getStakeholderdesc (address _stake) public view returns (string memory)  {


        return stakeholderAddrs[_stake].description;
    }
    
    function getNumberOfStakeholders () public view returns (uint){    
        return stakeholderCount;
    }

    function exists(address _stake) public view returns (bool){
        if(stakeholderAddrs[_stake].active == true){
            return true;
        }
        return false;
    }
    function concatenate(string memory a,string memory b) private pure returns (string memory){
        return string(abi.encodePacked(a,' ',b));
    } 

    function getFullStakeholdersDetails(address[] memory arr) public view returns(string memory){
        string memory r="";
         for (uint i=0; i<arr.length; i++) {
            string memory temp1=stakeholderAddrs[arr[i]].name;
            string memory temp2=stakeholderAddrs[arr[i]].description;
            
            r=concatenate(r,temp1);
            r=concatenate(r,temp2);
         }

        return r;
    }

}




