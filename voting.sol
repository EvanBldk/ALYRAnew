// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Voting is Ownable{

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }
    struct Proposal {
        string description;
        uint voteCount;
    }
    
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    
    WorkflowStatus status = WorkflowStatus.RegisteringVoters;

    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

    mapping(address => Voter) public Voters;

    
    function registerVoters(address voterAddress) public onlyOwner {
        require( WorkflowStatus status = WorkflowStatus.RegisteringVoters);
        (Voters[voterAddress]).isRegistered = true;
        (Voters[voterAddress]).hasVoted = false;
        (Voters[voterAddress]).votedProposalId = 0;
        emit VoterRegistered(voterAddress);
    }
    
    function startProposalRegistration() public Ownable{
            WorkflowStatus status = WorkflowStatus.ProposalsRegistrationStarted;
            event WorkflowStatusChange(WorkflowStatus RegisteringVoters, WorkflowStatus ProposalsRegistrationStarted);

    }
    
    proposalId[] proposals;
    
    function registerProposal(string _description, uint _voteCount) public {
            
            
            event ProposalRegistered(uint proposalId);

    }

}