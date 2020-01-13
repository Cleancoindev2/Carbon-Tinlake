// Copyright (C) 2019 Centrifuge
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
pragma solidity >=0.4.24;
import "ds-test/test.sol";

contract TrancheMock is DSTest {
    mapping (bytes32 => uint) calls;
    mapping (bytes32 => uint) returnValues;
    function setReturn(bytes32 name, uint returnValue) public {
        returnValues[name] = returnValue;
    }
    function call(bytes32 name) internal returns (uint) {
        calls[name]++;
        return returnValues[name];
    }
    function debt() public returns (uint) {
        return call("debt");
    }
    function balance() public returns (uint) {
        return call("balance");
    }
    function tokenSupply() public returns (uint) {
        return call("tokenSupply");
    }
}