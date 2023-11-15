// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Tipos de variables

abstract contract VariablesContract {
    constructor() {}

    //Booleanos
    bool constant isComplete = true;

    //Numeros
    int256 bigNumber = 10000000000;
    int32  mediumNumber = -30000;
    uint16 smallUnsignedInt = 30;
    uint16 smallPositiveNumber = 3;
    int64 newMediumNumber = mediumNumber;
    uint32 newSmallNumber = smallPositiveNumber;
    int16 public newOtherSmallNumber = int16(bigNumber); 

    //Address
    address ownerAddress = 0x380c8e5c915db7174314A10D247F68e82a471823;

    function getOwnerBalance( ) public view returns (uint) {
        uint balance = ownerAddress.balance;
        return balance;
    }

    //Funciones para address
    //transfer -> sender, to, ammount in wei if error, will rollback the transaction
    //send -> transfer, but if error, won't rollback
    //call -> invoke members in blockchain

    //ownerAddress.transfer(10), etc.abi

    //Enums

    enum InvestmentLevel{High,Medium,Low}
    InvestmentLevel level = InvestmentLevel.Medium;

    uint levelValue = uint(level);

    uint [] storageArray;

    function f(uint[] storage garray) internal {}
    function h(uint[] memory harray) internal {}


    //Si lo declaro sin tipo, marca error. Arrays y strings me piden declarar storage o memory
    function i(uint[] calldata array) internal {}

    //Variable de estado -> modifica la blockchain


    //Arrays
    //Estaticos
    uint[] q = new uint[](7);
    int32[5] fixedSlots = [int32(5),9,1,2,3];
    int32[] unlimited;

    function fun() public {
        uint[] memory a = new uint[](7);
        a[6] = 8;
        unlimited.push(10);
    }

    //Strings
    string name = "Hola";

    //Struct
    //Tipo definido por el usuario de diferentes tipos

    enum MajorityType { Simple, Absolute, Super, unamity}

    struct VotingSesion{
        uint sessionId;
        string descripcion;
        MajorityType majority;
        uint8 majorityPercent;
        mapping (address=> uint) votes;
    }

    struct Name {
        int hola;
    }


    //Mapas
    //Apunta a cierta locacion de almacen en base a los dos tipos de referencia que le indquemos
    mapping (address => uint) public values;
    uint missingAddress = values[ownerAddress];
}

