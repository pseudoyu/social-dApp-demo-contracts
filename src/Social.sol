// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./interfaces/ISocial.sol";
import {
    Social__InValidCharacterId,
    Social__InValidPostId,
    Social__InValidCommentId
} from "./Error.sol";

/**
 * @title Social Contract
 * @notice This contract is used for social media interactions
 * @dev This contract is only a demo version for the core functionality of Crossbell Contracts
 */
contract Social is ISocial {
    struct Character {
        address owner;
        uint256 id;
        string handle;
        string name;
        string bio;
        string avatarUrl;
    }

    struct Post {
        uint256 characterId;
        uint256 id;
        string title;
        string content;
    }

    struct Comment {
        uint256 postId;
        uint256 id;
        string content;
    }

    uint256 internal _characterIdIndex;
    mapping(uint256 => uint256) internal _postIdIndex;
    mapping(uint256 => mapping(uint256 => uint256)) internal _commentIdIndex;

    mapping(uint256 => Character) internal _characters;
    mapping(uint256 => mapping(uint256 => Post)) internal _posts;
    mapping(uint256 => mapping(uint256 => mapping(uint256 => Comment))) internal _comments;

    // events
    /*
     * @dev This event is emitted when a character is created
     * @param owner The owner of the character
     * @param characterId The id of the character
     */
    event CharacterCreated(address indexed owner, uint256 indexed characterId);

    /*
     * @dev This event is emitted when a character is updated
     * @param owner The owner of the character
     * @param characterId The id of the character
     */
    event CharacterUpdated(address indexed owner, uint256 indexed characterId);

    /*
     * @dev This event is emitted when a character is deleted
     * @param owner The owner of the character
     * @param characterId The id of the character
     */
    event CharacterDeleted(address indexed owner, uint256 indexed characterId);

    /*
     * @dev This event is emitted when a post is created
     * @param owner The owner of the character
     * @param characterId The id of the character
     * @param postId The id of the post
     */
    event PostCreated(address indexed owner, uint256 indexed characterId, uint256 indexed postId);

    /*
     * @dev This event is emitted when a post is updated
     * @param owner The owner of the character
     * @param characterId The id of the character
     * @param postId The id of the post
     */
    event PostUpdated(address indexed owner, uint256 indexed characterId, uint256 indexed postId);

    /*
     * @dev This event is emitted when a post is deleted
     * @param owner The owner of the character
     * @param characterId The id of the character
     * @param postId The id of the post
     */
    event PostDeleted(address indexed owner, uint256 indexed characterId, uint256 indexed postId);

    /*
     * @dev This event is emitted when a comment is created
     * @param owner The owner of the character
     * @param characterId The id of the character
     * @param postId The id of the post
     * @param commentId The id of the comment
     */
    event CommentCreated(
        address indexed owner,
        uint256 indexed characterId,
        uint256 indexed postId,
        uint256 commentId
    );

    /*
     * @dev This event is emitted when a comment is updated
     * @param owner The owner of the character
     * @param characterId The id of the character
     * @param postId The id of the post
     * @param commentId The id of the comment
     */
    event CommentUpdated(
        address indexed owner,
        uint256 indexed characterId,
        uint256 indexed postId,
        uint256 commentId
    );

    /*
     * @dev This event is emitted when a comment is deleted
     * @param owner The owner of the character
     * @param characterId The id of the character
     * @param postId The id of the post
     * @param commentId The id of the comment
     */
    event CommentDeleted(
        address indexed owner,
        uint256 indexed characterId,
        uint256 indexed postId,
        uint256 commentId
    );

    modifier validCharacterId(uint256 characterId) {
        if (characterId <= 0) revert Social__InValidCharacterId(characterId);
        _;
    }

    modifier validPostId(uint256 postId) {
        if (postId <= 0) revert Social__InValidPostId(postId);
        _;
    }

    modifier validCommentId(uint256 commentId) {
        if (commentId <= 0) revert Social__InValidCommentId(commentId);
        _;
    }

    /// @inheritdoc ISocial
    function createCharacter(
        string calldata handle,
        string calldata name,
        string calldata bio,
        string calldata avatarUrl
    ) external override returns (uint256 characterId) {
        characterId = ++_characterIdIndex;
        _characters[characterId] = Character({
            owner: msg.sender,
            id: characterId,
            handle: handle,
            name: name,
            bio: bio,
            avatarUrl: avatarUrl
        });
        emit CharacterCreated(msg.sender, characterId);
    }

    /// @inheritdoc ISocial
    function updateCharacter(
        uint256 characterId,
        string calldata handle,
        string calldata name,
        string calldata bio,
        string calldata avatarUrl
    ) external override validCharacterId(characterId) {
        Character storage character = _characters[characterId];
        character.handle = handle;
        character.name = name;
        character.bio = bio;
        character.avatarUrl = avatarUrl;
        emit CharacterUpdated(msg.sender, characterId);
    }

    /// @inheritdoc ISocial
    function deleteCharacter(uint256 characterId) external override validCharacterId(characterId) {
        delete _characters[characterId];
        emit CharacterDeleted(msg.sender, characterId);
    }

    /// @inheritdoc ISocial
    function createPost(
        uint256 characterId,
        string calldata title,
        string calldata content
    ) external override validCharacterId(characterId) returns (uint256 postId) {
        postId = ++_postIdIndex[characterId];
        _posts[characterId][postId] = Post({
            characterId: characterId,
            id: postId,
            title: title,
            content: content
        });
        emit PostCreated(msg.sender, characterId, postId);
    }

    /// @inheritdoc ISocial
    function updatePost(
        uint256 characterId,
        uint256 postId,
        string calldata title,
        string calldata content
    ) external override validCharacterId(characterId) validPostId(postId) {
        Post storage post = _posts[characterId][postId];
        post.title = title;
        post.content = content;
        emit PostUpdated(msg.sender, characterId, postId);
    }

    /// @inheritdoc ISocial
    function deletePost(
        uint256 characterId,
        uint256 postId
    ) external override validCharacterId(characterId) validPostId(postId) {
        delete _posts[characterId][postId];
        emit PostDeleted(msg.sender, characterId, postId);
    }

    /// @inheritdoc ISocial
    function createComment(
        uint256 characterId,
        uint256 postId,
        string calldata content
    )
        external
        override
        validCharacterId(characterId)
        validPostId(postId)
        returns (uint256 commentId)
    {
        commentId = ++_commentIdIndex[characterId][postId];
        _comments[characterId][postId][commentId] = Comment({
            postId: postId,
            id: commentId,
            content: content
        });
        emit CommentCreated(msg.sender, characterId, postId, commentId);
    }

    /// @inheritdoc ISocial
    function updateComment(
        uint256 characterId,
        uint256 postId,
        uint256 commentId,
        string calldata content
    )
        external
        override
        validCharacterId(characterId)
        validPostId(postId)
        validCommentId(commentId)
    {
        Comment storage comment = _comments[characterId][postId][commentId];
        comment.content = content;
        emit CommentUpdated(msg.sender, characterId, postId, commentId);
    }

    /// @inheritdoc ISocial
    function deleteComment(
        uint256 characterId,
        uint256 postId,
        uint256 commentId
    )
        external
        override
        validCharacterId(characterId)
        validPostId(postId)
        validCommentId(commentId)
    {
        delete _comments[characterId][postId][commentId];
        emit CommentDeleted(msg.sender, characterId, postId, commentId);
    }

    /// @inheritdoc ISocial
    function getCharacter(
        uint256 characterId
    )
        external
        view
        override
        validCharacterId(characterId)
        returns (
            string memory handle,
            string memory name,
            string memory bio,
            string memory avatarUrl
        )
    {
        Character storage character = _characters[characterId];
        handle = character.handle;
        name = character.name;
        bio = character.bio;
        avatarUrl = character.avatarUrl;
    }

    /// @inheritdoc ISocial
    function getPost(
        uint256 characterId,
        uint256 postId
    )
        external
        view
        override
        validCharacterId(characterId)
        validPostId(postId)
        returns (string memory title, string memory content)
    {
        Post storage post = _posts[characterId][postId];
        title = post.title;
        content = post.content;
    }

    /// @inheritdoc ISocial
    function getComment(
        uint256 characterId,
        uint256 postId,
        uint256 commentId
    )
        external
        view
        override
        validCharacterId(characterId)
        validPostId(postId)
        validCommentId(commentId)
        returns (string memory content)
    {
        Comment storage comment = _comments[characterId][postId][commentId];
        content = comment.content;
    }
}
