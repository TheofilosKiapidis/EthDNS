# Ethereum DNS
**General Idea** : Lets create a non-custodial DNS service based on a solidity contract.

Since we are not constricted to the hierarchical architecture of the legacy DNS system we can make a new simpler, flat protocol for IP resolution.

Domains are _"homes"_ and can be broken down into _"rooms"_.

Each home has an IP(v4/v6) address and each room of a home has its own port, just like in real life.

The name of a home is seperated from the name of a room by a dot(.). Therefore the home name must not have a dot in its name.

### For example:

``theofiloskiapidis.videos`` -> "theofiloskiapidis" is a home that has an IP and "videos" is a room that has a port.
In this house's room there is a video-hosting service such as peertube.

_The contract is not tested, only a concept. Feel free to test or modify._
