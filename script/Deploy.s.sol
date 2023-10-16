// SPDX-License-Identifier: MIT
// solhint-disable no-console,ordering
pragma solidity 0.8.18;

import {Deployer} from "./Deployer.sol";
import {DeployConfig} from "./DeployConfig.s.sol";
import {Social} from "../src/Social.sol";
import {console2 as console} from "forge-std/console2.sol";
import {TransparentUpgradeableProxy} from "../src/upgradeability/TransparentUpgradeableProxy.sol";

contract Deploy is Deployer {
    // solhint-disable private-vars-leading-underscore
    DeployConfig internal cfg;

    /// @notice Modifier that wraps a function in broadcasting.
    modifier broadcast() {
        vm.startBroadcast();
        _;
        vm.stopBroadcast();
    }

    /// @notice The name of the script, used to ensure the right deploy artifacts
    ///         are used.
    function name() public pure override returns (string memory name_) {
        name_ = "Deploy";
    }

    function setUp() public override {
        super.setUp();
        string memory path = string.concat(
            vm.projectRoot(),
            "/deploy-config/",
            deploymentContext,
            ".json"
        );
        cfg = new DeployConfig(path);

        console.log("Deploying from %s", deployScript);
        console.log("Deployment context: %s", deploymentContext);
    }

    /* solhint-disable comprehensive-interface */
    function run() external {
        deployImplementations();

        deployProxies();

        initialize();
    }

    /// @notice Initialize all of the proxies
    function initialize() public {
        initializeSocial();
    }

    /// @notice Deploy all of the proxies
    function deployProxies() public {
        deployProxy("Social");
    }

    /// @notice Deploy all of the logic contracts
    function deployImplementations() public {
        deploySocial();
    }

    function deployProxy(string memory _name) public broadcast returns (address addr_) {
        address logic = mustGetAddress(_stripSemver(_name));
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy({
            _logic: logic,
            admin_: cfg.proxyAdminOwner(),
            _data: ""
        });

        // check states
        address admin = address(uint160(uint256(vm.load(address(proxy), OWNER_KEY))));
        require(admin == cfg.proxyAdminOwner(), "proxy admin assert error");

        string memory proxyName = string.concat(_name, "Proxy");
        save(proxyName, address(proxy));
        console.log("%s deployed at %s", proxyName, address(proxy));

        addr_ = address(proxy);
    }

    function deploySocial() public broadcast returns (address addr_) {
        Social social = new Social();

        save("Social", address(social));
        console.log("Social deployed at %s", address(social));
        addr_ = address(social);
    }

    function initializeSocial() public broadcast {
        Social socialProxy = Social(mustGetAddress("SocialProxy"));
        console.log("Initializing Social at %s", address(socialProxy));
        socialProxy.createCharacter("admin", "admin", "admin", "https://demo.image");
    }
}
