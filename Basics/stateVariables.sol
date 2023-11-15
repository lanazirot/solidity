// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * 
 * Mantienen el estado del contrato, por lo que modifica la blockchain
 * 
 * Si es public, el compiler genera una funcion getter/setter, y eso lo
 * modifica por cada variable de estado que es publica
 * 
 * Si es interna, el contrato y los contratos que deriven de ese
 * contrato, pueden acceder a los contratos privados
 * 
 * Si es privada, solo el mismo contrato
 */

abstract contract StateVariables {

    mapping (address => bool) private frozzenAccounts;
    uint ContractLock; //Interno por default
    mapping (address=>bool) public tokenBalance;

    uint constant maxToken = 100_000;
    string constant contractVersion = "0.8.20";

    bytes32 constant contractHash = keccak256(bytes(contractVersion));

    constructor() {
        
    }
}