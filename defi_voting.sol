// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Voting is Ownable{
    
    
    uint proposalId = 0 ;
    WorkflowStatus status = WorkflowStatus.NotStarted; 
    
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
        NotStarted,
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    
    mapping(address => Voter) public Voters;
    mapping(uint => Proposal) proposals;
    Proposal[] proposalsArray;
    
    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint indexed proposalId);
    event Voted (address voter, uint indexed proposalId);

    function SetRegisteringVoters()public onlyOwner{
        require(status == WorkflowStatus.NotStarted);
        status = WorkflowStatus.RegisteringVoters;
        emit WorkflowStatusChange( WorkflowStatus.NotStarted, WorkflowStatus.RegisteringVoters);
    } 
   
   function SetProposalsRegistrationStarted () public onlyOwner{
       require(status == WorkflowStatus.RegisteringVoters);
        status = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange( WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }
    
    function SetProposalsRegistrationEnded () public onlyOwner{
        require(status == WorkflowStatus.ProposalsRegistrationStarted);
        status = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange( WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }
    
    function SetVotingSessionStarted() public onlyOwner{
        require(status == WorkflowStatus.ProposalsRegistrationEnded);
        status = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange( WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }
    
    function SetVotingSessionEnded() public onlyOwner{
        require(status == WorkflowStatus.VotingSessionStarted);
        status = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange( WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }
    
    function SetVotesTallied() public onlyOwner{
        require(status == WorkflowStatus.VotingSessionEnded);
        status = WorkflowStatus.VotesTallied;
        emit WorkflowStatusChange( WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
    }
    
    function registerVoters(address voterAddress) public  onlyOwner{
        require( status == WorkflowStatus.RegisteringVoters,"registering voters ended"); 
        (Voters[voterAddress]).isRegistered = true;
        (Voters[voterAddress]).hasVoted = false;
        emit VoterRegistered(voterAddress);
    }
    
    function addProposal( string memory _description)public {
        require( status == WorkflowStatus.ProposalsRegistrationStarted);
        require((Voters[msg.sender]).isRegistered == true);
        proposalId++;
        proposals[proposalId] = Proposal(_description, 0);
        Proposal memory proposal ;
        proposal.description = _description;
        proposal.voteCount = 0;
        proposalsArray.push(proposal);
        emit ProposalRegistered( proposalId);
    }
    
    function vote (uint _proposalId)public { 
        require( status == WorkflowStatus.VotingSessionStarted,"Not the time for registering proposals");
        require((Voters[msg.sender]).isRegistered == true);
        require((Voters[msg.sender]).hasVoted == false);
        (proposals[_proposalId]).voteCount++;
        (Voters[msg.sender]).hasVoted = true;
        (Voters[msg.sender]).votedProposalId = _proposalId;
        proposalsArray[_proposalId - 1].voteCount++;
        emit Voted (msg.sender, _proposalId);
    }
    
    uint public winnerVoteCount ;
    string public winner;
    
    function sort_array() public   {
        uint256 l = proposalsArray.length;
        for(uint i = 0; i < l; i++) {
            for(uint j = i+1; j < l ;j++) {
                if((proposalsArray[i]).voteCount > (proposalsArray[j]).voteCount) {
                    Proposal memory temp = proposalsArray[i];
                    proposalsArray[i] = proposalsArray[j];
                    proposalsArray[j] = temp;
                }
            }
        }
     }
     
     function getwinner()public onlyOwner returns( Proposal memory){
        require( status == WorkflowStatus.VotingSessionEnded);
        sort_array();
        winnerVoteCount = (proposalsArray[(proposalsArray.length)-1]).voteCount;
        winner = (proposalsArray[(proposalsArray.length)-1]).description;
        return proposalsArray[(proposalsArray.length)-1];
     }
     

}    
