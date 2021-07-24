# Chainworks
Chainworks is an anime-influenced creative production created by Joh Nostalg

# Current Features
- Single use gacha roll
- Concept art characters on [IPFS](https://ipfs.io/ipfs/QmZAMCQxjeSu2JH1n6DtDXXm3zJJ82t7HCxCSWq5XwQwvq)
- Two [games](https://ipfs.io/ipfs/QmbPAhB2Q7YypR5aGVSdY1FsTMZpgB8J5wLUnViU62J8xc) with custom maps for future games
  - A card game for 6 people based on Love Letter, [on Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=2555849128)
  - A singleplayer time trial pair-of-2 mini game 

# Gacha Instructions
- Have Kovan ETH and LINK in your personal wallet
- Open [Ethereum Remix](https://remix.ethereum.org/)
- Copy and paste [GachaSingleRoll.sol](https://github.com/JohNostalg/Chainworks/blob/main/contracts/GachaSingleRoll.sol) in workspace 
- Compile and deloy in Injected Web3 environment using the VRFCoordinator/Link/Keyhash/Fee in the Solidity file
- Send Kovan LINK to The deployed Smart Contract created on Kovan testnet
- Use RollDice, then use Hero function (wait a few seconds for the data to go to and from VRF Coodinator) to find out who you get!

# Card Game Instructions
- Install Steam
- Buy and Install Tabletop Simulator
- Subscribe to the Chainworks game to play on TTS

# Future Iterations
- Deploy contracts on Brownie
- Find out a way to call reference IPFS images of Heroes in the smart contract
- Develop personalities of characters
- Delegating a Japanese creative company to create better artwork of the characters

# Current version:
v0.1.6:
- Built quick mock of the card game, [on Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=2555849128)
- Forking [nft-mix](https://github.com/brownie-mix/nft-mix) to build test NFT's on Rinkleby testnet
