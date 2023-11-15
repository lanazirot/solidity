// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Funciones {
    function process(int _x, int _y, int _z, bool _flag) public {

    }

    //Es solo la firma del metodo, necesita sobreescribirse
    function anotherProcess(int x, int, int) public {

    }

    function multipleReturn(int x, int y) public pure returns (int a,int b){
        a = x+y;
        b = x*y;
    }   
}

contract GammaCalculator {
    function calculateGamma(int _y, int _z) external pure returns(int){
        return _y*3 + 7 * _z;
    }
}


contract TaxCalculator {
    GammaCalculator calculator;

    function tax(address _gammaAddress) public{
        calculator = GammaCalculator(_gammaAddress);
    }

    function calculate(int _x, int _y, int _z) public view returns(int){
        //Esto se considera una TX
        return _x + calculator.calculateGamma(_y, _z);
    }
}