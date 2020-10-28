# 电子设备通信协议/电路学习笔记

## UART

1. UART stands for **Universal Asynchronous Receiver/Transmitter**. It’s not a communication protocol like SPI and I2C, but a **physical circuit** in a microcontroller, or a stand-alone IC. A UART’s main purpose is to transmit and receive serial data.

2. Only two wires are needed to transmit data between two UARTs. Data flows from the Tx pin of the transmitting UART to the Rx pin of the receiving UART.

3. UARTs transmit data asynchronously, which means there is no clock signal to synchronize the output of bits from the transmitting UART to the sampling of bits by the receiving UART. Instead of a clock signal, the transmitting UART adds start and stop bits to the data packet being transferred. These bits define the beginning and end of the data packet so the receiving UART knows when to start reading the bits.

4. The UART that is going to transmit data receives the data from a data bus. The data bus is used to send data to the UART by another device like a CPU, memory, or microcontroller. Data is transferred from the data bus to the transmitting UART in parallel form. After the transmitting UART gets the parallel data from the data bus, it adds a start bit, a parity bit, and a stop bit, creating the data packet. Next, the data packet is output serially, bit by bit at the Tx pin. The receiving UART reads the data packet bit by bit at its Rx pin. The receiving UART then converts the data back into parallel form and removes the start bit, parity bit, and stop bits. Finally, the receiving UART transfers the data packet in parallel to the data bus on the receiving end. (伍注：核心即串/并转换）

## SPI

1. SD card modules, RFID card reader modules, and 2.4 GHz wireless transmitter/receivers all use SPI to communicate with microcontrollers.

2. One unique benefit of SPI is the fact that data can be transferred **without interruption**. **Any number** of bits can be sent or received in a continuous stream. With I2C and UART, data is sent in packets, limited to a specific number of bits. Start and stop conditions define the beginning and end of each packet, so the data is interrupted during transmission.

3. Devices communicating via SPI are in a **master-slave** relationship. The master is the controlling device (usually a microcontroller), while the slave (usually a sensor, display, or memory chip) takes instruction from the master.

4. The clock signal synchronizes the output of data bits from the master to the sampling of bits by the slave. One bit of data is transferred in each clock cycle, so the speed of data transfer is determined by the frequency of the clock signal. SPI communication is always initiated by the master since the master configures and generates the clock signal.

5. Any communication protocol where devices share a clock signal is known as **synchronous**. **SPI is a synchronous communication protocol.**

6. ADVANTAGEs
    - No start and stop bits, so the data can be streamed continuously without interruption
    - No complicated slave addressing system like I2C
    - Higher data transfer rate than I2C (almost twice as fast)
    - Separate MISO and MOSI lines, so data can be sent and received at the same time

7. DISADVANTAGES
    - Uses four wires (I2C and UARTs use two)
    - No acknowledgement that the data has been successfully received (I2C has this)
    - No form of error checking like the parity bit in UART
    - Only allows for a single master

## I2C

## 参考资料

1. [BASICS OF THE SPI COMMUNICATION PROTOCOL](https://www.circuitbasics.com/basics-of-the-spi-communication-protocol)
2. [BASICS OF UART COMMUNICATION](https://www.circuitbasics.com/basics-uart-communication/#:~:text=UART%20stands%20for%20Universal%20Asynchronous,transmit%20and%20receive%20serial%20data.)
3. [BASICS OF THE I2C COMMUNICATION PROTOCOL](https://www.circuitbasics.com/basics-of-the-i2c-communication-protocol/)
