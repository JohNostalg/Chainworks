# Chainworks
Chainworks is an anime-influenced creative production created by Joh Nostalg

> If one does not know to which port one is sailing, no wind is favorable. ~ Seneca

# Current Features
- Single use gacha roll
- Concept art characters on [IPFS](https://ipfs.io/ipfs/QmZAMCQxjeSu2JH1n6DtDXXm3zJJ82t7HCxCSWq5XwQwvq)
- Two [games](https://ipfs.io/ipfs/QmbPAhB2Q7YypR5aGVSdY1FsTMZpgB8J5wLUnViU62J8xc) with custom maps for future games
  - A card game for 6 people based on Love Letter
  - A singleplayer time trial pair-of-2 mini game 

# Gacha Instructions
- Have Kovan ETH and LINK in your personal wallet
- Open [Ethereum Remix](https://remix.ethereum.org/)
- Copy and paste [GachaSingleRoll.sol](https://github.com/JohNostalg/Chainworks/blob/main/contracts/GachaSingleRoll.sol) in workspace 
- Compile and deloy in Injected Web3 environment using the VRFCoordinator/Link/Keyhash/Fee in the Solidity file
- Send Kovan LINK to The deployed Smart Contract created on Kovan testnet
- Use RollDice, then use Hero function to find out who you get!

# Future Iterations
- Deploy contracts on Brownie
- Find out a way to call reference IPFS images of Heroes in the smart contract
- Develop personalities of characters
- Delegating a Japanese creative company to create better artwork of the characters

# Current version:
v0.1.5:
- [IPFS](https://ipfs.io/ipfs/QmVi6qhxheXhURa87KCAVpX3WaJJuDqDu4UWugcxeAhtgA)
- Split IPFS files into Characters, Games and Printing 
- Forked [Chainlink-mix](https://github.com/smartcontractkit/chainlink-mix) 
- Compiled GachaSingleRoll.sol on Brownie, added IPFS links to Heroes 
