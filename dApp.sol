pragma solidity >=0.7.0 < 0.9.0;
// SPDX-License-Identifier: MIT

contract Nebula { 
    struct KYC {
      uint256 customerID;
      string full_name;
      string profession;
      string Date_of_Birth;
      address wallet;
    }

    string public bank_name;
    string public bank_addess;

    uint number_of_accaounts=0;
    mapping(address => uint) account_balances;
    KYC[] records;
    mapping(address => KYC) accountInfo;

    modifier onlyRegistered(address SpecificAdress){
        require (accountInfo[SpecificAdress].customerID > 0, "not a Registered Account");
        _; 

    }


    function registerAccount( string memory full_name, string memory profession, string memory Date_of_Birth) payable external {
        require(accountInfo[msg.sender].customerID > 0, "This account exists");
        KYC memory newClient;
        newClient.profession = profession;
        newClient.full_name = full_name;
        newClient.wallet = msg.sender;
        newClient.Date_of_Birth = Date_of_Birth;
        number_of_accaounts += 1;    
        newClient.customerID = number_of_accaounts;
        accountInfo[msg.sender] = newClient;

    }

    function getAccountInfo(address userAddress) private view onlyRegistered(userAddress) returns (KYC memory) { 
        return accountInfo[userAddress];
    }

    function transfer(address newOwner, uint amount) onlyRegistered(newOwner) onlyRegistered(msg.sender) public {
     require(account_balances[msg.sender] >= amount, "pleas go get more money");
     account_balances[msg.sender] -= amount;
     account_balances[newOwner] += amount;

    }

    function withdraw(uint amount) public onlyRegistered(msg.sender) {
        require(account_balances[msg.sender] >= amount , "Insufficient funds");
        account_balances[msg.sender] -= amount;
        address payable destAddr = payable(msg.sender);
        destAddr.transfer(amount);
        
    }

    receive() payable external onlyRegistered(msg.sender) {
        account_balances[msg.sender] += msg.value;
        }
    

}

