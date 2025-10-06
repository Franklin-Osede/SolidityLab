**SolidityLab** is a curated collection of vulnerable smart contracts intended for advanced debugging, security analysis, and educational demonstrations.  
Each contract includes intentional flaws that allow developers to deeply explore the EVM, identify vulnerabilities, and implement fixes.

## 🎯 Purpose & Vision

This repository serves as a **learning and demonstration lab** for exploring security weaknesses in Solidity contracts, gaining hands-on debugging experience at the EVM level, and improving smart contract reliability.  
It is built to produce high-value technical content (videos, blog posts) and showcase real expertise in blockchain security.

Key goals:

- Reveal subtle vulnerabilities common in smart contracts (reentrancy, integer overflow, storage collision, etc.).  
- Provide a platform for developers and auditors to practice **step-by-step debugging** using professional tools.  
- Demonstrate how to go from a vulnerable contract to a hardened, secure version.  
- Empower viewers/readers to understand low-level mechanics: opcode behavior, gas optimization, storage layout, and attack vectors.

## 🧩 Project Structure & Content

The repository is organized into a series of **15 projects**, grouped by theme of vulnerability:

- **Security-Critical**  
  (e.g. reentrancy vault, front-running, proxy storage collision, delegatecall exploits, integer overflow)  
- **Business Logic Vulnerabilities**  
  (e.g. timestamp dependence, tx.origin issues, selfdestruct, short address attack)  
- **Optimization & Gas Considerations**  
  (e.g. storage packing, memory vs storage, loop DoS, external vs public, event logging efficiency)

Each project typically contains:
- A `contracts/` folder with:
  - `vulnerable/` version (with bugs)  
  - `fixed/` version (patches)  
  - `interfaces/` if needed  
- `test/` folder with unit and security tests  
- `script/` folder for deployment/debug scripts  
- `docs/` folder for architecture notes or vulnerability descriptions (optional)  

## 🔍 Value & Learning Outcomes

By working through SolidityLab, a developer or security enthusiast can:

- Understand **attack vectors** commonly found in smart contracts.  
- Practice **debugging at the transaction level** using tools like `forge debug`, `cast storage`, or Hardhat/Tenderly.  
- Learn how to **design robust contracts**, applying security patterns and best practices.  
- Develop intuition about **gas usage, storage layout, and EVM internals**.  
- Create content: walk-through vulnerability → exploit → fix → test, ideal para videos técnicos.

## 🌟 Vision & Future Extensions

Over time, SolidityLab can evolve to include:

- More advanced vulnerabilities (flash loan attacks, cross-chain logic, zero-knowledge proofs).  
- Integration with security tools (MythX, Slither, Manticore) and automated vulnerability scanning.  
- Visual dashboards of gas usage and execution traces.  
- Deployment of fixed contracts on testnets with real-world examples.  
- Challenges for community contributions: propose your own vulnerable contract, fix it, and submit a PR.

---

**Author:** Franklin Osede Prieto  
**Focus Areas:** Solidity • EVM Internals • Smart Contract Security • Debugging & Auditing  
