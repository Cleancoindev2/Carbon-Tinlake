// Copyright (C) 2020 Centrifuge

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity >=0.5.3;

import "../base_system.sol";

contract IssueTest is BaseSystemTest {

    function setUp() public {
        bytes32 juniorOperator_ = "whitelist";
        bytes32 distributor_ = "default";
        baseSetup(juniorOperator_, distributor_, false);
        createTestUsers(false);
    }

    function issueLoan(uint tokenId, bytes32 lookupId) public {
        uint loanId = borrower.issue(collateralNFT_, tokenId);
        assertPostCondition(loanId, tokenId, lookupId);
    }

    function assertPreCondition(uint tokenId, bytes32 lookupId) public {
        // assert: borrower = nftOwner
        assertEq(collateralNFT.ownerOf(tokenId), borrower_);
        // assert: nft not used for other loan
        assertEq(shelf.nftlookup(lookupId), 0);
    }

    function assertPostCondition(uint loanId, uint tokenId, bytes32 lookupId) public {
        // assert: nft + loan added to nftlookup
        assertEq(shelf.nftlookup(lookupId), loanId);
        // assert: borrower = loanOwner
        assertEq(title.ownerOf(loanId), borrower_);
        // assert: borrower still nftOwner
        assertEq(collateralNFT.ownerOf(tokenId), borrower_);
    }

    function testIssueLoan() public {
        (uint tokenId, bytes32 lookupId) = issueNFT(borrower_);
        assertPreCondition(tokenId, lookupId);
        issueLoan(tokenId, lookupId); 
    }

    function testFailIssueMultipleLoansForOneNFT() public {
        (uint tokenId, bytes32 lookupId) = issueNFT(borrower_);
        issueLoan(tokenId, lookupId); 

        // issue second loan against same nft
        uint secondLoanId = borrower.issue(collateralNFT_, tokenId);
        assertPostCondition(secondLoanId, tokenId, lookupId);
    }

    function testFailIssueLoanNotNFTOwner() public {
        // issue nft for random user -> borrower != nftOwner
        (uint tokenId, bytes32 lookupId) = issueNFT(randomUser_);
        issueLoan(tokenId, lookupId); 
    }
}
