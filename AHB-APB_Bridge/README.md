A multi-block bridge that connects an AHB system bus to APB peripherals, implemented in Verilog and verified with simulation testbenches.
## Design
The bridge is split into five blocks:
- **AHB slave interface** (`ahb_slave_interface.v`): samples AHB transfers
- **AHB master** (`AHB_Master.v`): generates AHB bus transactions for testing
- **APB controller** (`apb_controller.v`): FSM that drives APB setup and enable phases
- **APB interface** (`APB_Interface.v`): APB peripheral-side signals
- **Bridge top** (`Bridge_top.v`): integrates all blocks
## Verification
- `tb_ahb_slave_interface.v`: unit testbench for the AHB slave interface
- `tb_apb_controller.v`: unit testbench for the APB controller FSM
- `top_tb.v`: system-level testbench for CPU-to-peripheral read and write
Simulated in ModelSim. Protocol compliance was checked against the AHB and APB handshake rules.
## Tools
Verilog, ModelSim
