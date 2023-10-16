// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface ISocial {
    /**
     * @notice Creates a new character.
     * @param handle The handle of the character.
     * @param name The name of the character.
     * @param bio The bio of the character.
     * @param avatarUrl The avatarUrl of the character.
     * @return characterId The id of the character.
     */
    function createCharacter(
        string calldata handle,
        string calldata name,
        string calldata bio,
        string calldata avatarUrl
    ) external returns (uint256 characterId);

    /**
     * @notice Updates a character.
     * @param characterId The id of the character.
     * @param handle The handle of the character.
     * @param name The name of the character.
     * @param bio The bio of the character.
     * @param avatarUrl The avatarUrl of the character.
     */
    function updateCharacter(
        uint256 characterId,
        string calldata handle,
        string calldata name,
        string calldata bio,
        string calldata avatarUrl
    ) external;

    /**
     * @notice Deletes a character.
     * @param characterId The id of the character.
     */
    function deleteCharacter(uint256 characterId) external;

    /**
     * @notice Creates a new post.
     * @param characterId The id of the character.
     * @param title The title of the post.
     * @param content The content of the post.
     * @return postId The id of the post.
     */
    function createPost(
        uint256 characterId,
        string calldata title,
        string calldata content
    ) external returns (uint256 postId);

    /**
     * @notice Updates a post.
     * @param characterId The id of the character.
     * @param postId The id of the post.
     * @param title The title of the post.
     * @param content The content of the post.
     */
    function updatePost(
        uint256 characterId,
        uint256 postId,
        string calldata title,
        string calldata content
    ) external;

    /**
     * @notice Deletes a post.
     * @param characterId The id of the character.
     * @param postId The id of the post.
     */
    function deletePost(uint256 characterId, uint256 postId) external;

    /**
     * @notice Creates a new comment.
     * @param characterId The id of the character.
     * @param postId The id of the post.
     * @param content The content of the comment.
     * @return commentId The id of the comment.
     */
    function createComment(
        uint256 characterId,
        uint256 postId,
        string calldata content
    ) external returns (uint256 commentId);

    /**
     * @notice Updates a comment.
     * @param characterId The id of the character.
     * @param postId The id of the post.
     * @param commentId The id of the comment.
     * @param content The content of the comment.
     */
    function updateComment(
        uint256 characterId,
        uint256 postId,
        uint256 commentId,
        string calldata content
    ) external;

    /**
     * @notice Deletes a comment.
     * @param characterId The id of the character.
     * @param postId The id of the post.
     * @param commentId The id of the comment.
     */
    function deleteComment(uint256 characterId, uint256 postId, uint256 commentId) external;

    /**
     * @notice Gets the character.
     * @param characterId The id of the character.
     * @return handle The handle of the character.
     * @return name The name of the character.
     * @return bio The bio of the character.
     * @return avatarUrl The avatarUrl of the character.
     */

    function getCharacter(
        uint256 characterId
    )
        external
        view
        returns (
            string memory handle,
            string memory name,
            string memory bio,
            string memory avatarUrl
        );

    /**
     * @notice Gets the post.
     * @param characterId The id of the character.
     * @param postId The id of the post.
     * @return title The title of the post.
     * @return content The content of the post.
     */
    function getPost(
        uint256 characterId,
        uint256 postId
    ) external view returns (string memory title, string memory content);

    /**
     * @notice Gets the comment.
     * @param characterId The id of the character.
     * @param postId The id of the post.
     * @param commentId The id of the comment.
     * @return content The content of the comment.
     */
    function getComment(
        uint256 characterId,
        uint256 postId,
        uint256 commentId
    ) external view returns (string memory content);
}
