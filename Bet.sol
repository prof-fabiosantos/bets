/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Bet {
        
    address public owner;
    uint256 public totalBetValue;
    uint256 public totalBetAmount;
       
    struct Player {        
        address addressPlayer;
        uint256 scoreTeam1;
        uint256 scoreTeam2;
        uint256 betValue;
    }  

    Player[] public playerBets;
      
    modifier isOwner() {
        require(msg.sender == owner, "Somente o owner pode chamar esse metodo!");
        _;
    }
    
    event Winner(address indexed addressPlayer, uint256 valueToPay);

    constructor () {
        owner = msg.sender; 
        totalBetValue = 0;
        totalBetAmount = 0;      
    }

   function bet(uint256 _scoreTeam1, uint256 _scoreTeam2) public payable {
        
        totalBetAmount++; 
        uint256 betValue = msg.value;
        console.log("Valor apostado:", betValue);            
        playerBets.push(Player(msg.sender,_scoreTeam1,_scoreTeam2, betValue));

        totalBetValue += betValue;
        console.log("Valor total apostado:", totalBetValue);
    }
        

    function payWinners(uint256 _scoreTeam1, uint256 _scoreTeam2) public isOwner {                  

        for (uint i=0; i < playerBets.length; i++) {
            if (playerBets[i].scoreTeam1 == _scoreTeam1 && playerBets[i].scoreTeam2 == _scoreTeam2){
                uint256 valueToPay = playerBets[i].betValue + (playerBets[i].betValue / totalBetValue) * totalBetValue;                   
                payable(playerBets[i].addressPlayer).transfer(valueToPay);
                emit Winner(playerBets[i].addressPlayer,valueToPay); 
            }
        }                      
    }
}