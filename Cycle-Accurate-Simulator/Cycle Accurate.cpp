
#include<iostream>
#include<string>
#include<vector>
#include<bitset>
#include<fstream>
#include <iomanip>

using namespace std;

// For ALU & Memory size & Control Unit
#define MemSize 1024
#define ALU_OR   0b000
#define ALU_AND  0b001
#define ALU_XOR  0b010
#define ALU_ADD  0b011
#define ALU_NOR  0b100
#define ALU_SLT  0b101
#define ALU_SUB  0b110
#define ALU_NAND 0b111

// Some performance metrics
int cycle = 0;
int exeutedInstructions = 0;
int stalls = 0;
int fluches = 0;
int forwardings = 0;
int branches = 0;
int jump = 0;
int memAccess = 0;




// Fetch Wires
struct IFStruct
{
    bool jumpMuxOut = 0;
    bool branshMuxOut = 0;
    bool pcMuxOut = 0;
    bool fluch = 0;

    bitset<32> PC;
    bitset<32> Instr;
    bitset<32> nextPC;
    bool nop = 0;
};

// Decode wires
struct IDStruct{
    bitset<32> Instr;
    bitset<32> Read_data1;
    bitset<32> Read_data2;
    bitset<32> immExt;
    bitset<32> immShift;
    bitset<32> IDAdder;
    bitset<32> nextPC;
    bitset<32> concatinatedJump;
    bitset<32> jumpAddress;
    bitset<28> shiftedJump;
    bitset<26> jumpImm;
    bitset<16> imm;
    bitset<6> opcode;
    bitset<5> Rs;
    bitset<5> Rt;
    bitset<5> Rd;
    bool equal= 0;
    bool branhSel =0;

    bool pcSrc = 0;
    bool jumpSel = 0;
    bool regWrite = 0;
    bitset<2> memToReg = 0;
    bool memWrite = 0;
    bool memRead = 0;
    bitset<3> alu_op = 0;
    bitset<2> regDst = 0;
    bool aluSrc = 0;
    bool branch = 0;
    bool nop = 0;
};

// Execute wires
struct EXStruct {

    bitset<32> instr;
    bitset<32> nextPC;
   
    bitset<32> Read_data1;
    bitset<32> Read_data2;
    bitset<32> immExt;
    bitset<32> operand1;
    bitset<32> operand2;
    bitset<32> alu_result;
    bitset<5> Rs;
    bitset<5> Rt;
    bitset<5> Rd;
    bitset<5> writeReg;

    bool regWrite;
    bitset<2> memToReg;
    bool memWrite;
    bool memRead;
    bitset<3> alu_op;
    bitset<2> regDst;
    bool aluSrc;
};

// Memory access wires
struct MEMStruct
{
    bitset<32> instr;
    bitset<32> nextPC;
    bitset<32> alu_result;
    bitset<32> Read_data2;
    bitset<32> dataMemRead;
    bitset<5> writeReg;

    bitset<2> memToReg;
    bool regWrite, memRead, memWrite;
};

// Writeback wires
struct WBStruct
{
    bitset<32> instr;
    bitset<32> nextPC;
    bitset<32> dataMemRead;
    bitset<32> alu_result;
    bitset<32> writeData;
    bitset<5> writeReg;


    bitset<2> memToReg;
    bool regWrite;
};

// All design wires
struct stateStruct
{
    IFStruct IF;
    IDStruct ID;
    EXStruct EX;
    MEMStruct MEM;
    WBStruct WB;
};


// Fetch/Decode Pipe
struct IFID_Register {
    bitset<32> Instr;  
    bitset<32> nextPC; 
    bool nop;          
};

// Decode/Execute Pipe
struct IDEX_Register {
    bitset<32> instr;
    bitset<32> nextPC;
    bitset<32> Read_data1;
    bitset<32> Read_data2;
    bitset<32> immExt;       
    bitset<5> Rs, Rt, Rd;    

    bitset<3> alu_op;        
    bitset<2>regDst;
    bitset<2> memToReg;
    bool aluSrc, regWrite, memRead, memWrite, pcSrc;
    bool nop;                
};

// Execute/Memory Pipe
struct EXMEM_Register {
    bitset<32> instr;
    bitset<32> nextPC;
    bitset<32> alu_result;
    bitset<32> Read_data2;
    bitset<5> writeReg;
   
    bitset<2> memToReg;
    bool regWrite, memRead, memWrite;
};

// Memory/ Writeback Pipe
struct MEMWB_Register {
    bitset<32> instr;
    bitset<32> nextPC;
    bitset<32> dataMemRead;
    bitset<32> alu_result;
    bitset<5> writeReg;

    bitset<2> memToReg;
    bool regWrite;
};

// Instantiate the pipeline registers
IFID_Register IFID, next_IFID;
IDEX_Register IDEX, next_IDEX;
EXMEM_Register EXMEM, next_EXMEM;
MEMWB_Register MEMWB, next_MEMWB;

// Instruction memory class with vector to save all its instruction and read port
class instructionMem {
    vector<bitset<32>> instMem;

public:
    bitset<32> instructionOut;

    instructionMem() {
        instMem.resize(MemSize);  
        ifstream imemFile("instructionMem.txt");

        if (imemFile.is_open()) {
            string line;
            int i = 0;
            while (getline(imemFile, line) && i < MemSize) {
                line.erase(remove_if(line.begin(), line.end(), isspace), line.end());

                if (line.length() == 8) {  
                    try {
                        instMem[i] = bitset<32>(stoul(line, nullptr, 16));  
                        i++;
                    }
                    catch (const invalid_argument& e) {
                        cout << "Invalid argument in file ( Check the format of insturcion memory ): " << e.what() << endl;
                    }
                    catch (const out_of_range& e) {
                        cout << "Value out of range in file: " << e.what() << endl;
                    }
                }
                else {
                    cout << "Incorrect line length or format" << endl;
                }
            }
            imemFile.close();
        }
        else {
            cout << "Unable to open instruction memory file" << endl;
        }
    }

    bitset<32> readInstr(bitset<32> ReadAddress) {
        unsigned long addr = ReadAddress.to_ulong();
        if (addr < instMem.size()) {
            instructionOut = instMem[addr];
        }
        else {
            cout << "Address out of range" << endl;
            instructionOut.reset();
        }
        return instructionOut;
    }

};


class registerFile {
    vector<bitset<32>> registers;

public:
    registerFile() {
        registers.resize(32);
        ifstream regFile("registers.txt");
        if (regFile.is_open()) {
            string line;
            int i = 0;
            while (getline(regFile, line) && i < 32) {
                if (line.length() == 8) {
                    registers[i] = bitset<32>(stoul(line, nullptr, 16));
                    i++;
                }
            }
            regFile.close();
        }
        else {
            cout << "Unable to open register file" << endl;
        }
    }

    bitset<32> readRegister(bitset<5> regNum) {
        if (regNum == 0)
            return 0;
        return registers[regNum.to_ulong()];
    }

    void writeRegister(bitset<5> regNum, bitset<32> data) {
        registers[regNum.to_ulong()] = data;
    }

    void outputRegisters() {
        ofstream regFile("registers.txt");
        if (regFile.is_open()) {
            for (size_t i = 0; i < registers.size(); i++) {
                regFile <<uppercase << setw(8) <<setfill('0') << hex << registers[i].to_ulong() << endl;
            }
        }
        else {
            cout << "Unable to open file for writing" << endl;
        }
        regFile.close();
    }

    void printRegisters() {
         for (size_t i = 0; i < registers.size(); ++i) {
            cout << "R" << setw(2) << setfill('0') << i << ": 0x" << uppercase << setw(8) << setfill('0') << hex << registers[i].to_ulong() << endl;
        }
    }
};

class dataMemory {

    vector<bitset<32>> dataMem;

public:
    bitset<32> ReadData;

    dataMemory() {
        dataMem.resize(MemSize);
        ifstream dmemFile("dataMem.txt");
        if (dmemFile.is_open()) {
            string line;
            int i = 0;
            while (getline(dmemFile, line)) {
                if (line.length() == 8) { 
                    try {
                        dataMem[i] = bitset<32>(stoul(line, nullptr, 16));
                        i++;
                    }
                    catch (const invalid_argument& e) {
                        cout << "Invalid argument: " << e.what() << endl;
                    }
                    catch (const out_of_range& e) {
                        cout << "Out of range: " << e.what() << endl;
                    }
                }
                else {
                    cout << "Incorrect line length or format in dataMem.txt: " << line << endl;
                }
            }
            dmemFile.close();
        }
        else {
            cout << "Unable to open data memory file" << endl;
        }
    }

    bitset<32> readDataMem(bitset<32> Address) {
        unsigned long addr = Address.to_ulong();
        if (addr < dataMem.size()) {
            ReadData = dataMem[addr];
        }
        else {
            cout << "Address out of range" << endl;
            ReadData.reset();  
        }
        return ReadData;
    }

    void writeDataMem(bitset<32> Address, bitset<32> WriteData) {
        unsigned long addr = Address.to_ulong();
        if (addr < dataMem.size()) {
            dataMem[addr] = WriteData;
        }
        else {
            cout << "Address out of range" << endl;
        }
    }

    void outputDataMem() {
        ofstream dmemFile("dataMem.txt");
        if (dmemFile.is_open()) {
            for (size_t j = 0; j < dataMem.size(); j++) {
                dmemFile << setfill('0') << setw(8) << hex << dataMem[j].to_ulong() << endl;
            }
        }
        else {
            cout << "Unable to open file for writing" << endl;
        }
        dmemFile.close();
    }

};

// Sign Extention for immediate and jump
bitset<32> signextend(bitset<16> imm)
{
    string sestring;

    if (imm[15] == 0) {
        sestring = "0000000000000000" + imm.to_string<char, string::traits_type, string::allocator_type>();
    }
    else {
        sestring = "1111111111111111" + imm.to_string<char, string::traits_type, string::allocator_type>();
    }
    return (bitset<32>(sestring));

}


bitset<32> ALU(bitset<3> alu_op, bitset<32> op1, bitset<32> op2) {

    bitset<32> alu_result;

    switch (alu_op.to_ulong()) {
    case ALU_OR:
        alu_result = op1 | op2;
        break;
    case ALU_AND:
        alu_result = op1 & op2;
        break;
    case ALU_XOR:
        alu_result = op1 ^ op2;
        break;
    case ALU_ADD:
        alu_result = bitset<32>(op1.to_ulong() + op2.to_ulong());
        break;
    case ALU_NOR:
        alu_result = ~(op1 | op2);
        break;
    case ALU_SLT:
        alu_result = (op1.to_ulong() < op2.to_ulong()) ? bitset<32>(1) : bitset<32>(0);
        break;
    case ALU_SUB:
        alu_result = bitset<32>(op1.to_ulong() - op2.to_ulong());
        break;
    case ALU_NAND:
        alu_result = ~(op1 & op2);
        break;
    default:
        cout << "Unknown ALU operation" << endl;
        break;
    }

    return alu_result;
}


void Fetch(stateStruct& state, instructionMem& imem, IFID_Register& nextIFID) {
  
  
    
    // Fetch instruction
    state.IF.Instr = imem.readInstr(state.IF.PC);


    

    // Update pipeline register, handle fluches and stalls
    if (!state.IF.nop) {
        // Normal state
        state.IF.nextPC = state.IF.PC.to_ulong() + 1;
        nextIFID.Instr = state.IF.Instr;
        nextIFID.nextPC = state.IF.nextPC;
    }
    else {
        // If there is fluch
        if (state.IF.fluch) {
            nextIFID.Instr = 0;
            state.IF.nextPC = state.IF.PC;

        }
        else {
            // For stalls
            nextIFID.nextPC = state.IF.nextPC;
            nextIFID.Instr = nextIFID.Instr;
        }
    }

    // Next pc selection
    if (state.ID.pcSrc == 1) {
        if (state.ID.jumpSel == 1)
            state.IF.PC = state.ID.jumpAddress;
        else
            state.IF.PC = state.ID.Read_data1;
    }
    else {
        if (state.ID.branhSel == 1)
            state.IF.PC = state.ID.IDAdder;
        else
            state.IF.PC = state.IF.nextPC;
    }
}

void Decode(stateStruct & state, registerFile & regFile ,IFID_Register& IFID, IDEX_Register& nextIDEX) {
   
    state.ID.Instr = IFID.Instr; 
    state.ID.nextPC = IFID.nextPC;
    state.ID.nop = next_IFID.nop;

    bitset<6> opcode = bitset<6>((state.ID.Instr.to_ulong() >> 26) & 0x3F);

    state.ID.opcode = opcode;

    // R-type instructions (opcode == 0x00)
    if (opcode.to_ulong() == 0x00) {
        state.ID.aluSrc = 0;
        state.ID.regDst = 1;
        state.ID.memToReg = 0;
        state.ID.memRead = 0;
        state.ID.memWrite = 0;
        state.ID.branch = 0;
        state.ID.jumpSel = 0;
        bitset<6> funct = bitset<6>((state.ID.Instr.to_ulong()) & 0x3F);
        if (funct.to_ulong() == 0x00) {//OR  
            state.ID.alu_op = ALU_OR;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;
        }
        else if (funct.to_ulong() == 0x01) {//AND
            state.ID.alu_op = ALU_AND;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;

        }
        else if (funct.to_ulong() == 0x02) {//XOR
            state.ID.alu_op = ALU_XOR;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;

        }
        else if (funct.to_ulong() == 0x03) {//ADD 
            state.ID.alu_op = ALU_ADD;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;

        }
        else if (funct.to_ulong() == 0x04) {//NOR
            state.ID.alu_op = ALU_NOR;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;

        }
        else if (funct.to_ulong() == 0x05) {//NAND  
            state.ID.alu_op = ALU_NAND;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;

        }
        else if (funct.to_ulong() == 0x06) {//SLT
            state.ID.alu_op = ALU_SLT;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;

        }
        else if (funct.to_ulong() == 0x07) {//SUB
            state.ID.alu_op = ALU_SUB;
            state.ID.regWrite = 1;
            state.ID.pcSrc = 0;

        }
        else if (funct.to_ulong() == 0x08) {//JR
            state.ID.alu_op = ALU_SUB;
            state.ID.regWrite = 0;
            state.ID.pcSrc = 1;
            jump++;
        }
    }

    // I-type instructions
    else if (opcode.to_ulong() >= 0x10 && opcode.to_ulong() <= 0x17) {
        state.ID.aluSrc = 1;
        state.ID.regDst = 0;
        state.ID.memToReg = 0;
        state.ID.regWrite = 1;
        state.ID.memRead = 0;
        state.ID.memWrite = 0;
        state.ID.branch = 0;
        state.ID.jumpSel = 0;
        state.ID.pcSrc = 0;
        state.ID.Rd = state.ID.Rt;  // I-type destination register

        if (opcode.to_ulong() == 0x10) {
            state.ID.alu_op = ALU_OR;  // ORI
        }
        else if (opcode.to_ulong() == 0x11) {
            state.ID.alu_op = ALU_AND;  // ANDI
        }
        else if (opcode.to_ulong() == 0x12) {
            state.ID.alu_op = ALU_XOR;  // XORI
        }
        else if (opcode.to_ulong() == 0x13) {
            state.ID.alu_op = ALU_ADD;  // ADDI
        }
        else if (opcode.to_ulong() == 0x14) {
            state.ID.alu_op = ALU_NOR;  // NORI
        }
        else if (opcode.to_ulong() == 0x15) {
            state.ID.alu_op = ALU_NAND;  // NANDI
        }
        else if (opcode.to_ulong() == 0x16) {
            state.ID.alu_op = ALU_SLT;  // SLTI
        }
        else if (opcode.to_ulong() == 0x17) {
            state.ID.alu_op = ALU_SUB;  // SUBI
        }

    }
    // Load (LW)
    else if (opcode.to_ulong() == 0x23) {
        state.ID.alu_op = ALU_ADD;
        state.ID.aluSrc = 1;
        state.ID.regDst = 0;
        state.ID.memToReg = 1;
        state.ID.regWrite = 1;
        state.ID.memRead = 1;
        state.ID.memWrite = 0;
        state.ID.branch = 0;
        state.ID.jumpSel = 0;
        state.ID.pcSrc = 0;
        memAccess++;
    }
    // Store (SW)
    else if (opcode.to_ulong() == 0x2b) {
        state.ID.alu_op = ALU_ADD;
        state.ID.aluSrc = 1;
        state.ID.regDst = 0;
        state.ID.memToReg = 0;
        state.ID.regWrite = 0;
        state.ID.memRead = 0;
        state.ID.memWrite = 1;
        state.ID.branch = 0;
        state.ID.jumpSel = 0;
        state.ID.pcSrc = 0;
        memAccess++;

    }
    // Branch
    else if (opcode.to_ulong() == 0x30) {
        state.ID.alu_op = 0;
        state.ID.aluSrc = 0;
        state.ID.regDst = 0;
        state.ID.memToReg = 0;
        state.ID.regWrite = 0;
        state.ID.memRead = 0;
        state.ID.memWrite = 0;
        state.ID.branch = 1;
        state.ID.jumpSel = 0;
        state.ID.pcSrc = 0;
        branches++;
    }
    // Jump 
    else if (opcode.to_ulong() == 0x31) {
        state.ID.alu_op = 0;
        state.ID.aluSrc = 0;
        state.ID.regDst = 0;
        state.ID.memToReg = 0;
        state.ID.regWrite = 0;
        state.ID.memRead = 0;
        state.ID.memWrite = 0;
        state.ID.branch = 0;
        state.ID.jumpSel = 1;
        state.ID.pcSrc = 1;
        jump++;
    }
    // Jal
    else if (opcode.to_ulong() == 0x33) {
    state.ID.alu_op = 0;
    state.ID.aluSrc = 0;
    state.ID.regDst = 2;
    state.ID.memToReg = 2;
    state.ID.regWrite = 1;
    state.ID.memRead = 0;
    state.ID.memWrite = 0;
    state.ID.branch = 0;
    state.ID.jumpSel = 1;
    state.ID.pcSrc = 1;
    jump++;
    }
    else {
    state.ID.alu_op = 0;
    state.ID.aluSrc = 0;
    state.ID.regDst = 0;
    state.ID.memToReg = 0;
    state.ID.regWrite = 0;
    state.ID.memRead = 0;
    state.ID.memWrite = 0;
    state.ID.branch = 0;
    state.ID.jumpSel = 0;
    state.ID.pcSrc = 0;
    }


    // Extract registers
    state.ID.Rs = bitset<5>((state.ID.Instr.to_ulong() >> 21) & 0x1F); 
    state.ID.Rt = bitset<5>((state.ID.Instr.to_ulong() >> 16) & 0x1F); 
    state.ID.Rd = bitset<5>((state.ID.Instr.to_ulong() >> 11) & 0x1F); 


    
    // Read registers from regFile
    state.ID.Read_data1 = regFile.readRegister(state.ID.Rs);
    state.ID.Read_data2 = regFile.readRegister(state.ID.Rt);

    // Immediate value for I-type instructions
    state.ID.imm = bitset<16>(state.ID.Instr.to_ulong() & 0xFFFF);
    state.ID.immExt = signextend(state.ID.imm);
    state.ID.immShift = state.ID.immExt << 2;

    // Adding
    state.ID.IDAdder = state.ID.immShift.to_ulong() + state.ID.nextPC.to_ulong();

    // Check whether brach is taken
    if (state.ID.Read_data1 == state.ID.Read_data2) 
        state.ID.equal = 1;
    else 
        state.ID.equal = 0;

    state.ID.branhSel = state.ID.branch && state.ID.equal;


    // Jump 
    // Extracting the jump immediate and shifting
    if (opcode.to_ulong() == 0x31 || opcode.to_ulong() == 0x33) {
        state.ID.jumpSel = 1;
        bitset<26> jumpImm((state.ID.Instr.to_ulong() & 0x03FFFFFF));

        // No shifting as i make it word addressable not byte
        // bitset<28> shiftedJump(jumpImm.to_ulong() << 2); // Shift left by 2
        bitset<4> upperNextPC((state.ID.nextPC.to_ulong() >> 28) & 0xF);
        string fullAddress = upperNextPC.to_string() + jumpImm.to_string();
        state.ID.jumpAddress = bitset<32>(fullAddress, 0, 32);
    }
    bool hazard = false;
    if (state.ID.memRead == 1) { 
        if ((state.ID.Rt == nextIDEX.Rs) || (state.ID.Rt == nextIDEX.Rt)) {
            hazard = true;
        }
    }
    // If there is hazard stall the pipe
    if (hazard) {
        state.IF.nop = true;
        state.ID.nop = true;
        stalls++;
    }
    else {
        state.IF.nop = false;
        state.ID.nop = false;
    }

    // If there is branch or jump to fluch wrong fetched instruction
    bool fluch = state.ID.pcSrc || state.ID.branhSel;

    if (fluch) {
        state.IF.fluch=true;
        state.IF.nop = true;
        fluches++;
    }
    else
        state.IF.fluch = false;


    if (!state.ID.nop) {
        nextIDEX.instr = state.ID.Instr;
        nextIDEX.Read_data1 = state.ID.Read_data1;
        nextIDEX.Read_data2 = state.ID.Read_data2;
        nextIDEX.immExt = state.ID.immExt;
        nextIDEX.Rs = state.ID.Rs;
        nextIDEX.Rt = state.ID.Rt;
        nextIDEX.Rd = state.ID.Rd;
        nextIDEX.alu_op = state.ID.alu_op;
        nextIDEX.regDst = state.ID.regDst;
        nextIDEX.memToReg = state.ID.memToReg;
        nextIDEX.regWrite = state.ID.regWrite;
        nextIDEX.memRead = state.ID.memRead;
        nextIDEX.memWrite = state.ID.memWrite;
        nextIDEX.aluSrc = state.ID.aluSrc;
        nextIDEX.nextPC = state.ID.nextPC;
    }
    else if (state.ID.nop) {
        nextIDEX.instr = 0;
        nextIDEX.Read_data1 =0;
        nextIDEX.Read_data2 =0;
        nextIDEX.immExt = 0;
        nextIDEX.Rs =0;
        nextIDEX.Rt =0;
        nextIDEX.Rd =0;
        nextIDEX.alu_op = 0;
        nextIDEX.regDst = 0;
        nextIDEX.memToReg = 0;
        nextIDEX.regWrite = 0;
        nextIDEX.memRead = 0;
        nextIDEX.memWrite = 0;
        nextIDEX.aluSrc = 0;
    }
}

void Execute(stateStruct& state, IDEX_Register& IDEX, EXMEM_Register& nextEXMEM) {

    // To hold values for forwardings
    bitset<32> operand1;
    bitset<32> operand2;
    int tempForward=0;

    // Get the values from ID stage
    state.EX.instr = IDEX.instr;
    state.EX.Read_data1 = IDEX.Read_data1;
    state.EX.Read_data2 = IDEX.Read_data2;
    state.EX.immExt = IDEX.immExt;
    state.EX.Rs = IDEX.Rs;
    state.EX.Rt = IDEX.Rt;
    state.EX.Rd = IDEX.Rd;
    state.EX.alu_op = IDEX.alu_op;
    state.EX.regDst = IDEX.regDst;
    state.EX.memToReg = IDEX.memToReg;
    state.EX.regWrite = IDEX.regWrite;
    state.EX.memRead = IDEX.memRead;
    state.EX.memWrite = IDEX.memWrite;
    state.EX.aluSrc = IDEX.aluSrc;
    state.EX.nextPC = IDEX.nextPC;
    
    operand1 = state.EX.Read_data1;
    operand2 = state.EX.Read_data2;
   
    // Perform Forwardings
    if (EXMEM.regWrite && (EXMEM.writeReg == IDEX.Rs) && EXMEM.writeReg != 0) {
        operand1 = EXMEM.alu_result; 
        if(!state.EX.aluSrc)
            tempForward++;
    }

    if (EXMEM.regWrite && (EXMEM.writeReg == IDEX.Rt) && EXMEM.writeReg != 0) {
        operand2 = EXMEM.alu_result;
        if (!state.EX.aluSrc)
            tempForward++;
    }

    if (MEMWB.regWrite && (MEMWB.writeReg == IDEX.Rs) && ((EXMEM.writeReg != IDEX.Rs) || (EXMEM.writeReg == 0)) && (EXMEM.writeReg != 0) && (MEMWB.instr != 0x00000000)) {
        operand1 = MEMWB.alu_result;
        if (!state.EX.aluSrc)
            tempForward++;
    }

    if (MEMWB.regWrite && (MEMWB.writeReg == IDEX.Rt) && ((EXMEM.writeReg != IDEX.Rt) || (EXMEM.writeReg == 0)) && (EXMEM.writeReg != 0) && (MEMWB.instr != 0x00000000)) {
        operand2 = MEMWB.alu_result;
        if (!state.EX.aluSrc)
            tempForward++;
    }
    if(tempForward>0)
        forwardings = forwardings +1;

    state.EX.operand1 = operand1;
    state.EX.operand2 = IDEX.aluSrc ? IDEX.immExt : operand2;


    // Perform ALU operation
    state.EX.alu_result= ALU(state.EX.alu_op ,state.EX.operand1, state.EX.operand2);

    // Determine destination register
    if (IDEX.regDst == 0) {
        state.EX.writeReg = IDEX.Rt; // I-type instruction
    }
    else if (IDEX.regDst == 1) {
        state.EX.writeReg = IDEX.Rd; // R-type instruction
    }
    else if (IDEX.regDst == 2) {
        state.EX.writeReg = 31; // jal-type instruction
    }
    else {
        cout << "Unknown regDst" << endl;
    }

    // Send values to Memory stage
    nextEXMEM.instr = state.EX.instr;
    nextEXMEM.regWrite = state.EX.regWrite;
    nextEXMEM.memToReg = state.EX.memToReg;
    nextEXMEM.memWrite = state.EX.memWrite;
    nextEXMEM.memRead = state.EX.memRead;
    
    nextEXMEM.nextPC = state.EX.nextPC;
    nextEXMEM.alu_result = state.EX.alu_result;
    nextEXMEM.Read_data2 = state.EX.Read_data2;
    nextEXMEM.writeReg = state.EX.writeReg;
}

void memoryAccess(stateStruct& state, dataMemory& dmem, EXMEM_Register& EXMEM, MEMWB_Register& nextMEMWB) {

    // Get the values from execute stage at each
    state.MEM.regWrite = EXMEM.regWrite;
    state.MEM.memToReg = EXMEM.memToReg;
    state.MEM.memWrite = EXMEM.memWrite;
    state.MEM.memRead = EXMEM.memRead;
    state.MEM.instr = EXMEM.instr;
    state.MEM.nextPC = EXMEM.nextPC;
    state.MEM.alu_result = EXMEM.alu_result;
    state.MEM.Read_data2 = EXMEM.Read_data2;
    state.MEM.writeReg = EXMEM.writeReg;

    // Read from data memroy (treated as 1 cycle chache)
    if (state.MEM.memRead) 
        state.MEM.dataMemRead = dmem.readDataMem(state.MEM.alu_result);
    else  
        state.MEM.dataMemRead = 0;

    // Write on data memory
    if (state.MEM.memWrite) {
        dmem.writeDataMem(state.MEM.alu_result, state.MEM.Read_data2);
    }
    
    // Update the values and send them to write back stage
    nextMEMWB.regWrite = state.MEM.regWrite;
    nextMEMWB.memToReg = state.MEM.memToReg;
    nextMEMWB.instr = state.MEM.instr;
    nextMEMWB.nextPC = state.MEM.nextPC;
    nextMEMWB.alu_result = state.MEM.alu_result;
    nextMEMWB.dataMemRead = state.MEM.dataMemRead;
    nextMEMWB.writeReg = state.MEM.writeReg;
    
}

void writeBack(stateStruct& state, registerFile& regFile, MEMWB_Register& MEMWB) {
   
    // Get the values from memory stage
    state.WB.regWrite = MEMWB.regWrite;
    state.WB.memToReg = MEMWB.memToReg;
    state.WB.instr = MEMWB.instr;
    state.WB.nextPC= MEMWB.nextPC;
    state.WB.dataMemRead= MEMWB.dataMemRead;
    state.WB.alu_result= MEMWB.alu_result;
    state.WB.writeReg= MEMWB.writeReg;
    
    // Writeback mux selection 
    if (state.WB.regWrite) {
        if (state.WB.memToReg == 0) {
            regFile.writeRegister(state.WB.writeReg, state.WB.alu_result);
            state.WB.writeData = state.WB.alu_result;
        }
        else if (state.WB.memToReg == 1) {
            regFile.writeRegister(state.WB.writeReg, state.WB.dataMemRead);
            state.WB.writeData = state.WB.dataMemRead;
        }
        else if (state.WB.memToReg == 2) {
            regFile.writeRegister(state.WB.writeReg, state.WB.nextPC);
            state.WB.writeData = state.WB.nextPC;
        }
    }
}

// This function act as a clock, it updates each pipe with values from previous stage cycle  
void updatePipelineRegisters() {
    IFID = next_IFID;
    IDEX = next_IDEX;
    EXMEM = next_EXMEM;
    MEMWB =next_MEMWB;
}


void dumpFinalMetricsAndRegisters(int cycle, int fluches, int stalls, int executedInstructions,
    int forwardings, int branches, int jumps, int memAccess,
    registerFile& regFile, ofstream& dumpFile) {

    cout << "End of program encountered. Stopping simulation." << endl;
    dumpFile << "End of program encountered. Stopping simulation." << endl;

    // Metrics
    cout << hex << setfill('0');
    cout << "Number of cycles: 0x" << setw(8) << cycle << endl;
    cout << "Number of Fluches: 0x" << setw(8) << fluches << endl;
    cout << "Number of stalls: 0x" << setw(8) << stalls << endl;
    cout << "Number of Executed instructions: 0x" << setw(8) << exeutedInstructions << endl;
    cout << "Number of Forwardings: 0x" << setw(8) << forwardings << endl;
    cout << "Number of Branches: 0x" << setw(8) << branches << endl;
    cout << "Number of Jump: 0x" << setw(8) << jump << endl;
    cout << "Number of Memory access (LW, SW): 0x" << setw(8) << memAccess << endl;

    dumpFile << "Number of cycles: 0x" << setw(8) << cycle << endl;
    dumpFile << "Number of Fluches: 0x" << setw(8) << fluches << endl;
    dumpFile << "Number of stalls: 0x" << setw(8) << stalls << endl;
    dumpFile << "Number of Executed instructions: 0x" << setw(8) << exeutedInstructions << endl;
    dumpFile << "Number of Forwardings: 0x" << setw(8) << forwardings << endl;
    dumpFile << "Number of Branches: 0x" << setw(8) << branches << endl;
    dumpFile << "Number of Jump: 0x" << setw(8) << jump << endl;
    dumpFile << "Number of Memory access (LW,SW): 0x" << setw(8) << memAccess << endl;
    dumpFile << "Clock Frequency: 75 MHz" << endl;
    dumpFile << "Clock Period: 13.3 ns" << endl;
    dumpFile << "CPU Time: " << dec << static_cast<int>(cycle * 13.3) << " ns" << endl;

    regFile.printRegisters();
    dumpFile << "Register file values:" << endl;
    for (int i = 0; i < 32; ++i) {
        dumpFile << "R" << setw(2) << setfill('0')<< uppercase << i << ": 0x" << hex << setw(8) << setfill('0') << regFile.readRegister(i).to_ulong() << endl;
    }

}



int main()  {
    // Initialize the pipeline state and memory components
    stateStruct state;
    instructionMem imem;
    registerFile regFile;
    dataMemory dmem;

    // Initialize PC and set to start (usually 0)
    state.IF.PC = 0;
    state.IF.nop = false;
    state.ID.nop = false;

    // Creating the dump file for logs
    ofstream dumpFile("cycle.txt");

    // Check if the file is open
    if (!dumpFile.is_open()) {
        cout << "Error opening dump file!" << endl;
        return 1;
    }


    while (true) {

        // Pipeline stages simulation       
        writeBack(state, regFile, MEMWB);
        memoryAccess(state, dmem, EXMEM, next_MEMWB);
        Execute(state, IDEX, next_EXMEM);
        Decode(state, regFile, IFID, next_IDEX);
        Fetch(state, imem, next_IFID);
        
        exeutedInstructions = cycle - 4 - fluches - stalls;

        if (state.ID.Instr.to_ulong() == 0xFFFFFFFF || cycle == 100) {
            // Dump final metrics and register values
            dumpFinalMetricsAndRegisters(cycle, fluches, stalls, exeutedInstructions, forwardings, branches, jump, memAccess, regFile, dumpFile);
            break;
        }

        
      
        // Dump each instruction with its PC address
        dumpFile << "Fetched Instruction: 0x" << hex << setw(8) << setfill('0') << state.IF.Instr.to_ulong()
            << " at PC: 0x" << setw(8) << 4 * (state.IF.nextPC.to_ulong()-1) << endl;

        // Print pipeline information
        cycle++;
        cout << "Cycle " << cycle << ":\n";
        cout << "Fetched Instruction (IF stage)  : 0x" << hex << setw(8) << setfill('0') << state.IF.Instr.to_ulong() << endl;
        cout << "Decoded Instruction (ID stage)  : 0x" << hex << setw(8) << setfill('0') << state.ID.Instr.to_ulong() << endl;
        cout << "Executed Instruction (Ex stage) : 0x" << hex << setw(8) << setfill('0') << state.EX.instr.to_ulong() << endl;
        cout << "Memory Instruction (MEM stage)  : 0x" << hex << setw(8) << setfill('0') << state.MEM.instr.to_ulong() << endl;
        cout << "WriteBack Instruction (WB stage): 0x" << hex << setw(8) << setfill('0') << state.WB.instr.to_ulong() << endl;
        cout << "*****************************************************************\n";

        cout << "------------------------Fetch stage--------------------------------\n";
        cout << "Instruction at Fetch stage: 0x" << hex << setw(8) << setfill('0') << state.IF.Instr.to_ulong() << endl;
        cout << "PC:" << state.IF.PC.to_ulong()-1 << endl;
        cout << "------------------------Decode stage-------------------------------\n";
        cout << "Instruction at Decode: 0x" << hex << setw(8) << setfill('0') << state.ID.Instr.to_ulong() << endl;
        cout << "Opcode: 0x" << state.ID.opcode.to_ulong() << endl;
        cout << "Rs: $" << state.ID.Rs.to_ulong() << ", Rt: $" << state.ID.Rt.to_ulong() << ", Rd: $" << state.ID.Rd.to_ulong() << endl;
        cout << "ReadData1: 0x" << state.ID.Read_data1.to_ulong() << ", ReadData2: 0x" << state.ID.Read_data2.to_ulong() << endl;

        cout << "------------------------Execute stage------------------------------\n";
        cout << "Instruction at Execute: 0x" << hex << setw(8) << setfill('0') << state.EX.instr.to_ulong() << endl;
        cout << "Operand1: 0x" << state.EX.operand1.to_ulong() << endl;
        cout << "Operand2: 0x" << state.EX.operand2.to_ulong() << endl;
        cout << "ALU Operation: 0x" << state.EX.alu_op.to_ulong() << endl;
        cout << "ALU Result (EX stage): 0x" << hex << state.EX.alu_result.to_ulong() << endl;

        cout << "------------------------Memory access stage------------------------\n";
        cout << "Instruction at Memory: 0x" << hex << setw(8) << setfill('0') << state.MEM.instr.to_ulong() << endl;
        cout << "Address to be read from the memory: " << state.MEM.alu_result.to_ulong() << endl;
        cout << "Data read from the memory: " << state.MEM.dataMemRead.to_ulong() << endl;

        cout << "------------------------Write back stage---------------------------\n";
        cout << "Instruction at Write back: 0x" << hex << setw(8) << setfill('0') << state.WB.instr.to_ulong() << endl;
        cout << "Register to be written: " << state.WB.writeReg.to_ulong() << endl;
        cout << "Value: " << state.WB.writeData.to_ulong() << endl;
        cout << "Write Enable: " << state.WB.regWrite << endl;

        cout << "#########################################################################################################\n";

     
        // Update the pipeline registers for the next cycle
        updatePipelineRegisters();

    }



    // Close the dump file
    dumpFile.close();

    return 0;
}
