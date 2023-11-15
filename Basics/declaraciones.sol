/*Variables de estado, eventos, enumeradores, tipos de estructura, funciones y funciones con modificadores de acceso

Variables de estado son las que controlan el estado de contrato. Pueden ser cualquier tipo de dato comun como entero,
dobles, string. Algunos estados piden ciertos tipos de variables. Pueden ser declaradas implicitamente o explicitamente.

Eventos es un miembro del contrato por la cual la VM interactua para propagarse en la blockchain que lanza un callback
para poder ser atrapado

Enumeradores son solo la definicion de un cierto numero de valores que son customizados

Tipos de estructura son un set de variables y generalmente son de diferente tipo entre ellas mismas

Funciones encapsulan la logica en cierto bloque de codigo

Modificadores de funciones permiten modificar el comportamiento de la funcion, para restringir ciertas entradas o llamados a la
funcion. Un contrato puede declarar N modificadores */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
abstract contract AuthorizedToken{
    //Enumeradores
    enum UserType{
        TokenHolder, Admin, Owner
    }

    //Estructuras
    struct AccountInfo {
        address account;
        string firstName;
        string lastName;
        UserType userType;
    }

    //Mapas & variables de estado
    mapping(address => uint) public tokenBalance;
    mapping(address => AccountInfo) public registeredAccount;
    mapping(address => bool) public frozenAccount;

    address public owner;
    uint256 public constant maxTransferLimit = 1500;

    //Eventos
    event Transfer(address from, address to, uint256 ammount);
    event FrozenAccount(address target, bool frozen);

    //Modificadores de acceso
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //Constructores
    constructor (uint256 _initialSupply) {
        owner = msg.sender;
        mintToken(owner, _initialSupply);
    }

    //returns(<tipo_dato>)
    function checkLimit(uint256 _ammount) private pure returns(bool) {
        return _ammount <= maxTransferLimit;
    }

    function transfer(address _to, uint256 _ammount) public {
        require(checkLimit(_ammount));
        emit Transfer(msg.sender, _to, _ammount);
    }

    function mintToken(address _recipient, uint256 _mintedAmmount) public onlyOwner {
        tokenBalance[_recipient] += _mintedAmmount;
        emit Transfer(owner, _recipient, _mintedAmmount);
    }

    //Los strings se guardan con la ps memory
    function registerAccount(address account, bool isAdmin, string memory firstname, string memory lastname) public onlyOwner {

    }

    function validateAccount(address _account) internal view returns(bool){
        return frozenAccount[_account] && tokenBalance[_account] > 0;
    }

    function frozeAccount(address _account, bool freeze) onlyOwner public {
        frozenAccount[_account] = freeze;
        emit FrozenAccount(_account, freeze);
    }

}