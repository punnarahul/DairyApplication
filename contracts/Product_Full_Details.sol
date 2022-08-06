pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


import './Processes.sol';
import './Stakeholders.sol';

contract Product_Full_Details{

    struct Product {
        uint id;
        string name;
        uint quantity;
        string description;
        uint numberoftraces;
        uint numberoftemperatures;
	    string test_number;


        //all these are tabulated 
        uint [] temperatures;
        uint [] processes_involved;
        address [] stakeholders_involved; 
        uint [] timestamps;
        string [] locations;
        string globalId; 
    }

    //All instance varibles

    struct stakeholder {
        address addressstake;
        string staketype;
    }

    mapping(uint => Product) public products; 
    stakeholder[] stakeholderlist;





    function registerStakeholder(string memory stakeholdertype) public {
        stakeholderlist.push(stakeholder(msg.sender,stakeholdertype));
    }

     function getStakeHolderList() public view returns(stakeholder [] memory){
         return stakeholderlist;    
    }




    uint public productsCount;

    // Just to know the statistics
    uint public globalnumberstakeholders;
    uint public globalnumberProcesses;



    //Only to be called by manufactuerer
    //he should provide the quantity, his id , place, temperature
    //we anyways deploy backend we also send addrs
    function addProductManufacturer (string memory _name, uint _quantity, string memory _description, string memory _globalID,uint temp,string memory place,address addr) public {
        Stakeholders s = Stakeholders(addr);
        bool ex=s.isManufacturer(msg.sender);
        require(ex);
        productsCount++; 
        s.addStakeholderProduct(productsCount,msg.sender);
        
        products[productsCount].id = productsCount; 
        products[productsCount].name = _name;
        products[productsCount].quantity = _quantity;
        products[productsCount].description = _description;
        products[productsCount].globalId = _globalID;
        products[productsCount].temperatures.push(temp);
        products[productsCount].stakeholders_involved.push(msg.sender);
        products[productsCount].timestamps.push(now);
        products[productsCount].locations.push(place);
    }
    
    
    function addProductDistributer (uint temp,uint pid,string memory place,address addr) public restricted(pid) {
        Stakeholders s = Stakeholders(addr);
        bool ex=s.isDistributer(msg.sender);
        require(ex);
        s.addStakeholderProduct(pid,msg.sender);
        products[pid].temperatures.push(temp);
        products[pid].stakeholders_involved.push(msg.sender);
        products[pid].timestamps.push(now);
        products[pid].locations.push(place);
    } 


    function addProductRetailer (uint pid,uint temp,string memory place,address addr) public restricted(pid) {
        Stakeholders s = Stakeholders(addr);
        bool ex=s.isRetailer(msg.sender);
        require(ex);
        s.addStakeholderProduct(pid,msg.sender);
        products[pid].temperatures.push(temp);
        products[pid].stakeholders_involved.push(msg.sender);
        products[pid].timestamps.push(now);
        products[pid].locations.push(place);
    }


    function addProductProcessInvolved(uint processid,uint productid) public{
        products[productid].processes_involved.push(processid);
    }
    


    //Adding the microscope tests
    function addTestProduct (uint _productId, string memory _test_number) public { 
        require(_productId > 0 && _productId <= productsCount); 
        products[_productId].test_number = _test_number; 
    }


    function getNumberOfProducts () public view returns (uint){
        return productsCount;
    }

    function UpdateProductDescription (uint _productId, string memory _description) public { 
        require(_productId > 0 && _productId <= productsCount); 
        products[_productId].description = _description;  
    }



    function concatenate(string memory a,string memory b) private pure returns (string memory){
        return string(abi.encodePacked(a,' ',b));
    } 

            

    function getProductFullDetails (uint _productId) public view returns (string memory) {    
        string memory r="";
        r=concatenate(r,products[_productId].name);
        r=concatenate(r,":");
        r=concatenate(r,uint2str(products[_productId].quantity));
        r=concatenate(r,":");
        r=concatenate(r,uint2str(products[_productId].temperatures[0]));
        r=concatenate(r,":");
        r=concatenate(r,uint2str(products[_productId].temperatures[1]));
        r=concatenate(r,":");
        r=concatenate(r,uint2str(products[_productId].temperatures[2]));
        
        r=concatenate(r,":");
        r=concatenate(r,(products[_productId].locations[0]));
        r=concatenate(r,":");
        r=concatenate(r,(products[_productId].locations[1]));
        r=concatenate(r,":");
        r=concatenate(r,(products[_productId].locations[2]));

        
        r=concatenate(r,":");
        r=concatenate(r,uint2str(products[_productId].timestamps[0]));
        r=concatenate(r,":");
        r=concatenate(r,uint2str(products[_productId].timestamps[1]));
        r=concatenate(r,":");
        r=concatenate(r,uint2str(products[_productId].timestamps[2]));


        return r;
    }

    function getProductGlobalID (uint _productId) public view returns (string memory) {
        require(_productId > 0 && _productId <= productsCount); 

        return products[_productId].globalId;
    }

    function getProductTest (uint _productId) public view returns (string memory) {
        require(_productId > 0 && _productId <= productsCount); 

        return products[_productId].test_number;
    }

    function updateNumberOfProcesses (address addr) public {
        
        Processes p = Processes(addr);
        globalnumberProcesses=p.getNumberOfProcesses();    
    }


   function updateNumberOfStakeholders (address addr) public {
        
        Stakeholders s = Stakeholders(addr);
        globalnumberstakeholders=s.getNumberOfStakeholders();
        
    }

    function checkStakeholder (address addr, address stake) public view returns (bool){
        Stakeholders s = Stakeholders(addr);
        bool ex=s.exists(stake);
        return ex;
    }
    

    //*********************
    //utility functions
    //*********************


    modifier restricted(uint _productId){
        require(_productId > 0 && _productId <= productsCount);
        _;
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
}


