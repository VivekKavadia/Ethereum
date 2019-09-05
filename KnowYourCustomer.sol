pragma solidity ^0.5.0;

//Contract to create and store KYC requests for customers

contract KnowYourCustomer {
    //Structure to store customer information
    struct Customer {
        string name;
        string data;
        address bankAddress; //Address of bank which initiated KYC request
    }
    
    //Structure to store bank information
    struct Bank {
        string name;
        address ethAddress;
        string registrationNumber;
    }
    
    //Structure to store KYC information
    struct KYC {
        string customerName;
        address bankAddress;
    }
    
    mapping(string => Customer) customers;  //List of customers
    mapping(address => Bank) banks;         //List of banks
    mapping(string => KYC) requestKYC;      //List of all KYC requests
    
    //Adds KYC request to blockchain
    function addKYCRequest(string memory _customerName) public {
        if(requestKYC[_customerName].bankAddress > address(0)) {
            revert("KYC request for this customer already exists");
        }
        //KYC request for this customer does not exist so creating it
        requestKYC[_customerName].customerName = _customerName;
        requestKYC[_customerName].bankAddress = msg.sender;
    }
}