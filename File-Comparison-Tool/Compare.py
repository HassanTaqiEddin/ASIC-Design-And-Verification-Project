
import sys


def compare_files(file1_path, file2_path):
    differences = []
    line_num = 0

    try:
        with open(file1_path, 'r') as file1, open(file2_path, 'r') as file2:
            while True:
                line1 = file1.readline()
                line2 = file2.readline()
                line_num += 1

                # Check for end of both files
                if not line1 and not line2:
                    break

                # Check for end of one file before the other
                if not line1 or not line2:
                    differences.append({
                        'line': line_num,
                        'file1': line1.strip(),
                        'file2': line2.strip(),
                        'error': 'File lengths differ.'
                    })
                    continue

                # Split each line to extract the instruction part (before 'at PC:')
                instr1 = line1.split('at PC:')[0].strip()
                instr2 = line2.split('at PC:')[0].strip()

                # Compare only the instruction part, ignoring PC address
                if instr1.upper() != instr2.upper():
                    differences.append({
                        'line': line_num,
                        'file1': line1.strip(),
                        'file2': line2.strip(),
                        'error': 'Instruction mismatch.'
                    })

    except FileNotFoundError as e:
        print(f"Error: {e}")
        sys.exit(1)

    # Report differences
    if differences:
        print(f"Differences found: {len(differences)}\n")
        for diff in differences:
            print(f"Line {diff['line']}:")
            print(f"    cycle.txt:      {diff['file1']}")
            print(f"    simulation.txt: {diff['file2']}")
            print(f"    Error: {diff['error']}\n")
    else:
        print("No differences found. Both files are identical.")

#cycle_file = 'cycle.txt'
#simulation_file = 'simulation.txt'

cycle_file = 'D:\\Summer Training\\C++\\Cycle Accurate Model\\Cycle Accurate\\Cycle Accurate\\cycle.txt'
simulation_file = 'D:\\Summer Training\\Verilog\\Final\\simulation\\modelsim\\simulation.txt'

compare_files(cycle_file, simulation_file)
