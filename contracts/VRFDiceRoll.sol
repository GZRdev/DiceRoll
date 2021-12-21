// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract VRFDiceRoll is VRFConsumerBase {

    /* The below values have to be configured correctly for VRF requests to work. https://docs.chain.link/docs/vrf-contracts/
    LINK Token - LINK token address on the corresponding network (Ethereum, Polygon, BSC, etc)
    VRF Coordinator - address of the Chainlink VRF Coordinator
    Key Hash - public key against which randomness is generated
    Fee - fee required to fulfill a VRF request
    */

    /*
    * keyHash is a 64 digit hex string.
    * We use bytes 32 as the type for keyHash, because there are 8 bits in a byte.
    * 256 bits required for allocation.
    * 32 bytes * 8 bits in a byte = 256 bits.
    * 256 / 64(cus it's a 64 digit hex string) = 4
    * There are 4 bits per hex value (0-15) aka (0000 - 1111)
    * We have 64 total hex values so 64 * 4 bits per value = 256 bits
    * This is why we use bytes32 is my guess.
    * Also, bytes(1-32) uses less gas than string.
    */
    bytes32 internal keyHash;
    
    uint256 internal fee;

    uint256 public randomResult;

     /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */

    /*
    *constructor is inherited from VRFConsumerBase.
    *The first parameter is an address for the VRF coordinator.
    *The second parameter is an address for the LINK token.
    *Both parameters obtained from docs.chain.link website.
     */
    constructor() VRFConsumerBase(0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9, 0xa36085F69e2889c224210F603D836748e7dC0088) {
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
        /*
        *At this point, in the constructor, we've set
        *_vrfCoordinator address
        * LINK token address
        * keyHash (public key against which randomness generated)
        * fee
        */    
    }

    /**
    * Requests Randomness
    * Inherits the requestRandomness function from VRFConsumerBase
    * Inherits the makeRequestId function from VRFConsumerBase, which is inherited from VRFRequestIDBase
    */
    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");//Making sure this address has more LINK than the fee.
        return requestRandomness(keyHash, fee);
        /*
        * Basically, we return
        * keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
        * Which is the 'requestId' variable
        *
        *       _vRFInputSeed is uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
                    which is basically a 64 digit hex converted to a really big uint number
        * So 
        * bytes32 requestId is basically
        *   _keyHash
                which is basically a 64 digit length hex string,
        *   concatenated with
                uint256(64 digit length hex string + uint256'_userSeed' + address'_requester' + uint256'_nonce')
        *   After concatenation, this big long thing is converted into a 64 digit hex "string" of type bytes32, that acts as your requestId.
                It would look like 0xcA429582aC1eaB01B337b59E899D75242011702B or something like that.
        
        *TL;DR this function returns a requestId.
        */ 
    /**
    * Callback function used by VRF Coordinator
    */
    }
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;

        /*
        * Basically this function gives the requestId to the VRFCoordinator
        * VRFCoordinator then returns a random uint256 number to the variable 'randomness'
            We store the result in randomResult
        */
        
    }

    function rollDice() public view returns(uint256 roll){
        return roll = (randomResult % 6) + 1;
    }
    
    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
    
    /**
    function withdraw() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    ?

     */
    
    
    //will figure this out later
    /*   
    function withdrawLink() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    */


    /*
    *   Notes to self- for this to work, you have to create the contract
    *   Once the contract is created, you have to FUND the contract
    *   Like literally send funds TO the contract from your wallet so they are actually IN the contract.
    */

}