// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

/**
 * Used Chainlink Docs (Intermediates - Random Numbers) as a starter to build 
 * [https://docs.chain.link/docs/intermediates-tutorial/]
 * Made this in rage as I don't trust the Web 2.0 random dice rolls being... random.
 * Made in Ethereum Remix, works on Kovan testnet, Injected Web3 environment
 * FUTURE WORK IDEAS
 * 1. Editing/creating new Solidity code; Multiple pulls, figure how how to roll more than once, 
 * call refernece CID images/hash of Heroes on IPFS instead of string)
 * 2. Deploy SingleGachaRoll.sol on Brownie
 */

import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.6/Owned.sol";

/**
 * @notice A Chainlink VRF consumer which uses randomness to mimic the rolling
 * of a 36 sided die
 * @dev This is only an example implementation and not necessarily suitable for mainnet.
 */
contract VRFD36 is VRFConsumerBase, Owned {
    using SafeMathChainlink for uint256;

    uint256 private constant ROLL_IN_PROGRESS = 42;

    bytes32 private s_keyHash;
    uint256 private s_fee;
    mapping(bytes32 => address) private s_rollers;
    mapping(address => uint256) private s_results;

    event DiceRolled(bytes32 indexed requestId, address indexed roller);
    event DiceLanded(bytes32 indexed requestId, uint256 indexed result);

    /**
     * @notice Constructor inherits VRFConsumerBase
     *
     * @dev NETWORK: KOVAN
     * @dev   Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * @dev   LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * @dev   Key Hash:   0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     * @dev   Fee:        0.1 LINK (100000000000000000)
     *
     * @param vrfCoordinator address of the VRF Coordinator
     * @param link address of the LINK token
     * @param keyHash bytes32 representing the hash of the VRF job
     * @param fee uint256 fee to pay the VRF oracle
     */
    constructor(address vrfCoordinator, address link, bytes32 keyHash, uint256 fee)
        public
        VRFConsumerBase(vrfCoordinator, link)
    {
        s_keyHash = keyHash;
        s_fee = fee;
        
    }

    /**
     * @notice Requests randomness
     * @dev Warning: if the VRF response is delayed, avoid calling requestRandomness repeatedly
     * as that would give miners/VRF operators latitude about which VRF response arrives first.
     * @dev You must review your implementation details with extreme care.
     *
     * @param roller address of the roller
     */
    function rollDice(address roller) public onlyOwner returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= s_fee, "Not enough LINK to pay fee");
        require(s_results[roller] == 0, "Already rolled");
        requestId = requestRandomness(s_keyHash, s_fee);
        s_rollers[requestId] = roller;
        s_results[roller] = ROLL_IN_PROGRESS;
        emit DiceRolled(requestId, roller);
    }

    /**
     * @notice Callback function used by VRF Coordinator to return the random number
     * to this contract.
     * @dev Some action on the contract state should be taken here, like storing the result.
     * @dev WARNING: take care to avoid having multiple VRF requests in flight if their order of arrival would result
     * in contract states with different outcomes. Otherwise miners or the VRF operator would could take advantage
     * by controlling the order.
     * @dev The VRF Coordinator will only send this function verified responses, and the parent VRFConsumerBase
     * contract ensures that this method only receives randomness from the designated VRFCoordinator.
     *
     * @param requestId bytes32
     * @param randomness The random result returned by the oracle
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 d36Value = randomness.mod(36).add(1);
        s_results[s_rollers[requestId]] = d36Value;
        emit DiceLanded(requestId, d36Value);
    }

    /**
     * @notice Get the house assigned to the player once the address has rolled
     * @param player address
     * @return hero as a string
     */
    function hero(address player) public view returns (string memory) {
        require(s_results[player] != 0, "Dice not rolled");
        require(s_results[player] != ROLL_IN_PROGRESS, "Roll in progress");
        return getHeroName(s_results[player]);
    }

    /**
     * @notice Withdraw LINK from this contract.
     * @dev this is an example only, and in a real contract withdrawals should
     * happen according to the established withdrawal pattern: 
     * https://docs.soliditylang.org/en/v0.4.24/common-patterns.html#withdrawal-from-contracts
     * @param to the address to withdraw LINK to
     * @param value the amount of LINK to withdraw
     */
    function withdrawLINK(address to, uint256 value) public onlyOwner {
        require(LINK.transfer(to, value), "Not enough LINK");
    }

    /**
     * @notice Set the key hash for the oracle
     *
     * @param keyHash bytes32
     */
    function setKeyHash(bytes32 keyHash) public onlyOwner {
        s_keyHash = keyHash;
    }

    /**
     * @notice Get the current key hash
     *
     * @return bytes32
     */
    function keyHash() public view returns (bytes32) {
        return s_keyHash;
    }

    /**
     * @notice Set the oracle fee for requesting randomness
     *
     * @param fee uint256
     */
    function setFee(uint256 fee) public onlyOwner {
        s_fee = fee;
    }

    /**
     * @notice Get the current fee
     *
     * @return uint256
     */
    function fee() public view returns (uint256) {
        return s_fee;
    }

    /**
     * @notice Get the hero namne from the id
     * @param id uint256
     * @return hero name string
     */
    function getHeroName(uint256 id) private pure returns (string memory) {
        string[36] memory heroNames = [
           "Warrior - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/1",
            "Magician - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/2",
            "Common - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/3",
            "Martyr - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/4",
            "Rogue - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/5",
            "Noble - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/6",
            "Spy - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/7",
            "Priest - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/8",
            "Assassin - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/9",
            "Prophet - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/10",
            "Assassin - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/11",
            "King - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/12",
            "Farmer - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/13",
            "Bishop - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/14",
            "Doctor - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/15",
            "Barbarian - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/16",
            "Bard - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/17",
            "Taverner - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/18",
            "Lover - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/19",
            "Banker - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/20",
            "Prince - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/21",
            "Hacker - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/22",
            "Legalist - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/23",
            "Engineer - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/24",
            "Artist - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/25",
            "Scientist - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/26",
            "Pirate - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/27",
            "Alien - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/28",
            "Reporter - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/29",
            "Drifter - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/30",
            "Mercenary - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/31",
            "Puppeteer - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/32",
            "Driver - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/33",
            "Cleaner - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/34",
            "Worker - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/35",
            "Star - https://opensea.io/assets/0x152fcc68eb51c1c6b8fbc6411548f25a21791180/36"
        ];
        return heroNames[id.sub(1)];
    }
}
