// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

/// @dev Invalid Character Id
error Social__InValidCharacterId(uint256 characterId);
/// @dev Invalid Post Id
error Social__InValidPostId(uint256 postId);
/// @dev Invalid Comment Id
error Social__InValidCommentId(uint256 commentId);
/// @dev Not the owner of the character
error Social__NotCharacterOwner(uint256 characterId, address owner);
/// @dev No Operator Role
error Social__NoOperatorRole(address operator);
