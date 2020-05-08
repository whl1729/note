# CAN bus 学习笔记

## CAN bus wiki

1. A Controller Area Network (CAN bus) is a robust vehicle bus standard designed to **allow microcontrollers and devices to communicate with each other's applications without a host computer**.

2. For each device the data in a frame is transmitted sequentially but in such a way that if more than one device transmits at the same time the highest priority device is able to continue while the others back off. Frames are received by all devices, including by the transmitting device.

### Architecture

1. All nodes are connected to each other through a physically conventional two wire bus. The wires are a twisted pair with a 120 Ω (nominal) characteristic impedance.

2. This bus uses differential wired-AND signals. Two signals, CAN high (CANH) and CAN low (CANL) are either driven to a "dominant" state with CANH > CANL, or not driven and pulled by passive resistors to a "recessive" state with CANH ≤ CANL. A 0 data bit encodes a dominant state, while a 1 data bit encodes a recessive state, supporting a wired-AND convention, which gives nodes with lower ID numbers priority on the bus.

### Data transmission

1. The CAN specifications use the terms "dominant" bits and "recessive" bits, where dominant is a logical 0 (actively driven to a voltage by the transmitter) and recessive is a logical 1 (passively returned to a voltage by a resistor). The idle state is represented by the recessive level (Logical 1). If one node transmits a dominant bit and another node transmits a recessive bit then there is a collision and the dominant bit "wins". This means there is no delay to the higher-priority message, and the node transmitting the lower priority message automatically attempts to re-transmit six bit clocks after the end of the dominant message. This makes CAN very suitable as a real-time prioritized communications system.

2. （仲裁流程）The exact voltages for a logical 0 or 1 depend on the physical layer used, but the basic principle of CAN requires that each node listen to the data on the CAN network including the transmitting node(s) itself (themselves). If a logical 1 is transmitted by all transmitting nodes at the same time, then a logical 1 is seen by all of the nodes, including both the transmitting node(s) and receiving node(s). If a logical 0 is transmitted by all transmitting node(s) at the same time, then a logical 0 is seen by all nodes. If a logical 0 is being transmitted by one or more nodes, and a logical 1 is being transmitted by one or more nodes, then a logical 0 is seen by all nodes including the node(s) transmitting the logical 1. When a node transmits a logical 1 but sees a logical 0, it realizes that there is a contention and it quits transmitting. By using this process, any node that transmits a logical 1 when another node transmits a logical 0 "drops out" or loses the arbitration. A node that loses arbitration re-queues its message for later transmission and the CAN frame bit-stream continues without error until only one node is left transmitting. This means that the node that transmits the first 1 loses arbitration. Since the 11 (or 29 for CAN 2.0B) bit identifier is transmitted by all nodes at the start of the CAN frame, the node with the lowest identifier transmits more zeros at the start of the frame, and that is the node that wins the arbitration or has the highest priority.

3. The node with the lowest ID will always win the arbitration, and therefore has the highest priority.
