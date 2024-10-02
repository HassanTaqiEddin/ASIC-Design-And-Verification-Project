# Mapping for opcodes and function codes (custom MIPS)
opcode_mapping = {
    'or': '000000',     # R-type
    'and': '000000',    # R-type
    'xor': '000000',    # R-type
    'add': '000000',    # R-type
    'nor': '000000',    # R-type
    'nand': '000000',   # R-type
    'slt': '000000',    # R-type
    'sub': '000000',    # R-type
    'jr': '000000',     # R-type

    'ori': '010000',    # I-type
    'andi': '010001',   # I-type
    'xori': '010010',   # I-type
    'addi': '010011',   # I-type
    'nori': '010100',   # I-type
    'nandi': '010101',  # I-type
    'slti': '010110',   # I-type
    'subi': '010111',   # I-type
    'lw': '100011',     # I-type
    'sw': '101011',     # I-type
    'beq': '110000',    # I-type
    'j': '110001',      # J-type
    'jal': '110011'     # J-type
}

# Function code mapping for R-type instructions
function_mapping = {
    'or': '000000',    # OR function
    'and': '000001',   # AND function
    'xor': '000010',   # XOR function
    'add': '000011',   # ADD function
    'nor': '000100',   # NOR function
    'nand': '000101',  # NAND function
    'slt': '000110',   # SLT function
    'sub': '000111',   # SUB function
    'jr': '001000'     # JR function
}

# Full register mapping (R0 to R31)
register_mapping = {
    'R0': '00000', 'R1': '00001', 'R2': '00010', 'R3': '00011',
    'R4': '00100', 'R5': '00101', 'R6': '00110', 'R7': '00111',
    'R8': '01000', 'R9': '01001', 'R10': '01010', 'R11': '01011',
    'R12': '01100', 'R13': '01101', 'R14': '01110', 'R15': '01111',
    'R16': '10000', 'R17': '10001', 'R18': '10010', 'R19': '10011',
    'R20': '10100', 'R21': '10101', 'R22': '10110', 'R23': '10111',
    'R24': '11000', 'R25': '11001', 'R26': '11010', 'R27': '11011',
    'R28': '11100', 'R29': '11101', 'R30': '11110', 'R31': '11111'
}


def normalize_register(register):
    """Normalize register format, handle $ and case-insensitivity."""
    register = register.replace('$', '').upper()  # Remove $ and convert to uppercase
    if register.startswith('R'):
        return register_mapping.get(register, None)  # Check in register mapping
    return None


def bin_to_hex(binary_str):
    """Convert binary string to 8-character hexadecimal string."""
    return hex(int(binary_str, 2))[2:].zfill(8)


def instruction_to_machine_code_hex(instruction):
    """Convert MIPS instruction to hexadecimal machine code."""
    parts = instruction.split()
    command = parts[0].lower()  # Convert opcode to lowercase for case insensitivity

    if command in function_mapping:  # R-type instruction
        return bin_to_hex(r_type_to_machine_code(parts))
    elif command in opcode_mapping:  # I-type or J-type instruction
        if command == 'j' or command == 'jal':
            return bin_to_hex(j_type_to_machine_code(parts))
        else:
            return bin_to_hex(i_type_to_machine_code(parts))


def r_type_to_machine_code(parts):
    """Generate R-type machine code in binary."""
    try:
        if parts[0].lower() == 'jr':  # Special handling for JR instruction
            opcode = '000000'  # JR is an R-type instruction, so opcode is 000000
            rs = normalize_register(parts[1].strip(','))  # JR uses the rs register
            rt = '00000'  # rt is 0 for JR
            rd = '00000'  # rd is 0 for JR
            shamt = '00000'  # shamt is 0 for JR
            funct = '001000'  # Function code for JR
        else:
            opcode = '000000'  # All R-type instructions have opcode 000000
            rs = normalize_register(parts[2].strip(','))  # Source register
            rt = normalize_register(parts[3].strip(','))  # Second source register
            rd = normalize_register(parts[1].strip(','))  # Destination register
            shamt = '00000'  # Shift amount (default 0 for most instructions)
            funct = function_mapping[parts[0].lower()]  # Function code

        # Construct the binary instruction
        binary_instruction = f"{opcode}{rs}{rt}{rd}{shamt}{funct}"
        return binary_instruction

    except IndexError as e:
        raise ValueError(f"Malformed R-type instruction: {' '.join(parts)}. Error: {e}")


def i_type_to_machine_code(parts):
    """Generate I-type machine code in binary."""
    try:
        opcode = opcode_mapping[parts[0].lower()]  # 6 bits
        rt = normalize_register(parts[1].strip(','))  # Destination register (e.g., R6)

        # Handle the case with an immediate and base register part (like LW/SW)
        offset_base = parts[2]

        if '(' in offset_base and ')' in offset_base:  # Handle format like 4(R0)
            offset, base = offset_base.split('(')  # Split "4(R0)" into "4" and "R0)"
            base = base.strip(')')  # Remove closing parenthesis from base register
            rs = normalize_register(base)  # Base register (e.g., R0)
            imm = format(int(offset), '016b')  # Immediate value as a 16-bit binary number
        else:  # Handle instructions like NORI, BEQ, etc.
            rs = normalize_register(parts[2].strip(','))  # Source register (e.g., R5)
            imm_value = int(parts[3])  # Immediate value (could be negative)
            imm = format(imm_value & 0xFFFF, '016b')  # Convert to 16-bit two's complement

        # Construct the binary instruction
        binary_instruction = f"{opcode}{rs}{rt}{imm}"
        return binary_instruction

    except IndexError as e:
        raise ValueError(f"Malformed I-type instruction: {' '.join(parts)}. Error: {e}")
    except ValueError as ve:
        raise ValueError(f"Value error in I-type instruction: {' '.join(parts)}. Error: {ve}")



def j_type_to_machine_code(parts):
    """Generate J-type machine code in binary."""
    opcode = opcode_mapping[parts[0].lower()]  # 6 bits
    address = format(int(parts[1]), '026b')  # 26-bit address

    binary_instruction = f"{opcode}{address}"
    return binary_instruction


def read_mips_instructions(file_path):
    """Read MIPS instructions from a file."""
    instructions = []

    # Open the file and read each line
    with open(file_path, 'r') as file:
        for line in file:
            # Strip any whitespace and ignore empty lines
            line = line.strip()
            if line:
                # Ignore comments (assume comments start with '#')
                if '#' in line:
                    line = line.split('#')[0].strip()
                instructions.append(line)
    return instructions

def dump_machine_codes_to_file(instructions):
    """Dump machine codes (hex) to a file named 'instructionMem.txt'."""
    with open('instructionMem.txt', 'w') as file:
        for instr in instructions:
            machine_code = instruction_to_machine_code_hex(instr)
            file.write(machine_code + '\n')  # Write machine code only


def dump_instructions_and_codes_to_file(instructions):
    """Dump instructions along with machine codes to a file named 'instMemForDebugging.txt'."""
    with open('instMemForDebugging.txt', 'w') as file:
        for instr in instructions:
            machine_code = instruction_to_machine_code_hex(instr)
            file.write(f"Instruction: {instr}\nMachine Code (Hex): {machine_code}\n\n")


# Read and convert MIPS instructions to machine code in hex
file_path = 'MIPS.txt'
instructions = read_mips_instructions(file_path)
# Read and convert MIPS instructions to machine code in hex
file_path = 'MIPS.txt'
instructions = read_mips_instructions(file_path)

# Dump machine codes to 'instructionMem.txt'
dump_machine_codes_to_file(instructions)

# Dump instructions and machine codes to 'instMemForDebugging.txt'
dump_instructions_and_codes_to_file(instructions)

print("Files have been generated: 'instructionMem.txt' and 'instMemForDebugging.txt'")

print("MIPS to Hexadecimal Machine Code Conversion:")
for instr in instructions:
    print(f"Instruction: {instr}")
    print(f"Machine Code (Hex): {instruction_to_machine_code_hex(instr)}")
    print()










