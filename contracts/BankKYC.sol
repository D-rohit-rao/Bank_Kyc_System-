// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.9 <=0.9.0;

contract BankKYC 
{
    address kycadmin;

    constructor() 
    {
        kycadmin = msg.sender;
    }

    modifier onlyadmin()
    {
        require(msg.sender == kycadmin, "Only admin can access this function");
        _;
    }

    struct bank_struct 
    {
        string bank_Name;
        address bank_address;
        uint256 KYCcount;
        bool CanAddCustomer;
        bool CanDoKYC;
    }

    struct customer_struct 
    {
        string customer_Name;
        string customer_data;
        address coustomer_Bank;
        bool KYC_status;
    }

    mapping(address => bank_struct) bankMap;
    mapping(string => customer_struct) customerMap;

    ////
     function Add_Bank(string memory bank_Name, address bank_address) public onlyadmin
    {
        bankMap[bank_address] = bank_struct(bank_Name, bank_address, 0, false, false);
    }

    ////
     function Add_Customer(string memory customer_Name, string memory customer_data) public
    {
        require(bankMap[msg.sender].CanAddCustomer, "This bank don't have permission to address new customers");
        customerMap[customer_Name] = customer_struct(customer_Name, customer_data, msg.sender, false);
    }
    
    ////
    function Perform_KYC(string memory customer_Name) public 
    {
        require(bankMap[msg.sender].CanDoKYC, "This bank don't have permission to o KYC");
        customerMap[customer_Name].KYC_status = true;
        bankMap[msg.sender].KYCcount++;
    }

    ////
    function Block_add_Customer(address bank_address) public onlyadmin
    {
        require(bankMap[bank_address].bank_address != address(0),   "oops!.....Bank not found");
        bankMap[bank_address].CanAddCustomer = false;
    }

    ////
    function Allow_add_Customer(address bank_address) public onlyadmin 
    {
        bankMap[bank_address].CanAddCustomer = true;
    }

    ////
    function Block_add_KYC(address bank_address) public onlyadmin 
    {
        bankMap[bank_address].CanDoKYC = false;
    }

    ////
    function Allow_add_KYC(address bank_address) public onlyadmin 
    {
        bankMap[bank_address].CanDoKYC = true;
    }

    ////
    function View_Customer_Details(string memory customer_Name) public view
        returns (string memory,string memory,bool)
    {
        return (
            customerMap[customer_Name].customer_Name,
            customerMap[customer_Name].customer_data,
            customerMap[customer_Name].KYC_status
        );
    }

    ////
    function View_Bank_Details(address bank_address) public view
        returns (string memory,address,uint256,bool,bool)
    {
        return (
            bankMap[bank_address].bank_Name,
            bankMap[bank_address].bank_address,
            bankMap[bank_address].KYCcount,
            bankMap[bank_address].CanAddCustomer,
            bankMap[bank_address].CanDoKYC
        );
    }
}
