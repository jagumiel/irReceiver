# irReceiver
## _infraRed Remote Control Receiver and Decoder_

This project aims to capture a signal from a remote control and decode it.

## Introduction

In this project, an infrared frame is collected through a receiver and decoded in an FPGA, showing the result obtained in the LEDs. To do this, you must know the communication protocol used by the remote control and program a module in VHDL capable of decoding the signal. The connection of the devices is shown in the following figure.

![Alt text](images/1-Scheme.png?raw=true "Connection scheme.")

The infrared sensor is a circuit that is powered at 3.3V<sub>DC</sub>. The third pin corresponds to the output of the circuit, and has been given the name "irSignal". This line will connect to the development board through a GPIO. A module will be made in VHDL that has irSignal as input, and it will be in charge of decoding the signal and displaying its binary value, graphically, through some LEDs. This output has been given the name "frame".
The circuit diagram for the iR sensor is as follows:

![Alt text](images/2-irSensor-Schematic.png?raw=true "Receiver circuit schematic.")

It is a photoreceptor that converts the light signal received through infrared into an electrical signal. This circuit will be connected to the development board, as shown in figure 1. Keep in mind that when the circuit is not receiving an infrared signal, the irSignal line will have a voltage of 3.3V<sub>DC</sub>, instead , when infrared light is detected, the photoreceptor will go into cut-off state and the voltage on that line will be 0V<sub>DC</sub>. In summary, when there is no signal, the active line will be kept at '1', on the other hand, when a beam of light arrives in the infrared spectrum, the line will be at '0'.

The following image represents how a remote control sends a frame. When the signal is at '1' it means that at that moment the infrared led diode of the remote control is emitting light, and when it is at '0', it is off. As explained in the previous paragraph, the sensor will collect this data in reverse, since when light is emitted, the photoresistor goes into cut-off, generating a logical '0'.

![Alt text](images/3-desired-Frame.png?raw=true "Desired frame pattern.")

The figure above shows a data frame from an infrared emitter. The plot begins with a start condition, which consists of keeping the led on for 2.4ms. The first bit that is sent is the least significant (LSB), and the last is the most significant (MSB). To send a logic '1', the LED is kept off for 0.6ms and on for 1.2ms. In the case of wanting to send a logic '0', the LED remains off for 0.6ms and then turns on for 0.6ms. After sending the frame, a period of time is allowed to complete 45ms, period in which the LED is off. Once this wait is over, the data is sent again, this time without a start condition.

Once the communication protocol is known, the peripheral hardware will be connected to the development card and a module will be designed to analyze and decode the sent frame. A Sony remote control will be used to generate the signals.

## Materials

Next, the material that will be necessary to carry out the project is listed:

- Hardware
        - FPGA Development Board (Terasic DE1 SoC in my case)
        - InfraRed Receiver Circuit
        - Remote Control according to the frame specifications
        - Oscilloscope and tools for debugging
- Software
        - VHDL synthesizer (Quartus Prime 18.1 in my case)
