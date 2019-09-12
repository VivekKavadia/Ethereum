pragma solidity ^0.5.0;

//Contract to create and store KYC requests for customers

contract KnowYourCustomer {
     /*----------------- Structures -----------------*/

     //Structure to store customer information
     struct Customer {
          string name;
          string data;
          address bankEthAddress; //Address of bank which initiated KYC request
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
          address bankEthAddress;
     }

     //Structure to store admin users
     struct AdminUser {
          address adminUserAddress;
     }

     /*----------------- Mappings -----------------*/

     mapping(string => Customer) customers;  //List of customers
     mapping(address => Bank) banks;         //List of banks
     mapping(string => KYC) requestKYC;      //List of all KYC requests
     mapping(address => AdminUser) adminUsers;   //List of admin users

     /*----------------- Modifiers -----------------*/

     //Use to check if user requesting the operation is an admin
     modifier isSenderAdmin(address _adminUserAddressArray) {
          if(adminUsers[_adminUserAddressArray].adminUserAddress == address(0)) {
               revert("1;Only admin users can perform this operation");
          }
          _;
     }

     //Use to check if bank does not exist
     modifier doesBankExist(address _bankEthAddress) {
          if(bytes(banks[_bankEthAddress].name).length > 0) {
               revert("1;Bank already exists");
          }
          _;
     }

     //Adds KYC request to blockchain
     function addKYCRequest(string memory _customerName) public {
          if(requestKYC[_customerName].bankEthAddress > address(0)) {
               revert("KYC request for this customer already exists");
          }
          //KYC request for this customer does not exist so creating it
          requestKYC[_customerName].customerName = _customerName;
          requestKYC[_customerName].bankEthAddress = msg.sender;
     }

     //Adds customer to blockchain
     function addCustomer(string memory _customerName, string memory _dataHash) public returns(uint) {
          if(bytes(_customerName).length > 0 && bytes(_dataHash).length > 0) {
               //Customer does not exist so adding to blockchain
               customers[_customerName].name = _customerName;
               customers[_customerName].data = _dataHash;
               customers[_customerName].bankEthAddress = msg.sender;
               return 0;   //return success
          }
        
          return 1;
     }

     //Adds bank to blockchain
     //Validates that sender of request is admin user
     function addBank(string memory _bankName, address _bankEthAddress, string memory _regNumber)
               isSenderAdmin(msg.sender) doesBankExist(_bankEthAddress)
               public returns(bool) {
          if(bytes(_bankName).length > 0 && bytes(_regNumber).length > 0) {
               //Bank not found in blockchain so adding
               banks[_bankEthAddress].name = _bankName;
               banks[_bankEthAddress].ethAddress = _bankEthAddress;
               banks[_bankEthAddress].registrationNumber = _regNumber;

               return true;        //return success
          } else {
               return false;       //return failure
          }
     }
}
