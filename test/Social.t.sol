// SPDX-License-Identifier: MIT
// solhint-disable comprehensive-interface,no-console
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
// import {console2 as console} from "forge-std/console2.sol";
import {Utils} from "./helpers/Utils.sol";
import {
    Social__InValidCharacterId,
    Social__InValidPostId,
    Social__InValidCommentId
} from "../src/Error.sol";
import {Social} from "../src/Social.sol";
import {TransparentUpgradeableProxy} from "../src/upgradeability/TransparentUpgradeableProxy.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract SocialTest is Test, Utils {
    address public constant alice = address(0x111);
    address public constant bob = address(0x222);
    address public constant carol = address(0x333);
    address public constant dave = address(0x444);
    address public constant eve = address(0x555);
    address public constant frank = address(0x666);

    address public constant proxyAdmin = address(0x777);
    address public constant admin = address(0x888);

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    uint256 public constant initialAmount = 1e9 ether;

    Social internal _social;

    // events
    event CharacterCreated(address indexed owner, uint256 indexed characterId);
    event CharacterUpdated(address indexed owner, uint256 indexed characterId);
    event CharacterDeleted(address indexed owner, uint256 indexed characterId);
    event PostCreated(address indexed owner, uint256 indexed characterId, uint256 indexed postId);
    event PostUpdated(address indexed owner, uint256 indexed characterId, uint256 indexed postId);
    event PostDeleted(address indexed owner, uint256 indexed characterId, uint256 indexed postId);
    event CommentCreated(
        address indexed owner,
        uint256 indexed characterId,
        uint256 indexed postId,
        uint256 commentId
    );
    event CommentUpdated(
        address indexed owner,
        uint256 indexed characterId,
        uint256 indexed postId,
        uint256 commentId
    );
    event CommentDeleted(
        address indexed owner,
        uint256 indexed characterId,
        uint256 indexed postId,
        uint256 commentId
    );

    function setUp() public {
        Social socialImpl = new Social();
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(socialImpl),
            proxyAdmin,
            ""
        );

        bytes32 v = vm.load(address(proxy), bytes32(uint256(3)));
        v = vm.load(address(proxy), bytes32(0));
        assertEq(uint256(v), uint256(0)); // initialize version

        _social = Social(address(proxy));
    }

    function testCreateCharacter() public {
        // create character
        expectEmit();
        emit CharacterCreated(alice, 1);
        vm.prank(alice);
        uint256 characterId = _social.createCharacter(
            "test",
            "test-create",
            "bio",
            "https://demo.image"
        );

        (
            string memory handle,
            string memory name,
            string memory bio,
            string memory avatarUrl
        ) = _social.getCharacter(characterId);

        // check character index
        assertEq(characterId, 1);
        assertEq(handle, "test");
        assertEq(name, "test-create");
        assertEq(bio, "bio");
        assertEq(avatarUrl, "https://demo.image");
    }
}
