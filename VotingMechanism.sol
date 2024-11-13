// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VotingMechanism {
    // Mapping of candidates to vote counts
    mapping (address => uint256) public votes;
    
    // Flag indicating whether voting is paused or not
    bool public votingPaused = false;
    
    // Owner address for pausing/resuming functions
    address private ownerAddress;
    
    constructor() payable {
        ownerAddress = msg.sender; // Set the deployer as the initial owner
    }
    
    /**
     * Function to pause all votes and updates.
     */
    function pauseVoting() public onlyOwner {
        votingPaused = true;
    }
    
    /**
     * Function to resume normal voting operations.
     */
    function resumeVoting() public onlyOwner {
        require(votingPaused, "Cannot resume when not paused");
        votingPaused = false;
    }
    
    /**
     * Allows users to vote for a candidate by sending Ether.
     * @param _candidate The address of the chosen candidate
     */
    function castVote(address _candidate) external payable {
        // Check if voting is currently paused and revert if so
        require(!votingPaused, "Voting has been temporarily halted");
        
        votes[_candidate] += msg.value; // Update vote count for the selected candidate
        
        emit VoteCast(_candidate);
    }
    
    /**
     * OnlyOwner modifier function to restrict access.
     */
    modifier onlyOwner {
        require(msg.sender == ownerAddress, "Only authorized owners can perform this action");
        _;
    }

    event VoteCast(address indexed candidate); // Emitted when a vote is cast
}
